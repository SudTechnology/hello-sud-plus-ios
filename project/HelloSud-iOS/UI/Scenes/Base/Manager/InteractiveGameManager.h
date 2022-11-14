//
// Created by kaniel on 2022/11/4.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SudMGPWrapper/SudFSMMGListener.h>

/// 互动游戏管理模块（火箭游戏）
@interface InteractiveGameManager : NSObject

/// 加载互动游戏 火箭
/// @param gameId gameId
/// @param roomId roomId
/// @param gameView gameView
- (void)loadInteractiveGame:(int64_t)gameId roomId:(NSString *)roomId gameView:(UIView *)gameView;

/// 销毁互动游戏
- (void)destoryGame;

/// 展示游戏视图
- (void)showGameView;

/// 隐藏游戏视图
- (void)hideGameView;

/// 是否已经退出游戏
- (BOOL)isExistGame;

/// 播放火箭
/// @param jsonData
- (void)playRocket:(NSString *)jsonData;

/// 检测点是否在游戏可点击区域，如果游戏没有指定，则默认游戏需要响应该点，返回YES;否则按照游戏指定区域判断是否在区域内，在则返回YES,不在则返回NO
/// @param clickPoint 点击事件点
/// @return
- (BOOL)checkIfPointInGameClickRect:(CGPoint)clickPoint;

/// 礼物面板发送火箭
/// @param giftModel
/// @param toMicList
- (void)sendRocketGift:(GiftModel *)giftModel toMicList:(NSArray<AudioUserModel *> *)toMicList finished:(void (^)(BOOL success))finished;
@end