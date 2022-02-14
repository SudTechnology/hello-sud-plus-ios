//
//  AgoraAudioEngine.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/14.
//

#import "AgoraAudioEngine.h"
#import <ZegoExpressEngine/ZegoExpressEngine.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import <AgoraRtmKit/AgoraRtmKit.h>

@interface AgoraAudioEngine()<AgoraRtcEngineDelegate, AgoraRtmDelegate, AgoraRtmChannelDelegate, AgoraAudioDataFrameProtocol>
@property(nonatomic, assign)BOOL isMuteAllPlayStreamAudio;
@property(nonatomic, assign)BOOL isPublishing;
@property(nonatomic, strong)dispatch_queue_t queueMute;
@property(nonatomic, weak)id<MediaAudioEventListener> listener;
@property(nonatomic, strong)NSString *roomID;
/// 声网语音引擎
@property(nonatomic, strong)AgoraRtcEngineKit *agoraKit;
/// agora信令
@property(nonatomic, strong)AgoraRtmKit *agoraIM;
/// 信令通道
@property(nonatomic, strong)AgoraRtmChannel *imChannel;
@end

@implementation AgoraAudioEngine

- (dispatch_queue_t)queueMute {
    if (_queueMute == nil) {
        _queueMute = dispatch_queue_create("mute_queue", DISPATCH_QUEUE_SERIAL);
    }
    return _queueMute;
}

/// 设置事件处理器
/// @param listener 事件处理实例
- (void)setEventListener:(id<MediaAudioEventListener>)listener {
    _listener = listener;
}


- (void)config:(nonnull NSString *)appID appKey:(nonnull NSString *)appKey {
    _agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:appID delegate:self];
    [_agoraKit enableAudioVolumeIndication:300 smooth:3 report_vad:YES];
    [_agoraKit enableLocalAudio:NO];
    _agoraIM = [[AgoraRtmKit alloc]initWithAppId:appID delegate:self];
    [_agoraKit setAudioDataFrame:self];
}

- (void)destroy {
    [AgoraRtcEngineKit destroy];
}


- (BOOL)isMicrophoneMuted {
    return [_agoraKit isSpeakerphoneEnabled];
}


- (BOOL)isMuteAllPlayStreamAudio {
    return self.isMuteAllPlayStreamAudio;
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
    // 加入房间通道
    [self.agoraKit muteLocalAudioStream:YES];
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


- (void)muteAllPlayStreamAudio:(BOOL)isMute {
    self.isMuteAllPlayStreamAudio = isMute;
    [_agoraKit muteLocalAudioStream:isMute];
    [_agoraKit muteAllRemoteAudioStreams:isMute];
}


- (void)muteMicrophone:(BOOL)isMute {
    dispatch_async(self.queueMute, ^{
        /// 把采集设备停掉，（静音时不再状态栏提示采集数据）
        /// 异步激活采集通道（此处开销成本过大，相对耗时）
        [self.agoraKit enableLocalAudio:isMute ? NO : YES];
    });
}


- (void)mutePlayStreamAudio:(BOOL)isMute streamID:(nonnull NSString *)streamID {
    NSLog(@"暂不实现mutePlayStreamAudio");
}


- (void)setAllPlayStreamVolume:(NSInteger)volume {
    [self.agoraKit adjustPlaybackSignalVolume:volume];
}


- (void)setPlayVolume:(NSInteger)volume streamID:(nonnull NSString *)streamID {
    NSLog(@"暂不实现setPlayVolume");
    NSUInteger uid = 0;
    [self.agoraKit adjustUserPlaybackSignalVolume:uid volume:(int)volume];
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
    [self.agoraKit setEnableSpeakerphone:YES];
    NSMutableArray *arr = NSMutableArray.new;
    MediaUser *user = MediaUser.new;
    user.userID = [NSString stringWithFormat:@"%ld", uid];
    [arr addObject:user];
    [self.listener onRoomUserUpdate:MediaAudioEngineUpdateTypeAdd userList:arr roomID:self.roomID];
}

- (void)rtcEngine:(AgoraRtcEngineKit* _Nonnull)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onRoomUserUpdate:userList:roomID:)]) {
        NSMutableArray *arr = NSMutableArray.new;
        MediaUser *user = MediaUser.new;
        user.userID = [NSString stringWithFormat:@"%ld", uid];
        [arr addObject:user];
        [self.listener onRoomUserUpdate:MediaAudioEngineUpdateTypeAdd userList:arr roomID:self.roomID];
    }
}

/** Occurs when a remote user (Communication)/host (Live Broadcast) leaves a channel. Same as [userOfflineBlock]([AgoraRtcEngineKit userOfflineBlock:]).

There are two reasons for users to be offline:

- Leave a channel: When the user/host leaves a channel, the user/host sends a goodbye message. When the message is received, the SDK assumes that the user/host leaves a channel.
- Drop offline: When no data packet of the user or host is received for a certain period of time (20 seconds for the Communication profile, and more for the interactive live streaming profile), the SDK assumes that the user/host drops offline. Unreliable network connections may lead to NO detections, so Agora recommends using the [Agora RTM SDK](https://docs.agora.io/en/Real-time-Messaging/product_rtm?platform=All%20Platforms) for more reliable offline detection.

 @param engine AgoraRtcEngineKit object.
 @param uid    ID of the user or host who leaves a channel or goes offline.
 @param reason Reason why the user goes offline, see AgoraUserOfflineReason.
 */
- (void)rtcEngine:(AgoraRtcEngineKit* _Nonnull)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onRoomUserUpdate:userList:roomID:)]) {
        NSMutableArray *arr = NSMutableArray.new;
        MediaUser *user = MediaUser.new;
        user.userID = [NSString stringWithFormat:@"%ld", uid];
        [arr addObject:user];
        [self.listener onRoomUserUpdate:MediaAudioEngineUpdateTypeDelete userList:arr roomID:self.roomID];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didAudioMuted:(BOOL)muted byUid:(NSUInteger)uid {
    NSLog(@"audio muted state:%@, uid:%ld", @(muted), uid);
}

// objective-c
// 获取瞬时说话音量最高的几个用户（即说话者）的用户 ID、他们的音量及本地用户是否在说话。
// @param speakers 为一个数组，包含说话者的用户 ID 、音量及本地用户人声状态。音量的取值范围为 [0, 255]。
// @param totalVolume 指混音后频道内的总音量，取值范围为 [0, 255]。
- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine reportAudioVolumeIndicationOfSpeakers:(NSArray<AgoraRtcAudioVolumeInfo*> *_Nonnull)speakers totalVolume:(NSInteger)totalVolume {
    
    NSNumber *localSoundLevel = nil;
    NSMutableDictionary *soundLevels = NSMutableDictionary.new;
    for (AgoraRtcAudioVolumeInfo *item in speakers) {

        NSString *userID = [NSString stringWithFormat:@"%ld", item.uid];
        NSUInteger volume = item.volume / 255.0 * 100;
        
        if (item.uid > 0) {
            NSLog(@"reportAudioVolumeIndicationOfSpeakers userID:%@, volume:%@", userID, @(volume));
            soundLevels[userID] = @(volume);
        } else {
            // 说话时才回调
            if (item.vad == 1) {
                NSLog(@"reportAudioVolume local, volume:%@", @(volume));
                localSoundLevel = @(volume);
            }
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

#pragma mark AgoraRtmDelegate

/**
 Occurs when the connection state between the SDK and the Agora RTM system changes.

 @param kit An [AgoraRtmKit](AgoraRtmKit) instance.
 @param state The new connection state. See AgoraRtmConnectionState.
 @param reason The reason for the connection state change. See AgoraRtmConnectionChangeReason.
 */
- (void)rtmKit:(AgoraRtmKit * _Nonnull)kit connectionStateChanged:(AgoraRtmConnectionState)state reason:(AgoraRtmConnectionChangeReason)reason {
    NSLog(@"rtmKit connectionStateChanged:%ld, reason:%ld", (long)state, (long)reason);
}

/**
 Occurs when receiving a peer-to-peer message.

 @param kit An [AgoraRtmKit](AgoraRtmKit) instance.
 @param message The received message. Ensure that you check the `type` property when receiving the message instance: If the message type is `AgoraRtmMessageTypeRaw`, you need to downcast the received instance from AgoraRtmMessage to AgoraRtmRawMessage. See AgoraRtmMessageType.
 @param peerId The user ID of the sender.
 */
- (void)rtmKit:(AgoraRtmKit * _Nonnull)kit messageReceived:(AgoraRtmMessage * _Nonnull)message fromPeer:(NSString * _Nonnull)peerId {
    NSLog(@"rtmKit messageReceived:%@, peerId:%@", message, peerId);
}

#pragma mark AgoraRtmChannelDelegate

/**
 Occurs when a user joins the channel.

 When a remote user calls the [joinWithCompletion]([AgoraRtmChannel joinWithCompletion:]) method and successfully joins the channel, the local user receives this callback.

 **NOTE**

 This callback is disabled when the number of the channel members exceeds 512.

 @param channel The channel that the user joins. See AgoraRtmChannel.
 @param member The user joining the channel. See AgoraRtmMember.
 */
- (void)channel:(AgoraRtmChannel * _Nonnull)channel memberJoined:(AgoraRtmMember * _Nonnull)member {
    NSLog(@"rtmKit memberJoined:%@", member.userId);
}

/**
 Occurs when a channel member leaves the channel.

 When a remote channel member calls the [leaveWithCompletion]([AgoraRtmChannel leaveWithCompletion:]) method and successfully leaves the channel, the local user receives this callback.

 **NOTE**

 This callback is disabled when the number of the channel members exceeds 512.

 @param channel The channel that the user leaves. See AgoraRtmChannel.
 @param member The channel member that leaves the channel. See AgoraRtmMember.
 */
- (void)channel:(AgoraRtmChannel * _Nonnull)channel memberLeft:(AgoraRtmMember * _Nonnull)member {
    NSLog(@"rtmKit memberLeft:%@", member.userId);
}

/**
 Occurs when receiving a channel message.

 When a remote channel member calls the [sendMessage]([AgoraRtmChannel sendMessage:completion:]) method and successfully sends out a channel message, the local user receives this callback.

 @param channel The channel, to which the local user belongs. See AgoraRtmChannel.
 @param message The received channel message. See AgoraRtmMessage. Ensure that you check the `type` property when receiving the message instance: If the message type is `AgoraRtmMessageTypeRaw`, you need to downcast the received instance from AgoraRtmMessage to AgoraRtmRawMessage. See AgoraRtmMessageType.
 @param member The message sender. See AgoraRtmMember.
 */
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

- (AgoraAudioFramePosition)getObservedAudioFramePosition {
    return AgoraAudioFramePositionRecord;
}

- (AgoraAudioParam * _Nonnull)getRecordAudioParams {
    AgoraAudioParam *param = AgoraAudioParam.new;
    param.channel = 1;
    param.mode = AgoraAudioRawFrameOperationModeReadOnly;
    param.sampleRate = 44100;
    param.samplesPerCall = 1024;
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
