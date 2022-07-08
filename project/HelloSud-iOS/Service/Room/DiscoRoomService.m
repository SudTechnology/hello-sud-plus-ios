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
    /// 清场
    DiscoActionTypeClearDancePool = 17,
    /// 角色移动
    DiscoActionTypeMoveRole = 18,
    /// 角色变大
    DiscoActionTypeBiggerRole = 19,
    /// 角色飞天
    DiscoActionTypeFlyRole = 20,
    /// 角色特效
    DiscoActionTypeEffectRole = 22,
    /// 角色特写
    DiscoActionTypeSpecialRole = 23,
    /// 文字气泡
    DiscoActionTypeMsgPop = 24,
    /// 角色称号
    DiscoActionTypeNamedRole = 25,
    /// 上DJ台
    DiscoActionTypeUpDJ = 26,
    /// 跳舞模式
    DiscoActionTypeDancingMode = 27,
    /// 和主播跳舞
    DiscoActionTypeDancingWithAnchor = 28,
};

@interface DiscoRoomService ()
/// 当前主播跳舞池
@property(nonatomic, strong) NSMutableDictionary<NSString *, DiscoMenuModel *> *dicDancingMap;
/// 贡献榜
@property(nonatomic, strong) NSMutableDictionary <NSString *, DiscoContributionModel *> *rankMap;
@end

@implementation DiscoRoomService

- (DiscoMenuModel *)findSameSendUser:(NSString *)userID {
    NSArray *arr = self.danceMenuList;
    for (int i = 0; i < arr.count; ++i) {
        DiscoMenuModel *m = arr[i];
        if ([m.fromUser.userID isEqualToString:userID] && !m.isDanceFinished) {
            return m;
        }
    }
    return nil;
}

/// 更新舞池列表
/// @param giftModel
- (void)updateDanceMenuInfo:(RoomCmdSendGiftModel *)giftModel {

    DiscoMenuModel *m = [self findSameSendUser:giftModel.sendUser.userID];
    NSInteger addDuration = 0;
    switch (giftModel.giftID) {
        case 5: {
            // 礼物价格50
            addDuration = 60;
            if (m && !m.isDanceFinished) {
                m.duration += addDuration;
            } else {
                m = [[DiscoMenuModel alloc] init];
                m.duration = addDuration;
                m.fromUser = giftModel.sendUser;
                m.toUser = giftModel.toUser;
                [self.danceMenuList addObject:m];
            }
        }
            break;
        case 6: {
            // 礼物价格150
            // 与主播跳舞
            addDuration = 3 * 60;
            if (m && !m.isDanceFinished) {
                m.duration += addDuration;
            } else {
                m = [[DiscoMenuModel alloc] init];
                m.duration = addDuration;
                m.fromUser = giftModel.sendUser;
                m.toUser = giftModel.toUser;
                [self.danceMenuList addObject:m];
            }
        }
            break;
        case 7: {
            // 礼物价格1500
            // 插队
            if (m) {
                [self.danceMenuList removeObject:m];
                if (self.danceMenuList.count > 0) {
                    [self.danceMenuList insertObject:m atIndex:1];
                } else {
                    [self.danceMenuList addObject:m];
                }
            }
        }
            break;
        default:
            break;
    }

    if (addDuration > 0) {
        [self checkIfNeedToDancing:m duration:addDuration];
    }

}

- (void)checkIfNeedToDancing:(DiscoMenuModel *)m duration:(NSInteger)addDuration {
    if (m.beginTime == 0) {
        // 未开始跳舞
        NSString *anchorID = m.toUser.userID;
        if (!anchorID) {
            DDLogError(@"will dancing with anchor, but anchor id isempty");
            return;
        }
        if ([self isAnchorDancing:anchorID]) {
            // 当前主播在跳舞
            return;
        }
        // 开始跳舞
        [m beginDancing];
        self.dicDancingMap[anchorID] = m;
        if ([AppService.shared.login.loginUserInfo isMeByUserID:m.fromUser.userID]) {
            // 发送者是自己，执行与主播跳舞指令
            [self danceWithAnchor:m.duration isTop:NO field1:m.toUser.userID];
        }
    } else {
        // 已经在跳，如果是与自己在跳，则通知游戏继续跳
        if ([AppService.shared.login.loginUserInfo isMeByUserID:m.fromUser.userID]) {
            // 发送者是自己，执行与主播跳舞指令
            [self danceWithAnchor:addDuration isTop:NO field1:m.toUser.userID];
        }
    }
}

/// 增加跳舞信息
/// @param model
- (void)addDanceMenuInfo:(DiscoMenuModel *)model {
    [self.danceMenuList addObject:model];
    [self checkIfNeedToDancing:model duration:model.duration];
}

/// 增数据
/// @param model
- (void)addRankInfo:(DiscoContributionModel *)model {
    self.rankMap[model.fromUser.userID] = model;
    [self reSortRankList];
}

- (void)reSortRankList {
    NSArray *arr = [self.rankMap allValues];
    NSArray *sortedArr = [arr sortedArrayUsingComparator:^NSComparisonResult(DiscoContributionModel * obj1, DiscoContributionModel * obj2) {
        if (obj1.count == obj2.count) {
            return obj1.fromUser.userID < obj2.fromUser.userID;
        }
        return obj1.count < obj2.count;
    }];
    [self.rankList setArray:sortedArr];
}

/// 增加分值
/// @param fromUser
/// @param count
- (void)addRankCount:(AudioUserModel *)fromUser count:(NSInteger)count {
    DiscoContributionModel *m = self.rankMap[fromUser.userID];
    if (!m) {
        m = [[DiscoContributionModel alloc]init];
        m.fromUser = fromUser;
        [self addRankInfo:m];
    }
    m.count += count;
    [self reSortRankList];
}

/// 处理主播停止了跳舞
/// @param anchorID
- (void)handleAnchorStopDancing:(NSString *)anchorID {
    if (anchorID) {
        [self.dicDancingMap removeObjectForKey:anchorID];
        [self checkIfNeedToDancing];
    }
}


/// 处理排版数据
- (void)handleRankInfo {

}

/// 主播是否正在跳舞
- (BOOL)isAnchorDancing:(NSString *)anchorID {
    return self.dicDancingMap[anchorID];
}

/// 主播是否正在和我跳舞
- (BOOL)isAnchorDancingWithMe:(NSString *)anchorID {
    DiscoMenuModel *m = self.dicDancingMap[anchorID];
    if (m && [AppService.shared.login.loginUserInfo isMeByUserID:m.fromUser.userID]) {
        return YES;
    }
    return NO;
}

/// 检测是否要跳舞
- (void)checkIfNeedToDancing {
    NSArray *arr = self.danceMenuList;
    for (int i = 0; i < arr.count; ++i) {
        DiscoMenuModel *model = arr[i];
        if (model.beginTime == 0) {
            [model beginDancing];
            if ([AppService.shared.login.loginUserInfo isMeByUserID:model.fromUser.userID]) {
                // 发送者是自己，执行与主播跳舞指令
                [self danceWithAnchor:model.duration isTop:NO field1:model.toUser.userID];
            }
        }
    }
}

/// 清空舞池单
- (void)clearAllDancingMenu {
    [self.danceMenuList removeAllObjects];
    [self.dicDancingMap removeAllObjects];
}

- (NSMutableDictionary<NSString *, DiscoMenuModel *> *)dicDancingMap {
    if (!_dicDancingMap) {
        _dicDancingMap = [[NSMutableDictionary alloc] init];
    }
    return _dicDancingMap;
}

- (NSMutableDictionary<NSString *, DiscoContributionModel *> *)rankMap {
    if (!_rankMap) {
        _rankMap = [[NSMutableDictionary alloc] init];
    }
    return _rankMap;
}

- (NSMutableArray <DiscoMenuModel *> *)danceMenuList {
    if (!_danceMenuList) {
        _danceMenuList = [[NSMutableArray alloc] init];
    }
    return _danceMenuList;
}

- (NSMutableArray <DiscoContributionModel *> *)rankList {
    if (!_rankList) {
        _rankList = [[NSMutableArray alloc] init];
    }
    return _rankList;
}

/// 加入舞池
/// @param colorHexValue 昵称的颜色色值
- (void)joinDancePool:(NSString *)colorHexValue {
    AppCommonGameDiscoAction *m = [[AppCommonGameDiscoAction alloc] init];
    m.actionId = DiscoActionTypeJoinDancePool;
    m.field1 = colorHexValue;
    [self.currentRoomVC.sudFSTAPPDecorator notifyAppCommonGameDiscoAction:m];
}

/// 离开舞池
- (void)leaveDancePool {
    AppCommonGameDiscoAction *m = [[AppCommonGameDiscoAction alloc] init];
    m.actionId = DiscoActionTypeLeaveDancePool;
    [self.currentRoomVC.sudFSTAPPDecorator notifyAppCommonGameDiscoAction:m];
}

/// 加入主播位
/// @param position 0-0号主播位；1-1号主播位；2-2号主播位；3-3号主播位；4-4号主播位；5-5号主播位；6-6号主播位；7-7号主播位；-1-随机，默认随机
- (void)joinAnchorPosition:(NSString *)position {
    AppCommonGameDiscoAction *m = [[AppCommonGameDiscoAction alloc] init];
    m.actionId = DiscoActionTypeJoinAnchorPosition;
    m.field1 = position;
    [self.currentRoomVC.sudFSTAPPDecorator notifyAppCommonGameDiscoAction:m];
}

/// 离开主播位
/// @param playerId playerId（离开主播位的玩家id），默认自己离开，如果该玩家本来就不在主播位则没有任何效果
- (void)leaveAnchorPositionWithPlayerId:(NSString *)playerId {
    AppCommonGameDiscoAction *m = [[AppCommonGameDiscoAction alloc] init];
    m.actionId = DiscoActionTypeLeaveAnchorPosition;
    m.field1 = playerId;
    [self.currentRoomVC.sudFSTAPPDecorator notifyAppCommonGameDiscoAction:m];
}

/// 角色移动
/// @param cooldown 移动的持续时间，单位秒（范围为3-300，超出范围会取默认值）默认10秒
/// @param field1 移动速度快慢的数值（范围为0.1-3，保留1位小数点，1为正常速度，超出范围会取默认值）；默认1
- (void)movePosition:(int)cooldown field1:(NSString *)field1 {
    AppCommonGameDiscoAction *m = [[AppCommonGameDiscoAction alloc] init];
    m.actionId = DiscoActionTypeMoveRole;
    m.cooldown = cooldown;
    m.field1 = field1;
    [self.currentRoomVC.sudFSTAPPDecorator notifyAppCommonGameDiscoAction:m];
}

/// 角色飞天
/// @param cooldown 飞天的持续时间，单位秒（-1为永久）默认30秒
- (void)flySky:(int)cooldown {
    AppCommonGameDiscoAction *m = [[AppCommonGameDiscoAction alloc] init];
    m.actionId = DiscoActionTypeFlyRole;
    m.cooldown = cooldown;
    [self.currentRoomVC.sudFSTAPPDecorator notifyAppCommonGameDiscoAction:m];
}

/// 换角色
/// @param field1 角色ID（1：角色1（男）；2：角色2（男）；3：角色3（男）；4：角色4（男）；5：角色5（男）；6：角色6（男）；7：角色7（男）；8：角色8（男）；9：角色9（男）；10：角色10（男）；11：角色11（男）；12：角色12（女）；13：角色13（女）；14：角色14（女）；15：角色15（女）；16：角色16（女）；17：角色17（女）；18：角色18（女）；19：角色19（女）；20：角色20（女）；21：角色21（女））；默认随机
- (void)switchRole:(NSString *)field1 {
    AppCommonGameDiscoAction *m = [[AppCommonGameDiscoAction alloc] init];
    m.actionId = DiscoActionTypeChangeRole;
    m.field1 = field1;
    [self.currentRoomVC.sudFSTAPPDecorator notifyAppCommonGameDiscoAction:m];
}

/// 角色特写
/// @param cooldown 特写的持续时间，单位秒（范围为1-30，超出范围会取默认值）默认舞池角色1秒,DJ台角色3秒,跳舞的角色5秒
/// @param isTop false-不置顶；true-置顶
- (void)specialRole:(int)cooldown isTop:(BOOL)isTop {
    AppCommonGameDiscoAction *m = [[AppCommonGameDiscoAction alloc] init];
    m.actionId = DiscoActionTypeSpecialRole;
    m.cooldown = cooldown;
    m.isTop = isTop;
    [self.currentRoomVC.sudFSTAPPDecorator notifyAppCommonGameDiscoAction:m];
}

/// 文字气泡
/// @param cooldown 气泡的持续时间，单位秒（-1为永久）默认3秒
/// @param field1 气泡的文字内容；默认为空
- (void)showMsgPop:(int)cooldown field1:(NSString *)field1 {
    AppCommonGameDiscoAction *m = [[AppCommonGameDiscoAction alloc] init];
    m.actionId = DiscoActionTypeMsgPop;
    m.cooldown = cooldown;
    m.field1 = field1;
    [self.currentRoomVC.sudFSTAPPDecorator notifyAppCommonGameDiscoAction:m];
}

/// 角色变大
/// @param cooldown 变大的持续时间，单位秒（-1为永久）默认60秒
/// @param field1 放大倍数的数值（范围为0.1-5，保留1位小数点，1为原始大小，超出范围会取默认值）；默认2
- (void)scaleBiggerRole:(int)cooldown field1:(NSString *)field1 {
    AppCommonGameDiscoAction *m = [[AppCommonGameDiscoAction alloc] init];
    m.actionId = DiscoActionTypeBiggerRole;
    m.cooldown = cooldown;
    m.field1 = field1;
    [self.currentRoomVC.sudFSTAPPDecorator notifyAppCommonGameDiscoAction:m];
}

/// 角色特效
/// @param cooldown 特效的持续时间，单位秒（-1为永久）默认60秒
/// @param field1 特效ID（1：特效1；2：特效2；3：特效3；4：特效4；5：特效5；6：特效6）；默认随机
- (void)switchEffectRole:(int)cooldown field1:(NSString *)field1 {
    AppCommonGameDiscoAction *m = [[AppCommonGameDiscoAction alloc] init];
    m.actionId = DiscoActionTypeEffectRole;
    m.cooldown = cooldown;
    m.field1 = field1;
    [self.currentRoomVC.sudFSTAPPDecorator notifyAppCommonGameDiscoAction:m];
}

/// 和主播跳舞
/// @param cooldown 和主播跳舞的持续时间，单位秒（-1为永久）默认30秒
/// @param isTop false-不置顶；true-置顶
/// @param field1 playerId（主播玩家的id）；该参数必传，不传则没有任何效果
- (void)danceWithAnchor:(int)cooldown isTop:(BOOL)isTop field1:(NSString *)field1 {
    AppCommonGameDiscoAction *m = [[AppCommonGameDiscoAction alloc] init];
    m.actionId = DiscoActionTypeDancingWithAnchor;
    m.cooldown = cooldown;
    m.isTop = isTop;
    m.field1 = field1;
    [self.currentRoomVC.sudFSTAPPDecorator notifyAppCommonGameDiscoAction:m];
}

/// 上DJ台
/// @param cooldown 上DJ台的持续时间，单位秒（-1为永久）默认180秒
- (void)upToDJ:(int)cooldown {
    AppCommonGameDiscoAction *m = [[AppCommonGameDiscoAction alloc] init];
    m.actionId = DiscoActionTypeUpDJ;
    m.cooldown = cooldown;
    [self.currentRoomVC.sudFSTAPPDecorator notifyAppCommonGameDiscoAction:m];
}
@end
