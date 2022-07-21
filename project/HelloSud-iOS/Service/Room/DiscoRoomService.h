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
/// 展示等待跳舞通知
FOUNDATION_EXPORT NSNotificationName const showWaitingForDancingNTF;
/// 跳舞列表更新
FOUNDATION_EXPORT NSNotificationName const dancingListChangedNTF;

/// 蹦迪服务
@interface DiscoRoomService : AudioRoomService
/// 跳舞单
@property(nonatomic, strong) NSMutableArray <DiscoMenuModel *> *danceMenuList;
/// 结束跳舞单
@property(nonatomic, strong) NSMutableArray <DiscoMenuModel *> *finishedDanceMenuList;
/// 贡献榜
@property(nonatomic, strong) NSMutableArray <DiscoContributionModel *> *rankList;

/// 更新舞池列表
/// @param giftModel
- (void)handleUserSentGift:(RoomCmdSendGiftModel *)giftModel;

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

/// 处理结束同步数据
- (void)handleFinishedSyncDataInfo;

/// 清空舞池单
- (void)clearAllDancingMenu;

#pragma mark game cmd

/// 加入舞池
/// @param colorHexValue 昵称的颜色色值
- (void)joinDancePool:(NSString *)colorHexValue;

/// 离开舞池
- (void)leaveDancePool;

/// 跳舞模式
/// @param field1 field1:0-单对单（单个玩家只能和单个主播跳舞）；1-单对多（单个玩家可以和多个主播跳舞）默认0）
- (void)setDanceMode:(NSString *)field1;

/// 加入主播位
/// @param field1 0-0号主播位；1-1号主播位；2-2号主播位；3-3号主播位；4-4号主播位；5-5号主播位；6-6号主播位；7-7号主播位；-1-随机，默认随机
/// @param field2 机器人id
- (void)joinAnchorField1:(NSString *)field1 field2:(NSString *)field2;

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
/// @param field1 称号的持续时间，单位秒（-1为永久）默认永久
/// @param field1 称号的文字内容（6个汉字的长度）；默认在“全场最靓”，“最强王者”和“元宇宙砂砂舞”中随机
/// @param field2 称号特效ID（1：称号1；2：称号2；3：称号3）默认随机
- (void)switchRole:(NSString *)field1;

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

/// 角色特效
/// @param cooldown 特效的持续时间，单位秒（-1为永久）默认60秒
/// @param field1 特效ID（1：特效1；2：特效2；3：特效3；4：特效4；5：特效5；6：特效6）；默认随机
- (void)switchEffectRole:(int)cooldown field1:(NSString *)field1;

/// 和主播跳舞
/// @param cooldown 和主播跳舞的持续时间，单位秒（-1为永久）默认30秒
/// @param isTop false-不置顶；true-置顶
/// @param field1 playerId（主播玩家的id）；该参数必传，不传则没有任何效果
- (void)danceWithAnchor:(int)cooldown isTop:(BOOL)isTop field1:(NSString *)field1;

/// 上DJ台
/// @param cooldown 上DJ台的持续时间，单位秒（-1为永久）默认180秒
- (void)upToDJ:(int)cooldown;

#pragma mark restful api

/// 拉取机器人
/// @param finished finished
/// @param failure failure
+ (void)reqRobotListWithFinished:(void (^)(NSArray<RotbotInfoModel *> *robotList))finished failure:(void (^)(NSError *error))failure;

/// 上下主播位
/// @param up 上下
/// @param roomId roomId
/// @param userId userId
/// @param finished finished
/// @param failure failure
+ (void)reqUpDownAnchor:(BOOL)up roomId:(int64_t)roomId userId:(NSString *)userId success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

/// 扣费
/// @param coin 扣金币
/// @param finished finished
/// @param failure failure
+ (void)reqPayCoin:(NSInteger)coin success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

/// 拉取主播列表
/// @param roomId roomId
/// @param finished finished
/// @param failure failure
+ (void)reqAnchorList:(int64_t)roomId success:(void (^)(NSArray<AnchorUserInfoModel *> *robotList))success failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
