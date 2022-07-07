//
//  DiscoRoomService.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/30.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "AudioRoomService.h"
#import "DiscoRankModel.h"
#import "DiscoMenuModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 蹦迪服务
@interface DiscoRoomService : AudioRoomService
/// 跳舞单
@property(nonatomic, strong) NSMutableArray <DiscoMenuModel *> *danceMenuList;
/// 贡献榜
@property(nonatomic, strong) NSMutableArray <DiscoContributionModel *> *rankList;

/// 更新舞池列表
/// @param giftModel
- (void)updateDanceMenuInfo:(RoomCmdSendGiftModel *)giftModel;

/// 增加跳舞信息
/// @param model
- (void)addDanceMenuInfo:(DiscoMenuModel *)model;

/// 增数据
/// @param model
- (void)addRankInfo:(DiscoContributionModel *)model;

/// 增加分值
/// @param fromUser
/// @param count
- (void)addRankCount:(AudioUserModel *)fromUser count:(NSInteger)count;

/// 处理主播停止了跳舞
/// @param anchorID
- (void)handleAnchorStopDancing:(NSString *)anchorID;

/// 处理排版数据
- (void)handleRankInfo;

#pragma mark game cmd

/// 加入舞池
/// @param colorHexValue 昵称的颜色色值
- (void)joinDancePool:(NSString *)colorHexValue;

/// 离开舞池
- (void)leaveDancePool;

/// 加入主播位
/// @param position 0-0号主播位；1-1号主播位；2-2号主播位；3-3号主播位；4-4号主播位；5-5号主播位；6-6号主播位；7-7号主播位；-1-随机，默认随机
- (void)joinAnchorPosition:(NSString *)position;

/// 离开主播位
/// @param playerId playerId（离开主播位的玩家id），默认自己离开，如果该玩家本来就不在主播位则没有任何效果
- (void)leaveAnchorPositionWithPlayerId:(NSString *)playerId;

/// 角色移动
/// @param cooldown 移动的持续时间，单位秒（范围为3-300，超出范围会取默认值）默认10秒
/// @param field1 移动速度快慢的数值（范围为0.1-3，保留1位小数点，1为正常速度，超出范围会取默认值）；默认1
- (void)movePosition:(int)cooldown field1:(NSString *)field1;

/// 角色飞天
/// @param cooldown 飞天的持续时间，单位秒（-1为永久）默认30秒
- (void)flySky:(int)cooldown;

/// 角色称号
/// @param cooldown 称号的持续时间，单位秒（-1为永久）默认永久
/// @param field1 称号的文字内容（6个汉字的长度）；默认在“全场最靓”，“最强王者”和“元宇宙砂砂舞”中随机
/// @param field2 称号特效ID（1：称号1；2：称号2；3：称号3）默认随机
- (void)switchRole:(int)cooldown field1:(NSString *)field1 field2:(NSString *)field2;

/// 角色特写
/// @param cooldown 特写的持续时间，单位秒（范围为1-30，超出范围会取默认值）默认舞池角色1秒,DJ台角色3秒,跳舞的角色5秒
/// @param isTop false-不置顶；true-置顶
- (void)specialRole:(int)cooldown isTop:(BOOL)isTop;

/// 文字气泡
/// @param cooldown 气泡的持续时间，单位秒（-1为永久）默认3秒
/// @param field1 气泡的文字内容；默认为空
- (void)showMsgPop:(int)cooldown field1:(NSString *)field1;

/// 角色变大
/// @param cooldown 变大的持续时间，单位秒（-1为永久）默认60秒
/// @param field1 放大倍数的数值（范围为0.1-5，保留1位小数点，1为原始大小，超出范围会取默认值）；默认2
- (void)scaleBiggerRole:(int)cooldown field1:(NSString *)field1;

/// 和主播跳舞
/// @param cooldown 和主播跳舞的持续时间，单位秒（-1为永久）默认30秒
/// @param isTop false-不置顶；true-置顶
/// @param field1 playerId（主播玩家的id）；该参数必传，不传则没有任何效果
- (void)danceWithAnchor:(int)cooldown isTop:(BOOL)isTop field1:(NSString *)field1;
@end

NS_ASSUME_NONNULL_END
