//
// Created by kaniel on 2022/11/4.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SudMGPWrapper/SudFSMMGListener.h>

/// 火箭游戏
@interface RocketGameManager : NSObject
/// 游戏ID
@property(nonatomic, assign) int64_t gameId;
/// 游戏加载主view
@property(nonatomic, strong) UIView *gameView;

/// 加载互动游戏 火箭
/// @param gameId gameId
/// @param roomId roomId
/// @param gameView gameView
- (void)loadInteractiveGame:(int64_t)gameId roomId:(NSString *)roomId gameView:(UIView *)gameView;

/// 展示游戏视图
- (void)showGameView;

/// 隐藏游戏视图
- (void)hideGameView;

/// 销毁互动游戏
- (void)destoryGame;

- (BOOL)isExistGame;
@end