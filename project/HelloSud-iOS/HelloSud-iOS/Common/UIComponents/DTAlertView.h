//
//  DTAlertView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DTAlertView : BaseAlertView

/// 展示中心弹窗 - （内容自定义）
/// - Parameters:
///   - view: 展示的view
///   - onView: 当前的父视图
///   - isHitTest: 是否可点击 -- 默认不可点击
///   - onCloseCallBack: 关闭弹窗回调
+ (void)show:(UIView *)view rootView:(UIView *)rootView isHitTest:(BOOL)isHitTest onCloseCallback:(void(^)(void))cb;

/// 展示中心弹窗 - （文本 + 确定 + 取消）
/// @param msg 文本
/// @param sureText 确定Item文本
/// @param cancelText 取消Item文本
/// @param sureCb sure回调
/// @param closeCb close回调
+ (void)showTextAlert:(NSString *)msg sureText:(NSString *)sureText cancelText:(NSString *)cancelText onSureCallback:(void(^)(void))sureCb onCloseCallback:(void(^)(void))closeCb;

/// 展示中心弹窗 - （文本 + 确定 + 取消）
/// @param attrMsg 富文本
/// @param sureText 确定Item文本
/// @param cancelText 取消Item文本
/// @param rootView rootView
/// @param sureCb sure回调
/// @param closeCb close回调
+ (void)showAttrTextAlert:(NSAttributedString *)attrMsg sureText:(NSString *)sureText cancelText:(NSString *)cancelText rootView:(UIView *)rootView onSureCallback:(void(^)(void))sureCb onCloseCallback:(void(^)(void))closeCb;

/// 关闭弹窗
+ (void)close;
@end

NS_ASSUME_NONNULL_END
