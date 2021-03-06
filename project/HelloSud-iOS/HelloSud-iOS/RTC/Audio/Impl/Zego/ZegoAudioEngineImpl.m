//
//  ZegoAudioEngineImpl.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "ZegoAudioEngineImpl.h"
#import <ZegoExpressEngine/ZegoExpressEngine.h>

@interface ZegoAudioEngineImpl()<ZegoEventHandler, ZegoAudioDataHandler>
@property(nonatomic, assign)BOOL isMuteAllPlayStreamAudio;
@property(nonatomic, assign)BOOL isPublishing;
@property(nonatomic, strong)dispatch_queue_t queueMute;
@property(nonatomic, weak)id<AudioEventListener> listener;
@property(nonatomic, strong)NSString *roomID;

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
- (void)setEventListener:(id<AudioEventListener>)listener {
    _listener = listener;
}


- (void)initWithConfig:(NSDictionary *)config {
    NSString *appID = config[@"appID"];
    NSString *appKey = config[@"appKey"];
    ZegoEngineConfig *engineConfig = ZegoEngineConfig.new;
    // 控制音频采集开关与推流关系，推静音帧
    engineConfig.advancedConfig = @{@"audio_capture_dummy": @"true", @"init_domain_name": @"ze-config.divtoss.com"};
    [ZegoExpressEngine setEngineConfig:engineConfig];
    ZegoEngineProfile *profile = ZegoEngineProfile.new;
    profile.appID = [appID intValue];
    profile.appSign = appKey;
    profile.scenario = ZegoScenarioGeneral;
    [ZegoExpressEngine createEngineWithProfile:profile eventHandler:self];
    [[ZegoExpressEngine sharedEngine] startSoundLevelMonitor];
    [ZegoExpressEngine.sharedEngine enableAudioCaptureDevice:NO];
    
}

- (void)unInit {
    [ZegoExpressEngine destroyEngine:nil];
}

- (BOOL)isPublishing {
    return _isPublishing;
}

/// 开始原始音频采集
- (void)startCapture {
    // 设置音频数据回调
    [[ZegoExpressEngine sharedEngine] setAudioDataHandler:self];
    // 需要的音频数据类型 Bitmask，此处示例三个回调都开启
    ZegoAudioDataCallbackBitMask bitmask = ZegoAudioDataCallbackBitMaskCaptured | ZegoAudioDataCallbackBitMaskPlayback | ZegoAudioDataCallbackBitMaskMixed;
    // 需要的音频数据参数，此处示例单声道、16K
    ZegoAudioFrameParam *param = [[ZegoAudioFrameParam alloc] init];
    param.channel = ZegoAudioChannelMono;
    param.sampleRate = ZegoAudioSampleRate16K;
    // 开启获取原始音频数据功能
    [[ZegoExpressEngine sharedEngine] startAudioDataObserver:bitmask param:param];
}

/// 结束原始音频采集
- (void)stopCapture {
    [[ZegoExpressEngine sharedEngine] setAudioDataHandler:nil];
    [[ZegoExpressEngine sharedEngine] stopAudioDataObserver];
}

- (void)loginRoom:(nonnull NSString *)roomID user:(nonnull MediaUser *)user config:(nullable MediaRoomConfig *)config {
    if (self.roomID.length > 0) {
        [self logoutRoom];
    }
    self.roomID = roomID;
    ZegoUser *zegoUser = ZegoUser.new;
    zegoUser.userID = user.userID;
    zegoUser.userName = user.nickname;
    ZegoRoomConfig *zegoConfig = [ZegoRoomConfig defaultConfig];
    [ZegoExpressEngine.sharedEngine loginRoom:roomID user:zegoUser config:zegoConfig];
}


- (void)logoutRoom {
    if (self.isPublishing) {
        [self stopPublishStream];
    }
    [ZegoExpressEngine.sharedEngine logoutRoom];
}

- (void)muteMicrophone:(BOOL)isMute {
    dispatch_async(self.queueMute, ^{
        /// 把采集设备停掉，（静音时不再状态栏提示采集数据）
        /// 异步激活采集通道（此处开销成本过大，相对耗时）
        NSLog(@"muteMicrophone:%@", @(isMute));
        [ZegoExpressEngine.sharedEngine enableAudioCaptureDevice:isMute ? NO : YES];
        [ZegoExpressEngine.sharedEngine muteMicrophone:isMute];
    });
}

- (void)startPlayingStream:(nonnull NSString *)streamID {
    [ZegoExpressEngine.sharedEngine startPlayingStream:streamID];
}


- (void)startPublish:(nonnull NSString *)streamID {
    self.isPublishing = YES;
    [ZegoExpressEngine.sharedEngine startPublishingStream:streamID];
}


- (void)stopPlayingStream:(nonnull NSString *)streamID {
    [ZegoExpressEngine.sharedEngine stopPlayingStream:streamID];
}


- (void)stopPublishStream {
    self.isPublishing = NO;
    [ZegoExpressEngine.sharedEngine stopPublishingStream];
}

/// 发送指令
/// @param command 指令内容
/// @param roomID 房间ID
- (void)sendCommand:(NSString *)command roomID:(NSString *)roomID result:(void(^)(int))result; {
    [ZegoExpressEngine.sharedEngine sendCustomCommand:command toUserList:nil roomID:roomID callback:^(int errorCode) {
        result(errorCode);
    }];
}

#pragma mark ZegoEventHandler

- (void)onIMRecvCustomCommand:(NSString *)command fromUser:(ZegoUser *)fromUser roomID:(NSString *)roomID {
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onIMRecvCustomCommand:fromUser:roomID:)]) {
        MediaUser *user = MediaUser.new;
        user.userID = fromUser.userID;
        user.nickname = fromUser.userName;
        [self.listener onIMRecvCustomCommand:command fromUser:user roomID:roomID];
    }
}

- (void)onCapturedSoundLevelUpdate:(NSNumber *)soundLevel {
    if (self.isPublishing && self.listener != nil && [self.listener respondsToSelector:@selector(onCapturedSoundLevelUpdate:)]) {
        [self.listener onCapturedSoundLevelUpdate:soundLevel];
    }
}

- (void)onRemoteSoundLevelUpdate:(NSDictionary<NSString *,NSNumber *> *)soundLevels {
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onRemoteSoundLevelUpdate:)]) {
        NSMutableDictionary *dicSoundTemp = NSMutableDictionary.new;
        NSArray *allStrems = soundLevels.allKeys;
        for (NSString *key in allStrems) {
            NSString *userID = self.dicStreamUser[key];
            if (userID) {
                dicSoundTemp[userID] = soundLevels[key];
            }
        }
        [self.listener onRemoteSoundLevelUpdate:dicSoundTemp];
    }
}

- (void)onRoomStreamUpdate:(ZegoUpdateType)updateType streamList:(NSArray<ZegoStream *> *)streamList extendedData:(NSDictionary *)extendedData roomID:(NSString *)roomID {
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onRoomStreamUpdate:streamList:extendedData:roomID:)]) {
        NSMutableArray *arr = NSMutableArray.new;
        for (ZegoStream *m in streamList) {
            MediaStream *stream = MediaStream.new;
            MediaUser *user = MediaUser.new;
            user.userID = m.user.userID;
            user.nickname = m.user.userName;
            stream.user = user;
            stream.streamID = m.streamID;
            stream.extraInfo = m.extraInfo;
            [arr addObject:stream];
            if (updateType == ZegoUpdateTypeAdd) {
                self.dicStreamUser[m.streamID] = user.userID;
            } else {
                [self.dicStreamUser removeObjectForKey:m.streamID];
            }
        }
        [self.listener onRoomStreamUpdate:updateType streamList:arr extendedData:extendedData roomID:roomID];
    }
}

- (void)onPublisherStateUpdate:(ZegoPublisherState)state errorCode:(int)errorCode extendedData:(NSDictionary *)extendedData streamID:(NSString *)streamID {
    NSLog(@"zego onPublisherStateUpdate:%ld, errorcode:%d, streamID:%@, extendedData:%@", state, errorCode, streamID, extendedData);
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onPublisherStateUpdate:errorCode:extendedData:streamID:)]) {
        [self.listener onPublisherStateUpdate:state errorCode:errorCode extendedData:extendedData streamID:streamID];
    }
}

- (void)onPlayerStateUpdate:(ZegoPlayerState)state errorCode:(int)errorCode extendedData:(NSDictionary *)extendedData streamID:(NSString *)streamID {
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerStateUpdate:errorCode:extendedData:streamID:)]) {
        [self.listener onPlayerStateUpdate:state extendedData:extendedData streamID:streamID];
    }
}

- (void)onNetworkModeChanged:(ZegoNetworkMode)mode {
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onNetworkModeChanged:)]) {
        [self.listener onNetworkModeChanged:mode];
    }
}

- (void)onRoomUserUpdate:(ZegoUpdateType)updateType userList:(NSArray<ZegoUser *> *)userList roomID:(NSString *)roomID {
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onRoomUserUpdate:userList:roomID:)]) {
        NSMutableArray *arr = NSMutableArray.new;
        for (ZegoUser *u in userList) {
            MediaUser *user = MediaUser.new;
            user.userID = u.userID;
            user.nickname = u.userName;
            [arr addObject:user];
        }
        [self.listener onRoomUserUpdate:updateType userList:arr roomID:roomID];
    }
}

- (void)onRoomOnlineUserCountUpdate:(int)count roomID:(NSString *)roomID {
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onRoomOnlineUserCountUpdate:roomID:)]) {
        [self.listener onRoomOnlineUserCountUpdate:count roomID:roomID];
    }
}

- (void)onRoomStateUpdate:(ZegoRoomState)state errorCode:(int)errorCode extendedData:(nullable NSDictionary *)extendedData roomID:(NSString *)roomID {
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onRoomStateUpdate:errorCode:extendedData:roomID:)]) {
        [self.listener onRoomStateUpdate:(HSAudioEngineRoomState)state errorCode:errorCode extendedData:extendedData roomID:roomID];
    }
}


// 根据需要实现以下三个回调，分别对应上述 Bitmask 的三个选项
- (void)onCapturedAudioData:(const unsigned char *)data dataLength:(unsigned int)dataLength param:(ZegoAudioFrameParam *)param {
    // 本地采集音频数据，推流后可收到回调
    NSData *a_data = [[NSData alloc] initWithBytes:data length:dataLength];
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onCapturedAudioData:)]) {
        [self.listener onCapturedAudioData:a_data];
    }
}

- (void)onPlaybackAudioData:(const unsigned char *)data dataLength:(unsigned int)dataLength param:(ZegoAudioFrameParam *)param {
    // 远端拉流音频数据，开始拉流后可收到回调
}

- (void)onMixedAudioData:(const unsigned char *)data dataLength:(unsigned int)dataLength param:(ZegoAudioFrameParam *)param {
    // 本地采集与远端拉流声音混合后的音频数据回调
}

- (void)onPlayerAudioData:(const unsigned char *)data dataLength:(unsigned int)dataLength param:(ZegoAudioFrameParam *)param streamID:(NSString *)streamID {
    // 远端拉流音频数据，开始拉流后每条拉流数据的回调
}
@end
