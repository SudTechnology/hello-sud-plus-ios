//
//  AudioRoomViewController+Game.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseViewController.h"


NS_ASSUME_NONNULL_BEGIN

/// 基础场景游戏模块，处理游戏交互逻辑
@interface BaseSceneViewController(Game) <SudFSMMGListener>

/// 初始化sud
- (void)initSudFSMMG;
/// 登录游戏业务服务
- (void)loginGame;
/// 退出游戏
- (void)logoutGame;
/// 处理切换游戏
/// @param gameID 新的游戏ID
- (void)handleGameChange:(NSInteger)gameID;
@end

NS_ASSUME_NONNULL_END
