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
/// 接受者
@property(nonatomic, strong)AudioUserModel *toUser;
/// 礼物ID
@property(nonatomic, assign)NSInteger giftID;
/// 礼物数量
@property(nonatomic, assign)NSInteger giftCount;
/// 礼物类型 0为APP内置礼物 1为APP服务端礼物
@property (nonatomic, assign)NSInteger type;
/// 礼物图片
@property (nonatomic, strong)NSString *giftUrl;
/// 礼物动效图
@property (nonatomic, strong)NSString *animationUrl;
/// 礼物名称
@property (nonatomic, strong)NSString *giftName;

/// 特写时间
@property (nonatomic, assign)NSInteger specialDuration;

/// 构建消息
/// @param giftID giftID description
/// @param giftCount giftCount description
/// @param toUser toUser description
+ (instancetype)makeMsgWithGiftID:(NSInteger)giftID giftCount:(NSInteger)giftCount toUser:(AudioUserModel *)toUser;
- (NSAttributedString *)attrContent;
/// 获取礼物model
- (GiftModel *)getGiftModel;
@end

NS_ASSUME_NONNULL_END
