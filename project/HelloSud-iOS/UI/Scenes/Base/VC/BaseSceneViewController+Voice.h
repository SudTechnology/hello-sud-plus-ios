//
//  AudioRoomViewController+Voice.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/26.
//

#import "AudioRoomViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 基础场景语音控制模块
@interface BaseSceneViewController(Voice)

/// 开启推流
- (void)startPublishStream;

/// 关闭推流
- (void)stopPublish;

/// 登录房间
- (void)loginRoom;

/// 退出房间 rtc相关逻辑
- (void)logoutRoom;

#pragma mark =======音频采集=======
/// 开始音频采集
- (void)startCaptureAudioToASR;

/// 停止音频采集
- (void)stopCaptureAudioToASR;
@end

NS_ASSUME_NONNULL_END
