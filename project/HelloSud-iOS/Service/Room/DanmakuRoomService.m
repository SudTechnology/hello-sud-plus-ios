//
//  DanmukaRoomService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/16.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DanmakuRoomService.h"

@implementation DanmakuRoomService
/// 发送弹幕
/// @param roomId roomId
/// @param content content
/// @param finished finished
/// @param failure failure
+ (void)reqSendBarrage:(NSString *)roomId content:(NSString *)content finished:(void (^)(void))finished failure:(void (^)(NSError *error))failure {
    NSDictionary *dicParam = @{@"roomId": roomId, @"content": content};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"bullet-chat-game/send-barrage/v1") param:dicParam respClass:BaseRespModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            finished();
        }
    }                         failure:failure];
}

/// 拉取快捷弹幕列表
/// @param gameId gameId
/// @param finished finished
/// @param failure failure
+ (void)reqShortSendEffectList:(int64_t)gameId finished:(void (^)(NSArray<DanmakuCallWarcraftModel *> *modelList))finished failure:(void (^)(NSError *error))failure {
    NSDictionary *dicParam = @{@"gameId": @(gameId)};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"bullet-chat-game/shortcut-window/v1") param:dicParam respClass:RespDanmakuListModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            RespDanmakuListModel *m = (RespDanmakuListModel *) resp;
            NSMutableArray <DanmakuCallWarcraftModel *> *arr = [[NSMutableArray alloc] init];
            [arr setArray:m.callWarcraftInfoList];
            // 处理一下加入阵队数据，复用DanmakuCallWarcraftModel model
            if (m.joinTeamList.count > 0) {
                DanmakuCallWarcraftModel *joinTeamModel = [[DanmakuCallWarcraftModel alloc] init];
                joinTeamModel.effectShowType = DanmakuEffectModelShowTypeJoin;
                joinTeamModel.joinTeamList = m.joinTeamList;
                [arr insertObject:joinTeamModel atIndex:0];
            }
            finished(arr);
        }
    }                         failure:failure];
}
@end
