//
// Created by kaniel on 2022/7/29.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HsNFTPreferences.h"

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
/// 穿戴NFT key
#define kKeyUsedNFT @"key_used_nft_"
/// 穿戴的NFT详情token key
#define kKeyUsedNftDetailsToken @"key_used_nft_details_token"
/// 穿戴的国内NFT详情信息
#define kKeyWearCnNftModelInfo [self envKey:@"kKeyWearCnNftModelInfo"]
/// 穿戴的NFT详情信息
#define kKeyWearNftModelInfo [self envKey:@"kKeyWearNftModelInfo"]

@interface HsNFTPreferences ()
/// 当前用户绑定钱包token model
@property(nonatomic, strong) SudNFTBindWalletModel *bindWalletModel;
@end

@implementation HsNFTPreferences
+ (instancetype)shared {
    static HsNFTPreferences *g_manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        g_manager = HsNFTPreferences.new;
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
    NSString *key = [self currentUserWalletTokenKey];
    NSDictionary *userWalletMap = [NSUserDefaults.standardUserDefaults objectForKey:key];
    NSArray *arrKeys = [userWalletMap allKeys];
    _walletAddress = [NSUserDefaults.standardUserDefaults objectForKey:kKeyBindWallet];

    id tempStr = [NSUserDefaults.standardUserDefaults objectForKey:kKeyWearCnNftModelInfo];
    if (tempStr) {
        _wearCnNftModel = [SudNFTCnInfoModel.class mj_objectWithKeyValues:tempStr];
    }
    tempStr = [NSUserDefaults.standardUserDefaults objectForKey:kKeyWearNftModelInfo];
    if (tempStr) {
        _wearNftModel = [SudNFTInfoModel.class mj_objectWithKeyValues:tempStr];
    }
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
    if (self.bindZoneType == 1) {
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

- (void)setWearCnNftModel:(SudNFTCnInfoModel *)wearCnNftModel {
    _wearCnNftModel = wearCnNftModel;
    NSString *json = [wearCnNftModel mj_JSONString];
    [NSUserDefaults.standardUserDefaults setValue:json forKey:kKeyWearCnNftModelInfo];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)setWearNftModel:(SudNFTInfoModel *)wearNftModel {
    _wearNftModel = wearNftModel;
    NSString *json = [wearNftModel mj_JSONString];
    [NSUserDefaults.standardUserDefaults setValue:json forKey:kKeyWearNftModelInfo];
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
/// @param bindCnWalletModel
/// @param walletType
/// @param phone
- (void)saveWalletTokenWithBindCnWalletModel:(SudNFTBindCnWalletModel *)bindCnWalletModel walletType:(NSInteger)walletType phone:(NSString *)phone {
    // 用户手机号
    [NSUserDefaults.standardUserDefaults setValue:phone forKey:[NSString stringWithFormat:@"%@_%@", kKeyBindUserPhone, @(walletType)]];
    [NSUserDefaults.standardUserDefaults synchronize];
    // 用户token
    [NSUserDefaults.standardUserDefaults setValue:bindCnWalletModel.walletToken forKey:[NSString stringWithFormat:@"%@_%@", kKeyBindUserToken, @(walletType)]];
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

- (NSString *_Nullable)nftErrorMsg:(NSInteger)errCode errorMsg:(NSString *)errorMsg {
    
    static NSDictionary * errMsgMap = nil;
    if (!errMsgMap) {
        errMsgMap = @{
            @"1000":@"服务异常",
            @"1001":@"参数无效异常",
            @"1002":@"应用信息不存在",
            @"1003":@"应用id无效",
            @"1004":@"应用平台无效",
            @"1005":@"sdk令牌创建失败",
            @"1006":@"sdk 令牌无效",
            @"1007":@"钱包签名无效",
            @"1008":@"钱包令牌无效",
            @"1009":@"nft api配置不存在",
            @"1010":@"钱包配置不存在",
            @"1011":@"用户钱包随机数不存在",
            @"1012":@"绑定用户钱包失败",
            @"1013":@"nft url 未配置",
            @"1014":@"nft不属于用户",
            @"1015":@"nft穿戴令牌无效",
            @"1016":@"应用接入方认证请求头无效",
            @"1017":@"应用接入方认证签名无效",
            @"1018":@"应用接入方请求超时",
            @"1019":@"NFT详情令牌过期",
            @"1020":@"钱包类型不支持",
            @"1021":@"发送验证码失败",
            @"1022":@"绑定用户失败",
            @"1023":@"藏品列表获取失败",
            @"1024":@"藏品信息获取失败",
            @"1025":@"藏品不属于用户",
            @"1026":@"短信验证码发送太频繁",
            @"1027":@"手机号已被绑定",
            @"1028":@"该手机号已被其他用户绑定",
            @"1029":@"用户解绑失败",
            @"1030":@"短信验证码错误",
            @"1031":@"用户已绑定手机号",
            @"1032":@"该手机号不是该用户绑定的"
        };
    }
    NSString *key = [NSString stringWithFormat:@"%@", @(errCode)];
    NSDictionary *msg = errMsgMap[key];
    if (!msg){
        msg = errorMsg;
    }
    return [NSString stringWithFormat:@"%@(%@)", msg, key];
}

/// 是否已经穿戴
/// @param contractAddress contractAddress
/// @param tokenId tokenId
/// @return
- (BOOL)isNFTAlreadyUsed:(NSString *)contractAddress tokenId:(NSString *)tokenId {
    NSString *key = [NSString stringWithFormat:@"%@%@", kKeyUsedNFT, AppService.shared.loginUserID];
    NSString *value = [NSString stringWithFormat:@"%@_%@", contractAddress, tokenId];
    id temp = [NSUserDefaults.standardUserDefaults stringForKey:key];
    if (temp && [temp isKindOfClass:NSString.class]) {
        return [value isEqualToString:temp];
    }
    return NO;
}

/// 使用NFT
/// @param contractAddress
/// @param tokenId
- (void)useNFT:(NSString *)contractAddress tokenId:(NSString *)tokenId detailsToken:(NSString *)detailsToken add:(BOOL)add {
    NSString *key = [NSString stringWithFormat:@"%@%@", kKeyUsedNFT, AppService.shared.loginUserID];

    NSString *detailsTokenKey = [NSString stringWithFormat:@"%@%@_%@_%@", kKeyUsedNftDetailsToken, contractAddress, tokenId, AppService.shared.loginUserID].dt_md5;

    NSString *value = [NSString stringWithFormat:@"%@_%@", contractAddress, tokenId];
    if (add) {
        [NSUserDefaults.standardUserDefaults setObject:value forKey:key];
        [NSUserDefaults.standardUserDefaults setObject:detailsToken forKey:detailsTokenKey];
    } else {
        [NSUserDefaults.standardUserDefaults removeObjectForKey:key];
        [NSUserDefaults.standardUserDefaults removeObjectForKey:detailsTokenKey];
    }
    [NSUserDefaults.standardUserDefaults synchronize];
}

/// 获取使用详情token
/// @param contractAddress  contractAddress
/// @param tokenId  tokenId
/// @return
- (NSString *)detailsTokenWithContractAddress:(NSString *)contractAddress tokenId:(NSString *)tokenId {
    NSString *detailsTokenKey = [NSString stringWithFormat:@"%@%@_%@_%@", kKeyUsedNftDetailsToken, contractAddress, tokenId, AppService.shared.loginUserID].dt_md5;
    id token = [NSUserDefaults.standardUserDefaults stringForKey:detailsTokenKey];
    if (token) {
        return token;
    }
    return @"";
}

@end
