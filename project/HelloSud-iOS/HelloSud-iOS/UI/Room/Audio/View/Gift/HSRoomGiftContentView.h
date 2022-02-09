//
//  HSRoomGiftContentView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^GIFT_SELECTED_BLCOK)(HSGiftModel *giftModel);

@interface HSRoomGiftContentView : BaseView
/// 选中礼物回调
@property(nonatomic, copy)GIFT_SELECTED_BLCOK didSelectedCallback;
@property (nonatomic, strong) HSGiftModel *didSelectedGift;
@end

NS_ASSUME_NONNULL_END
