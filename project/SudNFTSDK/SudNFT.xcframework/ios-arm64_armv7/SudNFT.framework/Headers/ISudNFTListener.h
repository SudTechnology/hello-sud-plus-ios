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

typedef void(^ISudNFTListenerInitNFT)(NSInteger errCode, NSString *_Nullable errMsg);

typedef void(^ISudNFTListenerGetWalletList)(NSInteger errCode, NSString *_Nullable errMsg, SudNFTGetWalletListModel *_Nullable walletListModel);

typedef void(^ISudNFTListenerGetNFTList)(NSInteger errCode, NSString *_Nullable errMsg, SudNFTGetNFTListModel *_Nullable nftListModel);

typedef void(^ISudNFTListenerGenNFTCredentialsToken)(NSInteger errCode, NSString *_Nullable errMsg, SudNFTGenNFTCredentialsTokenModel *_Nullable generateDetailTokenModel);

typedef void(^ISudNFTListenerUnbindWallet)(NSInteger errCode, NSString *_Nullable errMsg);

typedef void(^ISudNFTListenerRemoveNFTCredentialsToken)(NSInteger errCode, NSString *_Nullable errMsg);

typedef void(^ISudNFTListenerRefreshWalletToken)(NSInteger errCode, NSString *_Nullable errMsg, SudNFTRefreshWalletTokenModel *_Nullable resp);

typedef void(^ISudNFTListenerSendSmsCode)(NSInteger errCode, NSString *_Nullable errMsg);

typedef void(^ISudNFTListenerBindCnWallet)(NSInteger errCode, NSString *_Nullable errMsg, SudNFTBindCnWalletModel *_Nullable resp);

typedef void(^ISudNFTListenerUnBindCnWallet)(NSInteger errCode, NSString *_Nullable errMsg);

typedef void(^ISudNFTListenerGetCnNFTList)(NSInteger errCode, NSString *_Nullable errMsg, SudNFTGetCnNFTListModel *_Nullable resp);

typedef void(^ISudNFTListenerCnGenNFTCredentialsToken)(NSInteger errCode, NSString *_Nullable errMsg, SudNFTCnCredentialsTokenModel *_Nullable resp);

typedef void(^ISudNFTListenerRemoveNFTCnCredentialsToken)(NSInteger errCode, NSString *_Nullable errMsg);

typedef void(^ISudNFTListenerRefreshCnWalletToken)(NSInteger errCode, NSString *_Nullable errMsg, SudNFTRefreshCnWalletTokenModel *_Nullable resp);

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
