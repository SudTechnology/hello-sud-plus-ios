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
    
    GameListViewController *gameList = [[GameListViewController alloc]init];
    BaseNavigationViewController * navGameList = [[BaseNavigationViewController alloc]initWithRootViewController:gameList];
    gameList.tabBarItem.title = NSString.dt_tab_room;
    gameList.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_icon_room"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    gameList.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_room"];
    
    HSSettingViewController *setting = [[HSSettingViewController alloc]init];
    setting.tabBarItem.title = NSString.dt_tab_setting;
    setting.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_setting"];
    setting.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_icon_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    BaseNavigationViewController * navSetting = [[BaseNavigationViewController alloc]initWithRootViewController:setting];
    
    
    [self addChildViewController:navHome];
    [self addChildViewController:navGameList];
    [self addChildViewController:navSetting];
}
@end
