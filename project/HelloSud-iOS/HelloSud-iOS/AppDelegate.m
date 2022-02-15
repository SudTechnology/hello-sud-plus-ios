//
//  AppDelegate.m
//  HelloSud
//
//  Created by kaniel on 2022/1/17.
//

#import "AppDelegate.h"
#import "HSMainTabBarController.h"
#import <Bugly/Bugly.h>
#import "DeviceUtil.h"
#import "MediaAudioEngineManager.h"
#import "HSLoginViewController.h"
@interface AppDelegate () {
    
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]init];
    if (HSAppManager.shared.isLogin) {
        [HSAppManager.shared refreshToken];
        self.window.rootViewController = [[HSMainTabBarController alloc]init];
    } else {
        self.window.rootViewController = [[HSLoginViewController alloc]init];
    }
    self.window.backgroundColor = UIColor.whiteColor;
    [self.window makeKeyAndVisible];
    [self configBugly];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    return YES;
}

- (void)configBugly {
    NSString *version = [NSString stringWithFormat:@"%@.%@", [DeviceUtil getAppVersion], [DeviceUtil getAppBuildCode]];
    [Bugly updateAppVersion:version];
    [Bugly startWithAppId:@"0d680b2d4c"];
}

#pragma mark - UISceneSession lifecycle


//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


@end
