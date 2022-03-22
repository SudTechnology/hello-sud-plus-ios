//
//  ZegoAudioEngineImpl.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "ZegoAudioEngineImpl.h"
#import <ZegoExpressEngine/ZegoExpressEngine.h>

@interface ZegoAudioEngineImpl()<ZegoEventHandler, ZegoAudioDataHandler>
@property(nonatomic, strong)dispatch_queue_t queueMute;
@property(nonatomic, weak)id<ISudAudioEventListener> listener;
@property(nonatomic, strong)NSString *mRoomId;

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
    _listener = listener;
}


- (void)initWithConfig:(AudioConfigModel *)model {
    if (model == nil)
        return;
    
    ZegoEngineConfig *engineConfig = ZegoEngineConfig.new;
    // 控制音频采集开关与推流关系，推静音帧
    engineConfig.advancedConfig = @{@"audio_capture_dummy": @"true", @"init_domain_name": @"ze-config.divtoss.com"};
    [ZegoExpressEngine setEngineConfig:engineConfig];
    ZegoEngineProfile *profile = ZegoEngineProfile.new;
    profile.appID = [model.appId intValue];
    profile.appSign = model.appSign;
    profile.scenario = ZegoScenarioCommunication;
    [ZegoExpressEngine createEngineWithProfile:profile eventHandler:self];
    
    ZegoExpressEngine *engine = [ZegoExpressEngine sharedEngine];
    if (engine != nil) {
        [engine startSoundLevelMonitor];
    }
}

- (void)destroy {
    [ZegoExpressEngine destroyEngine:nil];
    self.mRoomId = nil;
}

- (void)joinRoom:(AudioJoinRoomModel *)model {
    if (model == nil)
        return;

    ZegoExpressEngine *engine = [ZegoExpressEngine sharedEngine];
    if (engine != nil) {
        ZegoUser *zegoUser = ZegoUser.new;
        zegoUser.userID = model.userID;
        zegoUser.userName = model.userName;
        ZegoRoomConfig *zegoConfig = [ZegoRoomConfig defaultConfig];
        zegoConfig.isUserStatusNotify = YES;
        
        [engine loginRoom:model.roomID user:zegoUser config:zegoConfig];
    }
}

- (void)leaveRoom {
    ZegoExpressEngine *engine = [ZegoExpressEngine sharedEngine];
    if (engine != nil) {
        [engine logoutRoom];
        self.mRoomId = nil;
    }
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
            [ZegoExpressEngine.sharedEngine enableAudioCaptureDevice:NO];
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

#pragma mark ZegoEventHandler

- (void)onRoomStateUpdate:(ZegoRoomState)state errorCode:(int)errorCode extendedData:(nullable NSDictionary *)extendedData roomID:(NSString *)roomID {
    if (state == ZegoRoomStateConnected) {
        self.mRoomId = roomID;
    }
    
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onRoomStateUpdate:state:errorCode:extendedData:)]) {
        [self.listener onRoomStateUpdate:roomID state:(HSAudioEngineRoomState)state errorCode:errorCode extendedData:extendedData];
    }
}

- (void)onCapturedSoundLevelUpdate:(NSNumber *)soundLevel {
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onCapturedSoundLevelUpdate:)]) {
        [self.listener onCapturedSoundLevelUpdate:soundLevel];
    }
}

- (void)onRemoteSoundLevelUpdate:(NSDictionary<NSString *,NSNumber *> *)soundLevels {

    if (soundLevels == nil || [soundLevels count] == 0) {
        return;
    }

    if (self.listener != nil && [self.listener respondsToSelector:@selector(onRemoteSoundLevelUpdate:)]) {
        NSMutableDictionary *userSoundLevels = NSMutableDictionary.new;
        NSArray *allStrems = soundLevels.allKeys;
        for (NSString *key in allStrems) {
            NSString *userID = self.dicStreamUser[key];
            if (userID) {
                userSoundLevels[userID] = soundLevels[key];
            }
        }
        [self.listener onRemoteSoundLevelUpdate:userSoundLevels];
    }
}

- (void)onRoomStreamUpdate:(ZegoUpdateType)updateType streamList:(NSArray<ZegoStream *> *)streamList extendedData:(NSDictionary *)extendedData roomID:(NSString *)roomID {
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
                        [engine startPlayingStream:zegoStream.streamID];
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
    
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onRoomStreamUpdate:updateType:streamList:extendedData:)]) {
        NSMutableArray *arr = NSMutableArray.new;
        for (ZegoStream *m in streamList) {
            MediaStream *stream = MediaStream.new;
            stream.userID = m.user.userID;
            stream.streamID = m.streamID;
            stream.extraInfo = m.extraInfo;
            [arr addObject:stream];
        }
        
        [self.listener onRoomStreamUpdate:roomID updateType:updateType streamList:arr extendedData:extendedData];
    }
}

- (void)onIMRecvCustomCommand:(NSString *)command fromUser:(ZegoUser *)fromUser roomID:(NSString *)roomID {
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onRecvCommand:command:)]) {
        [self.listener onRecvCommand:fromUser.userID command:command];
    }
}

- (void)onRoomOnlineUserCountUpdate:(int)count roomID:(NSString *)roomID {
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onRoomOnlineUserCountUpdate:count:)]) {
        [self.listener onRoomOnlineUserCountUpdate:roomID count:count];
    }
}

// 根据需要实现以下三个回调，分别对应上述 Bitmask 的三个选项
- (void)onCapturedAudioData:(const unsigned char *)data dataLength:(unsigned int)dataLength param:(ZegoAudioFrameParam *)param {
    // 本地采集音频数据，推流后可收到回调
    NSData *a_data = [[NSData alloc] initWithBytes:data length:dataLength];
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onCapturedPCMData:)]) {
        [self.listener onCapturedPCMData:a_data];
    }
}

@end
