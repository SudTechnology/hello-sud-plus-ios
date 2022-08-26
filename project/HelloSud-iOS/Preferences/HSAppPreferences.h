//
// Created by kaniel on 2022/7/29.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const MY_ETHEREUM_CHAINS_SELECT_CHANGED_NTF;
extern NSString *const MY_NFT_WEAR_CHANGE_NTF;
extern NSString *const MY_NFT_BIND_WALLET_CHANGE_NTF;

/// 应用本地配置
@interface HSAppPreferences : NSObject
/// 绑定钱包类型
@property (nonatomic, assign)NSInteger bindWalletType;
/// 选择链网类型
@property (nonatomic, assign)NSInteger selectedEthereumChainType;
/// 绑定钱包
@property(nonatomic, copy, nullable) NSString *walletAddress;
@property (nonatomic, strong)NSString *nftListPageKey;
+ (instancetype)shared;
- (NSString *)walletToken;
/// 缓存钱包token
- (void)cacheWalletToken:(SudNFTBindWalletModel *)walletRespModel walletAddress:(NSString *)walletAddress;
@end
