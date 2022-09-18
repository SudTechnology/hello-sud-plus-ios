//
//  TXAudioEngineImpl.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/18.
//

#import "TXAudioEngineImpl.h"
#import <TXLiteAVSDK_TRTC/TRTCCloud.h>
#import <TXLiteAVSDK_TRTC/TRTCCloudDelegate.h>
#import <TXLiteAVSDK_TRTC/TRTCCloudDef.h>
#import "HSThreadUtils.h"

@interface TXAudioEngineImpl() <TRTCCloudDelegate, TRTCAudioFrameDelegate>

@property(nonatomic, weak)id<ISudAudioEventListener> mISudAudioEventListener;

@property (nonatomic, strong) TRTCCloud* mEngine;

@property(nonatomic, strong)NSMutableSet *roomUserList;

@end

@implementation TXAudioEngineImpl

- (TRTCCloud *)getEngine {
    return self.mEngine;
}

- (NSMutableSet *)roomUserList {
    if (!_roomUserList) {
        _roomUserList = NSMutableSet.new;
    }
    
    return _roomUserList;
}

- (void)setEventListener:(nonnull id<ISudAudioEventListener>)listener {
    _mISudAudioEventListener = listener;
}

- (void)initWithConfig:(AudioConfigModel *)model success:(nullable void(^)(void))success {
    if (self.mEngine != nil) {
        [self destroy];
    }
    
    /* 创建引擎 */
    self.mEngine = [TRTCCloud sharedInstance];
    if (self.mEngine != nil) {
        [self.mEngine setDelegate:self];
        [self.mEngine enableAudioVolumeEvaluation:300];
    }
    
    if (success != nil) {
        success();
    }
}

- (void)destroy {
    [TRTCCloud destroySharedIntance];
    self.mEngine = nil;
    [self.roomUserList removeAllObjects];
}

- (void)joinRoom:(AudioJoinRoomModel *)model {
    if (model == nil)
        return;
    
    TRTCCloud *engine = [self getEngine];
    if (engine != nil) {
        
        TRTCParams *params = [TRTCParams new];
        params.sdkAppId = [model.appId intValue];
        params.userId = model.userID;
        params.userSig = model.token;
        params.strRoomId = model.roomID;
        [engine enterRoom:params appScene:TRTCAppSceneAudioCall];
    }
}

- (void)leaveRoom {
    TRTCCloud *engine = [self getEngine];
    if (engine != nil) {
        /* 退出房间 */
        [engine exitRoom];
    }
    [self.roomUserList removeAllObjects];
}

- (void)startPublishStream {
    TRTCCloud *engine = [self getEngine];
    if (engine != nil) {
        [engine setSystemVolumeType:TRTCSystemVolumeTypeMedia];
        
        [engine startLocalAudio:TRTCAudioQualityDefault];
    }
}

- (void)stopPublishStream {
    TRTCCloud *engine = [self getEngine];
    if (engine != nil) {
        [engine stopLocalAudio];
    }
}

- (void)startSubscribingStream {
    TRTCCloud *engine = [self getEngine];
    if (engine != nil) {
        [engine muteAllRemoteAudio:NO];
    }
}

- (void)stopSubscribingStream {
    TRTCCloud *engine = [self getEngine];
    if (engine != nil) {
        [engine muteAllRemoteAudio:YES];
    }
}

- (void)startPCMCapture {
    TRTCCloud *engine = [self getEngine];
    if (engine != nil) {
        TRTCAudioFrameDelegateFormat *format = [[TRTCAudioFrameDelegateFormat alloc] init];
        format.sampleRate = TRTCAudioSampleRate16000;
        format.channels = 1;
        format.samplesPerCall = 160;
        [engine setCapturedRawAudioFrameDelegateFormat:format];
        
        /* 设置原始音频数据回调 */
        [engine setAudioFrameDelegate:self];
    }
}

- (void)stopPCMCapture {
    TRTCCloud *engine = [self getEngine];
    if (engine != nil) {
        /* 置空原始音频数据回调 */
        [engine setAudioFrameDelegate:nil];
    }
}

- (void)setAudioRouteToSpeaker:(BOOL) enabled {
    TRTCCloud *engine = [self getEngine];
    if (engine != nil) {
        if (enabled) {
            [engine setAudioRoute:TRTCAudioModeSpeakerphone];
        } else {
            [engine setAudioRoute:TRTCAudioModeEarpiece];
        }
    }
}

- (void)sendCommand:(nonnull NSString *)command listener:(nonnull void (^)(int))listener {
    if (command == nil) {
        if (listener) listener(-1);
        return;
    }
    
    TRTCCloud *engine = [self getEngine];
    if (engine != nil) {
        [engine sendCustomCmdMsg:0 data:[command dataUsingEncoding:NSUTF8StringEncoding] reliable:YES ordered:YES];
        if (listener) listener(0);
    } else {
        if (listener) listener(-1);
    }
}

// 更新房间内用户总人数
- (void)updateRoomUserCount {
    if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRoomOnlineUserCountUpdate:)]) {
        [self.mISudAudioEventListener onRoomOnlineUserCountUpdate:(int)self.roomUserList.count + 1];
    }
}

#pragma mark -------------- TRTCCloudDelegate --------------------
- (void)onEnterRoom:(NSInteger)result {
    if (result > 0) {
        if (self.mISudAudioEventListener != nil) {
            if ([self.mISudAudioEventListener respondsToSelector:@selector(onRoomStateUpdate:errorCode:extendedData:)]) {
                [self.mISudAudioEventListener onRoomStateUpdate:HSAudioEngineStateConnected errorCode:0 extendedData:nil];
            }
            [self updateRoomUserCount];
        }
    }
}

- (void)onRecvCustomCmdMsgUserId:(NSString *)userId cmdID:(NSInteger)cmdID seq:(UInt32)seq message:(NSData *)message {
    if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRecvCommand:command:)]) {
        [self.mISudAudioEventListener onRecvCommand:userId command:[[NSString alloc] initWithData:message encoding:NSUTF8StringEncoding]];
    }
}

- (void)onUserVoiceVolume:(NSArray<TRTCVolumeInfo *> *)userVolumes totalVolume:(NSInteger)totalVolume {
    if (self.mISudAudioEventListener == nil || userVolumes == nil || [userVolumes count] == 0) {
        return;
    }
    
    NSMutableDictionary *soundLevels = nil;
    NSNumber *localSoundLevel = nil;
    for (TRTCVolumeInfo *volumeInfo in userVolumes) {
        if (volumeInfo.userId == nil) {
            localSoundLevel = @(volumeInfo.volume);
        } else {
            if (soundLevels == nil) {
                soundLevels = NSMutableDictionary.new;
            }
            soundLevels[volumeInfo.userId] = @(volumeInfo.volume);
        }
    }
    
    // 本地采集音量
    if (localSoundLevel != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onCapturedSoundLevelUpdate:)]) {
        [self.mISudAudioEventListener onCapturedSoundLevelUpdate:localSoundLevel];
    }
    
    // 远程用户音量
    if (soundLevels != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRemoteSoundLevelUpdate:)]) {
        [self.mISudAudioEventListener onRemoteSoundLevelUpdate:soundLevels];
    }
}

- (void)onRemoteUserEnterRoom:(NSString *)userId {
    [self.roomUserList addObject:userId];
    [self updateRoomUserCount];
}

- (void)onRemoteUserLeaveRoom:(NSString *)userId reason:(NSInteger)reason {
    [self.roomUserList removeObject:userId];
    [self updateRoomUserCount];
}

#pragma mark -------------- TRTCAudioFrameDelegate -----------------
- (void)onCapturedRawAudioFrame:(TRTCAudioFrame *)frame {
    [HSThreadUtils runOnUiThread:^{
        if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onCapturedPCMData:)]) {
            [self.mISudAudioEventListener onCapturedPCMData:frame.data];
        }
    }];
}

@end
