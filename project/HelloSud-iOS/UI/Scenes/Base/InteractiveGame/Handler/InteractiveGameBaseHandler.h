//
// Created by kaniel on 2022/12/5.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>
@class InteractiveGameManager;
/// 互动游戏base处理模块
@interface InteractiveGameBaseHandler : NSObject<SudFSMMGListener>
/// ISudFSTAPP
@property(nonatomic, strong) SudFSMMGDecorator *sudFSMMGDecorator;
/// app To 游戏 管理类
@property(nonatomic, strong) SudFSTAPPDecorator *sudFSTAPPDecorator;
@property (nonatomic, weak)InteractiveGameManager *interactiveGameManager;
- (void)showLoadingView:(UIView *)gameView;
- (void)closeLoadingView;
@end