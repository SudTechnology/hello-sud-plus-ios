//
//  DiscoRoomService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/30.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoRoomService.h"
#import "SudMGPAPPState.h"

NSNotificationName const showWaitingForDancingNTF = @"showWaitingForDancingNTF";
/// 跳舞列表更新
NSNotificationName const dancingListChangedNTF = @"dancingListChangedNTF";



@interface DiscoRoomService ()
/// 当前主播跳舞池
@property(nonatomic, strong) NSMutableDictionary<NSString *, DiscoMenuModel *> *dicDancingMap;
/// 贡献榜
@property(nonatomic, strong) NSMutableDictionary <NSString *, DiscoContributionModel *> *rankMap;
@end

@implementation DiscoRoomService
/// 找出发送者，接受者一致的舞单
/// @param giftModel
/// @return
- (DiscoMenuModel *)findSameSendAndRecvUser:(RoomCmdSendGiftModel *)giftModel {
    NSArray *arr = self.danceMenuList;
    for (int i = 0; i < arr.count; ++i) {
        DiscoMenuModel *m = arr[i];
        if ([m.fromUser.userID isEqualToString:giftModel.sendUser.userID] &&
                [m.toUser.userID isEqualToString:giftModel.toUser.userID] &&
                !m.isDanceFinished) {
            return m;
        }
    }
    return nil;
}


/// 处理用户送出礼物
/// @param giftModel
- (void)handleUserSentGift:(RoomCmdSendGiftModel *)giftModel {

    // 收礼者与送礼者相同时忽略
    if ([giftModel.sendUser.userID isEqualToString:giftModel.toUser.userID]) {
        return;
    }
    BOOL refresh = NO;
    DiscoMenuModel *m = [self findSameSendAndRecvUser:giftModel];
    NSInteger addDuration = 0;
    switch (giftModel.giftID) {
        case 5: {
            // 礼物价格50
            addDuration = 60 * giftModel.giftCount;
            if (m && !m.isDanceFinished) {
                m.duration += addDuration;
            } else {
                m = [[DiscoMenuModel alloc] init];
                m.duration = addDuration;
                m.fromUser = giftModel.sendUser;
                m.toUser = giftModel.toUser;
                [self.danceMenuList addObject:m];
            }
            refresh = YES;
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
            refresh = YES;
        }
            break;
        case 7: {
            // 礼物价格1500
            // 插队
            if (m) {
                [self.danceMenuList removeObject:m];
                // 首个等待用户
                NSInteger firstWaitingIndex = -1;
                NSArray *arrTemp = self.danceMenuList;
                for (int i = 0; i < arrTemp.count; ++i) {
                    DiscoMenuModel *temp = arrTemp[i];
                    // 相同主播
                    if (temp.beginTime == 0 && [temp.toUser.userID isEqualToString:m.toUser.userID]) {
                        firstWaitingIndex = i;
                        break;
                    }
                }
                if (firstWaitingIndex >= 0) {
                    [self.danceMenuList insertObject:m atIndex:firstWaitingIndex];
                } else {
                    [self.danceMenuList addObject:m];
                }
                refresh = YES;
            }
        }
            break;
        default:
            break;
    }

    if (addDuration > 0) {
        // 送礼人是自己
        BOOL fromSentGift = [AppService.shared.login.loginUserInfo isMeByUserID:giftModel.sendUser.userID];
        [self checkIfNeedToDancing:m duration:addDuration fromSentGift:fromSentGift];
    }
    if (refresh) {
        [[NSNotificationCenter defaultCenter] postNotificationName:dancingListChangedNTF object:nil];
    }
}

- (void)checkIfNeedToDancing:(DiscoMenuModel *)m duration:(NSInteger)addDuration fromSentGift:(BOOL)fromSentGift {
    if (m.beginTime == 0) {
        // 未开始跳舞
        NSString *anchorID = m.toUser.userID;
        if (!anchorID) {
            DDLogError(@"will dancing with anchor, but anchor id isempty");
            return;
        }
        if ([self isUserDancing:anchorID]) {
            // 当前主播在跳舞
            DDLogDebug(@"current anchor is dancing:, anchorID:%@", anchorID);
            // 提示等待
            if (fromSentGift) {
                [[NSNotificationCenter defaultCenter] postNotificationName:showWaitingForDancingNTF object:nil];
            }
            return;
        }
        // 开始跳舞
        [m beginDancing];
        // 用户加入舞池
        self.dicDancingMap[anchorID] = m;
        self.dicDancingMap[m.fromUser.userID] = m;
        if ([AppService.shared.login.loginUserInfo isMeByUserID:m.fromUser.userID]) {
            // 发送者是自己，执行与主播跳舞指令
            [self danceWithAnchor:m.duration isTop:NO field1:m.toUser.userID];
            // 3秒特写
            [self specialRole:3 isTop:NO];
        }
    } else {
        // 已经在跳，如果是与自己在跳，则通知游戏继续跳
        if (!m.isDanceFinished) {
            [m beginDancing];
            // 用户加入舞池
            self.dicDancingMap[m.toUser.userID] = m;
            self.dicDancingMap[m.fromUser.userID] = m;
//            if ([AppService.shared.login.loginUserInfo isMeByUserID:m.fromUser.userID]) {
//                // 发送者是自己，执行与主播跳舞指令
//                [self danceWithAnchor:addDuration isTop:NO field1:m.toUser.userID];
//            }
        }
    }
}

/// 增加跳舞信息
/// @param model
- (void)addDanceMenuInfo:(DiscoMenuModel *)model {
    DDLogDebug(@"addDanceMenuInfo: fromUser:%@, toUserID:%@", model.fromUser.userID, model.toUser.userID);
    if ([self checkIsExist:model isFinished:model.isDanceFinished]) {
        DDLogDebug(@"exist same dance info: fromUser:%@, toUserID:%@", model.fromUser.userID, model.toUser.userID);
        return;
    }
    if (model.isDanceFinished) {
        // 已经结束列表
        [self.finishedDanceMenuList addObject:model];
    } else {
        [self.danceMenuList addObject:model];
    }
    [self checkIfNeedToDancing:model duration:model.duration fromSentGift:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:dancingListChangedNTF object:nil];
}

- (BOOL)checkIsExist:(DiscoMenuModel *)model isFinished:(BOOL)isFinished {
    if (isFinished) {
        NSArray *arr = self.finishedDanceMenuList;
        for (DiscoMenuModel *m in arr) {
            if ([model isSame:m]) {
                return YES;
            }
        }
    } else {
        NSArray *arr = self.danceMenuList;
        for (DiscoMenuModel *m in arr) {
            if ([model isSame:m]) {
                return YES;
            }
        }
    }
    return NO;
}

/// 增数据
/// @param model
- (void)addRankInfo:(DiscoContributionModel *)model {
    DDLogDebug(@"addRankInfo: fromUser:%@", model.fromUser.userID);
    self.rankMap[model.fromUser.userID] = model;
    [self reSortRankList];
}

- (void)reSortRankList {
    NSArray *arr = [self.rankMap allValues];
    NSArray *sortedArr = [arr sortedArrayUsingComparator:^NSComparisonResult(DiscoContributionModel *obj1, DiscoContributionModel *obj2) {
        if (obj1.count == obj2.count) {
            return [obj1.fromUser.userID compare:obj2.fromUser.userID];
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
        m = [[DiscoContributionModel alloc] init];
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
        DiscoMenuModel *m = self.dicDancingMap[anchorID];
        if (m) {
            [self.danceMenuList removeObject:m];
            [self.finishedDanceMenuList insertObject:m atIndex:0];
            // 移除主播舞伴
            [self.dicDancingMap removeObjectForKey:m.fromUser.userID];
        } else {
            DDLogError(@"handleAnchorStopDancing, no model in dancing map,anchorID:%@", anchorID);
        }

        // 移除主播
        [self.dicDancingMap removeObjectForKey:anchorID];
        [self checkIfNeedToDancing];
        [[NSNotificationCenter defaultCenter] postNotificationName:dancingListChangedNTF object:nil];
    }
}


/// 处理同步后数据
- (void)handleFinishedSyncDataInfo {
    [self checkIfNeedToDancing];
}

/// 主播是否正在跳舞
- (BOOL)isUserDancing:(NSString *)anchorID {
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
        [self checkIfNeedToDancing:model duration:model.remainDuration fromSentGift:NO];
    }
}

/// 清空舞池单
- (void)clearAllDancingMenu {
    [self.danceMenuList removeAllObjects];
    [self.finishedDanceMenuList removeAllObjects];
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

- (NSMutableArray <DiscoMenuModel *> *)finishedDanceMenuList {
    if (!_finishedDanceMenuList) {
        _finishedDanceMenuList = [[NSMutableArray alloc] init];
    }
    return _finishedDanceMenuList;
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

/// 跳舞模式
/// @param field1 field1:0-单对单（单个玩家只能和单个主播跳舞）；1-单对多（单个玩家可以和多个主播跳舞）默认0）
- (void)setDanceMode:(NSString *)field1 {
    AppCommonGameDiscoAction *m = [[AppCommonGameDiscoAction alloc] init];
    m.actionId = DiscoActionTypeDancingMode;
    m.field1 = field1;
    [self.currentRoomVC.sudFSTAPPDecorator notifyAppCommonGameDiscoAction:m];
}

/// 加入主播位
/// @param field1 0-0号主播位；1-1号主播位；2-2号主播位；3-3号主播位；4-4号主播位；5-5号主播位；6-6号主播位；7-7号主播位；-1-随机，默认随机
/// @param field2 机器人id
- (void)joinAnchorField1:(NSString *)field1 field2:(NSString *)field2 {
    DDLogDebug(@"joinAnchorField2:%@", field2);
    AppCommonGameDiscoAction *m = [[AppCommonGameDiscoAction alloc] init];
    m.actionId = DiscoActionTypeJoinAnchorPosition;
    m.field1 = field1;
    m.field2 = field2;
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
    DDLogDebug(@"danceWithAnchor: field1:%@", field1);
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

#pragma mark restful api

/// 拉取机器人
/// @param finished finished
/// @param failure failure
+ (void)reqRobotListWithFinished:(void (^)(NSArray<RotbotInfoModel *> *robotList))finished failure:(void (^)(NSError *error))failure {
    NSDictionary *dicParam = @{@"count": @(30)};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"robot/list/v1") param:dicParam respClass:RespDiscoRobotListModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            RespDiscoRobotListModel *m = (RespDiscoRobotListModel *) resp;
            finished(m.robotList);
        }
    }                         failure:failure];
}

/// 上下主播位
/// @param up 上下
/// @param roomId roomId
/// @param userId userId
/// @param finished finished
/// @param failure failure
+ (void)reqUpDownAnchor:(BOOL)up roomId:(int64_t)roomId userId:(NSString *)userId success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    NSDictionary *dicParam = @{@"roomId": @(roomId), @"handleType": up ? @1 : @2, @"userId": userId};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"disco/switch-anchors/v1") param:dicParam respClass:RespDiscoRobotListModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (success) {
            success();
        }
    }                         failure:failure];
}

/// 扣费
/// @param coin 扣金币
/// @param finished finished
/// @param failure failure
+ (void)reqPayCoin:(NSInteger)coin success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    NSDictionary *dicParam = @{@"price": @(coin)};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"disco/operation/v1") param:dicParam respClass:RespDiscoRobotListModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (success) {
            success();
        }
    }                         failure:failure];
}


/// 拉取主播列表
/// @param roomId roomId
/// @param finished finished
/// @param failure failure
+ (void)reqAnchorList:(int64_t)roomId success:(void (^)(NSArray<AnchorUserInfoModel *> *robotList))success failure:(void (^)(NSError *error))failure {

    NSDictionary *dicParam = @{@"roomId": @(roomId)};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"disco/anchor-list/v1") param:dicParam respClass:RespDiscoAnchorListModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (success) {
            RespDiscoAnchorListModel *m = (RespDiscoAnchorListModel *) resp;
            success(m.userInfoList);
        }
    }                         failure:failure];
}
@end
