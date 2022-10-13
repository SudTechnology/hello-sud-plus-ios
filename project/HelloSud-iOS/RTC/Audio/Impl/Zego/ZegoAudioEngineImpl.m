//
//  ZegoAudioEngineImpl.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "ZegoAudioEngineImpl.h"
#import <ZegoExpressEngine/ZegoExpressEngine.h>
#import "HSThreadUtils.h"

@interface ZegoAudioEngineImpl()<ZegoEventHandler, ZegoAudioDataHandler>
@property(nonatomic, strong)dispatch_queue_t queueMute;
@property(nonatomic, weak)id<ISudAudioEventListener> mISudAudioEventListener;
@property(nonatomic, copy)NSString *mRoomId;

/// 流与ID关系[streamID:userID]
@property(nonatomic, strong)NSMutableDictionary<NSString *, NSString *> *dicStreamUser;

@end

@implementation ZegoAudioEngineImpl

- (NSMutableDictionary<NSString *, NSString *>*)dicStreamUser {
    if (!_dicStreamUser) {
        _dicStreamUser = NSMutableDictionary.new;
    }
    return _dicStreamUser;
}

- (dispatch_queue_t)queueMute {
    if (_queueMute == nil) {
        _queueMute = dispatch_queue_create("mute_queue", DISPATCH_QUEUE_SERIAL);
    }
    return _queueMute;
}

/// 设置事件处理器
/// @param listener 事件处理实例
- (void)setEventListener:(id<ISudAudioEventListener>)listener {
    _mISudAudioEventListener = listener;
}

- (void)initWithConfig:(AudioConfigModel *)model success:(nullable void(^)(void))success {
    if (model == nil)
        return;
    
    ZegoEngineConfig *engineConfig = ZegoEngineConfig.new;
    // 控制音频采集开关与推流关系，推静音帧
    engineConfig.advancedConfig = @{@"audio_capture_dummy": @"true", @"init_domain_name": @"ze-config.divtoss.com"};
    [ZegoExpressEngine setEngineConfig:engineConfig];
    ZegoEngineProfile *profile = ZegoEngineProfile.new;
    /* 请通过官网注册获取，格式为 123456789L */
    profile.appID = (unsigned int)[model.appId longLongValue];
    /* 通用场景接入 */
    profile.scenario = ZegoScenarioCommunication;
    /* 创建引擎 */
    ZegoExpressEngine *engine = [ZegoExpressEngine createEngineWithProfile:profile eventHandler:self];
    if (engine != nil) {
        [engine startSoundLevelMonitor];
        [engine enableAudioCaptureDevice:NO];
        [engine enableAEC:YES];
        [engine enableHeadphoneAEC:YES];
    }
    
    if (success != nil) {
        success();
    }
}

- (void)destroy {
    /* 销毁 SDK */
    [ZegoExpressEngine destroyEngine:nil];
    self.mRoomId = nil;
}

- (void)joinRoom:(AudioJoinRoomModel *)model {
    if (model == nil)
        return;
    
    if (model.roomID == nil || [model.roomID length] == 0
        || model.userID == nil || [model.userID length] == 0) {
        @throw [NSException exceptionWithName:@"Invalid Argument" reason:@"roomID or userID can't be empty" userInfo:nil];
    }

    ZegoExpressEngine *engine = [ZegoExpressEngine sharedEngine];
    if (engine != nil) {
        /* 创建用户 */
        ZegoUser *zegoUser = ZegoUser.new;
        zegoUser.userID = model.userID;
        zegoUser.userName = model.userName;
        ZegoRoomConfig *zegoRoomConfig = [ZegoRoomConfig defaultConfig];
        /* Enable notification when user login or logout */
        zegoRoomConfig.isUserStatusNotify = YES;
        zegoRoomConfig.token = model.token;
        /* 开始登陆房间 */
        [engine loginRoom:model.roomID user:zegoUser config:zegoRoomConfig];
    }
}

- (void)leaveRoom {
    ZegoExpressEngine *engine = [ZegoExpressEngine sharedEngine];
    if (engine != nil) {
        /* 退出房间 */
        [engine logoutRoom];
    }
    self.mRoomId = nil;
}

- (void)startPublishStream {
    ZegoExpressEngine *engine = [ZegoExpressEngine sharedEngine];
    if (engine != nil) {
        CFUUIDRef uuid = CFUUIDCreate(nil);
        UInt64 recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
        NSString * streamId = [NSString stringWithFormat:@"%@-%llu", (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuid), recordTime];
        CFRelease(uuid);
        
        [engine startPublishingStream:streamId];
        dispatch_async(self.queueMute, ^{
            /// 把采集设备停掉，（静音时不再状态栏提示采集数据）
            /// 异步激活采集通道（此处开销成本过大，相对耗时）
            [engine enableAudioCaptureDevice:YES];
        });
    }
}

- (void)stopPublishStream {
    ZegoExpressEngine *engine = [ZegoExpressEngine sharedEngine];
    if (engine != nil) {
        [engine stopPublishingStream];
        dispatch_async(self.queueMute, ^{
            /// 把采集设备停掉，（静音时不再状态栏提示采集数据）
            /// 异步激活采集通道（此处开销成本过大，相对耗时）
            [engine enableAudioCaptureDevice:NO];
        });
    }
}

- (void)startSubscribingStream {
    ZegoExpressEngine *engine = [ZegoExpressEngine sharedEngine];
    if (engine != nil) {
        [engine muteAllPlayStreamAudio:NO];
    }
}

- (void)stopSubscribingStream {
    ZegoExpressEngine *engine = [ZegoExpressEngine sharedEngine];
    if (engine != nil) {
        [engine muteAllPlayStreamAudio:YES];
    }
}

/// 开始原始音频采集
- (void)startPCMCapture {
    ZegoExpressEngine *engine = [ZegoExpressEngine sharedEngine];
    if (engine != nil) {
        // 开启获取PCM数据功能
        ZegoAudioFrameParam *param = [[ZegoAudioFrameParam alloc] init];
        param.channel = ZegoAudioChannelMono;
        param.sampleRate = ZegoAudioSampleRate16K;
        ZegoAudioDataCallbackBitMask bitmask = ZegoAudioDataCallbackBitMaskCaptured;
        [engine startAudioDataObserver:bitmask param:param];
        
        // 设置原始音频数据回调
        [engine setAudioDataHandler:self];
    }
}

/// 结束原始音频采集
- (void)stopPCMCapture {
    ZegoExpressEngine *engine = [ZegoExpressEngine sharedEngine];
    if (engine != nil) {
        /* 置空原始音频数据回调 */
        [engine setAudioDataHandler:nil];
        [engine stopAudioDataObserver];
    }
}

- (void)setAudioRouteToSpeaker:(BOOL) enabled {
    ZegoExpressEngine *engine = [ZegoExpressEngine sharedEngine];
    if (engine != nil) {
        [engine setAudioRouteToSpeaker:enabled];
    }
}

/// 发送指令
/// @param command 指令内容
- (void)sendCommand:(NSString *)command listener:(void(^)(int))listener {
    ZegoExpressEngine *engine = [ZegoExpressEngine sharedEngine];
    if (engine != nil) {
        [engine sendCustomCommand:command toUserList:nil roomID:self.mRoomId callback:^(int errorCode) {
            listener(errorCode);
        }];
    }
}

/// 开始预览窗口
/// @param view view
- (void)startPreview:(UIView *)view {
    ZegoExpressEngine *engine = [ZegoExpressEngine sharedEngine];
    if (engine != nil) {
        if (view != nil) {
            ZegoCanvas *canvas = [ZegoCanvas canvasWithView:view];
            canvas.viewMode = ZegoViewModeAspectFill;
            [engine startPreview:canvas];
        }
    }
}

/// 观众开始拉流
- (void)startPlayingStream:(NSString *)streamID view:(UIView *)view {
    ZegoExpressEngine *engine = [ZegoExpressEngine sharedEngine];
    if (engine != nil) {
        ZegoCanvas *canvas = [ZegoCanvas canvasWithView:view];
        canvas.viewMode = ZegoViewModeAspectFill;
        [engine startPlayingStream:streamID canvas:canvas];

    }
}

/// 观众停止拉流
- (void)stopPlayingStream:(NSString *)streamID {
    ZegoExpressEngine *engine = [ZegoExpressEngine sharedEngine];
    if (engine != nil) {
        [engine stopPlayingStream:streamID];
    }
}

#pragma mark ZegoEventHandler

- (void)onDebugError:(int)errorCode funcName:(NSString *)funcName info:(NSString *)info {
    
}

- (void)onRoomStateUpdate:(ZegoRoomState)state errorCode:(int)errorCode extendedData:(nullable NSDictionary *)extendedData roomID:(NSString *)roomID {
    if (state == ZegoRoomStateConnected) {
        self.mRoomId = roomID;
    }
    
    if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRoomStateUpdate:errorCode:extendedData:)]) {
        [self.mISudAudioEventListener onRoomStateUpdate:(HSAudioEngineRoomState)state errorCode:errorCode extendedData:extendedData];
    }
}

- (void)onCapturedSoundLevelUpdate:(NSNumber *)soundLevel {
    if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onCapturedSoundLevelUpdate:)]) {
        [self.mISudAudioEventListener onCapturedSoundLevelUpdate:soundLevel];
    }
}

- (void)onRemoteSoundLevelUpdate:(NSDictionary<NSString *,NSNumber *> *)soundLevels {
    if (soundLevels == nil || [soundLevels count] == 0) {
        return;
    }

    if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRemoteSoundLevelUpdate:)]) {
        NSMutableDictionary *userSoundLevels = NSMutableDictionary.new;
        NSArray *allStrems = soundLevels.allKeys;
        for (NSString *key in allStrems) {
            NSString *userID = self.dicStreamUser[key];
            if (userID) {
                userSoundLevels[userID] = soundLevels[key];
            }
        }
        [self.mISudAudioEventListener onRemoteSoundLevelUpdate:userSoundLevels];
    }
}

- (void)onRoomStreamUpdate:(ZegoUpdateType)updateType streamList:(NSArray<ZegoStream *> *)streamList extendedData:(NSDictionary *)extendedData roomID:(NSString *)roomID {
    // 存储userId对应的streamId
    if (streamList != nil) {
        for (ZegoStream *m in streamList) {
            if (updateType == ZegoUpdateTypeAdd) {
                self.dicStreamUser[m.streamID] = m.user.userID;
            } else if (updateType == ZegoUpdateTypeDelete) {
                [self.dicStreamUser removeObjectForKey:m.streamID];
            }
        }
    }
    
    if (streamList != nil && [streamList count] > 0) {
        ZegoExpressEngine *engine = [ZegoExpressEngine sharedEngine];
        if (engine != nil) {
            switch (updateType) {
                case ZegoUpdateTypeAdd:
                    for (ZegoStream * zegoStream in streamList) {
                        [engine startPlayingStream:zegoStream.streamID canvas:nil];
                    }
                    break;
                case ZegoUpdateTypeDelete:
                    for (ZegoStream * zegoStream in streamList) {
                        [engine stopPlayingStream:zegoStream.streamID];
                    }
                    break;
            }
        }
    }
    
    if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRoomStreamUpdate:updateType:streamList:extendedData:)]) {
        NSMutableArray *arr = NSMutableArray.new;
        for (ZegoStream *m in streamList) {
            AudioStream *stream = AudioStream.new;
            stream.userID = m.user.userID;
            stream.streamID = m.streamID;
            stream.extraInfo = m.extraInfo;
            [arr addObject:stream];
        }
        
        [self.mISudAudioEventListener onRoomStreamUpdate:roomID updateType:updateType streamList:arr extendedData:extendedData];
    }
}

- (void)onIMRecvBroadcastMessage:(NSArray<ZegoBroadcastMessageInfo *> *)messageList roomID:(NSString *)roomID {
    if (messageList) {
        for (int i = 0; i < messageList.count; ++i) {
            ZegoBroadcastMessageInfo *msg = messageList[i];
            if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRecvCommand:command:)]) {
                NSString *content = [msg.message stringByRemovingPercentEncoding];
                [self.mISudAudioEventListener onRecvCommand:msg.fromUser.userID command:content];
            }
        }
    }

}

- (void)onIMRecvCustomCommand:(NSString *)command fromUser:(ZegoUser *)fromUser roomID:(NSString *)roomID {
    if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRecvCommand:command:)]) {
        [self.mISudAudioEventListener onRecvCommand:fromUser.userID command:command];
    }
}

- (void)onRoomOnlineUserCountUpdate:(int)count roomID:(NSString *)roomID {
    if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRoomOnlineUserCountUpdate:)]) {
        [self.mISudAudioEventListener onRoomOnlineUserCountUpdate:count];
    }
}

- (void)onPlayerStateUpdate:(ZegoPlayerState) state errorCode:(int) errorCode extendedData:(nullable NSDictionary *) extendedData streamID:(NSString *) streamID {    
    if (state == ZegoPlayerStatePlaying) {
        if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onPlayingStreamingAdd:)]) {
            [self.mISudAudioEventListener onPlayingStreamingAdd:streamID];
        }
    } else if (state == ZegoPlayerStateNoPlay) {
        if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onPlayingStreamingDelete:)]) {
            [self.mISudAudioEventListener onPlayingStreamingDelete:streamID];
        }
    }
}

// 根据需要实现以下三个回调，分别对应上述 Bitmask 的三个选项
- (void)onCapturedAudioData:(const unsigned char *)data dataLength:(unsigned int)dataLength param:(ZegoAudioFrameParam *)param {
    // 本地采集音频数据，推流后可收到回调
    if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onCapturedPCMData:)]) {
        NSData *pcmData = [[NSData alloc] initWithBytes:data length:dataLength];
        [self.mISudAudioEventListener onCapturedPCMData:pcmData];
    }
}

@end
