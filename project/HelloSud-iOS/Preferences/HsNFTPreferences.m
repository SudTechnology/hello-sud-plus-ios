//
// Created by kaniel on 2022/7/29.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HsNFTPreferences.h"

#define kKeyEtherChains @"kKeyEtherChains"

NSString *const MY_ETHEREUM_CHAINS_SELECT_CHANGED_NTF = @"MY_ETHEREUM_CHAINS_SELECT_CHANGED_NTF";
NSString *const MY_NFT_WEAR_CHANGE_NTF = @"MY_NFT_WEAR_CHANGE_NTF";
NSString *const MY_NFT_BIND_WALLET_CHANGE_NTF = @"MY_NFT_BIND_WALLET_CHANGE_NTF";
NSString *const MY_NFT_WALLET_TYPE_CHANGE_NTF = @"MY_NFT_WALLET_TYPE_CHANGE_NTF";
/// 房间列表更新通知
NSString *const MY_NFT_WALLET_LIST_UPDATE_NTF = @"MY_NFT_WALLET_LIST_UPDATE_NTF";
/// 我的页面切换提示气泡状态通知
NSString *const MY_SWITCH_TIP_STATE_CHANGED_NTF = @"MY_SWITCH_TIP_STATE_CHANGED_NTF";

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
/// 穿戴的国内NFT详情信息
#define kKeyWearCnNftModelInfo [self envKey:@"kKeyWearCnNftModelInfo"]
/// 穿戴的NFT详情信息
#define kKeyWearNftModelInfo [self envKey:@"kKeyWearNftModelInfo"]
/// 提示切换地址Key
#define kKeyTipChangeWalletAddress [self envKey:@"kKeyTipChangeWalletAddress"]
/// 提示切换链Key
#define kKeyTipChangeChain [self envKey:@"kKeyTipChangeChain"]

/// 穿戴集合
#define kKeyWearMap [self envKey:@"kKeyWearMap"]

@interface HsNFTPreferences ()

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
    _selectedEthereumChainType = [NSUserDefaults.standardUserDefaults integerForKey:kKeySelectedEthereumChain];
    id tempBindZoneType = [NSUserDefaults.standardUserDefaults objectForKey:kKeyBindWalletZone];
    if (tempBindZoneType) {
        _bindZoneType = [NSUserDefaults.standardUserDefaults integerForKey:kKeyBindWalletZone];
    }

    _currentWalletType = [NSUserDefaults.standardUserDefaults integerForKey:kKeyCurrentSelectedWallet];
    NSString *key = [self currentUserWalletTokenKey];
    NSDictionary *userWalletMap = [NSUserDefaults.standardUserDefaults objectForKey:key];
    NSArray *arrKeys = [userWalletMap allKeys];
    id tempStr = [NSUserDefaults.standardUserDefaults objectForKey:kKeyWearCnNftModelInfo];
    if (tempStr) {
        _wearCnNftModel = [SudNFTCnInfoModel.class mj_objectWithKeyValues:tempStr];
    }
    tempStr = [NSUserDefaults.standardUserDefaults objectForKey:kKeyWearNftModelInfo];
    if (tempStr) {
        _wearNftModel = [SudNFTInfoModel.class mj_objectWithKeyValues:tempStr];
    }
    _isShowedSwitchWalletAddress = [NSUserDefaults.standardUserDefaults boolForKey:kKeyTipChangeWalletAddress];
    _isShowedSwitchChain = [NSUserDefaults.standardUserDefaults boolForKey:kKeyTipChangeChain];
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
    return [self isBindWalletWithType:self.currentWalletType];
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
    if (self.bindZoneType == 0) {
        return YES;
    }
    return NO;
}

/// 判断指定钱包是否绑定
/// @param walletType
/// @return
- (BOOL)isBindWalletWithType:(NSInteger)walletType {
    return [self getBindUserTokenByWalletType:walletType].length > 0;
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

- (void)setIsShowedSwitchWalletAddress:(BOOL)isShowedSwitchWalletAddress {
    _isShowedSwitchWalletAddress = isShowedSwitchWalletAddress;
    [NSUserDefaults.standardUserDefaults setBool:isShowedSwitchWalletAddress forKey:kKeyTipChangeWalletAddress];
    [NSUserDefaults.standardUserDefaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:MY_SWITCH_TIP_STATE_CHANGED_NTF object:nil userInfo:nil];
}

- (void)setIsShowedSwitchChain:(BOOL)isShowedSwitchChain {
    _isShowedSwitchChain = isShowedSwitchChain;
    [NSUserDefaults.standardUserDefaults setBool:isShowedSwitchChain forKey:kKeyTipChangeChain];
    [NSUserDefaults.standardUserDefaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:MY_SWITCH_TIP_STATE_CHANGED_NTF object:nil userInfo:nil];
}

- (NSString *)currentWalletToken {
    return [self getBindUserTokenByWalletType:self.currentWalletType];
}

/// 当前钱包地址
- (NSString *)currentWalletAddress {
    return [self getBindWalletAddressByWalletType:self.currentWalletType];
}

/// 缓存钱包token
- (void)saveWalletToken:(SudNFTBindWalletModel *)walletRespModel walletType:(NSInteger)walletType walletAddress:(NSString *)walletAddress {
    if (walletAddress && walletRespModel) {
        // 本地持久化
        // 用户token
        [NSUserDefaults.standardUserDefaults setValue:walletRespModel.walletToken forKey:[NSString stringWithFormat:@"%@_%@", kKeyBindUserToken, @(walletType)]];
        // 绑定钱包地址
        [NSUserDefaults.standardUserDefaults setValue:walletAddress forKey:[NSString stringWithFormat:@"%@_%@", kKeyBindWallet, @(walletType)]];
        [NSUserDefaults.standardUserDefaults synchronize];
    }
}

/// 通过钱包类型获取绑定地址
/// @param walletType
/// @return
- (NSString *)getBindWalletAddressByWalletType:(NSInteger)walletType {
    return [NSUserDefaults.standardUserDefaults objectForKey:[NSString stringWithFormat:@"%@_%@", kKeyBindWallet, @(walletType)]];
}

- (NSString *)currentUserWalletTokenKey {
    return kWalletTokenKey;
}

- (void)setCurrentWalletType:(NSInteger)currentWalletType {
    _currentWalletType = currentWalletType;
    [NSUserDefaults.standardUserDefaults setInteger:currentWalletType forKey:kKeyCurrentSelectedWallet];
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
- (void)clearBindInfoWithWalletType:(NSInteger)walletType {
    // 移除绑定用户手机号
    [NSUserDefaults.standardUserDefaults removeObjectForKey:[NSString stringWithFormat:@"%@_%@", kKeyBindUserPhone, @(walletType)]];
    // 移除绑定用户token
    [NSUserDefaults.standardUserDefaults removeObjectForKey:[NSString stringWithFormat:@"%@_%@", kKeyBindUserToken, @(walletType)]];
    // 移除绑定钱包地址
    [NSUserDefaults.standardUserDefaults removeObjectForKey:[NSString stringWithFormat:@"%@_%@", kKeyBindWallet, @(walletType)]];
}

- (NSString *_Nullable)nftErrorMsg:(NSInteger)errCode errorMsg:(NSString *)errorMsg {

    static NSDictionary *errMsgMap = nil;
    if (!errMsgMap) {
        errMsgMap = @{
                @"1000": @"服务异常",
                @"1001": @"参数无效异常",
                @"1002": @"应用信息不存在",
                @"1003": @"应用id无效",
                @"1004": @"应用平台无效",
                @"1005": @"sdk令牌创建失败",
                @"1006": @"sdk 令牌无效",
                @"1007": @"钱包签名无效",
                @"1008": @"钱包令牌无效",
                @"1009": @"nft api配置不存在",
                @"1010": @"钱包配置不存在",
                @"1011": @"用户钱包随机数不存在",
                @"1012": @"绑定用户钱包失败",
                @"1013": @"nft url 未配置",
                @"1014": @"nft不属于用户",
                @"1015": @"nft穿戴令牌无效",
                @"1016": @"应用接入方认证请求头无效",
                @"1017": @"应用接入方认证签名无效",
                @"1018": @"应用接入方请求超时",
                @"1019": @"NFT详情令牌过期",
                @"1020": @"钱包类型不支持",
                @"1021": @"发送验证码失败",
                @"1022": @"绑定用户失败",
                @"1023": @"藏品列表获取失败",
                @"1024": @"藏品信息获取失败",
                @"1025": @"藏品不属于用户",
                @"1026": @"短信验证码发送太频繁",
                @"1027": @"手机号已被绑定",
                @"1028": @"该手机号已被其他用户绑定",
                @"1029": @"用户解绑失败",
                @"1030": @"短信验证码错误",
                @"1031": @"用户已绑定手机号",
                @"1032": @"该手机号不是该用户绑定的"
        };
    }
    NSString *key = [NSString stringWithFormat:@"%@", @(errCode)];
    NSDictionary *msg = errMsgMap[key];
    if (!msg) {
        msg = errorMsg;
    }
    return [NSString stringWithFormat:@"%@(%@)", msg, key];
}

/// 是否已经穿戴
/// @param contractAddress contractAddress
/// @param tokenId tokenId
/// @return
- (BOOL)isNFTAlreadyUsed:(NSString *)contractAddress tokenId:(NSString *)tokenId {

    NSMutableDictionary *wearDic = NSMutableDictionary.new;
    id temp = [NSUserDefaults.standardUserDefaults objectForKey:kKeyWearMap];
    if (temp && [temp isKindOfClass:NSDictionary.class]) {
        [wearDic setDictionary:temp];
    }
    NSString *currentWalletTypeKey = [NSString stringWithFormat:@"%@",@(self.currentWalletType)];
    NSDictionary *currentWalletWearInfo = wearDic[currentWalletTypeKey];
    if (currentWalletWearInfo &&
            [currentWalletWearInfo[@"contractAddress"] isEqualToString:contractAddress] &&
            [currentWalletWearInfo[@"tokenId"] isEqualToString:tokenId]
            ) {
        return YES;
    }
    return NO;
}

/// 使用NFT
/// @param contractAddress
/// @param tokenId
- (void)useNFT:(NSString *)contractAddress tokenId:(NSString *)tokenId detailsToken:(NSString *)detailsToken add:(BOOL)add {

    NSMutableDictionary *wearDic = NSMutableDictionary.new;
    id temp = [NSUserDefaults.standardUserDefaults objectForKey:kKeyWearMap];
    if (temp && [temp isKindOfClass:NSDictionary.class]) {
        [wearDic setDictionary:temp];
    }
    NSString *currentWalletTypeKey = [NSString stringWithFormat:@"%@",@(self.currentWalletType)];

    if (add) {
        NSMutableDictionary *currentWalletWearInfo = NSMutableDictionary.new;
        currentWalletWearInfo[@"contractAddress"] = contractAddress;
        currentWalletWearInfo[@"tokenId"] = tokenId;
        currentWalletWearInfo[@"detailsToken"] = detailsToken;
        wearDic[currentWalletTypeKey] = currentWalletWearInfo;
        [NSUserDefaults.standardUserDefaults setObject:wearDic forKey:kKeyWearMap];
    } else {
        [NSUserDefaults.standardUserDefaults setObject:nil forKey:kKeyWearMap];
    };
    [NSUserDefaults.standardUserDefaults synchronize];
}

/// 获取使用详情token
/// @param contractAddress  contractAddress
/// @param tokenId  tokenId
/// @return
- (NSString *)detailsTokenWithContractAddress:(NSString *)contractAddress tokenId:(NSString *)tokenId {

    NSMutableDictionary *wearDic = NSMutableDictionary.new;
    id temp = [NSUserDefaults.standardUserDefaults objectForKey:kKeyWearMap];
    if (temp && [temp isKindOfClass:NSDictionary.class]) {
        [wearDic setDictionary:temp];
    }
    NSString *currentWalletTypeKey = [NSString stringWithFormat:@"%@",@(self.currentWalletType)];
    NSDictionary *currentWalletWearInfo = wearDic[currentWalletTypeKey];
    id token = currentWalletWearInfo[@"detailsToken"];
    if (token) {
        return token;
    }
    return @"";
}

/// 是否当前穿戴来源于当前钱包
/// @param walletType
/// @return
- (BOOL)isCurrentWearFromWalletType:(NSInteger)walletType {
    NSMutableDictionary *wearDic = NSMutableDictionary.new;
    id temp = [NSUserDefaults.standardUserDefaults objectForKey:kKeyWearMap];
    if (temp && [temp isKindOfClass:NSDictionary.class]) {
        [wearDic setDictionary:temp];
    }
    NSString *currentWalletTypeKey = [NSString stringWithFormat:@"%@",@(walletType)];
    NSDictionary *currentWalletWearInfo = wearDic[currentWalletTypeKey];
    if (currentWalletWearInfo) {
        return YES;
    }
    return NO;
}

@end
