//
//  LoginService.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/17.
//

#import <Foundation/Foundation.h>

/// token刷新成功通知
extern NSString *const TOKEN_REFRESH_SUCCESS_NTF;
/// token刷新失败通知
extern NSString *const TOKEN_REFRESH_FAIL_NTF;
/// 钱包token失效
extern NSString *const WALLET_BIND_TOKEN_EXPIRED_NTF;
/// NFT刷新
extern NSString *const NFT_REFRESH_NFT;

NS_ASSUME_NONNULL_BEGIN

/// 登录服务
@interface LoginService : NSObject

/// 是否已经登录
@property(nonatomic, assign, readonly) BOOL isLogin;
/// 是否已经刷新token
@property(nonatomic, assign) BOOL isRefreshedToken;
/// 登录用户信息
@property(nonatomic, strong, readonly) AccountUserModel *loginUserInfo;
/// token
@property(nonatomic, copy, readonly) NSString *token;


- (void)prepare;

/// 请求登录
/// @param name 昵称
/// @param userID 用户ID
- (void)reqLogin:(NSString *)name userID:(nullable NSString *)userID sucess:(EmptyBlock)success;

- (void)checkToken;

/// 保持用户信息
- (void)saveLoginUserInfo;
@end

NS_ASSUME_NONNULL_END
