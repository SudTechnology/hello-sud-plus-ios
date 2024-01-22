//
//  GuessService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "LeagueRoomService.h"
@implementation LeagueRoomService

/// 查询正在参加的联赛房间
/// @param gameId gameId
/// @param betUsers roomID
+ (void)reqUserPlayingRoom:(int64_t)gameId finished:(void (^)(RespLeaguePlayingModel *))finished {
    NSDictionary *dicParam = @{@"gameId": @(gameId)};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"league/playing/v1") param:dicParam respClass:RespLeaguePlayingModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            finished((RespLeaguePlayingModel *) resp);
        }
    }                         failure:nil];
}
@end
