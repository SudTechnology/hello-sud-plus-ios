//
//  HSMainTabBarController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/20.
//

#import "HSMainTabBarController.h"
#import "HSGameListViewController.h"
#import "HSSettingViewController.h"

@interface HSMainTabBarController ()

@end

@implementation HSMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.tabBar.backgroundColor = UIColor.whiteColor;
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:HEX_COLOR(@"#8C8C8C")} forState: UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:HEX_COLOR(@"#000000")} forState: UIControlStateSelected];
    [self configMainPage];
}

- (void)configMainPage {
    // Do any additional setup after loading the view.
    HSGameListViewController *gameList = [[HSGameListViewController alloc]init];
    BaseNavigationViewController * navGameList = [[BaseNavigationViewController alloc]initWithRootViewController:gameList];
    gameList.tabBarItem.title = @"主页";
    gameList.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_icon_game_list"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    gameList.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_game_list"];
    HSSettingViewController *setting = [[HSSettingViewController alloc]init];
    setting.tabBarItem.title = @"设置";
    setting.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_setting"];
    setting.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_icon_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    BaseNavigationViewController * navSetting = [[BaseNavigationViewController alloc]initWithRootViewController:setting];
    
    
    [self addChildViewController:navGameList];
    [self addChildViewController:navSetting];
}
@end
