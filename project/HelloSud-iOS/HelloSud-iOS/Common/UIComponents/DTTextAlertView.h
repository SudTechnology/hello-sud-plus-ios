//
//  DTTextAlertView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 文本弹窗
@interface DTTextAlertView : BaseView
typedef NS_ENUM(NSInteger, AlertType)
{
    HSTypeOnlySure,
    HSTypeAll,
};

/// item回调
typedef void(^OnCLickItemCallBack)(void);
@property (nonatomic, copy) OnCLickItemCallBack onCancelItemlCallBack;
@property (nonatomic, copy) OnCLickItemCallBack onSureItemCallBack;

/// 按钮类型
@property (nonatomic, assign) AlertType alertType;
/// 是否点击item 自动关闭弹窗
@property (nonatomic, assign) BOOL isClickClose;

/// 文本alert初始化
/// @param msg content
/// @param sureText 确定按钮文字
/// @param cancelText 取消按钮文字 传空则没有取消按钮
/// @param isClickClose 点击背景是否关闭
/// @param sureCb 确定item回调
/// @param closeCb 取消item回调
- (void)config:(NSString *)msg sureText:(NSString *)sureText cancelText:(NSString *)cancelText isClickClose:(BOOL)isClickClose onSureCallback:(void(^)(void))sureCb onCloseCallback:(void(^)(void))closeCb;

/// 文本alert初始化
/// @param msg content
/// @param sureText 确定按钮文字
/// @param cancelText 取消按钮文字 传空则没有取消按钮
/// @param isClickClose 点击背景是否关闭
/// @param sureCb 确定item回调
/// @param closeCb 取消item回调
- (void)configAttr:(NSAttributedString *)msg sureText:(NSString *)sureText cancelText:(NSString *)cancelText isClickClose:(BOOL)isClickClose onSureCallback:(void(^)(void))sureCb onCloseCallback:(void(^)(void))closeCb;
@end

NS_ASSUME_NONNULL_END
