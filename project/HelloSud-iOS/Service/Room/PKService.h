//
// Created by kaniel on 2022/4/25.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "AudioRoomService.h"

/// PK场景服务
@interface PKService : AudioRoomService

#pragma mark 后台接口

/// 设置PK时长
/// @param roomId
/// @param duration
/// @param finished
- (void)reqSetPKDuration:(long)roomId duration:(NSInteger)duration finished:(void (^)(void))finished;

/// 开启PK， PK开关
/// @param roomId
/// @param open YES:开启 NO:关闭
/// @param finished
- (void)reqOpenPK:(long)roomId open:(BOOL)open finished:(void (^)(void))finished;

/// 开始PK， 进行PK
/// @param roomId
/// @param duration 时长 second
/// @param finished
- (void)reqStartPK:(long)roomId duration:(NSInteger)duration isAgain:(BOOL)isAgain finished:(void (^)(RespStartPKModel *resp))finished;

/// 同意接受PK
/// @param roomId
/// @param duration 时长 second
/// @param finished
- (void)reqAgreePK:(long)srcRoomId destRoomId:(int64_t)destRoomId finished:(void (^)(RespStartPKModel *resp))finished;

/// 解除PK关系
/// @param roomId
/// @param duration 时长 second
/// @param finished
- (void)reqReleasePK:(long)destRoomId finished:(void (^)(void))finished;

#pragma mark 跨房间消息

/// 发送PK邀请信息
/// @param roomID
/// @param finished
- (void)sendCrossPKInviteMsg:(NSString *)roomID finished:(void (^)(NSInteger errorCode))finished;

/// 回应PK邀请信息
/// @param roomID
/// @param agree
/// @param finished
- (void)sendCrossAgreedPKInviteMsg:(NSString *)roomID agress:(BOOL)agree pkId:(int64_t)pkId otherUser:(AudioUserModel *)otherUser finished:(void (^)(NSInteger errorCode))finished;

/// 发送PK 切换游戏
/// @param roomID gameID
/// @param gameID gameID
/// @param finished finished
- (void)sendCrossPKChangedGameMsg:(NSString *)roomID gameID:(int64_t)gameID finished:(void (^)(NSInteger errorCode))finished;

/// 发送开始PK
/// @param roomID gameID
/// @param minuteDuration minuteDuration
/// @param finished finished
- (void)sendCrossPKStartedMsg:(NSString *)roomID minuteDuration:(NSInteger)minuteDuration pkId:(int64_t)pkId finished:(void (^)(NSInteger errorCode))finished;

/// 结束跨房PK
/// @param roomID gameID
/// @param minuteDuration minuteDuration
/// @param finished finished
- (void)sendCrossPKFinishedMsg:(NSString *)roomID finished:(void (^)(NSInteger errorCode))finished;

/// 跨房PK移除对手
/// @param roomID gameID
/// @param minuteDuration minuteDuration
/// @param finished finished
- (void)sendCrossPKRemoveOtherMsg:(NSString *)roomID finished:(void (^)(NSInteger errorCode))finished;

/// 发送PK时长消息
/// @param roomID gameID
/// @param minuteDuration minuteDuration
/// @param finished finished
- (void)sendCrossPKChangeTimeMsg:(NSString *)roomID minuteDuration:(NSInteger)minuteDuration finished:(void (^)(NSInteger errorCode))finished;

#pragma mark 房间内消息

/// 发送PK开启信息
/// @param roomID ""
/// @param finished ""
- (void)sendPKOpenedMsg;

/// 给房间内用户发送应答邀请
/// @param roomID ""
/// @param agree ""
/// @param pkId ""
/// @param finished ""
- (void)sendAgreedPKInviteMsg:(AudioUserModel *)otherUser agress:(BOOL)agree pkId:(int64_t)pkId;

/// 给房间内用户发送PK结束
/// @param roomID ""
/// @param finished ""
- (void)sendPKClosedMsg;

/// 给房间内用户发送PK移除对手
/// @param finished finished
- (void)sendCrossPKRemoveOtherMsg;

/// 发送开始PK到本房间
/// @param roomID gameID
/// @param minuteDuration minuteDuration
/// @param finished finished
- (void)sendPKStartedMsgWithMinuteDuration:(NSInteger)minuteDuration pkId:(int64_t)pkId;

/// 发送PK时长消息
/// @param minuteDuration minuteDuration
/// @param finished finished
- (void)sendPKChangeTimeMsgWithMinuteDuration:(NSInteger)minuteDuration;
@end
