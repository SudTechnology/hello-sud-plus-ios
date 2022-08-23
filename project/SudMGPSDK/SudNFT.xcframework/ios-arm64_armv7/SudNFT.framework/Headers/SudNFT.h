//
//  SudNFT.h
//  SudMGP
//
//  Created by kaniel on 2022/7/19.
//

#import <Foundation/Foundation.h>
#import "ISudNFTListener.h"

NS_ASSUME_NONNULL_BEGIN

@class SudNFTWalletInfoModel;

/// NFT钱包
@interface SudNFT : NSObject
/// 获取版本号
/// @return 返回SDK版本号
+ (NSString *)getVersion;

/// 初始化, 必须初始化后使用
/// @param paramModel 参数model
/// @param listener 结果回调
+ (void)initNFT:(SudInitNFTParamModel *)paramModel listener:(ISudNFTListenerInitNFT _Nullable)listener;

/// 获取支持钱包列表
/// @param listener 返回支持钱包列表数据
+ (void)getWalletList:(ISudNFTListenerGetWalletList _Nullable)listener;

/// 绑定钱包
/// @param paramModel 参数model
/// @param listener 结果回调
+ (void)bindWallet:(SudNFTBindWalletParamModel *)paramModel listener:(id<ISudNFTListenerBindWallet>)listener;

/// 获取NFT列表,必须授权成功之后才能获取NFT列表
/// @param paramModel 参数model
/// @param listener 回调
+ (void)getNFTList:(SudNFTGetNFTListParamModel *)paramModel listener:(ISudNFTListenerGetNFTList _Nullable)listener;

/// 生成元数据使用唯一认证token
/// @param paramModel 参数model
/// @param listener 回调
+ (void)genNFTCredentialsToken:(SudNFTCredentialsTokenParamModel *)paramModel listener:(ISudNFTListenerGenNFTCredentialsToken)listener;

/// 处理三方APP拉起时universal link
/// @param userActivity userActivity description
+ (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity;
@end

NS_ASSUME_NONNULL_END
