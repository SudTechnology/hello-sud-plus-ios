//
//  BaseViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "BaseViewController.h"

@interface BaseViewController ()
/// 是否隐藏导航栏
@property(nonatomic, assign)BOOL hiddenNavigationBar;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStylePlain target:self action:@selector(dtNavigationBackClick)];
    [self dtAddViews];
    [self dtLayoutViews];
    [self dtConfigEvents];
    [self dtConfigUI];
    [self dtUpdateUI];
    self.hiddenNavigationBar = [self dtIsHidenNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hiddenNavigationBar = [self dtIsHidenNavigationBar];
}

- (void)setHiddenNavigationBar:(BOOL)hiddenNavigationBar {
    _hiddenNavigationBar = hiddenNavigationBar;
    [self.navigationController setNavigationBarHidden:hiddenNavigationBar animated:YES];
}

/// 是否隐藏导航栏,子类覆盖返回是否需要隐藏导航栏，默认不隐藏
- (BOOL)dtIsHidenNavigationBar {
    return NO;
}

/// 导航栏点击返回，子类实现是否处理格外逻辑
- (void)dtNavigationBackClick {
    [self.navigationController popViewControllerAnimated:YES];
}

/// 增加子view
- (void)dtAddViews {
    
}

/// 布局视图
- (void)dtLayoutViews {
    
}

/// 配置事件
- (void)dtConfigEvents {
    
}

/// 试图初始化
- (void)dtConfigUI {
    
}

/// 更新UI
- (void)dtUpdateUI {
    
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
