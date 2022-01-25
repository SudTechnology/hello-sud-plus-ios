//
//  ZegoAudioEngine.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "ZegoAudioEngine.h"
#import <ZegoExpressEngine/ZegoExpressEngine.h>

@interface ZegoAudioEngine()<ZegoEventHandler>
@property(nonatomic, assign)BOOL isMuteAllPlayStreamAudio;
@property(nonatomic, assign)BOOL isPublishing;
@property(nonatomic, strong)dispatch_queue_t queueMute;
@property(nonatomic, weak)id<MediaAudioEventHandler> eventHandler;
@end

@implementation ZegoAudioEngine

- (dispatch_queue_t)queueMute {
    if (_queueMute == nil) {
        _queueMute = dispatch_queue_create("mute_queue", DISPATCH_QUEUE_SERIAL);
    }
    return _queueMute;
}

/// 设置事件处理器
/// @param eventHandler 事件处理实例
- (void)setEventHandler:(id<MediaAudioEventHandler>)eventHandler {
    _eventHandler = eventHandler;
}


- (void)config:(nonnull NSString *)appID appKey:(nonnull NSString *)appKey {
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

- (void)destroy {
    [ZegoExpressEngine destroyEngine:nil];
}


- (BOOL)isMicrophoneMuted {
    return ZegoExpressEngine.sharedEngine.isMicrophoneMuted;
}


- (BOOL)isMuteAllPlayStreamAudio {
    return self.isMuteAllPlayStreamAudio;
}


- (BOOL)isPublishing {
    return self.isPublishing;
}


- (void)loginRoom:(nonnull NSString *)roomID user:(nonnull MediaUser *)user config:(nullable MediaRoomConfig *)config {
    ZegoUser *zegoUser = ZegoUser.new;
    zegoUser.userID = user.userID;
    zegoUser.userName = user.nickname;
    ZegoRoomConfig *zegoConfig = [ZegoRoomConfig defaultConfig];
    [ZegoExpressEngine.sharedEngine loginRoom:roomID user:zegoUser config:zegoConfig];
}


- (void)logoutRoom {
    [ZegoExpressEngine.sharedEngine logoutRoom];
}


- (void)muteAllPlayStreamAudio:(BOOL)isMute {
    self.isMuteAllPlayStreamAudio = isMute;
    [ZegoExpressEngine.sharedEngine muteAllPlayStreamAudio:isMute];
}


- (void)muteMicrophone:(BOOL)isMute {
    NSLog(@"must implementation from sub class");
    dispatch_async(self.queueMute, ^{
        /// 把采集设备停掉，（静音时不再状态栏提示采集数据）
        /// 异步激活采集通道（此处开销成本过大，相对耗时）
        [ZegoExpressEngine.sharedEngine enableAudioCaptureDevice:YES];
        [ZegoExpressEngine.sharedEngine muteMicrophone:isMute];
    });
}


- (void)mutePlayStreamAudio:(BOOL)isMute streamID:(nonnull NSString *)streamID {
    [ZegoExpressEngine.sharedEngine mutePlayStreamAudio:isMute streamID:streamID];
}


- (void)setAllPlayStreamVolume:(NSInteger)volume {
    [ZegoExpressEngine.sharedEngine setAllPlayStreamVolume:(unsigned)volume];
}


- (void)setPlayVolume:(NSInteger)volume streamID:(nonnull NSString *)streamID {
    [ZegoExpressEngine.sharedEngine setPlayVolume:(unsigned)volume streamID:streamID];
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
    if (self.eventHandler != nil && [self.eventHandler respondsToSelector:@selector(onIMRecvCustomCommand:fromUser:roomID:)]) {
        MediaUser *user = MediaUser.new;
        user.userID = fromUser.userID;
        user.nickname = fromUser.userName;
        [self.eventHandler onIMRecvCustomCommand:command fromUser:user roomID:roomID];
    }
}

- (void)onCapturedSoundLevelUpdate:(NSNumber *)soundLevel {
    if (self.eventHandler != nil && [self.eventHandler respondsToSelector:@selector(onCapturedSoundLevelUpdate:)]) {
        [self.eventHandler onCapturedSoundLevelUpdate:soundLevel];
    }
}

- (void)onRemoteSoundLevelUpdate:(NSDictionary<NSString *,NSNumber *> *)soundLevels {
    if (self.eventHandler != nil && [self.eventHandler respondsToSelector:@selector(onRemoteSoundLevelUpdate:)]) {
        [self.eventHandler onRemoteSoundLevelUpdate:soundLevels];
    }
}

- (void)onRoomStreamUpdate:(ZegoUpdateType)updateType streamList:(NSArray<ZegoStream *> *)streamList extendedData:(NSDictionary *)extendedData roomID:(NSString *)roomID {
    if (self.eventHandler != nil && [self.eventHandler respondsToSelector:@selector(onRoomStreamUpdate:streamList:extendedData:roomID:)]) {
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
        }
        [self.eventHandler onRoomStreamUpdate:updateType streamList:arr extendedData:extendedData roomID:roomID];
    }
}

- (void)onPublisherStateUpdate:(ZegoPublisherState)state errorCode:(int)errorCode extendedData:(NSDictionary *)extendedData streamID:(NSString *)streamID {
    if (self.eventHandler != nil && [self.eventHandler respondsToSelector:@selector(onPublisherStateUpdate:errorCode:extendedData:streamID:)]) {
        [self.eventHandler onPublisherStateUpdate:state errorCode:errorCode extendedData:extendedData streamID:streamID];
    }
}

- (void)onPlayerStateUpdate:(ZegoPlayerState)state errorCode:(int)errorCode extendedData:(NSDictionary *)extendedData streamID:(NSString *)streamID {
    if (self.eventHandler != nil && [self.eventHandler respondsToSelector:@selector(onPlayerStateUpdate:errorCode:extendedData:streamID:)]) {
        [self.eventHandler onPlayerStateUpdate:state extendedData:extendedData streamID:streamID];
    }
}

- (void)onNetworkModeChanged:(ZegoNetworkMode)mode {
    if (self.eventHandler != nil && [self.eventHandler respondsToSelector:@selector(onNetworkModeChanged:)]) {
        [self.eventHandler onNetworkModeChanged:mode];
    }
}
@end
