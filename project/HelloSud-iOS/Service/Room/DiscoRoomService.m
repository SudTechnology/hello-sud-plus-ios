//
//  DiscoRoomService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/30.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoRoomService.h"

/// 元宇宙砂砂舞Action类型
typedef NS_ENUM(NSInteger, DiscoActionType) {
    /// 切歌
    DiscoActionTypeSwitchMusic = 9,
    /// 角色是否绑定性别
    DiscoActionTypeBindGender = 10,
    /// 更换角色
    DiscoActionTypeChangeRole = 11,
    /// 加入主播位
    DiscoActionTypeJoinAnchorPosition = 12,
    /// 离开主播位
    DiscoActionTypeLeaveAnchorPosition = 13,
    /// 是否隐藏中央舞台
    DiscoActionTypeHiddenCenterStage = 14,
    /// 加入舞池
    DiscoActionTypeJoinDancePool = 15,
    /// 离开舞池
    DiscoActionTypeLeaveDancePool = 16,
};

@interface DiscoRoomService()
@end

@implementation DiscoRoomService

@end
