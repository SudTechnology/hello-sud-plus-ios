//
//  HSAlertView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSAlertView.h"
#import "HSTextAlertView.h"

@interface HSAlertView ()
@property(nonatomic, assign) CGFloat hsWidth;
@property(nonatomic, assign) BOOL isHitTest;

@end

@implementation HSAlertView

- (void)hsConfigUI {
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
                [self close];
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
///   - isHitTest: 是否可点击 -- 默认不可点击
///   - onCloseCallBack: 关闭弹窗回调
+ (void)show:(UIView *)view rootView:(UIView *)rootView isHitTest:(BOOL)isHitTest onCloseCallback:(void(^)(void))cb {
    UIView *superView = rootView;
    if (rootView == nil) {
        superView = AppUtil.currentWindow;
    }
    
    /// 如果存在移除当前展示弹窗
    if (h_alertView != nil && [NSStringFromClass(self) isEqualToString:@"HSAlertView"]) {
        [h_alertView removeFromSuperview];
    }
    
    HSAlertView *alert = [[HSAlertView alloc] init];
    alert.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2" alpha:0.9];
    alert.isHitTest = isHitTest;
    alert.customView = view;
    alert.layer.cornerRadius = 8;
    alert.layer.masksToBounds = true;
    alert.onCloseViewCallBack = cb;
    [alert setupUI];
    [superView addSubview:alert];
    h_alertView = alert;
    [h_alertView show];
}

+ (void)showTextAlert:(NSString *)msg sureText:(NSString *)sureText cancelText:(NSString *)cancelText onCloseCallback:(void(^)(void))cb {
    HSAlertView *alert = [[HSAlertView alloc] init];
    
}

@end
