//
//  LoginService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/17.
//

#import "LoginService.h"
/// token刷新通知
NSString *const TOKEN_REFRESH_NTF = @"TOKEN_REFRESH_NTF";

@implementation LoginService

+ (instancetype)shared {
    static LoginService *service = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        service = LoginService.new;
    });
    return service;
}

/// 请求登录
/// @param name 昵称
/// @param userID 用户ID
- (void)reqLogin:(NSString *)name userID:(nullable NSString *)userID sucess:(EmptyBlock)success {
    NSString *deviceId = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionaryWithDictionary:@{@"nickname": name, @"deviceId": deviceId}];
    if (userID.length > 0) {
        dicParam[@"userId"] = [NSNumber numberWithInteger:userID.integerValue];
    }
    [HttpService postRequestWithApi:kBASEURL(@"login/v1") param:dicParam success:^(NSDictionary *rootDict) {
        LoginModel *model = [LoginModel decodeModel:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.retMsg];
            return;
        }
        /// 存储用户信息
        AppManager.shared.loginUserInfo.name = model.nickname;
        AppManager.shared.loginUserInfo.userID = [NSString stringWithFormat:@"%ld", model.userId];
        AppManager.shared.loginUserInfo.icon = model.avatar;
        
        AppManager.shared.loginUserInfo.sex = 1;
        [AppManager.shared saveLoginUserInfo];
        
        [AppManager.shared saveToken: model.token];
        [AppManager.shared saveIsLogin];
        AppManager.shared.isRefreshedToken = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:TOKEN_REFRESH_NTF object:nil];
        if (success) success();
    } failure:^(id error) {
        [ToastUtil show:@"网络错误"];
    }];
}
@end
