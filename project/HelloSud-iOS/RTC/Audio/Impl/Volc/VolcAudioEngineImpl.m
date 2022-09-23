//
//  VolcAudioEngineImpl.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/18.
//

#import "VolcAudioEngineImpl.h"
#import <VolcEngineRTC/objc/rtc/ByteRTCEngineKit.h>
#import "HSThreadUtils.h"

@interface VolcAudioEngineImpl () <ByteRTCEngineDelegate, ByteRTCAudioProcessor>

@property (nonatomic, strong) ByteRTCEngineKit* mEngine;

@property (nonatomic, weak) id<ISudAudioEventListener> mISudAudioEventListener;

@end

@implementation VolcAudioEngineImpl

- (ByteRTCEngineKit *)getEngine {
    return self.mEngine;
}

- (void)setEventListener:(nonnull id<ISudAudioEventListener>)listener {
    self.mISudAudioEventListener = listener;
}

- (void)initWithConfig:(AudioConfigModel *)model success:(nullable void(^)(void))success {
    if (model == nil)
        return;
    
    if (self.mEngine != nil) {
        [self destroy];
    }
    
    self.mEngine = [[ByteRTCEngineKit alloc] initWithAppId:model.appId delegate:self parameters:nil];
    
    if (self.mEngine != nil) {
        ByteRTCAudioPropertiesConfig *config = ByteRTCAudioPropertiesConfig.new;
        config.interval = 300;
        config.enable_spectrum = NO;
        config.enable_vad = NO;
        [self.mEngine enableAudioPropertiesReport:config];
    }
    
    if (success != nil) {
        success();
    }
}

- (void)destroy {
    if (self.mEngine != nil) {
        [self.mEngine destroyEngine];
    }
    self.mEngine = nil;
}

- (void)joinRoom:(AudioJoinRoomModel *)model {
    if (model == nil)
        return;
    
    ByteRTCEngineKit *engine = [self getEngine];
    if (engine != nil) {
        ByteRTCRoomConfig *roomConfig = ByteRTCRoomConfig.new;
        roomConfig.profile = ByteRTCRoomProfileCommunication;
        roomConfig.isAutoPublish = NO;
        roomConfig.isAutoSubscribeAudio = YES;
        roomConfig.isAutoSubscribeVideo = NO;
        ByteRTCUserInfo *userInfo = ByteRTCUserInfo.new;
        userInfo.userId = model.userID;
        
        [engine joinRoomByKey:model.token roomId:model.roomID userInfo:userInfo rtcRoomConfig:roomConfig];
    }
}

- (void)leaveRoom {
    ByteRTCEngineKit *engine = [self getEngine];
    if (engine != nil) {
        /* 退出房间 */
        [engine leaveRoom];
    }
}

- (void)startPublishStream {
    ByteRTCEngineKit *engine = [self getEngine];
    if (engine != nil) {
        [engine startAudioCapture]; // 开启麦克风采集
        [engine publishStream:ByteRTCMediaStreamTypeAudio]; // 发布本地音频流
    }
}

- (void)stopPublishStream {
    ByteRTCEngineKit *engine = [self getEngine];
    if (engine != nil) {
        [engine unpublishStream:ByteRTCMediaStreamTypeAudio]; // 取消发布本地音频流
        [engine stopAudioCapture]; // 关闭麦克风采集
    }
}

- (void)startSubscribingStream {
    ByteRTCEngineKit *engine = [self getEngine];
    if (engine != nil) {
        [engine resumeAllSubscribedStream:ByteRTCControlMediaTypeAudio];
    }
}

- (void)stopSubscribingStream {
    ByteRTCEngineKit *engine = [self getEngine];
    if (engine != nil) {
        [engine pauseAllSubscribedStream:ByteRTCControlMediaTypeAudio];
    }
}

- (void)startPCMCapture {
    ByteRTCEngineKit *engine = [self getEngine];
    if (engine != nil) {
        ByteRTCAudioFormat * audioFormat = [[ByteRTCAudioFormat alloc] init];
        audioFormat.sampleRate = ByteRTCAudioSampleRate16000;
        audioFormat.channel = ByteRTCAudioChannelMono;
        [engine registerLocalAudioProcessor:self format:audioFormat];
    }
}

- (void)stopPCMCapture {
    ByteRTCEngineKit *engine = [self getEngine];
    if (engine != nil) {
        /* 置空原始音频数据回调 */
        ByteRTCAudioFormat * audioFormat = [[ByteRTCAudioFormat alloc] init];
        audioFormat.sampleRate = ByteRTCAudioSampleRate16000;
        audioFormat.channel = ByteRTCAudioChannelMono;
        [engine registerLocalAudioProcessor:nil format:audioFormat];
    }
}

- (void)setAudioRouteToSpeaker:(BOOL) enabled {
    ByteRTCEngineKit *engine = [self getEngine];
    if (engine != nil) {
        if (enabled) {
            [engine setAudioPlaybackDevice:ByteRTCAudioPlaybackDeviceSpeakerphone];
        } else {
            [engine setAudioPlaybackDevice:ByteRTCAudioPlaybackDeviceEarpiece];
        }
    }
}

- (void)sendCommand:(nonnull NSString *)command listener:(nonnull void (^)(int))listener {
    ByteRTCEngineKit *engine = [self getEngine];
    if (engine != nil) {
        [engine sendRoomMessage:command];
        if (listener) listener(0);
    } else {
        if (listener) listener(-1);
    }
}

#pragma mark ---------------- ByteRTCEngineDelegate -------------------
- (void)rtcEngine:(ByteRTCEngineKit * _Nonnull)engine onLocalAudioPropertiesReport:(NSArray<ByteRTCLocalAudioPropertiesInfo *> * _Nonnull)audioPropertiesInfos {
    if (self.mISudAudioEventListener == nil || audioPropertiesInfos == nil || [audioPropertiesInfos count] == 0) {
        return;
    }
    
    [HSThreadUtils runOnUiThread:^{
        for (ByteRTCLocalAudioPropertiesInfo *speaker in audioPropertiesInfos) {
            if (speaker.streamIndex == ByteRTCStreamIndexMain) {
                // 转换0-100声音值
                NSUInteger volume = speaker.audioPropertiesInfo.linearVolume / 255.0 * 100;
                if ([self.mISudAudioEventListener respondsToSelector:@selector(onCapturedSoundLevelUpdate:)]) {
                    [self.mISudAudioEventListener onCapturedSoundLevelUpdate:@(volume)];
                }
                break;
            }
        }
    }];
}

- (void)rtcEngine:(ByteRTCEngineKit * _Nonnull)engine onRemoteAudioPropertiesReport:(NSArray<ByteRTCRemoteAudioPropertiesInfo *> * _Nonnull)audioPropertiesInfos totalRemoteVolume:(NSInteger)totalRemoteVolume {
    if (self.mISudAudioEventListener == nil || audioPropertiesInfos == nil || [audioPropertiesInfos count] == 0) {
        return;
    }
    
    [HSThreadUtils runOnUiThread:^{
        NSMutableDictionary *soundLevels = nil;
        for (ByteRTCRemoteAudioPropertiesInfo *speaker in audioPropertiesInfos) {
            // 转换0-100声音值
            NSUInteger volume = speaker.audioPropertiesInfo.linearVolume / 255.0 * 100;
            NSString *userID = speaker.streamKey.userId;
            if (soundLevels == nil) {
                soundLevels = NSMutableDictionary.new;
            }
            soundLevels[userID] = @(volume);
        }
        
        // 远程用户音量
        if (soundLevels != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRemoteSoundLevelUpdate:)]) {
            [self.mISudAudioEventListener onRemoteSoundLevelUpdate:soundLevels];
        }
    }];
}

- (void)rtcEngine:(ByteRTCEngineKit * _Nonnull)engine onRoomMessageReceived:(NSString * _Nonnull)uid message:(NSString * _Nonnull)message {
    
    [HSThreadUtils runOnUiThread:^{
        if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRecvCommand:command:)]) {
            [self.mISudAudioEventListener onRecvCommand:uid command:message];
        }
    }];
}

- (void)rtcEngine:(ByteRTCEngineKit *_Nonnull)engine onRoomStats:(ByteRTCRoomStats *_Nonnull)stats {
    
    [HSThreadUtils runOnUiThread:^{
        if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRoomOnlineUserCountUpdate:)]) {
            [self.mISudAudioEventListener onRoomOnlineUserCountUpdate:(int)stats.userCount];
        }
    }];
}

- (void) rtcEngine:(ByteRTCEngineKit * _Nonnull)engine connectionChangedToState:(ByteRTCConnectionState) state {
    HSAudioEngineRoomState audioRoomState = [self convertAudioRoomState:state];
    if (audioRoomState != HSAudioEngineStateUndefined) {
        [HSThreadUtils runOnUiThread:^{
            if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRoomStateUpdate:errorCode:extendedData:)]) {
                [self.mISudAudioEventListener onRoomStateUpdate:audioRoomState errorCode:0 extendedData:nil];
            }
        }];
    }
}

- (void)rtcEngine:(ByteRTCEngineKit *_Nonnull)engine onJoinRoomResult:(NSString *_Nonnull)roomId withUid:(nonnull NSString *)uid errorCode:(NSInteger)errorCode joinType:(NSInteger)joinType elapsed:(NSInteger)elapsed {
    
}

- (HSAudioEngineRoomState)convertAudioRoomState:(ByteRTCConnectionState)state {
    if (state == ByteRTCConnectionStateDisconnected) {
        return HSAudioEngineStateDisconnected;
    }
    
    if (state == ByteRTCConnectionStateConnecting) {
        return HSAudioEngineStateConnecting;
    }
    
    if (state == ByteRTCConnectionStateConnected) {
        return HSAudioEngineStateConnected;
    }
    
    return HSAudioEngineStateUndefined;
}

#pragma mark -------------- ByteRTCAudioProcessor -----------------
- (int)processAudioFrame:(ByteRTCAudioFrame * _Nonnull)audioFrame {
    
    if (self.mISudAudioEventListener != nil) {
        [self.mISudAudioEventListener onCapturedPCMData:audioFrame.buffer];
    }
    return 0;
}

@end
