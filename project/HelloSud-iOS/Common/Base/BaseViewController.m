//
//  BaseViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hsAddViews];
    [self hsLayoutViews];
    [self hsConfigEvents];
    [self hsConfigUI];
    [self hsUpdateUI];
}

/// 增加子view
- (void)hsAddViews {
    
}

/// 布局视图
- (void)hsLayoutViews {
    
}

/// 配置事件
- (void)hsConfigEvents {
    
}

/// 试图初始化
- (void)hsConfigUI {
    
}

/// 更新UI
- (void)hsUpdateUI {
    
}

- (BOOL)hsShouldBackGesture {
    return YES;
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return [self hsShouldBackGesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
@end
