//
//  HSRoomOperatorView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
/// 房间底部操作
@interface HSRoomOperatorView : BaseView

/// 礼物点击
@property(nonatomic, copy)UIBUTTON_TAP_BLOCK giftTapBlock;
/// 礼物点击
@property(nonatomic, copy)UIVIEW_TAP_BLOCK inputTapBlock;
@end

NS_ASSUME_NONNULL_END
