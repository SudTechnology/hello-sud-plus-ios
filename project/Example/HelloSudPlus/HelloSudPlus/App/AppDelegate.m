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
#import "SDImageSVGNativeCoder.h"
#import <AFNetworking/AFNetworking.h>
#import <SudMGP/ISudCfg.h>
#import <SudMGP/ISudLogger.h>
#import <AFNetworking/AFNetworking.h>

@interface AppDelegate ()<BuglyDelegate> {

}

@property(nonatomic, assign) UIBackgroundTaskIdentifier taskId;
@property(nonatomic, strong) NSTimer *timer;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 配置顶部tableview不留出状态栏
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
//        UIScrollView.appearance.contentInsetAdjustmentBehavior = NO;
    }
    /// 防止键盘弹出抖动问题
    UIScrollView.appearance.shouldIgnoreContentInsetAdjustment = YES;

    // Override point for customization after application launch.
    [self configLog];
    [[AppService shared] prepare];
    [[AppService shared] setupNetWorkHeader];

    [self observerNTF];
    self.window = [[UIWindow alloc] init];
    // 登录过后，检测刷新token
    if (AppService.shared.login.isLogin) {
        self.window.rootViewController = [[MainTabBarController alloc] init];
    } else {
        self.window.rootViewController = [[LoginViewController alloc] init];
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
    [self configWebpCoder];
    [self checkNetwork];
    [self loadGameEmbedPackage];
//    [self redirectNSLogToDocumentFolder];
//    [self redirectNSLogToDocumentFolder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSessionRouteChanged:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    return YES;
}

/// 加载嵌入游戏包
- (void)loadGameEmbedPackage {
    [SudMGP setLogLevel:SudLogVERBOSE];
//    [[SudMGP getCfg] addEmbeddedMGPkg:1583284410804244481 mgPath:@"customrockets.sp"];
//    [[SudMGP getCfg] addEmbeddedMGPkg:1594978084509368321 mgPath:@"baseball.rpk"];
}

- (void)configBugly {
    NSString *version = [NSString stringWithFormat:@"%@.%@", [DeviceUtil getAppVersion], [DeviceUtil getAppBuildCode]];
    [Bugly updateAppVersion:version];
    BuglyConfig *config = BuglyConfig.new;
    config.delegate = self;
    [Bugly startWithAppId:BUGLEY_APP_ID config:config];
}


- (void)observerNTF {
    // 监听token刷新状态切换视图
    [[NSNotificationCenter defaultCenter] addObserverForName:TOKEN_REFRESH_SUCCESS_NTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *_Nonnull note) {
        if (AppService.shared.login.isRefreshedToken && ![self.window.rootViewController isKindOfClass:[MainTabBarController class]]) {
            /// 切根式图
            self.window.rootViewController = [[MainTabBarController alloc] init];
        }
        [self checkAppVersion];
        [UserService.shared reqUserCoinDetail:^(int64_t i) {
        }                                fail:nil];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:TOKEN_REFRESH_FAIL_NTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *_Nonnull note) {
        if (![self.window.rootViewController isKindOfClass:[LoginViewController class]]) {
            /// 切根式图
            [DTAlertView close];
            self.window.rootViewController = [[LoginViewController alloc] init];
        }
    }];
}

- (void)checkAppVersion {
    [[AppService shared] reqAppUpdate:^(BaseRespModel *resp) {
        [self showUpgrade:(RespVersionUpdateInfoModel *) resp];
    }                            fail:nil];
}

- (void)showUpgrade:(RespVersionUpdateInfoModel *)model {

    if (model == nil || model.packageUrl.length == 0) {
        return;
    }
    if (model.upgradeType == 1) {
        /// 强制升级
        [DTAlertView showTextAlert:NSString.dt_update_app_ver_low sureText:NSString.dt_update_now cancelText:nil disableAutoClose:YES onSureCallback:^{
            [self openPath:model.packageUrl];
        }          onCloseCallback:^{
            [DTAlertView close];
        }];
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
                [DTAlertView close];
            }          onCloseCallback:nil];
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

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self endTask];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    if (self.taskId != UIBackgroundTaskInvalid) {
        return;
    }
    WeakSelf
    self.taskId = [application beginBackgroundTaskWithExpirationHandler:^{
        [weakSelf endTask];
        NSLog(@"app suspend");
    }];
    // 申请延迟 Task
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(longTimeTask:)
                                                userInfo:nil
                                                 repeats:YES];
    
//    NSError* error = nil;
//    AVAudioSession* session = [AVAudioSession sharedInstance];
//    if (![session setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error]) {
//        NSLog(@"=====> Audio:setActive %@", error.localizedDescription);
//    }
}

- (void)endTask {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.taskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.taskId];
        self.taskId = UIBackgroundTaskInvalid;
    }
}

- (void)longTimeTask:(NSTimer *)tiemr {

    NSTimeInterval time = [[UIApplication sharedApplication] backgroundTimeRemaining];

    DDLogDebug(@"app background remain time: = %.02f Seconds", time);
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

/// 缓存本地数据
- (void)configWebpCoder {
    // Add coder
    SDImageWebPCoder *webPCoder = [SDImageWebPCoder sharedCoder];
    [[SDImageCodersManager sharedManager] addCoder:webPCoder];
    // register coder, on AppDelegate

    SDImageSVGNativeCoder *SVGNativeCoder = [SDImageSVGNativeCoder sharedCoder];
    [[SDImageCodersManager sharedManager] addCoder:SVGNativeCoder];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    UIInterfaceOrientationMask mask = self.window.rootViewController.supportedInterfaceOrientations;
    return mask;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id <UIUserActivityRestoring>> *_Nullable))restorationHandler {

    // 三方返回APP时，要将返回数据传入SudNFT去处理解析
    if ([SudNFT handleOpenUniversalLink:userActivity]) {
        return YES;
    }
    return YES;
}

- (void)checkNetwork {
    [AFNetworkReachabilityManager.sharedManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        DDLogDebug(@"net status:%@", @(status));
        switch (status) {
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:
                if (AppService.shared.login.isLogin && !AppService.shared.login.isRefreshedToken) {
                    [AppService.shared.login checkToken];
                }
                break;
            default:break;
        }
    }];
    [AFNetworkReachabilityManager.sharedManager startMonitoring];
}

/**
 *  发生异常时回调
 *
 *  @param exception 异常信息
 *
 *  @return 返回需上报记录，随异常上报一起上报
 */
- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception {
    DDLogError(@"bugly error:%@, info:%@", exception.debugDescription, exception.userInfo);
    return @"";
}


#pragma mark - 保存日志文件 -
- (void)redirectNSLogToDocumentFolder {
    // 如果已经连接Xcode调试则不输出到文件
    if(isatty(STDOUT_FILENO)) {
        return;
    }

    UIDevice *device = [UIDevice currentDevice];
    if([[device model] hasSuffix:@"Simulator"]){ //在模拟器不保存到文件中
        return;
    }

    // 获取Document目录下的Log文件夹，若没有则新建
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"KanielLog"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:logDirectory];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:logDirectory  withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //每次启动后都保存一个新的日志文件中
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"/%@.txt",dateStr];

    // freopen 重定向输出输出流，将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}


- (void)onSessionRouteChanged:(NSNotification *)n {
    NSLog(@"onSessionRouteChanged:%@", n.userInfo);
}

@end

/// 检测修改系统session

@interface AVAudioSession (SudTestAVAudioSession)



@end

@implementation  AVAudioSession (SudTestAVAudioSession)

+ (void)load
{
    swizzleMethod([self class], @selector(setActive:error:), @selector(sud_test_setActive:error:));
    swizzleMethod([self class], @selector(setActive:withOptions:error:), @selector(sud_test_setActive:withOptions:error:));
    swizzleMethod([self class], @selector(overrideOutputAudioPort:error:), @selector(sud_test_overrideOutputAudioPort:error:));
    
    swizzleMethod([self class], @selector(setCategory:error:), @selector(sud_test_setCategory:error:));
    swizzleMethod([self class], @selector(setCategory:withOptions:error:), @selector(sud_test_setCategory:withOptions:error:));
    swizzleMethod([self class], @selector(setCategory:mode:options:error:), @selector(sud_test_setCategory:mode:options:error:));
}


void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    // the method doesn’t exist and we just added one
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

- (BOOL)sud_test_setActive:(BOOL)active withOptions:(AVAudioSessionSetActiveOptions)options error:(NSError **)outError {
    BOOL result =  [self sud_test_setActive:active withOptions:options error:outError];
    NSLog(@"===============> session active 1:%@, options:%@, error:%@, result:%@", @(active), @(options), outError != nil ? *outError : nil, @(result));
    return result;
}

- (BOOL)sud_test_setActive:(BOOL)active error:(NSError **)outError {
    BOOL result =  [self sud_test_setActive:active error:outError];
    NSLog(@"===============> session active 2:%@, error:%@, result:%@", @(active), outError != nil ? *outError : nil, @(result));
    
    return result;
}

- (BOOL)sud_test_setCategory:(AVAudioSessionCategory)category error:(NSError *__autoreleasing  _Nullable *)outError {
    NSLog(@"===============> sud_test_setCategory:%@", category);
    return [self sud_test_setCategory:category error:outError];
}

- (BOOL)sud_test_setCategory:(AVAudioSessionCategory)category withOptions:(AVAudioSessionCategoryOptions)options error:(NSError *__autoreleasing  _Nullable *)outError {
    NSLog(@"===============> sud_test_setCategory options:%@, %@", category, @(options));
    return [self sud_test_setCategory:category withOptions:options error:outError];
}

- (BOOL)sud_test_setCategory:(AVAudioSessionCategory)category mode:(AVAudioSessionMode)mode options:(AVAudioSessionCategoryOptions)options error:(NSError *__autoreleasing  _Nullable *)outError {
    NSLog(@"===============> sud_test_setCategory mode options:%@, mode:%@, options:%@", category, mode, @(options));
    return [self sud_test_setCategory:category mode:mode options:options error:outError];
}

- (BOOL)sud_test_overrideOutputAudioPort:(AVAudioSessionPortOverride)portOverride error:(NSError *__autoreleasing  _Nullable *)outError {
    if (portOverride == AVAudioSessionPortOverrideSpeaker) {
        NSLog(@"===============> sud_test_overrideOutputAudioPort speaker:%@", NSThread.currentThread);
    }
    NSLog(@"===============> sud_test_overrideOutputAudioPort:%@, %@", @(portOverride), NSThread.currentThread);
    return [self sud_test_overrideOutputAudioPort:portOverride error:outError];
}


@end
