//
//  AppDelegate.m
//  QuickStart
//
//  Created by kaniel on 2022/5/24.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "AppDelegate.h"
#import "QSGameListViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self loadWindow];
    [self configLog];
    [self configIQKeyboard];
    DDLogDebug(@"current userID:%@", QSAppPreferences.shared.currentUserID);
    return YES;
}

/// 加载window
- (void)loadWindow {
    
    self.window = [[UIWindow alloc]init];
    // 游戏列表
    QSGameListViewController *vc = [[QSGameListViewController alloc] init];
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    self.window.backgroundColor = UIColor.redColor;
    [self.window makeKeyAndVisible];
}

/// 配置日志
- (void)configLog {

    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:[[DDLogFileManagerDefault alloc] init]];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setLocalizedDateFormatFromTemplate:@"YYYY/MM/dd HH:mm:ss:SSS"];
    fileLogger.logFormatter = [[DDLogFileFormatterDefault alloc] initWithDateFormatter:fmt];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hours
    fileLogger.logFileManager.maximumNumberOfLogFiles = 5;
    fileLogger.maximumFileSize = 5 * 1024 * 1024;
    [DDLog addLogger:fileLogger];
    if (@available(iOS 10.0, *)) {
        [DDLog addLogger:[DDOSLogger sharedInstance]]; //iOS10之后
    } else {
        // Fallback on earlier versions
        [DDLog addLogger:[DDASLLogger sharedInstance]]; //iOS10之前
    } // Uses os_log
    DDLogDebug(@"config log");
}


/// 配置IQKeyboard
- (void)configIQKeyboard {
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

@end
