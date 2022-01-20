//
//  BaseNavigationViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/20.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController()
@property(nonatomic, weak)id<UIGestureRecognizerDelegate> popDelegate;
@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavbar];
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
}


/// 配置导航栏
- (void)configNavbar {
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.blackColor};
}

@end
