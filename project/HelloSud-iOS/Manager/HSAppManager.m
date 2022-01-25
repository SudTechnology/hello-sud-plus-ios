//
//  HSAppManager.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "HSAppManager.h"

#define kKeyLoginUserInfo @"key_login_usre_info"

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
        m.userID = @"123";
        m.name = @"kaniel";
        m.icon = @"";
        m.sex = 1;
    }
}

/// 保持用户信息
- (void)saveLoginUserInfo {
    if (self.loginUserInfo) {
        NSString *jsonStr = [self.loginUserInfo mj_JSONString];
        [NSUserDefaults.standardUserDefaults setObject:jsonStr forKey:kKeyLoginUserInfo];
        [NSUserDefaults.standardUserDefaults synchronize];
    }
}
@end
