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

/// 礼物面板发送火箭
/// @param giftModel
/// @param toMicList
- (void)sendRocketGift:(GiftModel *)giftModel toMicList:(NSArray<AudioRoomMicModel *> *)toMicList finished:(void (^)(BOOL success))finished;

/// 设置动效回调
/// @param rocketEffectBlock
- (void)setupRocketEffectBlock:(void(^)(BOOL show))rocketEffectBlock;
@end
