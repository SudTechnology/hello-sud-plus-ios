//
//  NFTHttpService.h
//  SudMGP
//
//  Created by kaniel on 2022/7/23.
//

#import <Foundation/Foundation.h>
#import "ISudNFTListener.h"
#import "ISudNFTPrivateListener.h"

NS_ASSUME_NONNULL_BEGIN
/// NFT相关Http接口服务
@interface SudNFTHttpService : NSObject
@property(nonatomic, strong) SDKGetTokenRespModel *sdkTokenModel;

+ (instancetype)shared;

/// 获取token
/// @param appId appId description
/// @param appKey appKey description
/// @param userId userId description
/// @param bundleId bundleId description
/// @param listener listener description
- (void)reqSDKTokenWithAppId:(NSString *)appId appKey:(NSString *)appKey userId:(NSString *)userId bundleId:(NSString *)bundleId listener:(ISudNFTCommonListener)listener;

/// 获取钱包列表
/// @param listener 钱包列表
- (void)reqWalletListWithListener:(ISudNFTGetWalletListListener)listener;

/// 绑定钱包
/// @param userId 用户ID
/// @param walletAddress 钱包地址
/// @param sign 前面
/// @param listener listener description
- (void)reqBindWallet:(NSString *)userId walletAddress:(NSString *)walletAddress sign:(NSString *)sign listener:(ISudNFTReqBindWalletListener)listener;


/// 获取对应钱包NFT列表
/// @param walletToken 获取NFT对应用户钱包token
/// @param chainType 链网类型
/// @param walletAddress 钱包地址
/// @param pageKey 分页
/// @param listener listener description
- (void)reqNFTList:(NSString *)walletToken chainType:(NSInteger)chainType walletAddress:(NSString *)walletAddress pageKey:(NSString *)pageKey listener:(ISudNFTReqNFTListListener)listener;

/// 获取NFT对应元数据
/// @param walletToken 钱包token
/// @param chainType 链网类型
/// @param contractAddress 合约地址
/// @param tokenId NFT的tokenId
/// @param listener listener description
- (void)reqNFTMetaData:(NSString *)walletToken chainType:(NSInteger)chainType contractAddress:(NSString *)contractAddress tokenId:(NSString *)tokenId listener:(ISudNFTGeMetaDataListener)listener;

/// 获取NFT元数据详情token
/// @param walletToken 钱包token
/// @param chainType 链网类型
/// @param contractAddress 合约地址
/// @param tokenId NFT的tokenId
/// @param listener listener description
- (void)reqNFTDetailToken:(NSString *)walletToken chainType:(NSInteger)chainType contractAddress:(NSString *)contractAddress tokenId:(NSString *)tokenId listener:(ISudNFTReqGenerateDetailNFTTokenListener)listener;
@end

NS_ASSUME_NONNULL_END
