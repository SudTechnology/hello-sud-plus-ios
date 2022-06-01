//
// Created by kaniel on 2022/5/13.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseSceneViewController;
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
@end