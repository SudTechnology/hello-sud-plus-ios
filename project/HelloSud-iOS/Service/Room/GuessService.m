//
//  GuessService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GuessService.h"
#import "GuessRoomViewController.h"

@implementation GuessService


/// 下注1：跨房PK 2：游戏
/// @param betType betType
/// @param coin 消费金额
/// @param userList 用户ID列表
/// @param finished 完成回调
+ (void)reqBet:(NSInteger)betType coin:(NSInteger)coin userList:(NSArray <NSString *> *)userList finished:(void (^)(void))finished failure:(void (^)(NSError *error))failure {
    NSDictionary *dicParam = @{@"quizType": @(betType), @"coin": @(coin), @"supportedUserIdList": userList == nil ? @[] : userList};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"quiz/bet/v1") param:dicParam respClass:BaseRespModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            finished();
        }
    }                         failure:failure];
}

/// 查询竞猜游戏列表
/// @param finished 完成回调
+ (void)reqGuessListWithFinished:(void (^)(RespMoreGuessModel *))finished {
    NSDictionary *dicParam = @{};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"quiz/list/v1") param:dicParam respClass:RespMoreGuessModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            finished((RespMoreGuessModel *) resp);
        }
    }                         failure:nil];
}

/// 查询竞猜游戏列表
/// @param userIdList id列表
/// @param roomId 房间ID
/// @param finished 完成回调
+ (void)reqGuessPlayerList:(NSArray <NSString *> *)userIdList roomId:(NSString *)roomId finished:(void (^)(RespGuessPlayerListModel *))finished {
    NSDictionary *dicParam = @{@"roomId": roomId, @"playerList": userIdList ? userIdList : @[]};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"quiz/game-player/v1") param:dicParam respClass:RespGuessPlayerListModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            finished((RespGuessPlayerListModel *) resp);
        }
    }                         failure:nil];
}

/// 发送押注通知消息
/// @param roomID roomID
/// @param betUsers roomID
- (void)sendBetNotifyMsg:(NSString *)roomID betUsers:(NSArray<AudioUserModel *>*)betUsers {
    RoomCmdGuessBetNotifyModel *msg = [[RoomCmdGuessBetNotifyModel alloc]init];
    [msg configBaseInfoWithCmd:CMD_ROOM_QUIZ_BET];
    msg.recUser = betUsers;
    [self.currentRoomVC sendMsg:msg isAddToShow:NO];
    [(GuessRoomViewController *)self.currentRoomVC showBetScreenMsg:msg];
}
@end
