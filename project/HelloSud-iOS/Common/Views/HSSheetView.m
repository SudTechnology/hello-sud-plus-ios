//
//  HSSheetView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/19.
//

#import "HSSheetView.h"


typedef void(^EMPTY_BLOCK)(void);

@interface HSSheetView()

@property(nonatomic, copy) EMPTY_BLOCK closeCallback;
/// 内容视图
@property(nonatomic, strong)UIView * contentView;
@end

@implementation HSSheetView

static HSSheetView *g_alertView = nil;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)]) {
        [self configDefault];
    }
    return self;
}


/// 默认配置
- (void)configDefault {
    self.contentView = [UIView new];
    self.isRadius = YES;
    self.isKeyboardEnable = NO;
    self.isHitTest = YES;
    self.isSupportPanClose = YES;
}

/// 展示半屏视图内部会持有强引用当前实例，直到close
/// @param rootView 根视图
/// @param customView 用户自定义视图
/// @param cb 关闭回调
- (void)showIn:(UIView *)rootView customView:(UIView *)customView onCloseCallback:(void(^)(void))cb {
    UIView *superView = rootView;
    if (rootView == nil) {
        superView = AppUtil.currentWindow;
    }
    if (g_alertView != nil && g_alertView.closeCallback != nil) {
        g_alertView.closeCallback();
    }
    g_alertView = self;
    [superView addSubview:self];
    [self.contentView addSubview:customView];
}

/// 关闭
- (void)close {
    
}
@end
