//
//  RoomCmdSendGiftModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "RoomBaseCMDModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 礼物消息model
@interface RoomCmdSendGiftModel : RoomBaseCMDModel
/// 接受者
@property(nonatomic, strong)AudioUserModel *toUser;
/// 礼物ID
@property(nonatomic, assign)NSInteger giftID;
/// 礼物数量
@property(nonatomic, assign)NSInteger giftCount;

/// 构建消息
/// @param giftID giftID description
/// @param giftCount giftCount description
/// @param toUser toUser description
+ (instancetype)makeMsgWithGiftID:(NSInteger)giftID giftCount:(NSInteger)giftCount toUser:(AudioUserModel *)toUser;
- (NSAttributedString *)attrContent;
@end

NS_ASSUME_NONNULL_END
