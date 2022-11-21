//
//  GuessService.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "AudioRoomService.h"
#import "LeagueModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 竞猜服务
@interface LeagueRoomService : AudioRoomService

/// 查询正在参加的联赛房间
/// @param gameId gameId
/// @param betUsers roomID
+ (void)reqUserPlayingRoom:(int64_t)gameId finished:(void (^)(RespLeaguePlayingModel *))finished;
@end

NS_ASSUME_NONNULL_END
