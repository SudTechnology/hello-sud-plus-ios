//
//  AppDelegate.m
//  HelloSud
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by kaniel on 2022/1/17.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import <Bugly/Bugly.h>
#import "DeviceUtil.h"
#import "AudioEngineFactory.h"
#import "LoginViewController.h"
#import "KeyHeader.h"

@interface AppDelegate () {
    
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [[AppService shared] prepare];
    [[AppService shared] setupNetWorkHeader];
    [self observerNTF];
    self.window = [[UIWindow alloc]init];
    // 登录过后，检测刷新token
    if (AppService.shared.login.isLogin) {
        [AppService.shared.login checkToken];
        self.window.rootViewController = [[MainTabBarController alloc]init];
    } else {
        self.window.rootViewController = [[LoginViewController alloc]init];
    }
    self.window.backgroundColor = UIColor.whiteColor;
    [self.window makeKeyAndVisible];
    [self configBugly];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [GiftService.shared loadFromDisk];
    return YES;
}

- (void)configBugly {
    NSString *version = [NSString stringWithFormat:@"%@.%@", [DeviceUtil getAppVersion], [DeviceUtil getAppBuildCode]];
    [Bugly updateAppVersion:version];
    [Bugly startWithAppId:BUGLEY_APP_ID];
}

- (void)observerNTF {
    // 监听token刷新状态切换视图
    [[NSNotificationCenter defaultCenter] addObserverForName:TOKEN_REFRESH_SUCCESS_NTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        if (AppService.shared.login.isRefreshedToken && ![self.window.rootViewController isKindOfClass:[MainTabBarController class]]) {
            /// 切根式图
            self.window.rootViewController = [[MainTabBarController alloc] init];
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:TOKEN_REFRESH_FAIL_NTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        if (![self.window.rootViewController isKindOfClass:[LoginViewController class]]) {
            /// 切根式图
            self.window.rootViewController = [[LoginViewController alloc]init];
            [ToastUtil show:@"登录已过期，请重新进入"];
        }
    }];
}
@end
