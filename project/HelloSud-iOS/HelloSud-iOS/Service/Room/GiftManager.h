//
//  GiftManager.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "BaseView.h"
#import "GiftModel.h"
NS_ASSUME_NONNULL_BEGIN

/// 礼物管理
@interface GiftManager : BaseView

/// 礼物列表
@property(nonatomic, strong, readonly)NSArray<GiftModel*> *giftList;

+ (instancetype)shared;

/// 从磁盘加载礼物
- (void)loadFromDisk;

/// 获取礼物信息
/// @param giftID 礼物ID
- (nullable GiftModel *)giftByID:(NSInteger)giftID;
@end

NS_ASSUME_NONNULL_END
