//
//  GuessService.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "AudioRoomService.h"
#import "RespCrossAppModels.h"

NS_ASSUME_NONNULL_BEGIN

/// 跨APP服务
@interface CrossAppRoomService : AudioRoomService
/// 获取游戏列表
/// @param finished
+ (void)reqGameListWithFinished:(void (^)(RespGameListModel *))finished;

/// 开始组队匹配
/// @param gameId gameId
/// @param roomId roomId
/// @param finished finished
+ (void)reqStartCrossAppMatch:(int64_t)gameId roomId:(NSString *)roomId finished:(void (^)(RespStartCrossAppMatchModel *))finished failure:(void (^)(NSError *error))failure;

/// 取消组队匹配
/// @param gameId gameId
/// @param roomId roomId
/// @param groupId groupId
/// @param finished finished
+ (void)reqCancelCrossAppMatch:(int64_t)gameId roomId:(NSString *)roomId groupId:(NSString *)groupId finished:(void (^)(BaseRespModel *))finished failure:(void (^)(NSError *error))failure;

/// 加入组队
/// @param gameId gameId
/// @param roomId roomId
/// @param index index
/// @param finished finished
+ (void)reqJoinMatchGroup:(int64_t)gameId roomId:(NSString *)roomId index:(NSInteger)index finished:(void (^)(BaseRespModel *))finished failure:(void (^)(NSError *error))failure;

/// 退出组队
/// @param gameId gameId
/// @param finished finished
+ (void)reqExitMatchGroup:(NSString *)roomId finished:(void (^)(BaseRespModel *))finished failure:(void (^)(NSError *error))failure;

/// 切换游戏
/// @param gameId gameId
/// @param roomId roomId
/// @param finished finished
+ (void)reqSwitchMatchGame:(int64_t)gameId roomId:(NSString *)roomId finished:(void (^)(BaseRespModel *))finished;

/// 获取跨域房间列表
/// @param authSecret authSecret description
/// @param pageNumber pageNumber description
/// @param success success description
/// @param fail fail description
+ (void)reqCrossRoomList:(NSString *)authSecret pageNumber:(NSInteger)pageNumber success:(void (^)(NSArray <CrossRoomModel *> *roomList))success fail:(nullable ErrorBlock)fail;

/// 跨房匹配、并进入游戏房间
/// @param roomId roomId
/// @param authSecret authSecret
+ (void)reqCrossMatchRoom:(NSString *)roomId authSecret:(NSString *)authSecret gameId:(int64_t)gameId;
@end

NS_ASSUME_NONNULL_END
