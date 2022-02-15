//
//  GiftModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^HSGiftModelSelectedBlock)(void);

/// 礼物model
@interface GiftModel : BaseModel

/// 礼物图片地址
@property(nonatomic, copy)NSString *giftURL;
/// 礼物小图图片地址
@property(nonatomic, copy)NSString *smallGiftURL;
/// 礼物名称
@property(nonatomic, copy)NSString *giftName;
/// 礼物动效地址
@property(nonatomic, copy)NSString *animateURL;
/// 礼物动效类型
@property(nonatomic, copy)NSString *animateType;
/// 礼物ID
@property(nonatomic, assign)NSInteger giftID;


@property(nonatomic, assign)BOOL isSelected;
@property(nonatomic, copy)HSGiftModelSelectedBlock selectedChangedCallback;
@end

NS_ASSUME_NONNULL_END
