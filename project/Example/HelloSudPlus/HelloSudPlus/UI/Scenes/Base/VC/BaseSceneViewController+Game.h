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
- (void)configSudGame;

/// 加载游戏
- (void)loadGame;

/// 销毁游戏
- (void)destroyGame;

/// 处理切换游戏
/// @param gameID 新的游戏ID
- (void)switchToGame:(int64_t)gameID;

- (void)hanldeInitSudFSMMG;
@end

NS_ASSUME_NONNULL_END
