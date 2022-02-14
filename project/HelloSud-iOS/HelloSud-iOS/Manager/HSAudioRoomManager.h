//
//  HSAudioRoomManager.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import <Foundation/Foundation.h>
#import "HSAudioRoomViewController.h"
#import "HSAudioRoomViewController+IM.h"
#import "HSAudioRoomViewController+Game.h"
#import "HSAudioRoomViewController+Voice.h"
NS_ASSUME_NONNULL_BEGIN

/// 语音房间管理
@interface HSAudioRoomManager : NSObject
/// 当前房间VC
@property(nonatomic, weak)HSAudioRoomViewController *currentRoomVC;

/// 当前用户在房间角色
@property(nonatomic, assign)NSInteger roleType;
/// 当前用户麦位
@property(nonatomic, assign)NSInteger micIndex;

+ (instancetype)shared;

/// 请求进入房间
/// @param roomId 房间ID
- (void)reqEnterRoom:(long)roomId;

/// 请求退出房间
/// @param roomId 房间ID
- (void)reqExitRoom:(long)roomId;

/// 匹配开播的游戏，并进入游戏房间
/// @param gameId 游戏ID
- (void)reqMatchRoom:(long)gameId sceneType:(long)sceneType;

/// 用户上麦或下麦
/// @param roomId 房间ID
/// @param micIndex 麦位索引
/// @param handleType 0：上麦 1: 下麦
- (void)reqSwitchMic:(long)roomId micIndex:(int)micIndex handleType:(int)handleType success:(nullable EmptyBlock)success fail:(nullable ErrorBlock)fail;

/// 查询房间麦位列表
/// @param roomId 房间ID
- (void)reqMicList:(long)roomId success:(void(^)(NSArray<HSRoomMicList *> *micList))success fail:(ErrorBlock)fail;

/// 切换房间游戏接口
/// @param roomId 房间ID
- (void)reqSwitchGame:(long)roomId gameId:(long)gameId success:(EmptyBlock)success fail:(ErrorBlock)fail;

@end

NS_ASSUME_NONNULL_END
