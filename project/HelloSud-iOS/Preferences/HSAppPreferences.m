//
// Created by kaniel on 2022/7/29.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HSAppPreferences.h"

#define kKeyEtherChains @"kKeyEtherChains"

NSString *const MY_ETHEREUM_CHAINS_SELECT_CHANGED_NTF = @"MY_ETHEREUM_CHAINS_SELECT_CHANGED_NTF";

/// 用户选择链网
#define kKeySelectedEthereumChain [self envKey:@"kKeySelectedEthereumChain"]
/// 用户绑定钱包类型
#define kKeyBindWalletType [self envKey:@"kKeyBindWalletType"]

@interface HSAppPreferences()
@end

@implementation HSAppPreferences
+ (instancetype)shared {
    static HSAppPreferences *g_manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        g_manager = HSAppPreferences.new;
        [g_manager prepare];
    });
    return g_manager;
}

- (void)prepare {
    _selectedEthereumChainType = [NSUserDefaults.standardUserDefaults integerForKey:kKeySelectedEthereumChain];
    _bindWalletType = [NSUserDefaults.standardUserDefaults integerForKey:kKeyBindWalletType];
}

/// 环境隔离key
/// @param key key
/// @return
- (NSString *)envKey:(NSString *)key {
#if DEBUG
    return [NSString stringWithFormat:@"debug_%@", key];
#else
    return [NSString stringWithFormat:@"%@", key];
#endif
}

- (void)setSelectedEthereumChainType:(NSInteger)selectedEthereumChainType {
    BOOL isChanged = _selectedEthereumChainType != selectedEthereumChainType;
    _selectedEthereumChainType = selectedEthereumChainType;
    if (isChanged) {
        [NSUserDefaults.standardUserDefaults setInteger:selectedEthereumChainType forKey:kKeySelectedEthereumChain];
        [NSUserDefaults.standardUserDefaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:MY_ETHEREUM_CHAINS_SELECT_CHANGED_NTF object:nil userInfo:nil];
    }
}

- (void)setBindWalletType:(NSInteger)bindWalletType {
    _bindWalletType = bindWalletType;
    [NSUserDefaults.standardUserDefaults setInteger:bindWalletType forKey:kKeyBindWalletType];
    [NSUserDefaults.standardUserDefaults synchronize];
}

@end