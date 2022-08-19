//
//  ISudListenerNFT.h
//  Pods
//
//  Created by kaniel on 2022/7/19.
//

#ifndef ISudListenerNFT_h
#define ISudListenerNFT_h

#import <Foundation/Foundation.h>
#import "SudNFTModels.h"
/// 错误码:
///    -1 sdk 参数异常
///    0	success	成功
///    1000	internal service exception	服务异常
///    1001	parameters invalid	参数无效异常
///    1002	app info not exists	应用信息不存在
///    1003	app id invalid	应用id无效
///    1004	app platform invalid	应用平台无效
///    1005	sdk token create failed	sdk令牌创建失败
///    1006	sdk token invalid	sdk 令牌无效
///    1007	wallet sign invalid	钱包签名无效
///    1008	wallet token invalid	钱包令牌无效
///    1009	nft api config not exists	nft api配置不存在
///    1010	app wallet config not exists	钱包配置不存在
///    1011	user wallet nonce not exists	用户钱包随机数不存在
///    1012	bind user wallet failed	绑定用户钱包失败
///    1013	nft api not config	nft url 未配置

typedef void(^ISudNFTListenerInitNFT)(NSInteger errCode, NSString *_Nullable errMsg);

typedef void(^ISudNFTListenerGetWalletList)(NSInteger errCode, NSString *_Nullable errMsg, SudNFTGetWalletListModel *_Nullable walletListModel);

typedef void(^ISudNFTListenerGetNFTList)(NSInteger errCode, NSString *_Nullable errMsg, SudNFTGetNFTListModel *_Nullable nftListModel);

typedef void(^ISudNFTListenerBindWallet)(NSInteger errCode, NSString *_Nullable errMsg, SudNFTBindWalletModel *_Nullable walletInfoModel);

typedef void(^ISudNFTListenerGenNFTCredentialsToken)(NSInteger errCode, NSString *_Nullable errMsg, SudNFTGenNFTCredentialsTokenModel *_Nullable generateDetailTokenModel);

#endif /* ISudListenerNFT_h */
