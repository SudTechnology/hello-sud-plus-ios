//
//  DTSheetView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/19.
//

#import "DTSheetView.h"

@interface DTSheetView ()
/// 是否响应hitTest
@property(nonatomic, assign) BOOL isHitTest;
/// 是否响应hitTest
@property(nonatomic, assign) DTAlertType alertType;
@property(nonatomic, assign) CGFloat beginPanY;
@property(nonatomic, assign) CGFloat moveH;
@end

@implementation DTSheetView

- (void)dtConfigUI {
    self.isHitTest = true;
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
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_greaterThanOrEqualTo(0);
        if (self.alertType == DTAlertTypeTop) {
            make.top.mas_equalTo(self);
        } else {
            make.bottom.mas_equalTo(self);
        }
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
            UIView *testNextView = [super hitTest:point withEvent:event];
            if ([testNextView isKindOfClass:BaseView.class]) {
                if (((BaseView *)testNextView).dtNeedAcceptEvent) {
                    return testNextView;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hs_close];
            });
            return self;
        }
    }
    return [super hitTest:point withEvent:event];
}

/// 添加滑动手势
- (void)addPanGes {
    UIView *pandView = self.contentView;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanView:)];
    pan.delegate = self;
    pan.delaysTouchesBegan = YES;
    [pandView addGestureRecognizer:pan];
}

- (void)onPanView:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self.contentView.superview];
    CGPoint trans = [pan translationInView:self.contentView.superview];
    CGFloat moveH = point.y - self.beginPanY;
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.beginPanY = point.y;
            break;
        case UIGestureRecognizerStateChanged:
            if (moveH >= 0) {
                self.moveH = moveH;
                CGAffineTransform transY = CGAffineTransformMakeTranslation(0, moveH);
                self.contentView.transform = transY;
            }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (moveH >= 0) {
                self.moveH = moveH;
                CGAffineTransform transY = CGAffineTransformMakeTranslation(0, moveH);
                self.contentView.transform = transY;
            } else {
                [UIView animateWithDuration:0.25 animations:^{
                    self.contentView.transform = CGAffineTransformIdentity;
                }];
            }
            if (moveH > 0) {
                [DTSheetView close];
            }
            break;
    }
}

/// 展示底部弹窗 - （内容自定义）
/// - Parameters:
///   - view: 展示的view
///   - onView: 当前的父视图
///   - isHitTest: 是否可点击 -- 默认不可点击
///   - onCloseCallBack: 关闭弹窗回调
+ (void)show:(UIView *)view rootView:(UIView *)rootView hiddenBackCover:(BOOL)hiddenBackCover onCloseCallback:(void (^)(void))cb {
    [self showNode:view rootView:nil hiddenBackCover:hiddenBackCover alertType:DTAlertTypeBottom cornerRadius:12 onCloseCallback:cb];
}

/// 展示底部弹窗 - （内容自定义）
/// - Parameters:
///   - view: 展示的view
///   - onView: 当前的父视图
///   - isHitTest: 是否可点击 -- 默认不可点击
///   - cornerRadius: 切角
///   - onCloseCallBack: 关闭弹窗回调
+ (void)show:(UIView *)view rootView:(UIView *)rootView hiddenBackCover:(BOOL)hiddenBackCover cornerRadius:(CGFloat)cornerRadius onCloseCallback:(void (^)(void))cb {
    [self showNode:view rootView:nil hiddenBackCover:hiddenBackCover alertType:DTAlertTypeBottom cornerRadius:cornerRadius onCloseCallback:cb];
}

/// 展示底部弹窗 - （内容自定义）
/// - Parameters:
///   - view: 展示的view
///   - onCloseCallBack: 关闭弹窗回调
+ (void)show:(UIView *)view onCloseCallback:(void (^)(void))cb {
    [self showNode:view rootView:nil hiddenBackCover:false alertType:DTAlertTypeBottom cornerRadius:0 onCloseCallback:cb];
}

/// 展示顶部弹窗 - （内容自定义）
/// - Parameters:
///   - view: 展示的view
///   - onCloseCallBack: 关闭弹窗回调
+ (void)showTop:(UIView *)view cornerRadius:(NSInteger)cornerRadius onCloseCallback:(void (^)(void))cb {
    [self showNode:view rootView:nil hiddenBackCover:false alertType:DTAlertTypeTop cornerRadius:cornerRadius onCloseCallback:cb];
}

+ (void)showNode:(UIView *)view
        rootView:(UIView *)rootView
 hiddenBackCover:(BOOL)hiddenBackCover
       alertType:(DTAlertType)alertType
    cornerRadius:(NSInteger)cornerRadius
 onCloseCallback:(void (^)(void))cb {
    UIView *superView = rootView;
    if (rootView == nil) {
        superView = AppUtil.currentWindow;
    }

    /// 如果存在移除当前展示弹窗
    if ([self getAlert] != nil && [NSStringFromClass(self) isEqualToString:@"DTSheetView"]) {
        [[self getAlert] removeFromSuperview];
    }

    DTSheetView *alert = [[DTSheetView alloc] init];
    alert.contentView.backgroundColor = UIColor.clearColor;
    alert.alertType = alertType;
    alert.isHitTest = true;
    alert.customView = view;
    alert.contentView.layer.cornerRadius = cornerRadius;
    alert.contentView.layer.masksToBounds = true;
    alert.onCloseViewCallBack = cb;
    alert.hiddeBackCover = hiddenBackCover;
    if (hiddenBackCover) {
        alert.backView.alpha = 0;
    }
    [alert setupUI];
    [superView addSubview:alert];
    [self setAlert:alert];
    [[self getAlert] hs_show];

}

/// 关闭弹窗
+ (void)close {
    [[self getAlert] hs_close];
}

/// 增加下滑手势
+ (void)addPanGesture {
    [(DTSheetView *)[self getAlert] addPanGes];
}
@end
