//
//  SudNFT.h
//  SudMGP
//
//  Created by kaniel on 2022/7/19.
//

#import <Foundation/Foundation.h>
#import "ISudNFTListener.h"

NS_ASSUME_NONNULL_BEGIN

@class SudNFTWalletModel;

/// NFT钱包
@interface SudNFT : NSObject

/// 初始化, 必须初始化后使用
/// @param appId 应用ID
/// @param appKey 应用key
/// @param userId 用户ID
/// @param universalLink 应用universalLink; 前面必须完整https,后面不需要/ 如：https://links.example.com
/// @param listener 结果回调
+ (void)initNFTWithAppId:(NSString *_Nonnull)appId
                  appKey:(NSString *_Nonnull)appKey
                  userId:(NSString *_Nonnull)userId
           universalLink:(NSString *_Nonnull)universalLink
                listener:(id <ISudNFTListener> _Nullable)listener;

/// 获取支持钱包列表
/// @param listener 返回支持钱包列表数据
+ (void)getWalletListWithListener:(ISudNFTGetWalletListListener _Nullable)listener;

/// 绑定钱包
/// @param walletType 钱包类型
/// @param listener 结果回调
+ (void)bindWallet:(NSInteger)walletType listener:(ISudNFTBindWalletListener)listener;

/// 获取NFT列表,必须授权成功之后才能获取NFT列表
/// @param walletAddress 钱包地址
/// @param chainType 链网类型
/// @param pageKey 分页key,首页可不传,下一页时，请求上一页返回pageKey
/// @param listener 回调
+ (void)getNFTListWithWalletAddress:(NSString *_Nonnull)walletAddress
                          chainType:(NSInteger)chainType
                            pageKey:(NSString *_Nullable)pageKey
                           listener:(ISudNFTGeNFTListListener _Nullable)listener;

/// 获取对应源数据
/// @param contractAddress 合约地址
/// @param tokenId NFT tokenId
/// @param chainType 链网类型
/// @param listener 回调
+ (void)getNFTMetadata:(NSString *)contractAddress
               tokenId:(NSString *)tokenId
             chainType:(NSInteger)chainType
              listener:(ISudNFTGeMetaDataListener)listener;

/// 生成元数据使用唯一认证token
/// @param contractAddress 合约地址
/// @param tokenId NFT tokenId
/// @param chainType 链网类型
/// @param listener 回调
+ (void)generateNFTDetailToken:(NSString *)contractAddress
                       tokenId:(NSString *)tokenId
                     chainType:(NSInteger)chainType
                      listener:(ISudNFTGenerateDetailTokenListener)listener;


/// 处理三方APP拉起时universal link
/// @param userActivity userActivity description
+ (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity;
@end

NS_ASSUME_NONNULL_END
