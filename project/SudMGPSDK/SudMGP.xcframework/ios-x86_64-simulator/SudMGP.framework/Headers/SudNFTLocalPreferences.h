//
//  SudNFTLocalPreferences.h
//  SudMGP
//
//  Created by kaniel on 2022/7/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 本地配置
@class BindWalletRespModel;

@interface SudNFTLocalPreferences : NSObject
/// 环境变量 0 release 1 dev 2 fat
@property(nonatomic, assign) int env;
@property(nonatomic, copy) NSString *appId;
@property(nonatomic, copy) NSString *appKey;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *universalLink;
@property(nonatomic, copy) NSString *walletToken;

+ (instancetype)shared;

/// 切换环境
/// @param env 默认填0:release, 1:dev 2:fat
- (void)switchEnv:(int)env;

/// 缓存钱包token
- (void)cacheWalletToken:(BindWalletRespModel *)walletRespModel walletAddress:(NSString *)walletAddress;

/// 钱包token是否有效
- (BOOL)checkWalletTokenValid;
@end

NS_ASSUME_NONNULL_END
