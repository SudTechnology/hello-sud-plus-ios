//
//  AppDelegate.m
//  SudNFTQuickStart
//
//  Created by kaniel on 2022/9/1.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "AppDelegate.h"
#import "QuickStartViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self loadWindow];
    return YES;
}

/// 加载window
- (void)loadWindow {
    
    self.window = [[UIWindow alloc]init];
    // 游戏列表
    QuickStartViewController *vc = [[QuickStartViewController alloc] init];
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    self.window.backgroundColor = UIColor.redColor;
    [self.window makeKeyAndVisible];
}

@end
