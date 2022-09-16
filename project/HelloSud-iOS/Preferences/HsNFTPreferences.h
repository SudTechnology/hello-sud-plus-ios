//
// Created by kaniel on 2022/7/29.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const MY_ETHEREUM_CHAINS_SELECT_CHANGED_NTF;
extern NSString *const MY_NFT_WEAR_CHANGE_NTF;
extern NSString *const MY_NFT_BIND_WALLET_CHANGE_NTF;
extern NSString *const MY_NFT_WALLET_TYPE_CHANGE_NTF;

/// 房间列表更新通知
extern NSString *const MY_NFT_WALLET_LIST_UPDATE_NTF;
/// 我的页面切换提示气泡状态通知
extern NSString *const MY_SWITCH_TIP_STATE_CHANGED_NTF;

/// 应用本地配置
@interface HsNFTPreferences : NSObject

/// 选择链网类型
@property(nonatomic, assign) NSInteger selectedEthereumChainType;
@property(nonatomic, strong) NSString *nftListPageKey;
/// 绑定钱包区域 0海外 1国内
@property(nonatomic, assign) NSInteger bindZoneType;
/// 当前选中钱包
@property(nonatomic, assign) NSInteger currentWalletType;
/// 穿戴数据详情信息
@property(nonatomic, strong) SudNFTInfoModel *wearNftModel;
/// 穿戴国内数据详情信息
@property(nonatomic, strong) SudNFTCnInfoModel *wearCnNftModel;
/// 是否已经展示过切换
@property (nonatomic, assign)BOOL isShowedSwitchWalletAddress;
/// 是否已经展示过切换链
@property (nonatomic, assign)BOOL isShowedSwitchChain;

+ (instancetype)shared;

/// 当前海外钱包token
- (NSString *)currentWalletToken;

/// 当前海外钱包地址
- (NSString *)currentWalletAddress;

/// 缓存钱包token
- (void)saveWalletToken:(SudNFTBindWalletModel *)walletRespModel walletType:(NSInteger)walletType walletAddress:(NSString *)walletAddress;

/// 通过钱包类型获取绑定地址
/// @param walletType walletType
/// @return
- (NSString *)getBindWalletAddressByWalletType:(NSInteger)walletType;

/// 保存绑定用户信息
/// @param bindCnWalletModel bindUserModel
/// @param walletType walletType
/// @param phone phone
- (void)saveWalletTokenWithBindCnWalletModel:(SudNFTBindCnWalletModel *)bindCnWalletModel walletType:(NSInteger)walletType phone:(NSString *)phone;

/// 国内钱包token
/// @param walletType walletType
/// @return xx
- (NSString *)getBindUserTokenByWalletType:(NSInteger)walletType;

/// 通过钱包获取绑定用户手机号
/// @param walletType walletType
/// @return xx
- (NSString *)getBindUserPhoneByWalletType:(NSInteger)walletType;

/// 清除绑定用户信息
/// @param walletType walletType
- (void)clearBindInfoWithWalletType:(NSInteger)walletType;

/// 是否已经绑定了钱包
- (BOOL)isBindWallet;

/// 是否绑定了国内钱包
- (BOOL)isBindCNWallet;

/// 是否绑定了海外钱包
- (BOOL)isBindForeignWallet;

/// 判断指定钱包是否绑定
/// @param walletType
/// @return
- (BOOL)isBindWalletWithType:(NSInteger)walletType;

- (NSString *_Nullable)nftErrorMsg:(NSInteger)errCode errorMsg:(NSString *)errorMsg;

/// 是否已经穿戴
/// @param contractAddress contractAddress
/// @param tokenId tokenId
/// @return
- (BOOL)isNFTAlreadyUsed:(NSString *)contractAddress tokenId:(NSString *)tokenId;

/// 使用NFT
/// @param contractAddress
/// @param tokenId
- (void)useNFT:(NSString *)contractAddress tokenId:(NSString *)tokenId detailsToken:(NSString *)detailsToken add:(BOOL)add;

/// 获取使用详情token
/// @param contractAddress  contractAddress
/// @param tokenId  tokenId
/// @return
- (NSString *)detailsTokenWithContractAddress:(NSString *)contractAddress tokenId:(NSString *)tokenId;
@end
