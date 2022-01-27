//
//  HSAudioRoomViewController+Voice.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/26.
//

#import "HSAudioRoomViewController+Voice.h"
@implementation HSAudioRoomViewController(Voice)

/// 开启推流
/// @param streamID 流ID
- (void)startPublish:(NSString*)streamID {
    [MediaAudioEngineManager.shared.audioEngine startPublish:streamID];
    [MediaAudioEngineManager.shared.audioEngine muteMicrophone:NO];
}

/// 关闭推流
- (void)stopPublish {
    [MediaAudioEngineManager.shared.audioEngine stopPublishStream];
}

#pragma mark delegate
/// 捕获本地音量变化
/// @param soundLevel 本地音量级别，取值范围[0, 100]
- (void)onCapturedSoundLevelUpdate:(NSNumber*)soundLevel {
    if (soundLevel.intValue > 0) {
        NSLog(@"local voice:%@", soundLevel);
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
- (void)onRoomStreamUpdate:(MediaAudioEngineUpdateType)updateType streamList:(NSArray<MediaStream *>*)streamList extendedData:(NSDictionary<NSString *, NSObject*>*)extendedData roomID:(NSString *)roomID {
    switch (updateType) {
        case MediaAudioEngineUpdateTypeAdd:
            for (MediaStream *item in streamList) {
                [MediaAudioEngineManager.shared.audioEngine startPlayingStream:item.streamID];
            }
            break;
        case MediaAudioEngineUpdateTypeDelete:
            for (MediaStream *item in streamList) {
                [MediaAudioEngineManager.shared.audioEngine stopPlayingStream:item.streamID];
            }
            break;
    }
}
@end
