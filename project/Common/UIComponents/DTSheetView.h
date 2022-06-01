//
//  DTSheetView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/19.
//

#import "BaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

/// 半屏弹出sheet视图
@interface DTSheetView : BaseAlertView
typedef NS_ENUM(NSInteger, DTAlertType)
{
    DTAlertTypeBottom,
    DTAlertTypeTop,
};

/// 展示底部弹窗 - （内容自定义）
/// - Parameters:
///   - view: 展示的view
///   - onView: 当前的父视图
///   - isHitTest: 是否可点击 -- 默认不可点击
///   - onCloseCallBack: 关闭弹窗回调
+ (void)show:(UIView *)view rootView:(UIView *)rootView hiddenBackCover:(BOOL)hiddenBackCover onCloseCallback:(void (^)(void))cb;

/// 展示底部弹窗 - （内容自定义）
/// - Parameters:
///   - view: 展示的view
///   - onCloseCallBack: 关闭弹窗回调
+ (void)show:(UIView *)view onCloseCallback:(void (^)(void))cb;

/// 展示底部弹窗 - （内容自定义）
/// - Parameters:
///   - view: 展示的view
///   - onCloseCallBack: 关闭弹窗回调
+ (void)showTop:(UIView *)view cornerRadius:(NSInteger)cornerRadius onCloseCallback:(void (^)(void))cb;

/// 关闭弹窗
+ (void)close;
@end

NS_ASSUME_NONNULL_END
