//
//  AudioRoomService.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import <Foundation/Foundation.h>
#import "AudioRoomViewController.h"
#import "RoomCustomModel.h"
#import "GameCfgModel.h"
#import "RoomOrderCreateModel.h"
NS_ASSUME_NONNULL_BEGIN

/// 语音房间管理
@interface AudioRoomService : BaseSceneService

/// 请求创建房间
/// @param sceneType 场景类型
/// @param gameLevel 游戏等级（适配当前门票场景）
+ (void)reqCreateRoom:(NSInteger)sceneType gameLevel:(NSInteger)gameLevel;

/// 请求进入房间
/// @param roomId 房间ID
+ (void)reqEnterRoom:(long)roomId success:(nullable EmptyBlock)success fail:(nullable ErrorBlock)fail;

/// 匹配开播的游戏，并进入游戏房间
/// @param gameId 游戏ID
/// @param gameLevel 游戏等级（适配当前门票场景）= -1
+ (void)reqMatchRoom:(long)gameId sceneType:(long)sceneType gameLevel:(NSInteger)gameLevel;

/// 请求退出房间
/// @param roomId 房间ID
- (void)reqExitRoom:(long)roomId;

/// 用户上麦或下麦
/// @param roomId 房间ID
/// @param micIndex 麦位索引
/// @param handleType 0：上麦 1: 下麦
/// @param proxyUser 代理上麦用户
- (void)reqSwitchMic:(long)roomId micIndex:(int)micIndex handleType:(int)handleType proxyUser:(AudioUserModel *)proxyUser success:(nullable EmptyBlock)success fail:(nullable ErrorBlock)fail;

/// 查询房间麦位列表
/// @param roomId 房间ID
- (void)reqMicList:(long)roomId success:(void(^)(NSArray<HSRoomMicList *> *micList))success fail:(ErrorBlock)fail;

/// 切换房间游戏接口
/// @param roomId 房间ID
- (void)reqSwitchGame:(long)roomId gameId:(int64_t)gameId success:(EmptyBlock)success fail:(ErrorBlock)fail;

/// 下单
/// @param roomId 房间ID
- (void)reqRoomOrderCreate:(long)roomId gameId:(long)gameId userIdList:(NSArray*)userIdList success:(void(^)(RoomOrderCreateModel *m))success fail:(ErrorBlock)fail;

/// 同意接单
- (void)reqRoomOrderReceive:(NSInteger)orderId success:(EmptyBlock)success fail:(ErrorBlock)fail;


#pragma mark - Custom
+ (RoomCustomModel *)getCustomModel;
+ (GameCfgModel *)getGameCfgModel;

@end

NS_ASSUME_NONNULL_END
