//
//  RCloudAudioEngineImpl.m
//  HelloSud-iOS
//
//  Created by Herbert on 2022/4/8.
//

#import "RCloudAudioEngineImpl.h"
#import <RCVoiceRoomLib/RCVoiceRoomLib.h>
#import <RongIMLibCore/RCCoreClient.h>
#import <RongRTCLib/RCRTCEngine.h>
#import <RongRTCLib/RCRTCMicOutputStream.h>
#import <RongRTCLib/RCRTCRoom.h>
#import <RongIMLib/RongIMLib.h>
#import "ThreadUtils.h"

@interface RCloudAudioEngineImpl() <RCVoiceRoomDelegate, RCIMClientReceiveMessageDelegate>

@property(nonatomic, weak)id<ISudAudioEventListener> mISudAudioEventListener;

@property(nonatomic, copy)NSString *mUserID;

@property(nonatomic, strong)NSMutableSet *roomUserList;

@property(nonatomic, strong)NSMutableDictionary *seatUserMap;

@end

@implementation RCloudAudioEngineImpl

- (RCVoiceRoomEngine *)getEngine {
    return [RCVoiceRoomEngine sharedInstance];
}

- (NSMutableSet *)roomUserList {
    if (!_roomUserList) {
        _roomUserList = NSMutableSet.new;
    }
    
    return _roomUserList;
}

- (NSMutableDictionary *)seatUserMap {
    if (!_seatUserMap) {
        _seatUserMap = [NSMutableDictionary dictionary];
    }
    
    return _seatUserMap;
}

- (void)setEventListener:(nonnull id<ISudAudioEventListener>)listener {
    _mISudAudioEventListener = listener;
}

- (void)initWithConfig:(AudioConfigModel *)model {
    [self initWithConfig:model success:nil];
}

- (void)initWithConfig:(AudioConfigModel *)model success:(nullable dispatch_block_t)success {
    if (model == nil)
        return;
    
    // 设置自己的userId
    self.mUserID = model.userID;
    // 进行 AppKey 设置
    [[RCIMClient sharedRCIMClient] initWithAppKey:model.appKey];
    // 连接 IM 服务
    [[RCIMClient sharedRCIMClient] connectWithToken:model.token dbOpened:^(RCDBErrorCode code) {
        
    } success:^(NSString *userId) {
        if (success != nil) {
            [ThreadUtils runOnUiThread:^{
                success();
            }];
        }
    } error:^(RCConnectErrorCode errorCode) {
        
    }];
        
    [[RCCoreClient sharedCoreClient] addReceiveMessageDelegate:self];
}

- (void)destroy {
    [[RCIMClient sharedRCIMClient] disconnect];
    [[RCCoreClient sharedCoreClient] removeReceiveMessageDelegate:self];
    [self.roomUserList removeAllObjects];
}

- (void)joinRoom:(AudioJoinRoomModel *)model {
    if (model == nil)
        return;
    
    RCVoiceRoomEngine *engine = [self getEngine];
    if (engine != nil) {
        [engine setDelegate:self];
        
        [engine joinRoom:model.roomID success:^{
            [ThreadUtils runOnUiThread:^{
                if (self.mISudAudioEventListener != nil) {
                    if ([self.mISudAudioEventListener respondsToSelector:@selector(onRoomStateUpdate:state:errorCode:extendedData:)]) {
                        [self.mISudAudioEventListener onRoomStateUpdate:model.roomID state:HSAudioEngineStateConnected errorCode:0 extendedData:nil];
                    }
                    
                    [self updateRoomUserCount];
                }
                
                [engine enableSpeaker:YES];
            }];
        } error:^(RCVoiceRoomErrorCode code, NSString * _Nonnull msg) {
            
        }];
    }
}

- (void)leaveRoom {
    RCVoiceRoomEngine *engine = [self getEngine];
    if (engine != nil) {
        [engine leaveRoom:^{
        } error:^(RCVoiceRoomErrorCode code, NSString * _Nonnull msg) {
        }];
    }
    [self.roomUserList removeAllObjects];
}

- (void)startPublishStream {
    RCVoiceRoomEngine *engine = [self getEngine];
    if (engine != nil) {
        [engine getLatestSeatInfo:^(NSArray<RCVoiceSeatInfo *> * _Nonnull rcVoiceSeatInfos) {
            for (int seatIndex = 0; seatIndex < rcVoiceSeatInfos.count; seatIndex++) {
                RCVoiceSeatInfo * rcVoiceSeatInfo = rcVoiceSeatInfos[seatIndex];
                if (rcVoiceSeatInfo.status == RCSeatStatusEmpty) {
                    [engine enterSeat:seatIndex success:^{
                        [engine disableAudioRecording:NO];
                    } error:^(RCVoiceRoomErrorCode code, NSString * _Nonnull msg) {
                        
                    }];
                    
                    return;
                }
            }
        } error:^(RCVoiceRoomErrorCode code, NSString * _Nonnull msg) {
            
        }];
    }
}

- (void)stopPublishStream {
    RCVoiceRoomEngine *engine = [self getEngine];
    if (engine != nil) {
        [engine leaveSeatWithSuccess:^{
            [engine disableAudioRecording:YES];
        } error:^(RCVoiceRoomErrorCode code, NSString * _Nonnull msg) {
            
        }];
    }
}

- (void)startSubscribingStream {
    RCVoiceRoomEngine *engine = [self getEngine];
    if (engine != nil) {
        [engine muteAllRemoteStreams:NO];
    }
}

- (void)stopSubscribingStream {
    RCVoiceRoomEngine *engine = [self getEngine];
    if (engine != nil) {
        [engine muteAllRemoteStreams:YES];
    }
}

- (void)startPCMCapture {
    RCVoiceRoomEngine *engine = [self getEngine];
    if (engine != nil) {
        RCRTCMicOutputStream * defaultAudioStream = [RCRTCEngine sharedInstance].defaultAudioStream;
        if (defaultAudioStream != nil) {
            [defaultAudioStream setRecordAudioDataCallback:^(RCRTCAudioFrame * _Nonnull frame) {
                
//                if (self.mISudAudioEventListener != nil) {
//                    NSData *data = [[NSData alloc] initWithBytes:frame.bytes length:frame.length];
//                    [self.mISudAudioEventListener onCapturedPCMData:data];
//                }
            }];
        }
    }
}

- (void)stopPCMCapture {
    RCVoiceRoomEngine *engine = [self getEngine];
    if (engine != nil) {
        RCRTCMicOutputStream * defaultAudioStream = [RCRTCEngine sharedInstance].defaultAudioStream;
        if (defaultAudioStream != nil) {
            [defaultAudioStream setRecordAudioDataCallback:nil];
        }
    }
}

- (void)setAudioRouteToSpeaker:(BOOL) enabled {
    RCVoiceRoomEngine *engine = [self getEngine];
    if (engine != nil) {
        [engine enableSpeaker:enabled];
    }
}

- (void)sendCommand:(nonnull NSString *)command listener:(nonnull void (^)(int))listener {
    RCRTCRoom *rcrtcroom = [RCRTCEngine sharedInstance].room;
    if (rcrtcroom == nil)
        return;
    
    RCVoiceRoomEngine *engine = [self getEngine];
    if (engine != nil) {
        RCTextMessage *messageContent = [RCTextMessage messageWithContent:command];
        [engine sendMessage:messageContent success:^{
            
        } error:^(RCVoiceRoomErrorCode code, NSString * _Nonnull msg) {
            
        }];
    }
}

// 更新房间内用户总人数
- (void)updateRoomUserCount {
    RCRTCRoom *rcrtcroom = [RCRTCEngine sharedInstance].room;
    if (rcrtcroom == nil)
        return;
    
    if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRoomOnlineUserCountUpdate:count:)]) {
        [self.mISudAudioEventListener onRoomOnlineUserCountUpdate:rcrtcroom.roomId count:(int)self.roomUserList.count + 1];
    }
}

//#pragma mark ---------------- RCIMClientReceiveMessageDelegate -------------------
- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object {
    if (message != nil) {
        [ThreadUtils runOnUiThread:^{
            RCMessageContent *messageContent = message.content;
            if ([messageContent isKindOfClass:[RCTextMessage class]]) {
                RCTextMessage *textMessage = (RCTextMessage *)messageContent;
                if (self.mISudAudioEventListener != nil && [self.mISudAudioEventListener respondsToSelector:@selector(onRecvCommand:command:)]) {
                    [self.mISudAudioEventListener onRecvCommand:message.senderUserId command:textMessage.content];
                }
            }
        }];
    }
}

//#pragma mark ---------------- RCVoiceRoomDelegate -------------------
- (void)userDidEnterSeat:(NSInteger)seatIndex user:(NSString *)userId {
    [ThreadUtils runOnUiThread:^{
        [self.seatUserMap setObject:userId forKey:@(seatIndex)];
    }];
}

- (void)userDidLeaveSeat:(NSInteger)seatIndex user:(NSString *)userId {
    [ThreadUtils runOnUiThread:^{
        [self.seatUserMap removeObjectForKey:@(seatIndex)];
    }];
}

- (void)seatSpeakingStateChanged:(BOOL)speaking
                         atIndex:(NSInteger)index
                      audioLevel:(NSInteger)level {
    [ThreadUtils runOnUiThread:^{
        NSString *userId = [self.seatUserMap objectForKey:@(index)];
        if (userId == nil)
            return;
        float soundLevel = level * 10.0f;
        if ([self.mUserID isEqualToString:userId]) {
            // 本地采集音量
            if ([self.mISudAudioEventListener respondsToSelector:@selector(onCapturedSoundLevelUpdate:)]) {
                [self.mISudAudioEventListener onCapturedSoundLevelUpdate:@(soundLevel)];
            }
        } else {
            // 远程用户音量
            if ([self.mISudAudioEventListener respondsToSelector:@selector(onRemoteSoundLevelUpdate:)]) {
                NSMutableDictionary *soundLevels = NSMutableDictionary.new;
                [soundLevels setObject:@(soundLevel) forKey:userId];
                [self.mISudAudioEventListener onRemoteSoundLevelUpdate:soundLevels];
            }
        }
    }];
}

- (void)userDidEnter:(NSString *)userId {
    [ThreadUtils runOnUiThread:^{
        [self.roomUserList addObject:userId];
        [self updateRoomUserCount];
    }];
}

- (void)userDidExit:(NSString *)userId {
    [ThreadUtils runOnUiThread:^{
        [self.roomUserList removeObject:userId];
        [self updateRoomUserCount];
    }];
}

@end
