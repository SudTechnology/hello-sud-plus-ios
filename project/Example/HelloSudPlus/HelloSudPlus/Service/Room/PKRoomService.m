//
// Created by kaniel on 2022/4/25.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "PKRoomService.h"


@implementation PKRoomService

#pragma mark 后台接口

/// 设置PK时长
/// @param roomId ""
/// @param duration ""
/// @param finished ""
- (void)reqSetPKDuration:(long)roomId duration:(NSInteger)duration finished:(void (^)(void))finished {
    NSDictionary *dicParam = @{@"roomId": @(roomId), @"minute": @(duration)};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"room/pk/duration/v1") param:dicParam respClass:BaseRespModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            finished();
        }
    } failure:nil];
}

/// 开启PK， PK开关
/// @param roomId ""
/// @param open YES:开启 NO:关闭
/// @param finished ""
- (void)reqOpenPK:(long)roomId open:(BOOL)open finished:(void (^)(void))finished {
    NSDictionary *dicParam = @{@"roomId": @(roomId), @"pkSwitch": @(open)};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"room/pk/switch/v1") param:dicParam respClass:BaseRespModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            finished();
        }
    } failure:nil];
}

/// 开始PK， 进行PK
/// @param roomId ""
/// @param duration 时长 second
/// @param finished ""
- (void)reqStartPK:(long)roomId duration:(NSInteger)duration isAgain:(BOOL)isAgain finished:(void (^)(RespStartPKModel *resp))finished {
    NSDictionary *dicParam = @{@"roomId": @(roomId), @"minute": @(duration)};
    NSString *url = isAgain ? @"room/pk/again/v1" : @"room/pk/start/v1";
    [HSHttpService postRequestWithURL:kINTERACTURL(url) param:dicParam respClass:RespStartPKModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            finished((RespStartPKModel *) resp);
        }
    }                         failure:nil];
}

/// 同意接受PK
/// @param srcRoomId ""
/// @param destRoomId ""
/// @param finished ""
- (void)reqAgreePK:(long)srcRoomId destRoomId:(int64_t)destRoomId finished:(void (^)(RespStartPKModel *resp))finished {
    
    NSDictionary *dicParam = @{@"srcRoomId": @(srcRoomId), @"destRoomId": @(destRoomId)};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"room/pk/agree/v1") param:dicParam respClass:RespStartPKModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            finished((RespStartPKModel*)resp);
        }

    } failure:nil];
}

/// 解除PK关系
/// @param roomId
/// @param duration 时长 second
/// @param finished
- (void)reqReleasePK:(long)destRoomId finished:(void (^)(void))finished {
    NSDictionary *dicParam = @{@"roomId": @(destRoomId)};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"room/pk/release/v1") param:dicParam respClass:BaseRespModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            finished();
        }

    } failure:nil];
}

#pragma mark 跨房间消息

/// 发送PK邀请信息
/// @param roomID ""
/// @param finished ""
- (void)sendCrossPKInviteMsg:(NSString *)roomID finished:(void (^)(NSInteger errorCode))finished {
    RoomBaseCMDModel *msg = [[RoomBaseCMDModel alloc] init];
    [msg configBaseInfoWithCmd:CMD_ROOM_PK_SEND_INVITE];
    [self.currentRoomVC sendCrossRoomMsg:msg toRoomId:roomID isAddToShow:NO finished: finished];
}

/// 回应PK邀请信息
/// @param roomID ""
/// @param agree ""
/// @param finished ""
- (void)sendCrossAgreedPKInviteMsg:(NSString *)roomID agress:(BOOL)agree pkId:(int64_t)pkId otherUser:(AudioUserModel *)otherUser finished:(void (^)(NSInteger errorCode))finished {
    RoomCmdPKAckInviteModel *msg = [[RoomCmdPKAckInviteModel alloc] init];
    msg.isAccept = agree;
    if (pkId > 0) {
        msg.pkId = [NSString stringWithFormat:@"%lld", pkId];
    }
    msg.otherUser = otherUser;
    [msg configBaseInfoWithCmd:CMD_ROOM_PK_ANSWER];
    [self.currentRoomVC sendCrossRoomMsg:msg toRoomId:roomID isAddToShow:NO finished:finished];
}

/// 发送PK 切换游戏
/// @param roomID gameID
/// @param gameID gameID
/// @param finished finished
- (void)sendCrossPKChangedGameMsg:(NSString *)roomID gameID:(int64_t)gameID finished:(void (^)(NSInteger errorCode))finished {
    RoomCmdChangeGameModel *msg = [RoomCmdChangeGameModel makeMsg:gameID];
    msg.cmd = CMD_ROOM_PK_CHANGE_GAME;
    [self.currentRoomVC sendCrossRoomMsg:msg toRoomId:roomID isAddToShow:NO finished: finished];
}

/// 发送开始PK
/// @param roomID gameID
/// @param minuteDuration minuteDuration
/// @param finished finished
- (void)sendCrossPKStartedMsg:(NSString *)roomID minuteDuration:(NSInteger)minuteDuration pkId:(int64_t)pkId finished:(void (^)(NSInteger errorCode))finished {
    RoomCmdPKStartedModel *msg = [[RoomCmdPKStartedModel alloc] init];
    [msg configBaseInfoWithCmd:CMD_ROOM_PK_START];
    msg.minuteDuration = minuteDuration;
    if (pkId > 0) {
        msg.pkId = [NSString stringWithFormat:@"%lld", pkId];
    }
    [self.currentRoomVC sendCrossRoomMsg:msg toRoomId:roomID isAddToShow:NO finished:finished];
}

/// 结束跨房PK
/// @param roomID gameID
/// @param minuteDuration minuteDuration
/// @param finished finished
- (void)sendCrossPKFinishedMsg:(NSString *)roomID finished:(void (^)(NSInteger errorCode))finished {
    RoomBaseCMDModel *msg = [[RoomBaseCMDModel alloc] init];
    [msg configBaseInfoWithCmd:CMD_ROOM_PK_FINISH];
    [self.currentRoomVC sendCrossRoomMsg:msg toRoomId:roomID isAddToShow:NO finished:finished];
}

/// 跨房PK移除对手
/// @param roomID gameID
/// @param minuteDuration minuteDuration
/// @param finished finished
- (void)sendCrossPKRemoveOtherMsg:(NSString *)roomID finished:(void (^)(NSInteger errorCode))finished {
    RoomBaseCMDModel *msg = [[RoomBaseCMDModel alloc] init];
    [msg configBaseInfoWithCmd:CMD_ROOM_PK_REMOVE_RIVAL];
    [self.currentRoomVC sendCrossRoomMsg:msg toRoomId:roomID isAddToShow:NO finished:finished];
}

/// 发送PK时长消息
/// @param roomID gameID
/// @param minuteDuration minuteDuration
/// @param finished finished
- (void)sendCrossPKChangeTimeMsg:(NSString *)roomID minuteDuration:(NSInteger)minuteDuration finished:(void (^)(NSInteger errorCode))finished {
    RoomCmdPKStartedModel *msg = [[RoomCmdPKStartedModel alloc] init];
    [msg configBaseInfoWithCmd:CMD_ROOM_PK_SETTINGS];
    msg.minuteDuration = minuteDuration;
    [self.currentRoomVC sendCrossRoomMsg:msg toRoomId:roomID isAddToShow:NO finished:finished];
}

#pragma mark 房间内消息

/// 发送PK开启信息
/// @param finished ""
- (void)sendPKOpenedMsg {
    RoomBaseCMDModel *msg = [[RoomBaseCMDModel alloc] init];
    [msg configBaseInfoWithCmd:CMD_ROOM_PK_OPEN_MATCH];
    [self.currentRoomVC sendMsg:msg isAddToShow:NO finished:nil];
}

/// 给房间内用户发送应答邀请
/// @param roomID ""
/// @param agree ""
/// @param pkId ""
/// @param finished ""
- (void)sendAgreedPKInviteMsg:(AudioUserModel *)otherUser agress:(BOOL)agree pkId:(int64_t)pkId {
    RoomCmdPKAckInviteModel *msg = [[RoomCmdPKAckInviteModel alloc] init];
    msg.isAccept = agree;
    if (pkId > 0) {
        msg.pkId = [NSString stringWithFormat:@"%lld", pkId];
    }
    [msg configBaseInfoWithCmd:CMD_ROOM_PK_ANSWER];
    msg.otherUser = otherUser;
    [self.currentRoomVC sendMsg:msg isAddToShow:NO finished:nil];
}

/// 给房间内用户发送PK结束
/// @param roomID ""
/// @param finished ""
- (void)sendPKClosedMsg {
    RoomBaseCMDModel *msg = [[RoomBaseCMDModel alloc] init];
    [msg configBaseInfoWithCmd:CMD_ROOM_PK_FINISH];
    [self.currentRoomVC sendMsg:msg isAddToShow:NO finished:nil];
}

/// 给房间内用户发送PK移除对手
/// @param finished finished
- (void)sendCrossPKRemoveOtherMsg {
    RoomBaseCMDModel *msg = [[RoomBaseCMDModel alloc] init];
    [msg configBaseInfoWithCmd:CMD_ROOM_PK_REMOVE_RIVAL];
    [self.currentRoomVC sendMsg:msg isAddToShow:NO finished:nil];
}

/// 发送开始PK到本房间
/// @param minuteDuration minuteDuration
/// @param finished finished
- (void)sendPKStartedMsgWithMinuteDuration:(NSInteger)minuteDuration pkId:(int64_t)pkId {
    RoomCmdPKStartedModel *msg = [[RoomCmdPKStartedModel alloc] init];
    [msg configBaseInfoWithCmd:CMD_ROOM_PK_START];
    msg.minuteDuration = minuteDuration;
    if (pkId > 0) {
        msg.pkId = [NSString stringWithFormat:@"%lld", pkId];
    }
    [self.currentRoomVC sendMsg:msg isAddToShow:NO finished:nil];
}

/// 发送PK时长消息
/// @param minuteDuration minuteDuration
/// @param finished finished
- (void)sendPKChangeTimeMsgWithMinuteDuration:(NSInteger)minuteDuration {
    RoomCmdPKStartedModel *msg = [[RoomCmdPKStartedModel alloc] init];
    [msg configBaseInfoWithCmd:CMD_ROOM_PK_SETTINGS];
    msg.minuteDuration = minuteDuration;
    [self.currentRoomVC sendMsg:msg isAddToShow:NO finished:nil];
}
@end
