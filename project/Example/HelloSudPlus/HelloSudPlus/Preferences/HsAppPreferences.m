//
// Created by kaniel on 2022/9/21.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HsAppPreferences.h"

#define kKeyAppEnvType @"kKeyAppEnvType"
#define kKeyGameEnvType @"kKeyGameEnvType"
#define kKeyNftEnvType @"kKeyNftEnvType"
#define kKeyAppIdEnvType @"kKeyAppIdEnvType"

@implementation HsAppPreferences
+ (instancetype)shared {
    static HsAppPreferences *g_manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        g_manager = HsAppPreferences.new;
        [g_manager prepare];
    });
    return g_manager;
}

- (void)prepare {
#if DEBUG
    _appEnvType = HsAppEnvTypeSim;
    _gameEnvType = HsGameEnvTypeSim;
    _nftEnvType = HsNftEnvTypeSim;
    _appIdType = HsAppIdTypeDefault;
    if ([NSUserDefaults.standardUserDefaults objectForKey:kKeyAppEnvType]) {
        _appEnvType = [NSUserDefaults.standardUserDefaults integerForKey:kKeyAppEnvType];
    }
    if ([NSUserDefaults.standardUserDefaults objectForKey:kKeyGameEnvType]) {
        _gameEnvType = [NSUserDefaults.standardUserDefaults integerForKey:kKeyGameEnvType];
    }
    if ([NSUserDefaults.standardUserDefaults objectForKey:kKeyNftEnvType]) {
        _nftEnvType = [NSUserDefaults.standardUserDefaults integerForKey:kKeyNftEnvType];
    }
    if ([NSUserDefaults.standardUserDefaults objectForKey:kKeyAppIdEnvType]) {
        _appIdType = [NSUserDefaults.standardUserDefaults integerForKey:kKeyAppIdEnvType];
    }
#else
    self.appEnvType = HsAppEnvTypePro;
    self.gameEnvType = HsGameEnvTypePro;
    self.nftEnvType = HsNftEnvTypePro;
    self.appIdType = HsAppIdTypeDefault;
#endif

}

- (void)setAppEnvType:(HsAppEnvType)appEnvType {
    _appEnvType = appEnvType;
    [NSUserDefaults.standardUserDefaults setInteger:appEnvType forKey:kKeyAppEnvType];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)setGameEnvType:(HsGameEnvType)gameEnvType {
    _gameEnvType = gameEnvType;
    [NSUserDefaults.standardUserDefaults setInteger:gameEnvType forKey:kKeyGameEnvType];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)setNftEnvType:(HsNftEnvType)nftEnvType {
    _nftEnvType = nftEnvType;
    [NSUserDefaults.standardUserDefaults setInteger:nftEnvType forKey:kKeyNftEnvType];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)setAppIdType:(HsAppIdType)appIdType {
    _appIdType = appIdType;
    [NSUserDefaults.standardUserDefaults setInteger:appIdType forKey:kKeyAppIdEnvType];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (NSString *)baseUrl {
    if (HsAppPreferences.shared.appIdType == HsAppIdType945) {
        return [self backupBaseUrl];
    }
    NSString *url = nil;
    switch (self.appEnvType) {
        case HsAppEnvTypePro:
            url = @"https://base-hello-sud.sud.tech";
            break;
        case HsAppEnvTypeSim:
            url = @"https://sim-base-hello-sud.sud.tech";
            break;
        case HsAppEnvTypeFat:
            url = @"https://fat-base-hello-sud.sud.tech";
            break;
        case HsAppEnvTypeDev:
            url = @"https://dev-base-hello-sud.sud.tech";
            break;
    }
    return url;
}

- (NSString *)interactUrl {
    if (HsAppPreferences.shared.appIdType == HsAppIdType945) {
        return [self backupInteractUrl];
    }
    NSString *url = nil;
    switch (self.appEnvType) {
        case HsAppEnvTypePro:
            url = @"https://interact-hello-sud.sud.tech";
            break;
        case HsAppEnvTypeSim:
            url = @"https://sim-interact-hello-sud.sud.tech";
            break;
        case HsAppEnvTypeFat:
            url = @"https://fat-interact-hello-sud.sud.tech";
            break;
        case HsAppEnvTypeDev:
            url = @"https://dev-interact-hello-sud.sud.tech";
            break;
    }
    return url;
}

- (NSString *)gameUrl {
    if (HsAppPreferences.shared.appIdType == HsAppIdType945) {
        return [self backupGameUrl];
    }
    NSString *url = nil;
    switch (self.appEnvType) {
        case HsAppEnvTypePro:
            url = @"https://game-hello-sud.sud.tech";
            break;
        case HsAppEnvTypeSim:
            url = @"https://sim-game-hello-sud.sud.tech";
            break;
        case HsAppEnvTypeFat:
            url = @"https://fat-game-hello-sud.sud.tech";
            break;
        case HsAppEnvTypeDev:
            url = @"https://dev-game-hello-sud.sud.tech";
            break;
    }
    return url;
}

- (NSString *)appId {
    NSString *appId = AppService.shared.configModel.sudCfg.appId;
    if (HsAppPreferences.shared.appIdType == HsAppIdType945) {
        appId = @"1544232043822546945";
    }
    return appId;
}

- (NSString *)appKey {
    NSString *appKey = AppService.shared.configModel.sudCfg.appKey;
    if (HsAppPreferences.shared.appIdType == HsAppIdType945) {
        appKey = @"Wi1zWeuM0GHqReJ1PMWMXCHlpK9IZ9mJ";
    }
    return appKey;
}


- (NSString *)backupBaseUrl {
    NSString *url = nil;
    switch (self.appEnvType) {
        case HsAppEnvTypePro:
            url = @"https://base-hello-sud-backup.sud.tech";
            break;
        case HsAppEnvTypeSim:
            url = @"https://sim-base-hello-sud-backup.sud.tech";
            break;
        case HsAppEnvTypeFat:
            url = @"https://fat-base-hello-sud-backup.sud.tech";
            break;
        case HsAppEnvTypeDev:
            url = @"https://dev-base-hello-sud-backup.sud.tech";
            break;
    }
    return url;
}

- (NSString *)backupInteractUrl {
    NSString *url = nil;
    switch (self.appEnvType) {
        case HsAppEnvTypePro:
            url = @"https://interact-hello-sud-backup.sud.tech";
            break;
        case HsAppEnvTypeSim:
            url = @"https://sim-interact-hello-sud-backup.sud.tech";
            break;
        case HsAppEnvTypeFat:
            url = @"https://fat-interact-hello-sud-backup.sud.tech";
            break;
        case HsAppEnvTypeDev:
            url = @"https://dev-interact-hello-sud-backup.sud.tech";
            break;
    }
    return url;
}

- (NSString *)backupGameUrl {
    NSString *url = nil;
    switch (self.appEnvType) {
        case HsAppEnvTypePro:
            url = @"https://game-hello-sud-backup.sud.tech";
            break;
        case HsAppEnvTypeSim:
            url = @"https://sim-game-hello-sud-backup.sud.tech";
            break;
        case HsAppEnvTypeFat:
            url = @"https://fat-game-hello-sud-backup.sud.tech";
            break;
        case HsAppEnvTypeDev:
            url = @"https://dev-game-hello-sud-backup.sud.tech";
            break;
    }
    return url;
}


@end
