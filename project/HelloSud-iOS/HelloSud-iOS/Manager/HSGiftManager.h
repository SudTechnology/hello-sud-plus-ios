//
//  HSGiftManager.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "BaseView.h"
#import "HSGiftModel.h"
NS_ASSUME_NONNULL_BEGIN

/// 礼物管理
@interface HSGiftManager : BaseView

/// 礼物列表
@property(nonatomic, strong, readonly)NSArray<HSGiftModel*> *giftList;

+ (instancetype)shared;

/// 获取礼物信息
/// @param giftID 礼物ID
- (nullable HSGiftModel *)giftByID:(NSInteger)giftID;
@end

NS_ASSUME_NONNULL_END
