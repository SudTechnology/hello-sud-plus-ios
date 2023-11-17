//
//  GiftItemCollectionViewCell.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface GiftItemCollectionViewCell : BaseCollectionViewCell
/// 点击详情
@property(nonatomic, strong)void(^moreGiftDetailClickBlock)(BaseModel *giftModel);
@end

NS_ASSUME_NONNULL_END
