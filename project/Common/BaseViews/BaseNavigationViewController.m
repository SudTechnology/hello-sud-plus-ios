//
//  BaseNavigationViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/20.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
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
    NSDictionary * dicTitle = @{NSForegroundColorAttributeName: UIColor.blackColor,NSFontAttributeName: [UIFont systemFontOfSize:17 weight:UIFontWeightMedium]};
    navBar.titleTextAttributes = dicTitle;
    
    NSDictionary *dicBarBtn = @{NSForegroundColorAttributeName: UIColor.blackColor, NSFontAttributeName: [UIFont systemFontOfSize:17]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:dicBarBtn forState:UIControlStateNormal];
    self.navigationBar.tintColor = UIColor.blackColor;
    navBar.backgroundColor = UIColor.whiteColor;
    navBar.barTintColor = UIColor.whiteColor;
    navBar.shadowImage = [UIImage new];
    navBar.translucent = NO;
    [self.navigationBar setBackgroundImage:UIImage.new forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = UIImage.new;
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *navAppearance = UINavigationBarAppearance.new;
        [navAppearance configureWithOpaqueBackground];
        navAppearance.backgroundColor = UIColor.whiteColor;
        navAppearance.shadowColor = nil;
        navAppearance.shadowImage = UIImage.new;
        navAppearance.backgroundEffect = nil;
        navAppearance.titleTextAttributes = dicTitle;
        UINavigationBar *bar = [UINavigationBar appearance];
        bar.standardAppearance = navAppearance;
        bar.scrollEdgeAppearance = bar.standardAppearance;
    }
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController != self.viewControllers[0] && [viewController isKindOfClass:[BaseViewController class]]) {
        self.interactivePopGestureRecognizer.delegate = (BaseViewController *)viewController;
    } else {
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}
@end
