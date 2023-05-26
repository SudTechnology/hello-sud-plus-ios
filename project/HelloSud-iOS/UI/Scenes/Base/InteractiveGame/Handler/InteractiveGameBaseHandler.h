//
// Created by kaniel on 2022/12/5.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

@class InteractiveGameManager;

/// 互动游戏base处理模块
@interface InteractiveGameBaseHandler : NSObject <SudFSMMGListener>
/// ISudFSTAPP
@property(nonatomic, strong) SudFSMMGDecorator *sudFSMMGDecorator;
/// app To 游戏 管理类
@property(nonatomic, strong) SudFSTAPPDecorator *sudFSTAPPDecorator;
@property(nonatomic, weak) InteractiveGameManager *interactiveGameManager;
/// 游戏设置点击区域
@property(nonatomic, strong) MgCommonSetClickRect *gameClickRect;
/// 是否游戏已经准备完毕
@property(nonatomic, assign) BOOL isGamePrepareOK;
/// 是否需要展示游戏
@property(nonatomic, assign) BOOL isShowGame;
/// 是否需要展示游戏主界面
@property(nonatomic, assign) BOOL showMainView;

/// 展示游戏视图
- (void)showGameView:(BOOL)showMainView;

/// 隐藏游戏视图
- (void)hideGameView:(BOOL)notifyGame;

/// 展示loading视图
- (void)showLoadingView:(UIView *)gameView;

/// 关闭loading
- (void)closeLoadingView;

/// 检测点是否在游戏可点击区域，如果游戏没有指定，则默认游戏需要响应该点，返回YES;否则按照游戏指定区域判断是否在区域内，在则返回YES,不在则返回NO
/// @param clickPoint 点击事件点
/// @return
- (BOOL)checkIfPointInGameClickRect:(CGPoint)clickPoint;
@end
