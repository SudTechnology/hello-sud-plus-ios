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

@interface AgoraAudioEngine()<AgoraRtcEngineDelegate, AgoraRtmDelegate, AgoraRtmChannelDelegate>
@property(nonatomic, assign)BOOL isMuteAllPlayStreamAudio;
@property(nonatomic, assign)BOOL isPublishing;
@property(nonatomic, strong)dispatch_queue_t queueMute;
@property(nonatomic, weak)id<MediaAudioEventListener> listener;
@property(nonatomic, strong)NSString *roomID;
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
    _agoraIM = [[AgoraRtmKit alloc]initWithAppId:appID delegate:self];
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


- (void)loginRoom:(nonnull NSString *)roomID user:(nonnull MediaUser *)user config:(nullable MediaRoomConfig *)config {
    if (self.roomID.length > 0) {
        [self logoutRoom];
    }
    self.roomID = roomID;
    
    NSUInteger uid = (NSUInteger)[user.userID longLongValue];
    [_agoraKit joinChannelByToken:nil channelId:roomID info:nil uid:uid joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        NSLog(@"join channel success:%@", channel);
    }];
    // 登录IM
    WeakSelf
    [_agoraIM loginByToken:nil user:user.userID completion:^(AgoraRtmLoginErrorCode errorCode) {
        weakSelf.imChannel = [weakSelf.agoraIM createChannelWithId:roomID delegate:self];
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
        [self.agoraKit setEnableSpeakerphone:isMute];
    });
}


- (void)mutePlayStreamAudio:(BOOL)isMute streamID:(nonnull NSString *)streamID {
    NSLog(@"暂未实现mutePlayStreamAudio");
    
//    [ZegoExpressEngine.sharedEngine mutePlayStreamAudio:isMute streamID:streamID];
}


- (void)setAllPlayStreamVolume:(NSInteger)volume {
    [self.agoraKit adjustPlaybackSignalVolume:volume];
}


- (void)setPlayVolume:(NSInteger)volume streamID:(nonnull NSString *)streamID {
    NSLog(@"暂未实现setPlayVolume");
    NSUInteger uid = 0;
    [self.agoraKit adjustUserPlaybackSignalVolume:uid volume:(int)volume];
}


- (void)startPlayingStream:(nonnull NSString *)streamID {
    NSLog(@"暂未实现setPlayVolume");
}


- (void)startPublish:(nonnull NSString *)streamID {
    self.isPublishing = YES;
    [self.agoraKit setEnableSpeakerphone:YES];
}


- (void)stopPlayingStream:(nonnull NSString *)streamID {
    NSLog(@"暂未实现stopPlayingStream");
}


- (void)stopPublishStream {
    self.isPublishing = NO;
    [self.agoraKit setEnableSpeakerphone:NO];
}

/// 发送指令
/// @param command 指令内容
/// @param roomID 房间ID
- (void)sendCommand:(NSString *)command roomID:(NSString *)roomID result:(void(^)(int))result; {
    [ZegoExpressEngine.sharedEngine sendCustomCommand:command toUserList:nil roomID:roomID callback:^(int errorCode) {
        result(errorCode);
    }];
    AgoraRtmMessage *msg = AgoraRtmMessage.new;
    msg.text = command;
    [self.imChannel sendMessage:msg completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
        if (result) {
            result((int)errorCode);
        }
    }];
}

#pragma mark ZegoEventHandler

- (void)onIMRecvCustomCommand:(NSString *)command fromUser:(ZegoUser *)fromUser roomID:(NSString *)roomID {
//    if (self.eventHandler != nil && [self.eventHandler respondsToSelector:@selector(onIMRecvCustomCommand:fromUser:roomID:)]) {
//        MediaUser *user = MediaUser.new;
//        user.userID = fromUser.userID;
//        user.nickname = fromUser.userName;
//        [self.eventHandler onIMRecvCustomCommand:command fromUser:user roomID:roomID];
//    }
}

- (void)onCapturedSoundLevelUpdate:(NSNumber *)soundLevel {
//    if (self.eventHandler != nil && [self.eventHandler respondsToSelector:@selector(onCapturedSoundLevelUpdate:)]) {
//        [self.eventHandler onCapturedSoundLevelUpdate:soundLevel];
//    }
}

- (void)onRemoteSoundLevelUpdate:(NSDictionary<NSString *,NSNumber *> *)soundLevels {
//    if (self.eventHandler != nil && [self.eventHandler respondsToSelector:@selector(onRemoteSoundLevelUpdate:)]) {
//        [self.eventHandler onRemoteSoundLevelUpdate:soundLevels];
//    }
}

- (void)onRoomStreamUpdate:(ZegoUpdateType)updateType streamList:(NSArray<ZegoStream *> *)streamList extendedData:(NSDictionary *)extendedData roomID:(NSString *)roomID {
//    if (self.eventHandler != nil && [self.eventHandler respondsToSelector:@selector(onRoomStreamUpdate:streamList:extendedData:roomID:)]) {
//        NSMutableArray *arr = NSMutableArray.new;
//        for (ZegoStream *m in streamList) {
//            MediaStream *stream = MediaStream.new;
//            MediaUser *user = MediaUser.new;
//            user.userID = m.user.userID;
//            user.nickname = m.user.userName;
//            stream.user = user;
//            stream.streamID = m.streamID;
//            stream.extraInfo = m.extraInfo;
//            [arr addObject:stream];
//        }
//        [self.eventHandler onRoomStreamUpdate:updateType streamList:arr extendedData:extendedData roomID:roomID];
//    }
}

- (void)onPublisherStateUpdate:(ZegoPublisherState)state errorCode:(int)errorCode extendedData:(NSDictionary *)extendedData streamID:(NSString *)streamID {
    NSLog(@"zego onPublisherStateUpdate:%ld, errorcode:%d, streamID:%@, extendedData:%@", state, errorCode, streamID, extendedData);
//    if (self.eventHandler != nil && [self.eventHandler respondsToSelector:@selector(onPublisherStateUpdate:errorCode:extendedData:streamID:)]) {
//        [self.eventHandler onPublisherStateUpdate:state errorCode:errorCode extendedData:extendedData streamID:streamID];
//    }
}

- (void)onPlayerStateUpdate:(ZegoPlayerState)state errorCode:(int)errorCode extendedData:(NSDictionary *)extendedData streamID:(NSString *)streamID {
//    if (self.eventHandler != nil && [self.eventHandler respondsToSelector:@selector(onPlayerStateUpdate:errorCode:extendedData:streamID:)]) {
//        [self.eventHandler onPlayerStateUpdate:state extendedData:extendedData streamID:streamID];
//    }
}

- (void)onNetworkModeChanged:(ZegoNetworkMode)mode {
//    if (self.eventHandler != nil && [self.eventHandler respondsToSelector:@selector(onNetworkModeChanged:)]) {
//        [self.eventHandler onNetworkModeChanged:mode];
//    }
}

- (void)onRoomUserUpdate:(ZegoUpdateType)updateType userList:(NSArray<ZegoUser *> *)userList roomID:(NSString *)roomID {
//    if (self.eventHandler != nil && [self.eventHandler respondsToSelector:@selector(onRoomUserUpdate:userList:roomID:)]) {
//        NSMutableArray *arr = NSMutableArray.new;
//        for (ZegoUser *u in userList) {
//            MediaUser *user = MediaUser.new;
//            user.userID = u.userID;
//            user.nickname = u.userName;
//            [arr addObject:user];
//        }
//        [self.eventHandler onRoomUserUpdate:updateType userList:arr roomID:roomID];
//    }
}

/// The callback triggered every 30 seconds to report the current number of online users.
///
/// Available since: 1.7.0
/// Description: This method will notify the user of the current number of online users in the room..
/// Use cases: Developers can use this callback to show the number of user online in the current room.
/// When to call /Trigger: After successfully logging in to the room.
/// Restrictions: None.
/// Caution: 1. This function is called back every 30 seconds. 2. Because of this design, when the number of users in the room exceeds 500, there will be some errors in the statistics of the number of online people in the room.
///
/// @param count Count of online users.
/// @param roomID Room ID where the user is logged in, a string of up to 128 bytes in length.
- (void)onRoomOnlineUserCountUpdate:(int)count roomID:(NSString *)roomID {
//    if (self.eventHandler != nil && [self.eventHandler respondsToSelector:@selector(onRoomOnlineUserCountUpdate:roomID:)]) {
//        [self.eventHandler onRoomOnlineUserCountUpdate:count roomID:roomID];
//    }
}

- (void)onRoomStateUpdate:(ZegoRoomState)state errorCode:(int)errorCode extendedData:(nullable NSDictionary *)extendedData roomID:(NSString *)roomID {
//    if (self.eventHandler != nil && [self.eventHandler respondsToSelector:@selector(onRoomStateUpdate:errorCode:extendedData:roomID:)]) {
//        [self.eventHandler onRoomStateUpdate:(MediaAudioEngineRoomState)state errorCode:errorCode extendedData:extendedData roomID:roomID];
//    }
}

#pragma mark AgoraRtmDelegate

/**
 Occurs when the connection state between the SDK and the Agora RTM system changes.

 @param kit An [AgoraRtmKit](AgoraRtmKit) instance.
 @param state The new connection state. See AgoraRtmConnectionState.
 @param reason The reason for the connection state change. See AgoraRtmConnectionChangeReason.
 */
- (void)rtmKit:(AgoraRtmKit * _Nonnull)kit connectionStateChanged:(AgoraRtmConnectionState)state reason:(AgoraRtmConnectionChangeReason)reason {
    
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
}

@end
