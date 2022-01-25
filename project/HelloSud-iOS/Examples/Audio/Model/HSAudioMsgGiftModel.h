//
//  HSAudioMsgGiftModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "HSAudioMsgBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 礼物消息model
@interface HSAudioMsgGiftModel : HSAudioMsgBaseModel
/// 接受者
@property(nonatomic, assign)HSAudioUserModel *toUser;
/// 礼物ID
@property(nonatomic, assign)NSInteger giftID;
/// 礼物数量
@property(nonatomic, assign)NSInteger giftCount;

/// 构建消息
/// @param giftID giftID description
/// @param giftCount giftCount description
/// @param toUser toUser description
+ (instancetype)makeMsgWithGiftID:(NSInteger)giftID giftCount:(NSInteger)giftCount toUser:(HSAudioUserModel *)toUser;
- (NSAttributedString *)attrContent;
@end

NS_ASSUME_NONNULL_END
