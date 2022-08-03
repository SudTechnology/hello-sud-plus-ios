//
//  DanmukaRoomService.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/16.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "AudioRoomService.h"

NS_ASSUME_NONNULL_BEGIN
/// 弹幕房间服务
@interface DanmakuRoomService : AudioRoomService
/// 发送弹幕
/// @param roomId roomId
/// @param content content
/// @param finished finished
/// @param failure failure
+ (void)reqSendBarrage:(NSString *)roomId content:(NSString *)content gameId:(int64_t)gameId finished:(void (^)(void))finished failure:(void (^)(NSError *error))failure;

/// 发送礼物
/// @param roomId roomId
/// @param giftId giftId
/// @param finished finished
/// @param failure failure
+ (void)reqSendGift:(NSString *)roomId giftId:(NSString *)giftId amount:(NSInteger)amount price:(NSInteger)price type:(NSInteger)type finished:(void (^)(void))finished failure:(void (^)(NSError *error))failure;

/// 拉取快捷弹幕列表
/// @param gameId gameId
/// @param finished finished
/// @param failure failure
+ (void)reqShortSendEffectList:(int64_t)gameId finished:(void (^)(NSArray<DanmakuCallWarcraftModel *> *modelList, NSString *guideTip))finished failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
