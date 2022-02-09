//
//  HSAudioRoomViewController+Game.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseViewController.h"
#import "HSAudioRoomViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 语音房游戏模块，处理游戏交互逻辑
@interface HSAudioRoomViewController(Game) <ISudFSMMG>

/// 登录游戏业务服务
- (void)loginGame;
/// 退出游戏
- (void)logoutGame;
@end

NS_ASSUME_NONNULL_END
