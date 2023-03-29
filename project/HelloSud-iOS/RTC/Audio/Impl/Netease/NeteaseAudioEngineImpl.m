//
//  NeteaseAudioEngineImpl.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/18.
//

#import "NeteaseAudioEngineImpl.h"
#import <NERtcSDK/INERtcEngine.h>
#import <NERtcSDK/NERtcEngineDelegate.h>
#import <NERtcSDK/NERtcSDK.h>
#import <NIMSDK/NIMSDK.h>
#import "HSThreadUtils.h"

@interface NeteaseAudioEngineImpl () <NIMLoginManagerDelegate, NIMChatManagerDelegate, NERtcEngineDelegateEx, NERtcEngineAudioFrameObserver>

/// 事件监听者
@property(nonatomic, weak)id<ISudAudioEventListener> mISudAudioEventListener;
/// 当前进入房间
@property(nonatomic, strong)NSString *mRoomID;

@property(nonatomic, strong)NSMutableSet *roomUserList;

@end


@implementation NeteaseAudioEngineImpl

- (void)setEventListener:(nonnull id<ISudAudioEventListener>)listener {
    _mISudAudioEventListener = listener;
}

- (id<INERtcEngineEx>)getEngine {
    return [NERtcEngine sharedEngine];
}

- (NSMutableSet *)roomUserList {
    if (!_roomUserList) {
        _roomUserList = NSMutableSet.new;
    }
    
    return _roomUserList;
}

- (void)initWithConfig:(AudioConfigModel *)model success:(nullable void(^)(void))success {
    if (model == nil)
        return;
    
    // 连接 IM 服务
    [[[NIMSDK sharedSDK] loginManager] login:model.userID token:model.token completion:^(NSError * _Nullable error) {
        if (error == nil) {
            if (success != nil) {
                [HSThreadUtils runOnUiThread:^{
                    success();
                }];
            }
        }
    }];
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
    
    id<INERtcEngineEx> engine = [self getEngine];
    if (engine != nil) {
        NERtcEngineContext *context = [[NERtcEngineContext alloc] init];
        // 设置通话相关信息的回调
        context.engineDelegate = self;
        // 设置当前应用的appKey
        context.appKey = model.appKey;
        [engine setParameters:@{kNERtcKeyPublishSelfStreamEnabled: @YES, kNERtcKeyAutoSubscribeAudio: @YES, }];
        [engine setAudioProfile:kNERtcAudioProfileHighQualityStereo scenario:kNERtcAudioScenarioChatRoom];
        [engine setupEngineWithContext:context];
        [engine enableAudioVolumeIndication:YES interval:1000];
        [engine setChannelProfile:kNERtcChannelProfileLiveBroadcasting];
        [engine setLoudspeakerMode:YES];
        [engine setAudioSessionOperationRestriction:kNERtcAudioSessionOperationRestrictionDeactivateSession];
    }
}

- (void)destroy {
    id<INERtcEngineEx> engine = [self getEngine];
    if (engine != nil) {
        [NERtcEngine destroyEngine]; //销毁实例
    }
    
    [[[NIMSDK sharedSDK] loginManager] logout:nil];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
    self.mRoomID = nil;
    [self.roomUserList removeAllObjects];
}

- (void)joinRoom:(AudioJoinRoomModel *)model {
    if (model == nil)
        return;
    
    id<INERtcEngineEx> engine = [self getEngine];
    if (engine != nil) {
        // 默认关闭麦克风，关掉推流
//        [self stopPublishStream];
        [engine joinChannelWithToken:model.token channelName:model.roomID myUid:[model.userID longLongValue] completion:^ (NSError * _Nullable error, uint64_t channelId, uint64_t elapesd, uint64_t uid) {
            [HSThreadUtils runOnUiThread:^{
                if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRoomStateUpdate:errorCode:extendedData:)]) {
                    [self.mISudAudioEventListener onRoomStateUpdate:HSAudioEngineStateConnected errorCode:0 extendedData:nil];
                }
            }];
        }];
        [engine enableAudioVolumeIndication:YES interval:300];
    }
    self.mRoomID = model.roomID;
    
    // IM 进入聊天室
    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
    request.roomId = model.roomID;
    [[[NIMSDK sharedSDK] chatroomManager] enterChatroom:request completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom, NIMChatroomMember * _Nullable me) {
        if (!error) {  // 进入聊天室成功
            [[[NIMSDK sharedSDK] chatManager] addDelegate:self];
        } else {   // 进入聊天室失败
            
        }
    }];
}

- (void)leaveRoom {
    id<INERtcEngineEx> engine = [self getEngine];
    if (engine != nil) {
        [engine leaveChannel];
        [engine enableLocalAudio:NO];
        
        [engine enableAudioVolumeIndication:NO interval:300];
    }
    
    // IM 离开聊天室
    [[[NIMSDK sharedSDK] chatroomManager] exitChatroom:self.mRoomID completion:nil];
    [[[NIMSDK sharedSDK] chatManager] removeDelegate:self];
    self.mRoomID = nil;
    [self.roomUserList removeAllObjects];
}

- (void)startPublishStream {
    id<INERtcEngineEx> engine = [self getEngine];
    if (engine != nil) {
        [engine enableLocalAudio:YES];  // 开启麦克风采集
        [engine muteLocalAudio:NO];  // 发布本地音频流
    }
}

- (void)stopPublishStream {
    id<INERtcEngineEx> engine = [self getEngine];
    if (engine != nil) {
        [engine enableLocalAudio:NO];  // 关闭麦克风采集
        [engine muteLocalAudio:YES];  // 取消发布本地音频流
    }
}

- (void)startSubscribingStream {
    id<INERtcEngineEx> engine = [self getEngine];
    if (engine != nil) {
        [engine subscribeAllRemoteAudio:YES];
    }
}

- (void)stopSubscribingStream {
    id<INERtcEngineEx> engine = [self getEngine];
    if (engine != nil) {
        [engine subscribeAllRemoteAudio:NO];
    }
}

- (void)startPCMCapture {
    id<INERtcEngineEx> engine = [self getEngine];
    if (engine != nil) {
        // 设置音频回调参数
        NERtcAudioFrameRequestFormat * formatPCM = [[NERtcAudioFrameRequestFormat alloc] init];
        formatPCM.channels = 1;
        formatPCM.sampleRate = 16000;
        formatPCM.mode = kNERtcAudioFrameOpModeReadOnly;
        [engine setRecordingAudioFrameParameters:formatPCM];
        [engine setAudioFrameObserver:self];
    }
}

- (void)stopPCMCapture {
    id<INERtcEngineEx> engine = [self getEngine];
    if (engine != nil) {
        /* 关闭获取PCM数据功能 */
        [engine setAudioFrameObserver:nil];
    }
}

- (void)setAudioRouteToSpeaker:(BOOL) enabled {
    id<INERtcEngineEx> engine = [self getEngine];
    if (engine != nil) {
        [engine setLoudspeakerMode:enabled];
    }
}

- (void)sendCommand:(nonnull NSString *)command listener:(nonnull void (^)(int))listener {
    NIMSession *session = [NIMSession session:self.mRoomID type:NIMSessionTypeChatroom];
    NIMMessage *message = [[NIMMessage alloc] init];
    message.text = command;
    NSError *error = nil;
    
    [[[NIMSDK sharedSDK] chatManager] sendMessage:message toSession:session error:&error];
    if (listener) listener(error == nil ? 0 : (int)error.code);
}

// 更新房间内用户总人数
- (void)updateRoomUserCount {
    if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRoomOnlineUserCountUpdate:)]) {
        [self.mISudAudioEventListener onRoomOnlineUserCountUpdate:(int)self.roomUserList.count + 1];
    }
}

//#pragma mark ---------------- NIMLoginManagerDelegate -------------------
- (void)onLogin:(NIMLoginStep)step {
    
}

//#pragma mark ---------------- NIMChatManagerDelegate -------------------
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages {
    if (self.mISudAudioEventListener == nil || messages == nil || [messages count] == 0) {
        return;
    }
    
    [HSThreadUtils runOnUiThread:^{
        for (NIMMessage *message in messages) {
            if (message.messageType == NIMMessageTypeText) {
                if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRecvCommand:command:)]) {
                    [self.mISudAudioEventListener onRecvCommand:message.from command:message.text];
                }
            }
        }
    }];
}

#pragma mark ---------------- NERtcEngineDelegateEx ----------------
- (void)onLocalAudioVolumeIndication:(int)volume {
    [HSThreadUtils runOnUiThread:^{
        // 本地采集音量
        if ([self.mISudAudioEventListener respondsToSelector:@selector(onCapturedSoundLevelUpdate:)]) {
            [self.mISudAudioEventListener onCapturedSoundLevelUpdate:@(volume)];
        }
    }];
}

-(void)onRemoteAudioVolumeIndication:(nullable NSArray<NERtcAudioVolumeInfo*> *)speakers totalVolume:(int)totalVolume {
    [HSThreadUtils runOnUiThread:^{
        NSMutableDictionary *soundLevels = NSMutableDictionary.new;
        for (NERtcAudioVolumeInfo *speaker in speakers) {
            NSString *userID = [NSString stringWithFormat:@"%llu", speaker.uid];
            soundLevels[userID] = @(speaker.volume);
        }
        
        // 远程用户音量
        if (soundLevels != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRemoteSoundLevelUpdate:)]) {
            [self.mISudAudioEventListener onRemoteSoundLevelUpdate:soundLevels];
        }
    }];
}

- (void)onNERtcEngineUserDidJoinWithUserID:(uint64_t)userID userName:(NSString *)userName {
    [HSThreadUtils runOnUiThread:^{
        [self.roomUserList addObject:@(userID)];
        [self updateRoomUserCount];
    }];
}

- (void)onNERtcEngineUserDidLeaveWithUserID:(uint64_t)userID reason:(NERtcSessionLeaveReason)reason {
    [HSThreadUtils runOnUiThread:^{
        [self.roomUserList removeObject:@(userID)];
        [self updateRoomUserCount];
    }];
}

//#pragma mark ---------------- NERtcEngineAudioFrameObserver -------------------
- (void)onNERtcEngineAudioFrameDidRecord:(NERtcAudioFrame *)frame {
    if (self.mISudAudioEventListener != nil) {
        NSUInteger dataLength = frame.format.channels * frame.format.samplesPerChannel * frame.format.bytesPerSample;
        NSData * data = [NSData dataWithBytes:frame.data length:dataLength];
        [self.mISudAudioEventListener onCapturedPCMData:data];
    }
}

@end
