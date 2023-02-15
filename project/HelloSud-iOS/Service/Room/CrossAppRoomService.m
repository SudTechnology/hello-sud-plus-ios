//
//  GuessService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "CrossAppRoomService.h"

@implementation CrossAppRoomService

/// 获取游戏列表
/// @param finished
+ (void)reqGameListWithFinished:(void (^)(RespGameListModel *))finished {
    DDLogDebug(@"reqGameListWithFinished");
    NSDictionary *dicParam = @{};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"extra/game-list/v1") param:dicParam respClass:RespGameListModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            finished((RespGameListModel *) resp);
        }
    }                         failure:nil];
}

/// 开始组队匹配
/// @param gameId gameId
/// @param roomId roomId
/// @param finished finished
+ (void)reqStartCrossAppMatch:(int64_t)gameId roomId:(NSString *)roomId finished:(void (^)(RespStartCrossAppMatchModel *))finished failure:(void (^)(NSError *error))failure {
    DDLogDebug(@"reqStartCrossAppMatch");
    NSDictionary *dicParam = @{@"gameId": [NSString stringWithFormat:@"%@", @(gameId)], @"roomId": roomId};
    [HSHttpService postRequestWithURL:kGameURL(@"extra/start-match-team/v1") param:dicParam respClass:RespStartCrossAppMatchModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            finished((RespStartCrossAppMatchModel *) resp);
        }
    }                         failure:failure];
}

/// 取消组队匹配
/// @param gameId gameId
/// @param roomId roomId
/// @param groupId groupId
/// @param finished finished
+ (void)reqCancelCrossAppMatch:(int64_t)gameId roomId:(NSString *)roomId groupId:(NSString *)groupId finished:(void (^)(BaseRespModel *))finished failure:(void (^)(NSError *error))failure {
    DDLogDebug(@"reqCancelCrossAppMatch");
    NSDictionary *dicParam = @{@"gameId": [NSString stringWithFormat:@"%@", @(gameId)], @"roomId": roomId, @"groupId": groupId ?: @""};
    [HSHttpService postRequestWithURL:kGameURL(@"extra/cancel-match-team/v1") param:dicParam respClass:BaseRespModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            finished((BaseRespModel *) resp);
        }
    }                         failure:failure];
}

/// 加入组队
/// @param gameId gameId
/// @param roomId roomId
/// @param index index
/// @param finished finished
+ (void)reqJoinMatchGroup:(int64_t)gameId roomId:(NSString *)roomId index:(NSInteger)index finished:(void (^)(BaseRespModel *))finished failure:(void (^)(NSError *error))failure {
    DDLogDebug(@"reqJoinMatchGroup");
    NSDictionary *dicParam = @{@"gameId": [NSString stringWithFormat:@"%@", @(gameId)], @"roomId": roomId, @"index": @(index)};
    [HSHttpService postRequestWithURL:kGameURL(@"extra/join-team/v1") param:dicParam respClass:BaseRespModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            finished((BaseRespModel *) resp);
        }
    }                         failure:failure];
}

/// 退出组队
/// @param gameId gameId
/// @param finished finished
+ (void)reqExitMatchGroup:(NSString *)roomId finished:(void (^)(BaseRespModel *))finished failure:(void (^)(NSError *error))failure {
    DDLogDebug(@"reqExitMatchGroup");
    NSDictionary *dicParam = @{@"roomId": roomId};
    [HSHttpService postRequestWithURL:kGameURL(@"extra/quit-team/v1") param:dicParam respClass:BaseRespModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            finished((BaseRespModel *) resp);
        }
    }                         failure:failure];
}

/// 切换游戏
/// @param gameId gameId
/// @param roomId roomId
/// @param finished finished
+ (void)reqSwitchMatchGame:(int64_t)gameId roomId:(NSString *)roomId finished:(void (^)(BaseRespModel *))finished {
    DDLogDebug(@"reqSwitchMatchGame");
    NSDictionary *dicParam = @{@"gameId": @(gameId), @"roomId": roomId};
    [HSHttpService postRequestWithURL:kGameURL(@"extra/switch-game/v1") param:dicParam respClass:BaseRespModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            finished((BaseRespModel *) resp);
        }
    }                         failure:nil];
}

/// 获取跨域房间列表
/// @param authSecret authSecret description
/// @param pageNumber pageNumber description
/// @param success success description
/// @param fail fail description
+ (void)reqCrossRoomList:(NSString *)authSecret pageNumber:(NSInteger)pageNumber success:(void (^)(NSArray <CrossRoomModel *> *roomList))success fail:(nullable ErrorBlock)fail {

    NSDictionary *dic = @{@"authSecret": @"", @"pageNumber": @(pageNumber), @"pageSize": @(50)};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"extra/get-auth-room-list") param:dic respClass:RespCrossRoomListModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        RespCrossRoomListModel *model = (RespCrossRoomListModel *) resp;
        if (success) {
            success(model.roomInfos);
        }
    }                         failure:fail];
}

/// 跨房匹配、并进入游戏房间
/// @param roomId roomId
/// @param authSecret authSecret
+ (void)reqCrossMatchRoom:(NSString *)roomId authSecret:(NSString *)authSecret gameId:(int64_t)gameId {
    WeakSelf

    static BOOL isMatchingRoom = false;
    if (isMatchingRoom) {
        NSLog(@"there is req match room, so skip it");
        return;
    }
    isMatchingRoom = YES;
    NSMutableDictionary *dicParam = NSMutableDictionary.new;
    dicParam[@"roomId"] = roomId;
    dicParam[@"authSecret"] = authSecret;
    dicParam[@"gameId"] = @(gameId);
    [HSHttpService postRequestWithURL:kINTERACTURL(@"extra/match-room/v1") param:dicParam respClass:RespCrossMatchRoomModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        RespCrossMatchRoomModel *model = (RespCrossMatchRoomModel *) resp;
        [AudioRoomService reqEnterRoom:[model.localRoomId longLongValue] isFromCreate:NO extData:@{@"crossAppRoomId": roomId, @"crossSecret": authSecret} success:^{
            isMatchingRoom = NO;
        }                         fail:^(NSError *error) {
            [ToastUtil show:[error debugDescription]];
            isMatchingRoom = NO;
        }];
    }                         failure:^(NSError *error) {
        isMatchingRoom = NO;
    }];
}
@end
