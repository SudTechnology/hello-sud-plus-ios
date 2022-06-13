//
//  GuessService.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "AudioRoomService.h"

NS_ASSUME_NONNULL_BEGIN
/// 竞猜服务
@interface GuessService : AudioRoomService

/// 下注1：跨房PK 2：游戏)
/// @param betType betType
/// @param userList 用户ID列表
/// @param finished
+ (void)reqBet:(NSInteger)betType coin:(NSInteger)coin userList:(NSArray <NSString *> *)userList finished:(void (^)(void))finished;

/// 查询竞猜游戏列表
/// @param finished 完成回调
+ (void)reqGuessListWithFinished:(void (^)(RespMoreGuessModel *))finished;
@end

NS_ASSUME_NONNULL_END
