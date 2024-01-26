//
// Created by kaniel on 2022/5/13.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParamModel.h"
#import "BaseSceneConfigModel.h"

@class BaseSceneViewController;
/// 1：语聊房场景 2：1v1场景 3：才艺房场景 4：秀场场景 5:门票场景 6：竞猜场景 7：跨房PK场景 8：点单场景 9：语音识别场景 10：联赛场景 11：自定义场景 12：弹幕, 13: 蹦迪 16 跨域
typedef NS_ENUM(NSInteger, SceneType) {
    SceneTypeAudio = 1,
    SceneTypeOneOne = 2,
    SceneTypeTalent = 3,
    SceneTypeShow = 4,
    SceneTypeTicket = 5,
    SceneTypeGuess = 6,
    SceneTypeCross = 7,
    SceneTypeOrder = 8,
    SceneTypeASR = 9,
    SceneTypeLeague = 10,
    SceneTypeCustom = 11,
    SceneTypeDanmaku = 12,
    SceneTypeDisco = 13,
    SceneTypeCrossDomain = 14,
    SceneTypeCrossApp = 16,
    SceneTypeVertical = 18,
    SceneTypeAudio3D = 19,
//    SceneTypeThirdWebGame = 20, 三方web game
    
    SceneTypeGameCategoryAudio = 101, // 语音互动类
    SceneTypeGameCategoryRealTimePvP = 102,//    实时竞技类
    SceneTypeGameCategoryChess = 103,//    经典棋类
    SceneTypeGameCategoryCard = 104,//    经典牌类
    SceneTypeGameCategoryBoard = 105,//    经典桌游类
    SceneTypeGameCategoryParty = 106,//    组队竞技
    SceneTypeGameCategoryCasual = 107,//    休闲娱乐类
    SceneTypeGameCategoryInteractive = 108,//    互动礼物
    SceneTypeGameCategoryDanmaku = 109,//    弹幕游戏
    SceneTypeGameCategoryBetting = 110,//    Betting Games
    SceneTypeGameCategoryLingxian = 111,//    灵仙
    SceneTypeGameCategory3DAudio = 112,//    灵仙
};




/// 基础场景服务
@interface BaseSceneService : NSObject

/// 场景类型
@property (nonatomic, assign) SceneType sceneType;
/// 当前用户在房间角色
//LIVE_ROLE_UNKNOWN = 0;   // 未知类型
//LIVE_ROLE_OWNER = 1;     // 房主
//LIVE_ROLE_COMPERE = 999; // 主持人
//LIVE_ROLE_MANAGER = 3;   // 超级管理员
//LIVE_ROLE_NORMAL_MANAGER = 4;  // 普通管理员
//LIVE_ROLE_NORMAL = 1000; // 普通人
@property(nonatomic, assign)NSInteger roleType;
/// 当前用户麦位
@property(nonatomic, assign)NSInteger micIndex;
/// 当前房间VC
@property(nonatomic, weak)BaseSceneViewController *currentRoomVC;

/// 发送礼物
/// @param roomId roomId
/// @param giftId giftId
/// @param finished finished
/// @param failure failure
+ (void)reqSendGift:(NSString *)roomId giftId:(NSString *)giftId amount:(NSInteger)amount price:(NSInteger)price type:(NSInteger)type receiverList:(NSArray<NSString *> *)receiverList finished:(void (^)(void))finished failure:(void (^)(NSError *error))failure;

@end
