//
// Created by kaniel on 2022/7/29.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const MY_ETHEREUM_CHAINS_SELECT_CHANGED_NTF;
extern NSString *const MY_NFT_WEAR_CHANGE_NTF;
extern NSString *const MY_NFT_BIND_WALLET_CHANGE_NTF;
/// 房间列表更新通知
extern NSString *const MY_NFT_WALLET_LIST_UPDATE_NTF;

/// 应用本地配置
@interface HSAppPreferences : NSObject
/// 绑定钱包类型
@property(nonatomic, assign) NSInteger bindWalletType;
/// 选择链网类型
@property(nonatomic, assign) NSInteger selectedEthereumChainType;
/// 绑定钱包
@property(nonatomic, copy, nullable) NSString *walletAddress;
@property(nonatomic, strong) NSString *nftListPageKey;
/// 绑定钱包区域 0海外 1国内
@property(nonatomic, assign) NSInteger bindZoneType;

/// 当前选中钱包
@property(nonatomic, assign) NSInteger currentSelectedWalletType;

+ (instancetype)shared;

- (NSString *)walletToken;

/// 缓存钱包token
- (void)cacheWalletToken:(SudNFTBindWalletModel *)walletRespModel walletAddress:(NSString *)walletAddress;

/// 保存绑定用户信息
/// @param bindCnWalletModel bindUserModel
/// @param walletType walletType
/// @param phone phone
- (void)saveWalletTokenWithBindCnWalletModel:(SudNFTBindCnWalletModel *)bindCnWalletModel walletType:(NSInteger)walletType phone:(NSString *)phone;

/// 通过钱包获取绑定用户token
/// @param walletType walletType
/// @return xx
- (NSString *)getBindUserTokenByWalletType:(NSInteger)walletType;

/// 通过钱包获取绑定用户手机号
/// @param walletType walletType
/// @return xx
- (NSString *)getBindUserPhoneByWalletType:(NSInteger)walletType;

/// 清除绑定用户信息
/// @param walletType walletType
- (void)clearBindUserInfoWithWalletType:(NSInteger)walletType;

/// 是否已经绑定了钱包
- (BOOL)isBindWallet;

/// 是否绑定了国内钱包
- (BOOL)isBindCNWallet;

/// 是否绑定了海外钱包
- (BOOL)isBindForeignWallet;
@end
