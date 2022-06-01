//
//  AgoraAudioEngineImpl.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/14.
//

#import "AgoraAudioEngineImpl.h"
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import <AgoraRtmKit/AgoraRtmKit.h>
#import "HSThreadUtils.h"
#import "AsyncCallWrapper.h"

@interface AgoraAudioEngineImpl()<AgoraRtcEngineDelegate, AgoraRtmDelegate, AgoraRtmChannelDelegate, AgoraAudioDataFrameProtocol>

/// 事件监听者
@property(nonatomic, weak)id<ISudAudioEventListener> mISudAudioEventListener;
/// 声网语音引擎
@property(nonatomic, strong)AgoraRtcEngineKit *mEngine;
/// 当前进入房间
@property(nonatomic, strong)NSString *mRoomID;

/// agora信令
@property(nonatomic, strong)AgoraRtmKit *mRtmKit;
/// 信令通道
@property(nonatomic, strong)AgoraRtmChannel *mRtmChannel;
@end

@implementation AgoraAudioEngineImpl

- (AgoraRtcEngineKit *)getEngine {
    return self.mEngine;
}

/// 设置事件处理器
/// @param listener 事件处理实例
- (void)setEventListener:(id<ISudAudioEventListener>)listener {
    _mISudAudioEventListener = listener;
}

/// model.token, 这里的token是RTM的token，用于信令
- (void)initWithConfig:(AudioConfigModel *)model success:(nullable void(^)(void))success {
    
    [[AsyncCallWrapper sharedInstance] addOperationWithBlock:^{
        AgoraRtcEngineConfig * config = [[AgoraRtcEngineConfig alloc] init];
        config.appId = model.appId;
        config.areaCode = AgoraAreaCodeGLOB;
        self.mEngine = [AgoraRtcEngineKit sharedEngineWithConfig:config delegate:self];
        
        if (self.mEngine != NULL) {
            [self.mEngine setChannelProfile:AgoraChannelProfileCommunication];
            [self.mEngine enableAudioVolumeIndication:300 smooth:3 report_vad:YES];
            
            // 初始化rtm信令
            [self initRtm:model success:success];
        }
    }];
}

- (void)destroy {
    [[AsyncCallWrapper sharedInstance] addOperationWithBlock:^{
        [AgoraRtcEngineKit destroy];
        self.mEngine = nil;
        self.mRoomID = nil;
        [self destroyRtm];
    }];
}

- (void)joinRoom:(AudioJoinRoomModel *)model {
    if (model == nil)
        return;
    
    [[AsyncCallWrapper sharedInstance] addOperationWithBlock:^{
        AgoraRtcEngineKit *engine = [self getEngine];
        if (engine != nil) {
            [self joinRtmRoom:model.roomID];
            
            // 默认关闭麦克风，关掉推流
            [engine enableLocalAudio:NO];
            AgoraRtcChannelMediaOptions * channelMediaOptions = [[AgoraRtcChannelMediaOptions alloc] init];
            channelMediaOptions.autoSubscribeAudio = YES;
            channelMediaOptions.autoSubscribeVideo = NO;
            channelMediaOptions.publishLocalAudio = NO;
            channelMediaOptions.publishLocalVideo = NO;
            // 加入频道
            [engine joinChannelByUserAccount:model.userID token:model.token channelId:model.roomID options:channelMediaOptions];
            [engine setEnableSpeakerphone:YES];
            self.mRoomID = model.roomID;
        }
    }];
}

- (void)leaveRoom {
    
    [[AsyncCallWrapper sharedInstance] addOperationWithBlock:^{
        AgoraRtcEngineKit *engine = [self getEngine];
        if (engine != nil) {
            [engine leaveChannel:nil];
            self.mRoomID = nil;
        }
        
        [self leaveRtmRoom];
    }];
}

- (void)startPublishStream {
    [[AsyncCallWrapper sharedInstance] addOperationWithBlock:^{
        AgoraRtcEngineKit *engine = [self getEngine];
        if (engine != nil) {
            [engine enableLocalAudio:YES];  // 开启麦克风采集
            [engine muteLocalAudioStream:NO];  // 发布本地音频流
        }
    }];
}

- (void)stopPublishStream {
    [[AsyncCallWrapper sharedInstance] addOperationWithBlock:^{
        AgoraRtcEngineKit *engine = [self getEngine];
        if (engine != nil) {
            [engine enableLocalAudio:NO]; // 关闭麦克风采集
            [engine muteLocalAudioStream:YES]; // 取消发布本地音频流
        }
    }];
}

- (void)startSubscribingStream {
    [[AsyncCallWrapper sharedInstance] addOperationWithBlock:^{
        AgoraRtcEngineKit *engine = [self getEngine];
        if (engine != nil) {
            [engine muteAllRemoteAudioStreams:NO];
        }
    }];
}

- (void)stopSubscribingStream {
    [[AsyncCallWrapper sharedInstance] addOperationWithBlock:^{
        AgoraRtcEngineKit *engine = [self getEngine];
        if (engine != nil) {
            [engine muteAllRemoteAudioStreams:YES];
        }
    }];
}

/// 开始原始音频采集
- (void)startPCMCapture {
    [[AsyncCallWrapper sharedInstance] addOperationWithBlock:^{
        AgoraRtcEngineKit *engine = [self getEngine];
        if (engine != nil) {
            /* 开启获取PCM数据功能 */
            [engine setAudioDataFrame:self];
        }
    }];
}

/// 结束原始音频采集
- (void)stopPCMCapture {
    [[AsyncCallWrapper sharedInstance] addOperationWithBlock:^{
        AgoraRtcEngineKit *engine = [self getEngine];
        if (engine != nil) {
            /* 关闭获取PCM数据功能 */
            [engine setAudioDataFrame:nil];
        }
    }];
}

- (void)setAudioRouteToSpeaker:(BOOL) enabled {
    [[AsyncCallWrapper sharedInstance] addOperationWithBlock:^{
        AgoraRtcEngineKit *engine = [self getEngine];
        if (engine != nil) {
            [engine setEnableSpeakerphone:enabled];
        }
    }];
}

/// 发送指令
/// @param command 指令内容
- (void)sendCommand:(NSString *)command listener:(void(^)(int))listener {
    [[AsyncCallWrapper sharedInstance] addOperationWithBlock:^{
        AgoraRtmMessage *msg = AgoraRtmMessage.new;
        msg.text = command;
        [self.mRtmChannel sendMessage:msg completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
            if (listener) {
                listener((int)errorCode);
            }
        }];
    }];
}

- (HSAudioEngineRoomState)convertAudioRoomState:(AgoraConnectionStateType)state {
    if (state == AgoraConnectionStateDisconnected) {
        return HSAudioEngineStateDisconnected;
    }
    
    if (state == AgoraConnectionStateConnecting) {
        return HSAudioEngineStateConnecting;
    }
    
    if (state == AgoraConnectionStateConnected) {
        return HSAudioEngineStateConnected;
    }
    
    return HSAudioEngineStateUndefined;
}

#pragma mark AgoraRtcEngineDelegate

- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine reportAudioVolumeIndicationOfSpeakers:(NSArray<AgoraRtcAudioVolumeInfo*> *_Nonnull)speakers totalVolume:(NSInteger)totalVolume {
    if (self.mISudAudioEventListener == nil || speakers == nil || [speakers count] == 0) {
        return;
    }
    
    [HSThreadUtils runOnUiThread:^{
        NSMutableDictionary *soundLevels = nil;
        NSNumber *localSoundLevel = nil;
        for (AgoraRtcAudioVolumeInfo *speaker in speakers) {
            // 转换0-100声音值
            NSUInteger volume = speaker.volume / 255.0 * 100;
            if (speaker.uid > 0) { // 远端用户
                if (soundLevels == nil) {
                    soundLevels = NSMutableDictionary.new;
                }
                NSString *userID = [NSString stringWithFormat:@"%ld", speaker.uid];
                soundLevels[userID] = @(volume);
            } else { // 本地用户
                localSoundLevel = @(volume);
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
    }];
}

- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine connectionChangedToState:(AgoraConnectionStateType)state reason:(AgoraConnectionChangedReason)reason {
    HSAudioEngineRoomState audioRoomState = [self convertAudioRoomState:state];
    if (audioRoomState != HSAudioEngineStateUndefined) {
        [HSThreadUtils runOnUiThread:^{
            if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRoomStateUpdate:errorCode:extendedData:)]) {
                [self.mISudAudioEventListener onRoomStateUpdate:audioRoomState errorCode:0 extendedData:nil];
            }
        }];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit* _Nonnull)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {

}

- (void)rtcEngine:(AgoraRtcEngineKit* _Nonnull)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {

}

#pragma mark - AgoraAudioDataFrameProtocol
- (BOOL)onRecordAudioFrame:(AgoraAudioFrame * _Nonnull)frame {
    [HSThreadUtils runOnUiThread:^{
        if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onCapturedPCMData:)]) {
            NSUInteger length = frame.samplesPerChannel * frame.channels * frame.bytesPerSample;
            NSData *pcmData = [[NSData alloc] initWithBytes:frame.buffer length:length];
            [self.mISudAudioEventListener onCapturedPCMData:pcmData];
        }
    }];
    return YES;
}

- (BOOL)onPlaybackAudioFrame:(AgoraAudioFrame* _Nonnull)frame {
    return NO;
}

- (BOOL)onMixedAudioFrame:(AgoraAudioFrame* _Nonnull)frame {
    return NO;
}

- (BOOL)onPlaybackAudioFrameBeforeMixing:(AgoraAudioFrame* _Nonnull)frame uid:(NSUInteger)uid {
    return NO;
}

- (BOOL)isMultipleChannelFrameWanted {
    return NO;
}

- (BOOL)onPlaybackAudioFrameBeforeMixingEx:(AgoraAudioFrame* _Nonnull)frame channelId:(NSString* _Nonnull)channelId uid:(NSUInteger)uid {
    return NO;
}

- (AgoraAudioFramePosition)getObservedAudioFramePosition {
    return AgoraAudioFramePositionRecord;
}

- (AgoraAudioParam* _Nonnull)getMixedAudioParams {
    return nil;
}

- (AgoraAudioParam * _Nonnull)getRecordAudioParams {
    AgoraAudioParam * param = [[AgoraAudioParam alloc] init];
    param.channel = 1;
    param.sampleRate = 16000;
    param.mode = AgoraAudioRawFrameOperationModeReadOnly;
    param.samplesPerCall = 160;
    return param;
}

- (AgoraAudioParam* _Nonnull)getPlaybackAudioParams {
    return nil;
}

#pragma mark RTM 信令操作
/// 初始化rtm信令, 登录 Agora RTM 系统
- (void)initRtm:(AudioConfigModel *)model success:(nullable dispatch_block_t)success {
    if (self.mRtmKit == nil) {
        self.mRtmKit = [[AgoraRtmKit alloc]initWithAppId:model.appId delegate:self];
    }
    
    if (self.mRtmKit != nil) {
        // 登录Agora RTM 系统
        [_mRtmKit loginByToken:model.token user:model.userID completion:^(AgoraRtmLoginErrorCode errorCode) {
            if (errorCode == AgoraRtmLoginErrorOk) {
                if (success != nil) {
                    [HSThreadUtils runOnUiThread:^{
                        success();
                    }];
                }
            }
        }];
    }
}

// 登出 Agora RTM 系统, 释放当前 RtmClient 实例使用的所有资源
- (void)destroyRtm {
    if (self.mRtmKit != nil) {
        [self.mRtmKit logoutWithCompletion:^(AgoraRtmLogoutErrorCode errorCode) {
            
        }];
        self.mRtmKit = nil;
    }
    self.mRtmChannel = nil;
}

// rtm登录房间
- (void)joinRtmRoom:(NSString *)roomId {
    if (self.mRtmKit != nil) {
        // 创建频道
        self.mRtmChannel = [self.mRtmKit createChannelWithId:roomId delegate:self];
        if (self.mRtmChannel != nil) {
            [self.mRtmChannel joinWithCompletion:^(AgoraRtmJoinChannelErrorCode errorCode) {
                
            }];
        }
    }
}

// rtm退出房间
- (void)leaveRtmRoom {
    if (self.mRtmKit != nil && self.mRtmChannel != nil) {
        [self.mRtmChannel leaveWithCompletion:nil];
        [self.mRtmKit destroyChannelWithId:self.mRoomID];
        self.mRtmChannel = nil;
    }
}

#pragma mark AgoraRtmDelegate

- (void)rtmKit:(AgoraRtmKit * _Nonnull)kit connectionStateChanged:(AgoraRtmConnectionState)state reason:(AgoraRtmConnectionChangeReason)reason {
    NSLog(@"rtmKit connectionStateChanged:%ld, reason:%ld", (long)state, (long)reason);
}

- (void)rtmKit:(AgoraRtmKit * _Nonnull)kit messageReceived:(AgoraRtmMessage * _Nonnull)message fromPeer:(NSString * _Nonnull)peerId {
    NSLog(@"rtmKit messageReceived:%@, peerId:%@", message, peerId);
}


#pragma mark AgoraRtmChannelDelegate

- (void)channel:(AgoraRtmChannel * _Nonnull)channel messageReceived:(AgoraRtmMessage * _Nonnull)message fromMember:(AgoraRtmMember * _Nonnull)member {
    NSLog(@"rtmKit messageReceived:%@, userId:%@", message.text, member.userId);
    if (message.type != AgoraRtmMessageTypeText) {
        NSLog(@"未识别信令消息");
        return;
    }
    
    [HSThreadUtils runOnUiThread:^{
        if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRecvCommand:command:)]) {
            [self.mISudAudioEventListener onRecvCommand:member.userId command:message.text];
        }
    }];
}

- (void)channel:(AgoraRtmChannel * _Nonnull)channel memberCount:(int)count {
    
    [HSThreadUtils runOnUiThread:^{
        if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRoomOnlineUserCountUpdate:)]) {
            [self.mISudAudioEventListener onRoomOnlineUserCountUpdate:count];
        }
    }];
}

@end
