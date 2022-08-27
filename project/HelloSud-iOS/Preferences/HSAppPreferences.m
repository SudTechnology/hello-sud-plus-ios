//
// Created by kaniel on 2022/7/29.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HSAppPreferences.h"

#define kKeyEtherChains @"kKeyEtherChains"

NSString *const MY_ETHEREUM_CHAINS_SELECT_CHANGED_NTF = @"MY_ETHEREUM_CHAINS_SELECT_CHANGED_NTF";
NSString *const MY_NFT_WEAR_CHANGE_NTF = @"MY_NFT_WEAR_CHANGE_NTF";
NSString *const MY_NFT_BIND_WALLET_CHANGE_NTF = @"MY_NFT_BIND_WALLET_CHANGE_NTF";
/// 房间列表更新通知
NSString *const MY_NFT_WALLET_LIST_UPDATE_NTF = @"MY_NFT_WALLET_LIST_UPDATE_NTF";

/// 用户选择链网
#define kKeySelectedEthereumChain [self envKey:@"kKeySelectedEthereumChain"]
/// 用户绑定钱包类型
#define kKeyBindWalletType [self envKey:@"kKeyBindWalletType"]
#define kWalletTokenKey [self envKey:@"kKeyNFTWalletToken"]
/// 用户绑定钱包
#define kKeyBindWallet [self envKey:@"kKeyBindWallet"]

/// 用户绑定钱包区域
#define kKeyBindWalletZone [self envKey:@"kKeyBindWalletZone"]

/// 用户绑定手机号
#define kKeyBindUserPhone [self envKey:@"kKeyBindUserPhone"]

/// 用户绑定Token
#define kKeyBindUserToken [self envKey:@"kKeyBindUserToken"]

/// 用户当前选中钱包
#define kKeyCurrentSelectedWallet [self envKey:@"kKeyCurrentSelectedWallet"]

@interface HSAppPreferences ()
/// 当前用户绑定钱包token model
@property(nonatomic, strong) SudNFTBindWalletModel *bindWalletModel;
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
    _bindZoneType = -1;
    _bindWalletType = -1;
    _selectedEthereumChainType = [NSUserDefaults.standardUserDefaults integerForKey:kKeySelectedEthereumChain];
    id tempBindZoneType = [NSUserDefaults.standardUserDefaults objectForKey:kKeyBindWalletZone];
    if (tempBindZoneType) {
        _bindZoneType = [NSUserDefaults.standardUserDefaults integerForKey:kKeyBindWalletZone];
    }
    id tempBindWalletType = [NSUserDefaults.standardUserDefaults objectForKey:kKeyBindWalletType];
    if (tempBindWalletType) {
        _bindWalletType = [NSUserDefaults.standardUserDefaults integerForKey:kKeyBindWalletType];
    }

    _currentSelectedWalletType = [NSUserDefaults.standardUserDefaults integerForKey:kKeyCurrentSelectedWallet];
    _currentSelectedWalletType = _bindWalletType;
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

/// 是否已经绑定了钱包
- (BOOL)isBindWallet {
    if (self.walletAddress.length > 0 || self.bindWalletType > 0) {
        return YES;
    }
    return NO;
}

/// 是否绑定了国内钱包
- (BOOL)isBindCNWallet {
    if (self.bindWalletType > 0) {
        return YES;
    }
    return NO;
}


/// 是否绑定了海外钱包
- (BOOL)isBindForeignWallet {
    if (self.walletAddress.length > 0) {
        return YES;
    }
    return NO;
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

- (void)setBindZoneType:(NSInteger)bindZoneType {
    _bindZoneType = bindZoneType;
    [NSUserDefaults.standardUserDefaults setInteger:bindZoneType forKey:kKeyBindWalletZone];
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
        NSMutableDictionary *userWalletMap = [[NSMutableDictionary alloc] init];
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

- (void)setCurrentSelectedWalletType:(NSInteger)currentSelectedWalletType {
    _currentSelectedWalletType = currentSelectedWalletType;
    [NSUserDefaults.standardUserDefaults setInteger:currentSelectedWalletType forKey:kKeyCurrentSelectedWallet];
    [NSUserDefaults.standardUserDefaults synchronize];
}

/// 保存绑定用户信息
/// @param bindUserModel
/// @param walletType
/// @param phone
- (void)saveWalletTokenWithBindUserModel:(SudNFTBindUserModel *)bindUserModel walletType:(NSInteger)walletType phone:(NSString *)phone {
    // 用户手机号
    [NSUserDefaults.standardUserDefaults setValue:phone forKey:[NSString stringWithFormat:@"%@_%@", kKeyBindUserPhone, @(walletType)]];
    [NSUserDefaults.standardUserDefaults synchronize];
    // 用户token
    [NSUserDefaults.standardUserDefaults setValue:bindUserModel.walletToken forKey:[NSString stringWithFormat:@"%@_%@", kKeyBindUserToken, @(walletType)]];
    [NSUserDefaults.standardUserDefaults synchronize];
}

/// 通过钱包获取绑定用户token
/// @param walletType
/// @return
- (NSString *)getBindUserTokenByWalletType:(NSInteger)walletType {
    return [NSUserDefaults.standardUserDefaults objectForKey:[NSString stringWithFormat:@"%@_%@", kKeyBindUserToken, @(walletType)]];
}

/// 通过钱包获取绑定用户手机号
/// @param walletType
/// @return
- (NSString *)getBindUserPhoneByWalletType:(NSInteger)walletType {
    return [NSUserDefaults.standardUserDefaults objectForKey:[NSString stringWithFormat:@"%@_%@", kKeyBindUserPhone, @(walletType)]];
}

/// 清除绑定用户信息
/// @param walletType
- (void)clearBindUserInfoWithWalletType:(NSInteger)walletType {
    // 移除绑定用户手机号
    [NSUserDefaults.standardUserDefaults removeObjectForKey:[NSString stringWithFormat:@"%@_%@", kKeyBindUserPhone, @(walletType)]];
    // 移除绑定用户token
    [NSUserDefaults.standardUserDefaults removeObjectForKey:[NSString stringWithFormat:@"%@_%@", kKeyBindUserToken, @(walletType)]];
    /// 清楚绑定类型
    self.currentSelectedWalletType = -1;
    self.bindZoneType = -1;
    self.bindWalletType = -1;
}

@end
