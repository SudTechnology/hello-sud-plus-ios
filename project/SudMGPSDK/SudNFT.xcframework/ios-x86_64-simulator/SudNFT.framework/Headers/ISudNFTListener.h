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

typedef void(^ISudNFTListenerGenNFTCredentialsToken)(NSInteger errCode, NSString *_Nullable errMsg, SudNFTGenNFTCredentialsTokenModel *_Nullable generateDetailTokenModel);

typedef void(^ISudNFTListenerSendSmsCode)(NSInteger errCode, NSString *_Nullable errMsg);

typedef void(^ISudNFTListenerBindCnWallet)(NSInteger errCode, NSString *_Nullable errMsg, SudNFTBindCnWalletModel *_Nullable resp);

typedef void(^ISudNFTListenerUnBindCnWallet)(NSInteger errCode, NSString *_Nullable errMsg);

typedef void(^ISudNFTListenerGetCnNFTList)(NSInteger errCode, NSString *_Nullable errMsg, SudNFTGetCnNFTListModel *_Nullable resp);

typedef void(^ISudNFTListenerCnGenNFTCredentialsToken)(NSInteger errCode, NSString *_Nullable errMsg, SudNFTCnCredentialsTokenModel *_Nullable resp);

/// 钱包绑定状态类型
typedef NS_ENUM(NSInteger, ISudNFTBindWalletStageType) {
    /// 连接钱包
    ISudNFTBindWalletStageTypeConnect = 1,
    /// 钱包签名
    ISudNFTBindWalletStageTypeSign = 2,
};

/// 钱包绑定事件类型
typedef NS_ENUM(NSInteger, ISudNFTBindWalletStageEventType) {
    /// 连接钱包开始
    ISudNFTBindWalletStageEventTypeConnectStarted = 1,
    /// 连接钱包结束
    ISudNFTBindWalletStageEventTypeConnectEnd = 2,
    /// 钱包签名开始
    ISudNFTBindWalletStageEventTypeSignStarted = 3,
    /// 钱包签名结束
    ISudNFTBindWalletStageEventTypeSignEnd = 4,
};

@protocol ISudNFTListenerBindWallet <NSObject>
@optional
/// 绑定钱包成功回调
/// @param walletInfoModel 成功回调
- (void)onSuccess:(SudNFTBindWalletModel *_Nullable)walletInfoModel;

/// 绑定钱包
- (void)onFailure:(NSInteger)errCode errMsg:(NSString *_Nullable)errMsg;

/// 钱包绑定事件通知，可以使用此状态做交互状态展示
/// @param stage 1: 连接；2：签名
/// @param event 1：连接开始；2 成功连接钱包；3：签名开始；4:签名结束
- (void)onBindStageEvent:(NSInteger)stage event:(NSInteger)event;

/// 绑定步骤顺序列表
/// @param stageList 对应状态事件列表，如：[1, 2]
- (void)onBindStageList:(NSArray <NSNumber *> *_Nullable)stageList;
@end

#endif /* ISudListenerNFT_h */
