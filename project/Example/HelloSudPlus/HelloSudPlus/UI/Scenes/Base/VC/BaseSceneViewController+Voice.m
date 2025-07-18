//
//  AudioRoomViewController+Voice.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/26.
//

#import "BaseSceneViewController+Voice.h"
#import "BaseSceneViewController.h"
#import "IMRoomManager.h"
#import "SudAudioPlayer.h"

@implementation BaseSceneViewController (Voice)

/// 开启推流
- (void)startPublishStream {
    if (self.gameEventHandler.sudFSMMGDecorator.keyWordASRing) {
        [self startCaptureAudioToASR];
    }
    [AudioEngineFactory.shared.audioEngine startPublishStream];
}

/// 关闭推流
- (void)stopPublish {
    if (self.gameEventHandler.sudFSMMGDecorator.keyWordASRing) {
        [self stopCaptureAudioToASR];
    }
    [AudioEngineFactory.shared.audioEngine stopPublishStream];
}

- (void)loginRoom {
    /// 设置语音引擎事件回调
    WeakSelf
    AudioJoinRoomModel *audioJoinRoomModel = nil;
    audioJoinRoomModel = [[AudioJoinRoomModel alloc] init];
    audioJoinRoomModel.userID = AppService.shared.login.loginUserInfo.userID;
    audioJoinRoomModel.userName = AppService.shared.login.loginUserInfo.name;
    audioJoinRoomModel.roomID = self.roomID;
    audioJoinRoomModel.token = self.enterModel.rtcToken;
    if (AppService.shared.rtcConfigModel != nil) {
        audioJoinRoomModel.appId = AppService.shared.rtcConfigModel.appId;
    }

    if (audioJoinRoomModel == nil)
        return;

    // 配置语音引擎
    AudioConfigModel *configModel = AppService.shared.rtcConfigModel;
    if (configModel) {
        NSString *rtcType = AppService.shared.rtcType;

        configModel.userID = AppService.shared.login.loginUserInfo.userID;
        if ([rtcType isEqualToString:kRtcTypeRongCloud]) {
            configModel.token = self.enterModel.rtcToken;
        } else {
            configModel.token = self.enterModel.rtiToken;
        }

        if ([AppService shared].configModel != nil && [AppService shared].configModel.agoraCfg != nil) {
            IMRoomManager.sharedInstance.userId = AppService.shared.login.loginUserInfo.userID;
            [[IMRoomManager sharedInstance] init:[AppService shared].configModel.agoraCfg.appId listener:self];
            [[IMRoomManager sharedInstance] joinRoom:self.roomID
                                              userID:AppService.shared.login.loginUserInfo.userID
                                            userName:AppService.shared.login.loginUserInfo.name
                                               token:self.enterModel.imToken
                                             success:^{
                                                 [weakSelf onHandleCrossRoomImConnected];
                                             } fail:^(NSInteger code, NSString *msg) {

                    }];
        }

        [AudioEngineFactory.shared.audioEngine initWithConfig:configModel success:^{
            [self joinRoom:audioJoinRoomModel];
        }];
        return;
    }

    [self joinRoom:audioJoinRoomModel];
    [self joinRoomIm];
}

/// 加入房间IM
- (void)joinRoomIm {
    WeakSelf
    DDLogDebug(@"joinRoomIm");
    [[IMRoomManager sharedInstance] joinRoom:self.roomID userID:AppService.shared.login.loginUserInfo.userID userName:AppService.shared.login.loginUserInfo.name token:self.enterModel.imToken success:^{
        [weakSelf onHandleCrossRoomImConnected];
    }                                   fail:^(NSInteger code, NSString *msg) {
        DDLogError(@"joinRoomIm error:%@(%ld)", msg, code);
    }];
}

- (void)joinRoom:(AudioJoinRoomModel *)audioJoinRoomModel {
    [AudioEngineFactory.shared.audioEngine joinRoom:audioJoinRoomModel];
    [AudioEngineFactory.shared.audioEngine setEventListener:self];
    [AudioEngineFactory.shared.audioEngine setAudioRouteToSpeaker:YES];
}


- (void)logoutRoom:(void (^)(void))finished {
    [kAudioRoomService reqExitRoom:self.roomID.longLongValue];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    // 离开房间
    [AudioEngineFactory.shared.audioEngine leaveRoom];
    [[IMRoomManager sharedInstance] leaveRoom];
    [self destroyGame];
    if (finished) finished();
}

#pragma mark =======音频采集=======

/// 开始音频采集
- (void)startCaptureAudioToASR {
    [AudioEngineFactory.shared.audioEngine startPCMCapture];
}

/// 停止音频采集
- (void)stopCaptureAudioToASR {
    [AudioEngineFactory.shared.audioEngine stopPCMCapture];
}

/// 拉取视频流
/// @param videoView 展示视频视图
- (void)startToPullVideo:(UIView *)videoView streamID:(NSString *)streamID {
    if ([AudioEngineFactory.shared.audioEngine respondsToSelector:@selector(startPlayingStream:view:)]) {
        [AudioEngineFactory.shared.audioEngine startPlayingStream:streamID view:videoView];
    }
}

/// 停止拉取视频流
/// @param streamID 视频流ID
- (void)stopPullVideoStream:(NSString *)streamID {
    [AudioEngineFactory.shared.audioEngine stopPlayingStream:streamID];
}

/// 同步游戏声音状态
- (void)syncGameMicState:(NSNumber *)soundLevel userId:(NSString *)userId {
    
    if (!self.gameEventHandler.isOpenAiAgent) {
        return;
    }

    NSInteger currentVolume = soundLevel.integerValue;
    [self.gameEventHandler handleUserPlayerAudioState:userId state:currentVolume > 0 ? SudAudioItemPlayerStatePlaying : SudAudioItemPlayerStateFinished];
}
#pragma mark delegate

- (void)handleMicStateTimeout {
    NSTimeInterval currentTs = [[NSDate date]timeIntervalSince1970];
    NSDictionary *dicTemp = self.userMicUpdateTimeMap.copy;
    
    NSMutableDictionary *stopSoundLevels = NSMutableDictionary.new;
    for (NSString *key in dicTemp.allKeys) {
        NSTimeInterval lastUpdateTs = [dicTemp[key] doubleValue];
        // 超过指定时间，给游戏发送暂停
        if (currentTs - lastUpdateTs > 2) {
            stopSoundLevels[key] = @(0);
            [self.userMicUpdateTimeMap removeObjectForKey:key];
        }
    }
    if (stopSoundLevels.count > 0) {
        DDLogDebug(@"send stop sound levels:%@", stopSoundLevels);
        [self handleRemoteSoundLevelUpdate:stopSoundLevels];
    }
    if (self.userMicUpdateTimeMap.count == 0) {
        [self.micStateTimer stopTimer];
        self.micStateTimer = nil;
    }
}


/// 监控超时未收到的音量信息，并及时停止
- (void)updateRemoteSoundTimeout:(NSDictionary<NSString *, NSNumber *> *)soundLevels {
    if (!self.micStateTimer) {
        WeakSelf
        self.micStateTimer = [DTTimer timerWithTimeInterval:1 repeats:YES block:^(DTTimer *timer) {
            [weakSelf handleMicStateTimeout];
        }];
    }
    for (NSString *userId in soundLevels.allKeys) {
        NSTimeInterval ts = [[NSDate date]timeIntervalSince1970];
        self.userMicUpdateTimeMap[userId] = @(ts);
    }
}

- (void)handleRemoteSoundLevelUpdate:(NSDictionary<NSString *, NSNumber *> *)soundLevels {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_REMOTE_VOICE_VOLUME_CHANGED object:nil userInfo:@{@"dicVolume": soundLevels}];
    for (NSString *userId in soundLevels.allKeys) {
        [self syncGameMicState:soundLevels[userId] userId:userId];
    }
}

/// 捕获本地音量变化
/// @param soundLevel 本地音量级别，取值范围[0, 100]
- (void)onCapturedSoundLevelUpdate:(NSNumber *)soundLevel {
    if (soundLevel.intValue > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NTF_LOCAL_VOICE_VOLUME_CHANGED object:nil userInfo:@{@"volume": soundLevel}];
    }

    [self syncGameMicState:soundLevel userId:AppService.shared.login.loginUserInfo.userID];
}

/// 捕获远程音流音量变化
/// @param soundLevels [流ID: 音量]，音量取值范围[0, 100]
- (void)onRemoteSoundLevelUpdate:(NSDictionary<NSString *, NSNumber *> *)soundLevels {
    
    [self updateRemoteSoundTimeout:soundLevels];
    [self handleRemoteSoundLevelUpdate:soundLevels];
}

/// 房间流更新 增、减，需要收到此事件后播放对应流
/// @param roomID 房间ID
/// @param updateType 流更新类型 增，减
/// @param streamList 变动流列表
/// @param extendedData 扩展信息
- (void)onRoomStreamUpdate:(NSString *)roomID updateType:(HSAudioEngineUpdateType)updateType streamList:(NSArray<AudioStream *> *)streamList extendedData:(NSDictionary<NSString *, NSObject *> *)extendedData {
    switch (updateType) {
        case HSAudioEngineUpdateTypeAdd:
            for (AudioStream *item in streamList) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NTF_STREAM_INFO_CHANGED object:nil userInfo:@{kNTFStreamInfoKey: item}];
                
                [self.gameEventHandler handleUserPlayerAudioState:item.userID state:SudAudioItemPlayerStatePlaying];
            }
            break;
        case HSAudioEngineUpdateTypeDelete:

            break;
    }
}

- (void)onRoomOnlineUserCountUpdate:(int)count {
    NSInteger oldCount = self.totalUserCount;
    self.totalUserCount = count;
    if (oldCount != count) {
        [self dtUpdateUI];
    }
}

- (void)onRoomStateUpdate:(HSAudioEngineRoomState)state errorCode:(int)errorCode extendedData:(NSDictionary *)extendedData {
    DDLogInfo(@"onRoomStateUpdate:%@, errorCode:%@", @(state), @(errorCode));
    if (state == HSAudioEngineStateConnecting) {
        // 连接中
        if (self.isEnteredRoom) {
            self.isNeedReLoginRoom = YES;
            DDLogDebug(@"re connecting room");
        }
    } else if (state == HSAudioEngineStateConnected) {
        if (self.isNeedReLoginRoom) {
            DDLogDebug(@"re login room");
            [self loginRoom];
        }
    }
}

- (void)onImRoomStateUpdate:(HSAudioEngineRoomState)state errorCode:(int)errorCode extendedData:(NSDictionary *)extendedData {
    DDLogInfo(@"onImRoomStateUpdate:%@, errorCode:%@", @(state), @(errorCode));
    if (state == HSAudioEngineStateConnected) {
       if (!self.isSentEnterRoom) {
           self.isSentEnterRoom = YES;
           [self sendEnterRoomMsg];
           [self onHandleEnteredRoom];
       }
   }
    
//    if (state == HSAudioEngineStateDisconnected || state == HSAudioEngineStateConnecting) {
//        if (self.isLoginedIm) {
//            DDLogDebug(@"re login room im");
//            self.isNeedReLoginedIm = YES;
//        }
//    } else if (state == HSAudioEngineStateConnected){
//        if (self.isNeedReLoginedIm){
//            [self joinRoomIm];
//        }
//    }
}



- (void)onCapturedPCMData:(NSData *)data {
    [self.gameEventHandler.sudFSTAPPDecorator pushAudio:data];
    // 推送给AI
    [self.gameEventHandler pushAudioToAiAgent:data];
}
@end
