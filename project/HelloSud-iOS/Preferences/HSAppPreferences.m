//
// Created by kaniel on 2022/7/29.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HSAppPreferences.h"

#define kKeyEtherChains @"kKeyEtherChains"

NSString *const MY_ETHEREUM_CHAINS_SELECT_CHANGED_NTF = @"MY_ETHEREUM_CHAINS_SELECT_CHANGED_NTF";
NSString *const MY_NFT_WEAR_CHANGE_NTF = @"MY_NFT_WEAR_CHANGE_NTF";
NSString *const MY_NFT_BIND_WALLET_CHANGE_NTF = @"MY_NFT_BIND_WALLET_CHANGE_NTF";

/// 用户选择链网
#define kKeySelectedEthereumChain [self envKey:@"kKeySelectedEthereumChain"]
/// 用户绑定钱包类型
#define kKeyBindWalletType [self envKey:@"kKeyBindWalletType"]
#define kWalletTokenKey [self envKey:@"kKeyNFTWalletToken"]
/// 用户绑定钱包
#define kKeyBindWallet [self envKey:@"kKeyBindWallet"]

@interface HSAppPreferences()
/// 当前用户绑定钱包token model
@property (nonatomic, strong)SudNFTBindWalletModel *bindWalletModel;
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
    NSString *key = [self currentUserWalletTokenKey];
    NSDictionary *userWalletMap = [NSUserDefaults.standardUserDefaults objectForKey:key];
    NSArray *arrKeys = [userWalletMap allKeys];
    _walletAddress = [NSUserDefaults.standardUserDefaults objectForKey:kKeyBindWallet];

    SudNFTBindWalletModel *m = [SudNFTBindWalletModel mj_objectWithKeyValues:userWalletMap[arrKeys[0]]];
    self.bindWalletModel = m;
    if (m == nil || m.walletToken.length == 0) {
        _walletAddress = nil;
    }
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

- (NSString *)walletToken {
    return self.bindWalletModel.walletToken;
}

/// 缓存钱包token
- (void)cacheWalletToken:(SudNFTBindWalletModel *)walletRespModel walletAddress:(NSString *)walletAddress {
    self.bindWalletModel = walletRespModel;
    if (walletAddress && walletRespModel) {
        // 本地持久化
        NSString *key = [self currentUserWalletTokenKey];
        NSMutableDictionary *userWalletMap = [[NSMutableDictionary alloc]init];
        // 存储钱包数据
        userWalletMap[walletAddress] = [walletRespModel mj_JSONString];
        [NSUserDefaults.standardUserDefaults setObject:userWalletMap forKey:key];
        [NSUserDefaults.standardUserDefaults synchronize];
    }
}

- (NSString *)currentUserWalletTokenKey {
    return kWalletTokenKey;
}

- (void)setWalletAddress:(NSString *)walletAddress {
    _walletAddress = walletAddress;
    [NSUserDefaults.standardUserDefaults setValue:walletAddress forKey:kKeyBindWallet];
    [NSUserDefaults.standardUserDefaults synchronize];
}

@end
