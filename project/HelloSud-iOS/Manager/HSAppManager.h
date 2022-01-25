//
//  HSAppManager.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import <UIKit/UIKit.h>
#import "HSAccountUserModel.h"

NS_ASSUME_NONNULL_BEGIN

/// APP管理模块
@interface HSAppManager : NSObject
+ (instancetype)shared;

/// 登录用户信息
@property(nonatomic, strong, readonly)HSAccountUserModel *loginUserInfo;

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
@end

NS_ASSUME_NONNULL_END
