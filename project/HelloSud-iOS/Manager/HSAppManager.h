//
//  HSAppManager.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import <UIKit/UIKit.h>
#import "HSAccountUserModel.h"
#import "HSConfigModel.h"

NS_ASSUME_NONNULL_BEGIN

/// APP管理模块
@interface HSAppManager : NSObject
/// 登录用户信息
@property(nonatomic, strong, readonly) HSAccountUserModel *loginUserInfo;
/// token
@property(nonatomic, copy, readonly) NSString *token;
/// 配置信息
@property(nonatomic, strong) HSConfigData *configData;

+ (instancetype)shared;

/// 保持用户信息
- (void)saveLoginUserInfo;

/// 是否同意登录协议
@property(nonatomic, assign, readonly) BOOL isAgreement;

/// 保存是否同意协议
- (void)saveAgreement;

/// 是否已经登录
@property(nonatomic, assign, readonly) BOOL isLogin;

/// 保存是否同意协议
- (void)saveIsLogin;

/// 随机名字
- (NSString *)randomUserName;

/// 设置请求header
- (void)setupNetWorkHeader;

/// 保存token
- (void)saveToken:(NSString *)token;

/// 刷新token
- (void)refreshToken;

/// 请求登录
/// @param name 昵称
/// @param userID 用户ID
- (void)reqLogin:(NSString *)name userID:(nullable NSString *)userID sucess:(EmptyBlock)success;

/// APP隐私协议地址
- (NSURL *)appPrivacyURL;
/// APP用户协议
- (NSURL *)appProtocolURL;
@end

NS_ASSUME_NONNULL_END
