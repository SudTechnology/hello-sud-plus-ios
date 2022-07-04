//
//  DiscoRoomService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/30.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoRoomService.h"
#import "SudMGPAPPState.h"

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
/// 加入舞池
/// @param colorHexValue 昵称的颜色色值
- (void)joinDancePool:(NSString *)colorHexValue {
    AppCommonGameDiscoAction *m = [[AppCommonGameDiscoAction alloc]init];
    m.actionId = DiscoActionTypeJoinDancePool;
    m.field1 = colorHexValue;
    [self.currentRoomVC.sudFSTAPPDecorator notifyAppCommonGameDiscoAction:m];
}
/// 离开舞池
- (void)leaveDancePool {
    AppCommonGameDiscoAction *m = [[AppCommonGameDiscoAction alloc]init];
    m.actionId = DiscoActionTypeLeaveDancePool;
    [self.currentRoomVC.sudFSTAPPDecorator notifyAppCommonGameDiscoAction:m];
}
/// 加入主播位
/// @param position 0-0号主播位；1-1号主播位；2-2号主播位；3-3号主播位；4-4号主播位；5-5号主播位；6-6号主播位；7-7号主播位；-1-随机，默认随机
- (void)joinAnchorPosition:(NSString *)position {
    AppCommonGameDiscoAction *m = [[AppCommonGameDiscoAction alloc]init];
    m.actionId = DiscoActionTypeJoinAnchorPosition;
    m.field1 = position;
    [self.currentRoomVC.sudFSTAPPDecorator notifyAppCommonGameDiscoAction:m];
}
/// 离开主播位
/// @param playerId playerId（离开主播位的玩家id），默认自己离开，如果该玩家本来就不在主播位则没有任何效果
- (void)leaveAnchorPositionWithPlayerId:(NSString *)playerId {
    AppCommonGameDiscoAction *m = [[AppCommonGameDiscoAction alloc]init];
    m.actionId = DiscoActionTypeLeaveAnchorPosition;
    m.field1 = playerId;
    [self.currentRoomVC.sudFSTAPPDecorator notifyAppCommonGameDiscoAction:m];
}
@end
