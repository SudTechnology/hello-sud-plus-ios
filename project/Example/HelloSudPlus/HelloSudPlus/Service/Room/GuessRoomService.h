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
@interface GuessRoomService : AudioRoomService
/// 玩家列表
@property (nonatomic, strong)NSMutableArray *playerList;

/// 下注1：跨房PK 2：游戏)
/// @param betType betType
/// @param userList 用户ID列表
/// @param finished
+ (void)reqBet:(NSInteger)betType coin:(NSInteger)coin userList:(NSArray <NSString *> *)userList finished:(void (^)(void))finished failure:(void (^)(NSError *error))failure;

/// 查询竞猜游戏列表
/// @param finished 完成回调
+ (void)reqGuessListWithFinished:(void (^)(RespMoreGuessModel *))finished;

/// 查询竞猜游戏列表
/// @param userIdList id列表
/// @param roomId 房间ID
/// @param finished 完成回调
+ (void)reqGuessPlayerList:(NSArray <NSString *> *)userIdList roomId:(NSString *)roomId finished:(void (^)(RespGuessPlayerListModel *))finished;

/// 发送押注通知消息
/// @param roomID roomID
/// @param betUsers roomID
- (void)sendBetNotifyMsg:(NSString *)roomID betUsers:(NSArray<AudioUserModel *>*)betUsers;
@end

NS_ASSUME_NONNULL_END
