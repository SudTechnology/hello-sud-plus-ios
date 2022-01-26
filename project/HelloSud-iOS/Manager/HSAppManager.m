//
//  HSAppManager.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "HSAppManager.h"

#define kKeyLoginUserInfo @"key_login_user_info"
#define kKeyLoginAgreement @"key_login_agreement"
#define kKeyLoginIsLogin @"key_login_isLogin"

@implementation HSAppManager
+ (instancetype)shared {
    static HSAppManager *g_manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        g_manager = HSAppManager.new;
    });
    return g_manager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self config];
    }
    return self;
}

- (void)config {
    id temp = [NSUserDefaults.standardUserDefaults objectForKey:kKeyLoginUserInfo];
    if (temp && [temp isKindOfClass:NSString.class]) {
        HSAccountUserModel *m = [HSAccountUserModel mj_objectWithKeyValues:temp];
        _loginUserInfo = m;
    } else {
        HSAccountUserModel *m = HSAccountUserModel.new;
        _loginUserInfo = m;
        m.userID = [NSString stringWithFormat:@"%u", arc4random()];
        m.name = @"小公主2";
        m.icon = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi0.hdslb.com%2Fbfs%2Farticle%2F7af2c723accd90ce5c9e79471a76251ae44f0798.jpg&refer=http%3A%2F%2Fi0.hdslb.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1645674165&t=cb63922664bc54461211e0ae8acd6e95";
        m.sex = 1;
    }
    
    _isAgreement = [NSUserDefaults.standardUserDefaults boolForKey:kKeyLoginAgreement];
    _isLogin = [NSUserDefaults.standardUserDefaults boolForKey:kKeyLoginIsLogin];
}

/// 保持用户信息
- (void)saveLoginUserInfo {
    if (self.loginUserInfo) {
        NSString *jsonStr = [self.loginUserInfo mj_JSONString];
        [NSUserDefaults.standardUserDefaults setObject:jsonStr forKey:kKeyLoginUserInfo];
        [NSUserDefaults.standardUserDefaults synchronize];
    }
}

/// 保存是否同意协议
- (void)saveAgreement {
    _isAgreement = true;
    [NSUserDefaults.standardUserDefaults setBool:true forKey:kKeyLoginAgreement];
    [NSUserDefaults.standardUserDefaults synchronize];
}

/// 保存是否同意协议
- (void)saveIsLogin {
    _isLogin = true;
    [NSUserDefaults.standardUserDefaults setBool:true forKey:kKeyLoginIsLogin];
    [NSUserDefaults.standardUserDefaults synchronize];
}

@end
