//
//  HSAlertView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSAlertView : BaseAlertView

/// 展示中心弹窗 - （内容自定义）
/// - Parameters:
///   - view: 展示的view
///   - onView: 当前的父视图
///   - isHitTest: 是否可点击 -- 默认不可点击
///   - onCloseCallBack: 关闭弹窗回调
+ (void)show:(UIView *)view rootView:(UIView *)rootView isHitTest:(BOOL)isHitTest onCloseCallback:(void(^)(void))cb;
@end

NS_ASSUME_NONNULL_END
