//
//  AudioRoomViewController+Voice.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/26.
//

#import "AudioRoomViewController+Voice.h"
@implementation AudioRoomViewController(Voice)

/// 开启推流
/// @param streamID 流ID
- (void)startPublish:(NSString*)streamID {
    [AudioEngineFactory.shared.audioEngine muteMicrophone:NO];
    [AudioEngineFactory.shared.audioEngine startPublish:streamID];
}

/// 关闭推流
- (void)stopPublish {
    [AudioEngineFactory.shared.audioEngine stopPublishStream];
    [AudioEngineFactory.shared.audioEngine muteMicrophone:YES];
}

- (void)loginRoom {
    /// 设置语音引擎事件回调
    [AudioEngineFactory.shared.audioEngine setEventListener:self];
    MediaUser *user = [MediaUser user:AppManager.shared.loginUserInfo.userID nickname:AppManager.shared.loginUserInfo.name];
    [AudioEngineFactory.shared.audioEngine loginRoom:self.roomID user:user config:nil];
}

- (void)logoutRoom {
    [AudioEngineFactory.shared.audioEngine logoutRoom];
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
/// @param updateType 流更新类型 增，减
/// @param streamList 变动流列表
/// @param extendedData 扩展信息
/// @param roomID 房间ID
- (void)onRoomStreamUpdate:(HSAudioEngineUpdateType)updateType streamList:(NSArray<MediaStream *>*)streamList extendedData:(NSDictionary<NSString *, NSObject*>*)extendedData roomID:(NSString *)roomID {
    switch (updateType) {
        case HSAudioEngineUpdateTypeAdd:
            for (MediaStream *item in streamList) {
                [AudioEngineFactory.shared.audioEngine startPlayingStream:item.streamID];
                [[NSNotificationCenter defaultCenter]postNotificationName:NTF_STREAM_INFO_CHANGED object:nil userInfo:@{kNTFStreamInfoKey:item}];
                
            }
            break;
        case HSAudioEngineUpdateTypeDelete:
            for (MediaStream *item in streamList) {
                [AudioEngineFactory.shared.audioEngine stopPlayingStream:item.streamID];
            }
            break;
    }
}

- (void)onRoomOnlineUserCountUpdate:(int)count roomID:(NSString *)roomID {
    NSInteger oldCount = self.totalUserCount;
    self.totalUserCount = count;
    if (oldCount != count) {
        [self dtUpdateUI];
    }
}

- (void)onRoomUserUpdate:(HSAudioEngineUpdateType)updateType userList:(NSArray<MediaUser *> *)userList roomID:(NSString *)roomID {
    if (updateType == HSAudioEngineUpdateTypeAdd) {
        self.totalUserCount += userList.count;
    } else if (updateType == HSAudioEngineUpdateTypeDelete) {
        self.totalUserCount -= userList.count;
        if (self.totalUserCount < 0) {
            self.totalUserCount = 0;
        }
    }
    [self dtUpdateUI];
}

- (void)onRoomStateUpdate:(HSAudioEngineRoomState)state errorCode:(int)errorCode extendedData:(NSDictionary *)extendedData roomID:(NSString *)roomID {
    if (state == HSAudioEngineStateConnected && !self.isSentEnterRoom) {
        [self sendEnterRoomMsg];
    }
}

- (void)onCapturedAudioData:(NSData *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.iSudFSTAPP pushAudio:data];
    });
}
@end
