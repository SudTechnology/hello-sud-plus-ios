//
// Created by kaniel on 2022/12/5.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InteractiveGameBaseHandler.h"

/// 火箭互动处理模块
@interface InteractiveGameRocketHandler : InteractiveGameBaseHandler
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
- (void)sendRocketGift:(GiftModel *)giftModel toMicList:(NSArray<AudioRoomMicModel *> *)toMicList finished:(void (^)(BOOL success))finished;

/// 展示游戏视图
- (void)showGameView:(BOOL)showMainView;

/// 设置动效回调
/// @param rocketEffectBlock
- (void)setupRocketEffectBlock:(void(^)(BOOL show))rocketEffectBlock;
@end