//
//  AudioRoomViewController+Voice.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/26.
//

#import "BaseSceneViewController+Voice.h"
#import "BaseSceneViewController.h"

@implementation BaseSceneViewController(Voice)

/// 开启推流
- (void)startPublishStream {
    if (self.sudFSMMGDecorator.keyWordASRing) {
        [self startCaptureAudioToASR];
    }
    [AudioEngineFactory.shared.audioEngine startPublishStream];
}

/// 关闭推流
- (void)stopPublish {
    if (self.sudFSMMGDecorator.keyWordASRing) {
        [self stopCaptureAudioToASR];
    }
    [AudioEngineFactory.shared.audioEngine stopPublishStream];
}

- (void)loginRoom {
    /// 设置语音引擎事件回调

    AudioJoinRoomModel *audioJoinRoomModel = nil;
    audioJoinRoomModel = [[AudioJoinRoomModel alloc] init];
    audioJoinRoomModel.userID = AppService.shared.login.loginUserInfo.userID;
    audioJoinRoomModel.userName = AppService.shared.login.loginUserInfo.name;
    audioJoinRoomModel.roomID = self.roomID;
    audioJoinRoomModel.token = self.enterModel.rtcToken;
    
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
        if ([rtcType isEqualToString:kRtcTypeRongCloud] || [rtcType isEqualToString:kRtcTypeCommEase]) {
            [AudioEngineFactory.shared.audioEngine initWithConfig:configModel success:^{
                [self joinRoom:audioJoinRoomModel];
            }];
            return;
        }
    
        [AudioEngineFactory.shared.audioEngine initWithConfig:configModel];
    }

    [self joinRoom:audioJoinRoomModel];
}

- (void)joinRoom:(AudioJoinRoomModel *)audioJoinRoomModel {
    [AudioEngineFactory.shared.audioEngine joinRoom:audioJoinRoomModel];
    [AudioEngineFactory.shared.audioEngine setEventListener:self];
    [AudioEngineFactory.shared.audioEngine setAudioRouteToSpeaker:YES];
}

- (void)logoutRoom {
    [AudioEngineFactory.shared.audioEngine leaveRoom];
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

#pragma mark delegate
/// 捕获本地音量变化
/// @param soundLevel 本地音量级别，取值范围[0, 100]
- (void)onCapturedSoundLevelUpdate:(NSNumber*)soundLevel {
    if (soundLevel.intValue > 0) {
//        NSLog(@"local voice:%@", soundLevel);
        [[NSNotificationCenter defaultCenter]postNotificationName:NTF_LOCAL_VOICE_VOLUME_CHANGED object:nil userInfo:@{@"volume":soundLevel}];
    }
}

/// 捕获远程音流音量变化
/// @param soundLevels [流ID: 音量]，音量取值范围[0, 100]
- (void)onRemoteSoundLevelUpdate:(NSDictionary<NSString*, NSNumber*>*)soundLevels {
    [[NSNotificationCenter defaultCenter]postNotificationName:NTF_REMOTE_VOICE_VOLUME_CHANGED object:nil userInfo:@{@"dicVolume":soundLevels}];
}

/// 房间流更新 增、减，需要收到此事件后播放对应流
/// @param roomID 房间ID
/// @param updateType 流更新类型 增，减
/// @param streamList 变动流列表
/// @param extendedData 扩展信息
- (void)onRoomStreamUpdate:(NSString *)roomID updateType:(HSAudioEngineUpdateType)updateType streamList:(NSArray<AudioStream *>*)streamList extendedData:(NSDictionary<NSString *, NSObject*>*)extendedData {
    switch (updateType) {
        case HSAudioEngineUpdateTypeAdd:
            for (AudioStream *item in streamList) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NTF_STREAM_INFO_CHANGED object:nil userInfo:@{kNTFStreamInfoKey:item}];
            }
            break;
        case HSAudioEngineUpdateTypeDelete:
            break;
    }
}

- (void)onRoomOnlineUserCountUpdate:(NSString *)roomID count:(int)count {
    NSInteger oldCount = self.totalUserCount;
    self.totalUserCount = count;
    if (oldCount != count) {
        [self dtUpdateUI];
    }
}

- (void)onRoomStateUpdate:(NSString *)roomID state:(HSAudioEngineRoomState)state errorCode:(int)errorCode extendedData:(NSDictionary *)extendedData {
    if (state == HSAudioEngineStateConnected && !self.isSentEnterRoom) {
        [self sendEnterRoomMsg];
    }
}

- (void)onCapturedPCMData:(NSData *)data {
    [self.sudFSTAPPDecorator pushAudio:data];
}
@end
