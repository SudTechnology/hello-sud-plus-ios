//
//  HSMainTabBarController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/20.
//

#import "HSMainTabBarController.h"
#import "HSGameListViewController.h"
#import "HSSettingViewController.h"
#import "HSHomeViewController.h"

@interface HSMainTabBarController ()

@end

@implementation HSMainTabBarController

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
    
    HSHomeViewController *home = [[HSHomeViewController alloc]init];
    BaseNavigationViewController * navHome = [[BaseNavigationViewController alloc]initWithRootViewController:home];
    home.tabBarItem.title = @"主页";
    home.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_icon_game_list"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    home.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_game_list"];
    
    HSGameListViewController *gameList = [[HSGameListViewController alloc]init];
    BaseNavigationViewController * navGameList = [[BaseNavigationViewController alloc]initWithRootViewController:gameList];
    gameList.tabBarItem.title = @"房间";
    gameList.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_icon_room"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    gameList.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_room"];
    
    HSSettingViewController *setting = [[HSSettingViewController alloc]init];
    setting.tabBarItem.title = @"设置";
    setting.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_setting"];
    setting.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_icon_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    BaseNavigationViewController * navSetting = [[BaseNavigationViewController alloc]initWithRootViewController:setting];
    
    
    [self addChildViewController:navHome];
    [self addChildViewController:navGameList];
    [self addChildViewController:navSetting];
}
@end
