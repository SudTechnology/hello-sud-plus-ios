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

/// 切换扬声器作为音频通道
- (void)setAudioRouteToSpeaker:(BOOL) enabled;

#pragma mark =======音频采集=======
/// 开始音频采集
- (void)startCaptureAudioToASR;

/// 停止音频采集
- (void)stopCaptureAudioToASR;

/// 拉取视频流
/// @param videoView 展示视频视图
/// @param streamID 视频流ID
- (void)startToPullVideo:(UIView *)videoView streamID:(NSString *)streamID;

/// 停止拉取视频流
/// @param streamID 视频流ID
- (void)stopPullVideoStream:(NSString *)streamID;

/// 开始预览窗口
/// @param view view
- (void)startPreview:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
