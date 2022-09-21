//
// Created by kaniel on 2022/9/21.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HsAppPreferences.h"

#define kKeyAppEnvType @"kKeyAppEnvType"
#define kKeyGameEnvType @"kKeyGameEnvType"
#define kKeyNftEnvType @"kKeyNftEnvType"

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
    self.appEnvType = HsAppEnvTypeSim;
    self.gameEnvType = HsGameEnvTypeSim;
    self.nftEnvType = HsNftEnvTypeSim;
    if ([NSUserDefaults.standardUserDefaults objectForKey:kKeyAppEnvType]) {
        _appEnvType = [NSUserDefaults.standardUserDefaults integerForKey:kKeyAppEnvType];
    }
    if ([NSUserDefaults.standardUserDefaults objectForKey:kKeyGameEnvType]) {
        _gameEnvType = [NSUserDefaults.standardUserDefaults integerForKey:kKeyGameEnvType];
    }
    if ([NSUserDefaults.standardUserDefaults objectForKey:kKeyNftEnvType]) {
        _nftEnvType = [NSUserDefaults.standardUserDefaults integerForKey:kKeyNftEnvType];
    }
#else
    self.appEnvType = HsAppEnvTypePro;
    self.gameEnvType = HsGameEnvTypePro;
    self.nftEnvType = HsNftEnvTypePro;
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

- (NSString *)baseUrl {
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
@end
