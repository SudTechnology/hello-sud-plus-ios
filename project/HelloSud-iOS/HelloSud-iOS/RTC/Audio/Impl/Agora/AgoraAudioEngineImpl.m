//
//  AgoraAudioEngineImpl.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/14.
//

#import "AgoraAudioEngineImpl.h"
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import <AgoraRtmKit/AgoraRtmKit.h>

@interface AgoraAudioEngineImpl()<AgoraRtcEngineDelegate, AgoraRtmDelegate, AgoraRtmChannelDelegate, AgoraAudioDataFrameProtocol>

/// 是否静音所有播放流
@property(nonatomic, assign)BOOL isMuteAllPlayStreamAudio;
/// 是否在推流
@property(nonatomic, assign)BOOL isPublishing;
/// 事件监听者
@property(nonatomic, weak)id<AudioEventListener> listener;
/// 当前进入房间
@property(nonatomic, strong)NSString *roomID;
/// 声网语音引擎
@property(nonatomic, strong)AgoraRtcEngineKit *agoraKit;
/// agora信令
@property(nonatomic, strong)AgoraRtmKit *agoraIM;
/// 信令通道
@property(nonatomic, strong)AgoraRtmChannel *imChannel;
@end

@implementation AgoraAudioEngineImpl

/// 设置事件处理器
/// @param listener 事件处理实例
- (void)setEventListener:(id<AudioEventListener>)listener {
    _listener = listener;
}


- (void)initWithConfig:(NSDictionary *)config {
    NSString *appID = config[@"appID"];
    _agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:appID delegate:self];
    [_agoraKit enableAudioVolumeIndication:300 smooth:3 report_vad:YES];
    _agoraIM = [[AgoraRtmKit alloc]initWithAppId:appID delegate:self];
    [_agoraKit setAudioDataFrame:self];
}

- (void)unInit {
    [AgoraRtcEngineKit destroy];
    _agoraKit = nil;
}

- (BOOL)isPublishing {
    return _isPublishing;
}

/// 开始原始音频采集
- (void)startCapture {
    [_agoraKit setAudioDataFrame:self];
}

/// 结束原始音频采集
- (void)stopCapture {
    [_agoraKit setAudioDataFrame:nil];
}

- (void)loginRoom:(nonnull NSString *)roomID user:(nonnull MediaUser *)user config:(nullable MediaRoomConfig *)config {
    if (self.roomID.length > 0) {
        [self logoutRoom];
    }
    self.roomID = roomID;
    WeakSelf
    NSUInteger uid = (NSUInteger)[user.userID longLongValue];
    // 关闭推流、采集
    [self.agoraKit enableLocalAudio:NO];
    // 加入房间通道
    [_agoraKit joinChannelByToken:nil channelId:roomID info:nil uid:uid joinSuccess:nil];
    // 登录IM
    [_agoraIM loginByToken:nil user:user.userID completion:^(AgoraRtmLoginErrorCode errorCode) {
        weakSelf.imChannel = [weakSelf.agoraIM createChannelWithId:roomID delegate:self];
        // 加入房间信令通道
        [weakSelf.imChannel joinWithCompletion:^(AgoraRtmJoinChannelErrorCode errorCode) {
            NSLog(@"join im channel state:%ld", (long)errorCode);
        }];
    }];
}


- (void)logoutRoom {
    if (self.isPublishing) {
        [self stopPublishStream];
    }
    [_agoraKit leaveChannel:nil];
}

- (void)muteMicrophone:(BOOL)isMute {
    [self.agoraKit enableLocalAudio:isMute ? NO : YES];
}


- (void)startPlayingStream:(nonnull NSString *)streamID {
    NSLog(@"暂不实现setPlayVolume");
}


- (void)startPublish:(nonnull NSString *)streamID {
    self.isPublishing = YES;
    [self.agoraKit muteLocalAudioStream:NO];
}


- (void)stopPlayingStream:(nonnull NSString *)streamID {
    NSLog(@"暂不实现stopPlayingStream");
}


- (void)stopPublishStream {
    self.isPublishing = NO;
    [self.agoraKit muteLocalAudioStream:YES];
}

/// 发送指令
/// @param command 指令内容
/// @param roomID 房间ID
- (void)sendCommand:(NSString *)command roomID:(NSString *)roomID result:(void(^)(int))result; {
    AgoraRtmMessage *msg = AgoraRtmMessage.new;
    msg.text = command;
    [self.imChannel sendMessage:msg completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
        if (result) {
            result((int)errorCode);
        }
    }];
}

#pragma mark AgoraRtcEngineDelegate

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    NSLog(@"join channel success:%@", channel);
    [self.agoraKit muteLocalAudioStream:YES];
    [self.agoraKit setEnableSpeakerphone:YES];
    NSMutableArray *arr = NSMutableArray.new;
    MediaUser *user = MediaUser.new;
    user.userID = [NSString stringWithFormat:@"%ld", uid];
    [arr addObject:user];
    [self.listener onRoomUserUpdate:HSAudioEngineUpdateTypeAdd userList:arr roomID:self.roomID];
}

- (void)rtcEngine:(AgoraRtcEngineKit* _Nonnull)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onRoomUserUpdate:userList:roomID:)]) {
        NSMutableArray *arr = NSMutableArray.new;
        MediaUser *user = MediaUser.new;
        user.userID = [NSString stringWithFormat:@"%ld", uid];
        [arr addObject:user];
        [self.listener onRoomUserUpdate:HSAudioEngineUpdateTypeAdd userList:arr roomID:self.roomID];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit* _Nonnull)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onRoomUserUpdate:userList:roomID:)]) {
        NSMutableArray *arr = NSMutableArray.new;
        MediaUser *user = MediaUser.new;
        user.userID = [NSString stringWithFormat:@"%ld", uid];
        [arr addObject:user];
        [self.listener onRoomUserUpdate:HSAudioEngineUpdateTypeDelete userList:arr roomID:self.roomID];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didAudioMuted:(BOOL)muted byUid:(NSUInteger)uid {
    NSLog(@"audio muted state:%@, uid:%ld", @(muted), uid);
}

- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine reportAudioVolumeIndicationOfSpeakers:(NSArray<AgoraRtcAudioVolumeInfo*> *_Nonnull)speakers totalVolume:(NSInteger)totalVolume {
    
    NSNumber *localSoundLevel = nil;
    NSMutableDictionary *soundLevels = NSMutableDictionary.new;
    for (AgoraRtcAudioVolumeInfo *item in speakers) {

        NSString *userID = [NSString stringWithFormat:@"%ld", item.uid];
        // 转换0-100声音值
        NSUInteger volume = item.volume / 255.0 * 100;
        NSLog(@"reportAudioVolumeIndicationOfSpeakers userID:%@, volume:%@", userID, @(volume));
        if (item.uid > 0) {
            soundLevels[userID] = @(volume);
        } else {
            localSoundLevel = @(volume);
        }
    }
    
    // 本地采集音量
    if (self.isPublishing && localSoundLevel && self.listener != nil && [self.listener respondsToSelector:@selector(onCapturedSoundLevelUpdate:)]) {
        [self.listener onCapturedSoundLevelUpdate:localSoundLevel];
    }
    // 远程用户音量
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onRemoteSoundLevelUpdate:)]) {
        [self.listener onRemoteSoundLevelUpdate:soundLevels];
    }
    
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine localAudioStateChange:(AgoraAudioLocalState)state error:(AgoraAudioLocalError)error {

    NSLog(@"localAudioStateChange:%@, error:%@", @(state), @(error));
}

#pragma mark AgoraRtmDelegate

- (void)rtmKit:(AgoraRtmKit * _Nonnull)kit connectionStateChanged:(AgoraRtmConnectionState)state reason:(AgoraRtmConnectionChangeReason)reason {
    NSLog(@"rtmKit connectionStateChanged:%ld, reason:%ld", (long)state, (long)reason);
}

- (void)rtmKit:(AgoraRtmKit * _Nonnull)kit messageReceived:(AgoraRtmMessage * _Nonnull)message fromPeer:(NSString * _Nonnull)peerId {
    NSLog(@"rtmKit messageReceived:%@, peerId:%@", message, peerId);
}


#pragma mark AgoraRtmChannelDelegate

- (void)channel:(AgoraRtmChannel * _Nonnull)channel memberJoined:(AgoraRtmMember * _Nonnull)member {
    NSLog(@"rtmKit memberJoined:%@", member.userId);
}

- (void)channel:(AgoraRtmChannel * _Nonnull)channel memberLeft:(AgoraRtmMember * _Nonnull)member {
    NSLog(@"rtmKit memberLeft:%@", member.userId);
}

- (void)channel:(AgoraRtmChannel * _Nonnull)channel messageReceived:(AgoraRtmMessage * _Nonnull)message fromMember:(AgoraRtmMember * _Nonnull)member {
    NSLog(@"rtmKit messageReceived:%@, userId:%@", message.text, member.userId);
    if (message.type != AgoraRtmMessageTypeText) {
        NSLog(@"未识别信令消息");
        return;
    }
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onIMRecvCustomCommand:fromUser:roomID:)]) {
        MediaUser *user = MediaUser.new;
        user.userID = member.userId;
        [self.listener onIMRecvCustomCommand:message.text fromUser:user roomID:member.channelId];
    }
}

#pragma mark - AgoraAudioDataFrameProtocol

- (BOOL)isMultipleChannelFrameWanted {
    return NO;
}

- (AgoraAudioFramePosition)getObservedAudioFramePosition {
    return AgoraAudioFramePositionRecord;
}

- (AgoraAudioParam * _Nonnull)getRecordAudioParams {
    AgoraAudioParam * param = [[AgoraAudioParam alloc] init];
    param.channel = 1;
    param.sampleRate = 16000;
    param.mode = AgoraAudioRawFrameOperationModeReadOnly;
    param.samplesPerCall = 160;
    return param;
}

- (BOOL)onRecordAudioFrame:(AgoraAudioFrame * _Nonnull)frame {
    NSUInteger length = frame.samplesPerChannel * frame.channels * frame.bytesPerSample;
    NSData *a_data = [[NSData alloc] initWithBytes:frame.buffer length:length];
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onCapturedAudioData:)]) {
        [self.listener onCapturedAudioData:a_data];
    }
    return true;
}

@end
