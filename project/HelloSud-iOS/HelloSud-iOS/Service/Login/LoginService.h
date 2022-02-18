//
//  LoginService.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/17.
//

#import <Foundation/Foundation.h>
/// token刷新通知
extern NSString * const TOKEN_REFRESH_NTF;

NS_ASSUME_NONNULL_BEGIN
/// 登录服务
@interface LoginService : NSObject

+ (instancetype)shared;

/// 请求登录
/// @param name 昵称
/// @param userID 用户ID
- (void)reqLogin:(NSString *)name userID:(nullable NSString *)userID sucess:(EmptyBlock)success;
@end

NS_ASSUME_NONNULL_END
