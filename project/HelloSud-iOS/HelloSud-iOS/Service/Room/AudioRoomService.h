//
//  AudioRoomService.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import <Foundation/Foundation.h>
#import "AudioRoomViewController.h"
#import "BaseSceneViewController+IM.h"
#import "BaseSceneViewController+Game.h"
#import "BaseSceneViewController+Voice.h"
NS_ASSUME_NONNULL_BEGIN

/// 语音房间管理
@interface AudioRoomService : NSObject
/// 1：语聊房场景 2：1v1场景 3：才艺房场景 4：秀场场景 5:门票场景 6：竞猜场景 7：跨房PK场景 8：点单场景 9：语音识别场景 10：联赛场景 11：自定义场景
typedef NS_ENUM(NSInteger, SceneType) {
    SceneTypeAudio = 1,
    SceneTypeOneOne,
    SceneTypeTalent,
    SceneTypeShow,
    SceneTypeTicket,
    SceneTypeGuess,
    SceneTypeCross,
    SceneTypeOrder,
    SceneTypeASR,
    SceneTypeLeague,
    SceneTypeCustom
};
/// 场景类型
@property (nonatomic, assign) SceneType sceneType;
/// 当前房间VC
@property(nonatomic, weak)BaseSceneViewController *currentRoomVC;
/// 当前用户在房间角色
@property(nonatomic, assign)NSInteger roleType;
/// 当前用户麦位
@property(nonatomic, assign)NSInteger micIndex;

+ (instancetype)shared;

/// 请求创建房间
/// @param sceneType 场景类型
/// @param gameLevel 游戏等级（适配当前门票场景）
- (void)reqCreateRoom:(NSInteger)sceneType gameLevel:(NSInteger)gameLevel;

/// 请求进入房间
/// @param roomId 房间ID
- (void)reqEnterRoom:(long)roomId success:(nullable EmptyBlock)success fail:(nullable ErrorBlock)fail;

/// 请求退出房间
/// @param roomId 房间ID
- (void)reqExitRoom:(long)roomId;

/// 匹配开播的游戏，并进入游戏房间
/// @param gameId 游戏ID
/// @param gameLevel 游戏等级（适配当前门票场景）= -1
- (void)reqMatchRoom:(long)gameId sceneType:(long)sceneType gameLevel:(NSInteger)gameLevel;

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


#pragma mark - TicketService
- (NSMutableArray <NSAttributedString *> *)getTicketRewardAttributedStrArr;

@end

NS_ASSUME_NONNULL_END
