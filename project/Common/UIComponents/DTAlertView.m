//
//  DTAlertView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "DTAlertView.h"
#import "DTTextAlertView.h"

@interface DTAlertView ()
@property(nonatomic, assign) CGFloat hsWidth;
@property(nonatomic, assign) BOOL isHitTest;

@end

@implementation DTAlertView

- (void)dtConfigUI {
    self.hsWidth = 296;
    self.isHitTest = false;
}

- (void)setupUI {
    [self addSubview:self.backView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.customView];
    [self aLayoutViews];
}

- (void)aLayoutViews {
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_hsWidth);
        make.height.mas_greaterThanOrEqualTo(0);
        make.center.mas_equalTo(self);
    }];
    [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHitTest) {
        UIView *v = self.contentView;
        CGRect frame = [v convertRect:v.bounds toView:self];
        BOOL contains = CGRectContainsPoint(frame, point);
        if (!contains) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hs_close];
            });
            return self;
        }
    }
    return [super hitTest:point withEvent:event];
}

/// 展示中心弹窗 - （内容自定义）
/// - Parameters:
///   - view: 展示的view
///   - onView: 当前的父视图
///   - clickToClose: 是否可点击背景层关闭 -- 默认不可点击
///   - onCloseCallBack: 关闭弹窗回调
+ (DTAlertView *)show:(UIView *)view rootView:(UIView *)rootView clickToClose:(BOOL)clickToClose showDefaultBackground:(BOOL)showDefaultBackground onCloseCallback:(void (^)(void))cb {
    UIView *superView = rootView;
    if (rootView == nil) {
        superView = AppUtil.currentWindow;
    }

    /// 如果存在移除当前展示弹窗
    if ([self getAlert] != nil && [NSStringFromClass(self) isEqualToString:@"DTAlertView"]) {
        [[self getAlert] removeFromSuperview];
    }

    DTAlertView *alert = [[DTAlertView alloc] init];
    if (showDefaultBackground) {
        alert.contentView.backgroundColor = [UIColor dt_colorWithHexString:@"#F2F2F2" alpha:1];
    }
    alert.isHitTest = clickToClose;
    alert.customView = view;
    alert.contentView.layer.cornerRadius = 8;
    alert.contentView.layer.masksToBounds = true;
    alert.onCloseViewCallBack = cb;
    [alert setupUI];
    [superView addSubview:alert];
    [self setAlert:alert];
    [[self getAlert] hs_show];
    return [self getAlert];
}

/// 展示中心弹窗 - （文本 + 确定 + 取消）
/// @param msg 文本
/// @param sureText 确定Item文本
/// @param cancelText 取消Item文本
/// @param sureCb sure回调
/// @param closeCb close回调
+ (DTAlertView *)showTextAlert:(NSString *)msg sureText:(NSString *)sureText cancelText:(nullable NSString *)cancelText onSureCallback:(void(^)(void))sureCb onCloseCallback:(nullable void(^)(void))closeCb {
    DTTextAlertView *alert = [[DTTextAlertView alloc] init];
    [alert config:msg sureText:sureText cancelText:cancelText isClickClose:false onSureCallback:sureCb onCloseCallback:closeCb];
    [DTAlertView show:alert rootView:AppUtil.currentWindow clickToClose:false showDefaultBackground:YES onCloseCallback:^{
//        closeCb();
    }];
    return [self getAlert];
}

/// 展示中心弹窗 - （文本 + 确定 + 取消）
/// @param msg 文本
/// @param sureText 确定Item文本
/// @param cancelText 取消Item文本
/// @param disableAutoClose 是否禁止自动关闭 YES禁止自动关闭，需要手动调close
/// @param sureCb sure回调
/// @param closeCb close回调
+ (DTAlertView *)showTextAlert:(NSString *)msg sureText:(NSString *)sureText cancelText:(nullable NSString *)cancelText disableAutoClose:(BOOL)disableAutoClose onSureCallback:(void(^)(void))sureCb onCloseCallback:(nullable void(^)(void))closeCb {
    DTTextAlertView *alert = [[DTTextAlertView alloc] init];
    alert.disableAutoCloseWhenClick = disableAutoClose;
    [alert config:msg sureText:sureText cancelText:cancelText isClickClose:false onSureCallback:sureCb onCloseCallback:closeCb];
    [DTAlertView show:alert rootView:AppUtil.currentWindow clickToClose:false showDefaultBackground:YES onCloseCallback:^{
//        closeCb();
    }];
    return [self getAlert];
}

/// 展示中心弹窗 - （文本 + 确定 + 取消）
/// @param attrMsg 富文本
/// @param sureText 确定Item文本
/// @param cancelText 取消Item文本
/// @param rootView rootView
/// @param sureCb sure回调
/// @param closeCb close回调
+ (DTAlertView *)showAttrTextAlert:(NSAttributedString *)attrMsg sureText:(NSString *)sureText cancelText:(NSString *)cancelText rootView:(UIView *)rootView onSureCallback:(void(^)(void))sureCb onCloseCallback:(void(^)(void))closeCb {
    DTTextAlertView *alert = [[DTTextAlertView alloc] init];
    [alert configAttr:attrMsg sureText:sureText cancelText:cancelText isClickClose:false onSureCallback:sureCb onCloseCallback:closeCb];
    [DTAlertView show:alert rootView:rootView == nil ? AppUtil.currentWindow : rootView clickToClose:false showDefaultBackground:YES onCloseCallback:^{
//        closeCb();
    }];
    return [self getAlert];
}

/// 关闭弹窗
+ (void)close {
    [[self getAlert] hs_close];
}

@end
