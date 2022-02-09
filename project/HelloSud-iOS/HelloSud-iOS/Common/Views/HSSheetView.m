//
//  HSSheetView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/19.
//

#import "HSSheetView.h"

@interface HSSheetView()
/// 是否响应hitTest
@property(nonatomic, assign) BOOL isHitTest;
@end

@implementation HSSheetView

- (void)hsConfigUI {
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
        make.left.bottom.right.mas_equalTo(self);
        make.height.mas_greaterThanOrEqualTo(0);
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
///   - isHitTest: 是否可点击 -- 默认不可点击
///   - onCloseCallBack: 关闭弹窗回调
+ (void)show:(UIView *)view rootView:(UIView *)rootView onCloseCallback:(void(^)(void))cb {
    UIView *superView = rootView;
    if (rootView == nil) {
        superView = AppUtil.currentWindow;
    }
    
    /// 如果存在移除当前展示弹窗
    if ([self getAlert] != nil && [NSStringFromClass(self) isEqualToString:@"HSSheetView"]) {
        [[self getAlert] removeFromSuperview];
    }
    
    HSSheetView *alert = [[HSSheetView alloc] init];
    alert.contentView.backgroundColor = UIColor.clearColor;// [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    alert.isHitTest = true;
    alert.customView = view;
    alert.contentView.layer.cornerRadius = 12;
    alert.contentView.layer.masksToBounds = true;
    alert.onCloseViewCallBack = cb;
    [alert setupUI];
    [superView addSubview:alert];
    [self setAlert:alert];
    [[self getAlert] hs_show];
}

/// 关闭弹窗
+ (void)close {
    [[self getAlert] hs_close];
}
@end
