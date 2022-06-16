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
+ (void)reqSendBarrage:(NSString *)roomId content:(NSString *)content finished:(void (^)(void))finished failure:(void (^)(NSError *error))failure;

/// 拉取快捷弹幕列表
/// @param gameId gameId
/// @param finished finished
/// @param failure failure
+ (void)reqShortSendEffectList:(int64_t)gameId finished:(void (^)(NSArray<DanmakuCallWarcraftModel *> *modelList))finished failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
