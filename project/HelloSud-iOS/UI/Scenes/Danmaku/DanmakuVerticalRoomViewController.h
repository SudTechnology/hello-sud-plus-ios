//
//  DanmakuRoomViewController.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "AudioRoomViewController.h"

NS_ASSUME_NONNULL_BEGIN
/// 竖屏弹幕游戏
@interface DanmakuVerticalRoomViewController : AudioRoomViewController
/// 视频视图
@property(nonatomic, strong, readonly) BaseView *videoView;
/// 重置视频视图
- (void)resetVideoView;
- (void)changeVideoViewToFit;
@end

NS_ASSUME_NONNULL_END
