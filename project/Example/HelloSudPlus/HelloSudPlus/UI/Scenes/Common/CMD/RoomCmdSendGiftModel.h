//
//  RoomCmdSendGiftModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "RoomBaseCMDModel.h"

@class GiftModel;
NS_ASSUME_NONNULL_BEGIN

/// 礼物消息model
@interface RoomCmdSendGiftModel : RoomBaseCMDModel

@property(nonatomic, strong) NSArray<AudioUserModel *> *toUserList;
/// 礼物ID
@property(nonatomic, assign) NSInteger giftID;
/// 礼物数量
@property(nonatomic, assign) NSInteger giftCount;
/// 礼物类型 0为APP内置礼物 1为APP服务端礼物
@property(nonatomic, assign) NSInteger type;
/// 礼物图片
@property(nonatomic, strong) NSString *giftUrl;
/// 礼物动效图
@property(nonatomic, strong) NSString *animationUrl;
/// 礼物名称
@property(nonatomic, strong) NSString *giftName;
/// 礼物扩展数据
@property(nonatomic, strong) NSString *extData;

/// 特写时间
@property(nonatomic, assign) NSInteger specialDuration;
/// 是否跳过费用支付
@property(nonatomic, assign) BOOL skillFee;
/// 是否全麦
@property(nonatomic, assign) BOOL isAllSeat;

/// 构建消息
/// @param giftID giftID description
/// @param giftCount giftCount description
/// @param toUser toUser description
+ (instancetype)makeMsgWithGiftID:(NSInteger)giftID giftCount:(NSInteger)giftCount toUser:(AudioUserModel *)toUser;

/// 构建消息
/// @param giftID giftID description
/// @param giftCount giftCount description
/// @param toUserList toUserList description
+ (instancetype)makeMsgWithGiftID:(NSInteger)giftID giftCount:(NSInteger)giftCount toUserList:(NSArray<AudioUserModel *> *)toUserList;

- (NSAttributedString *)attrContent;

/// 获取礼物model
- (GiftModel *)getGiftModel;

/// 设置展示接收方这是支持多个人的礼物消息
- (void)setShowToUser:(AudioUserModel *)toUser;

- (AudioUserModel *)toUser;

// 根据用户列表产生展示的礼物消息
- (NSArray<RoomCmdSendGiftModel *> *)getShowGiftMsgModelListByUserList;
@end

NS_ASSUME_NONNULL_END
