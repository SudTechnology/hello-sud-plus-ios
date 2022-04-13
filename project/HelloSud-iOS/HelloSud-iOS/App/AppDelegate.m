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
#import <NIMSDK/NIMSDK.h>

@interface AppDelegate () {

}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    [[AppService shared] prepare];
    /// 不支持的多语言，默认英文
    if ([SettingsService isNotSupportLanguage]) {
        LanguageUtil.userLanguage = @"en";
    }
    [[AppService shared] setupNetWorkHeader];
    
    [self observerNTF];
    self.window = [[UIWindow alloc]init];
    // 登录过后，检测刷新token
    if (AppService.shared.login.isLogin) {
        self.window.rootViewController = [[MainTabBarController alloc]init];
        [AppService.shared.login checkToken];
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
    
    NIMSDKOption *option = [NIMSDKOption optionWithAppKey:@"110f7db7c00ee497bd7b32954c36464c"];
    [[NIMSDK sharedSDK] registerWithOption:option];
    
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
        [self checkAppVersion];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:TOKEN_REFRESH_FAIL_NTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        if (![self.window.rootViewController isKindOfClass:[LoginViewController class]]) {
            /// 切根式图
            self.window.rootViewController = [[LoginViewController alloc]init];
        }
    }];
}

- (void)checkAppVersion {
    [[AppService shared] reqAppUpdate:^(BaseRespModel *resp) {
        [self showUpgrade:(RespVersionUpdateInfoModel *) resp];
    } fail:nil];
}

- (void)showUpgrade:(RespVersionUpdateInfoModel *)model {

    if (model == nil || model.packageUrl.length == 0) {
        return;
    }
    if (model.upgradeType == 1) {
        /// 强制升级
        [DTAlertView showTextAlert:NSString.dt_update_app_ver_low sureText:NSString.dt_update_now cancelText:nil onSureCallback:^{
            [self openPath:model.packageUrl];
        } onCloseCallback:nil];
    } else if (model.upgradeType == 2) {
        /// 引导升级
        // 2.格式化日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *keyTodayShow = [NSString stringWithFormat:@"keyUpgrade_%@", [formatter stringFromDate:[NSDate date]]];
        BOOL isTodayShow = [NSUserDefaults.standardUserDefaults boolForKey:keyTodayShow];
        if (!isTodayShow) {
            [NSUserDefaults.standardUserDefaults setBool:YES forKey:keyTodayShow];
            [NSUserDefaults.standardUserDefaults synchronize];
            [DTAlertView showTextAlert:NSString.dt_update_app_ver_new sureText:NSString.dt_update_now cancelText:NSString.dt_next_time_again_say onSureCallback:^{
                [self openPath:model.packageUrl];
            } onCloseCallback:nil];
        }
        
    }
}

- (void)openPath:(NSString *)path {
    NSURL *url = [[NSURL alloc] initWithString:path];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
@end
