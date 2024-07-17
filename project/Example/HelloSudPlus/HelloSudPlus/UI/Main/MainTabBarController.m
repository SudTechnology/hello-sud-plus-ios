//
//  MainTabBarController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/20.
//

#import "MainTabBarController.h"
#import "GameListViewController.h"
#import "HSSettingViewController.h"
#import "HomeViewController.h"
#import "MyViewController.h"
#import "GameTabViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.tabBar.backgroundColor = UIColor.whiteColor;
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:HEX_COLOR(@"#8C8C8C")} forState: UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:HEX_COLOR(@"#000000")} forState: UIControlStateSelected];
    self.tabBar.tintColor = HEX_COLOR(@"#000000");
    [self configMainPage];
}

- (void)configMainPage {
    // Do any additional setup after loading the view.
    
    HomeViewController *home = [[HomeViewController alloc]init];
    BaseNavigationViewController * navHome = [[BaseNavigationViewController alloc]initWithRootViewController:home];
    home.tabBarItem.title = NSString.dt_tab_home;
    home.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_icon_game_list"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    home.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_game_list"];
    
    GameTabViewController *game = [[GameTabViewController alloc]init];
    BaseNavigationViewController * navGame = [[BaseNavigationViewController alloc]initWithRootViewController:game];
    game.tabBarItem.title = @"dt_tab_game".dt_lan;
    game.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_icon_game"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    game.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_game"];
    
    GameListViewController *gameList = [[GameListViewController alloc]init];
    BaseNavigationViewController * navGameList = [[BaseNavigationViewController alloc]initWithRootViewController:gameList];
    gameList.tabBarItem.title = NSString.dt_tab_room;
    gameList.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_icon_room"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    gameList.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_room"];

    MyViewController *setting = [[MyViewController alloc]init];
    BaseNavigationViewController * navSetting = [[BaseNavigationViewController alloc]initWithRootViewController:setting];
    setting.tabBarItem.title = NSString.dt_tab_my;
    setting.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_my"];
    setting.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_icon_my"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    [self addChildViewController:navGame];
    [self addChildViewController:navHome];
    [self addChildViewController:navGameList];
    [self addChildViewController:navSetting];
    
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *visibleViewController = self.presentedViewController;
    if (!visibleViewController || visibleViewController.isBeingDismissed || [visibleViewController isKindOfClass:UIAlertController.class]) {
        visibleViewController = self.selectedViewController;
    }
    if ([visibleViewController isKindOfClass:NSClassFromString(@"AVFullScreenViewController")]) {
        return visibleViewController.supportedInterfaceOrientations;
    }

    return [visibleViewController supportedInterfaceOrientations];
}
@end
