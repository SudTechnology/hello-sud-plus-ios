//
//  LoginService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/17.
//

#import "LoginService.h"

/// 配置信息缓存key
#define kKeyRefreshToken [self envKey:@"key_refresh_token"]
/// 用户信息缓存key
#define kKeyLoginUserInfo [self envKey:@"key_login_user_info"]
/// 用户是否登录缓存key
#define kKeyLoginIsLogin [self envKey:@"key_login_isLogin"]
/// 用户是否登录token缓存key
#define kKeyLoginToken [self envKey:@"key_login_token"]

/// token刷新通知
NSString *const TOKEN_REFRESH_SUCCESS_NTF = @"TOKEN_REFRESH_SUCCESS_NTF";
/// token刷新失败通知
NSString *const TOKEN_REFRESH_FAIL_NTF = @"TOKEN_REFRESH_FAIL_NTF";

@implementation LoginService

+ (instancetype)shared {
    static LoginService *service = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        service = LoginService.new;
    });
    return service;
}

/// 环境隔离key
/// @param key key
/// @return
- (NSString *)envKey:(NSString *)key {
#if DEBUG
    return [NSString stringWithFormat:@"debug_%@", key];
#else
    return [NSString stringWithFormat:@"%@", key];
#endif
}

- (void)config {
    id temp = [NSUserDefaults.standardUserDefaults objectForKey:kKeyLoginUserInfo];
    if (temp && [temp isKindOfClass:NSString.class]) {
        AccountUserModel *m = [AccountUserModel mj_objectWithKeyValues:temp];
        m.userID = QSAppPreferences.shared.currentUserID;
        _loginUserInfo = m;
    } else {
        AccountUserModel *m = AccountUserModel.new;
        _loginUserInfo = m;
        m.userID = QSAppPreferences.shared.currentUserID;
        m.name = @"";
        m.icon = @"";
        m.sex = 1;
    }

    _isLogin = [NSUserDefaults.standardUserDefaults boolForKey:kKeyLoginIsLogin];
    id temp_token = [NSUserDefaults.standardUserDefaults objectForKey:kKeyLoginToken];
    if (temp_token && [temp_token isKindOfClass:NSString.class]) {
        _token = temp_token;
        [self saveIsLogin];
    }
    DDLogInfo(@"login user name:%@, userID:%@", _loginUserInfo.name, _loginUserInfo.userID);

}

/// 保存登录状态
- (void)saveIsLogin {
    _isLogin = true;
    [NSUserDefaults.standardUserDefaults setBool:true forKey:kKeyLoginIsLogin];
    [NSUserDefaults.standardUserDefaults synchronize];
}

/// 保持用户信息
- (void)saveLoginUserInfo {
    if (self.loginUserInfo) {
        NSString *jsonStr = [self.loginUserInfo mj_JSONString];
        [NSUserDefaults.standardUserDefaults setObject:jsonStr forKey:kKeyLoginUserInfo];
        [NSUserDefaults.standardUserDefaults synchronize];
        DDLogInfo(@"login user name:%@, userID:%@", _loginUserInfo.name, _loginUserInfo.userID);
    }
}

/// 保存token
- (void)saveToken:(NSString *)token {
    _token = token;
    [[AppService shared] setupNetWorkHeader];
    [NSUserDefaults.standardUserDefaults setValue:token forKey:kKeyLoginToken];
    [NSUserDefaults.standardUserDefaults synchronize];

    [[AppService shared] reqConfigData];
}

- (void)prepare {
    [self config];
}

/// 请求登录
/// @param name 昵称
/// @param userID 用户ID
- (void)reqLogin:(NSString *)name userID:(nullable NSString *)userID sucess:(EmptyBlock)success {
    NSString *deviceId = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionaryWithDictionary:@{@"nickname": name, @"deviceId": deviceId}];
    if (userID.length > 0) {
        dicParam[@"userId"] = @(userID.integerValue);
    }
    WeakSelf
    [HSHttpService postRequestWithURL:kBASEURL(@"login/v1") param:dicParam respClass:LoginModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        LoginModel *model = (LoginModel *)resp;
        /// 存储用户信息
        weakSelf.loginUserInfo.name = model.nickname;
        weakSelf.loginUserInfo.userID = [NSString stringWithFormat:@"%ld", model.userId];
        weakSelf.loginUserInfo.icon = model.avatar;

        weakSelf.loginUserInfo.sex = 1;
        [weakSelf saveLoginUserInfo];
        [weakSelf saveRefreshToken:model.refreshToken];
        [weakSelf saveToken:model.token];
        [weakSelf saveIsLogin];
        weakSelf.isRefreshedToken = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:TOKEN_REFRESH_SUCCESS_NTF object:nil];
        if (success) success();
    } failure:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TOKEN_REFRESH_FAIL_NTF object:nil];
    }];
}

- (void)checkToken {
    [self refreshToken];
}


/// 刷新token
- (void)refreshToken {
    NSString *refreshToken = [self getRefreshToken];
    if (refreshToken.length == 0) {
        NSLog(@"refreshTokenWithSuccess err, refresh token is empty");
        [[NSNotificationCenter defaultCenter] postNotificationName:TOKEN_REFRESH_FAIL_NTF object:nil];
        return;
    }
    NSDictionary *dicParam = @{@"refreshToken": refreshToken};
    WeakSelf
    [HSHttpService postRequestWithURL:kBASEURL(@"refresh-token/v1") param:dicParam respClass:RespRefreshTokenModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        RespRefreshTokenModel *model = (RespRefreshTokenModel *) resp;
        if (model.retCode != 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TOKEN_REFRESH_FAIL_NTF object:nil];
            [ToastUtil show:[model errorMsg]];
            return;
        }
        [weakSelf saveRefreshToken:model.refreshToken];
        [weakSelf saveToken:model.token];
        [weakSelf saveIsLogin];
        weakSelf.isRefreshedToken = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:TOKEN_REFRESH_SUCCESS_NTF object:nil];
    } failure:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TOKEN_REFRESH_FAIL_NTF object:nil];
    }];
}

- (void)saveRefreshToken:(NSString *)refreshToken {
    [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:kKeyRefreshToken];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (NSString *)getRefreshToken {
    return [NSUserDefaults.standardUserDefaults objectForKey:kKeyRefreshToken];
}
@end
