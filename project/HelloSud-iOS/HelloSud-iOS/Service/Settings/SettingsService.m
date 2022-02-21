//
//  SettingsService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/17.
//

#import "SettingsService.h"

@implementation SettingsService

/// APP隐私协议地址
+ (NSURL *)appPrivacyURL {
    NSString *path = [NSBundle.mainBundle pathForResource:@"user_privacy" ofType:@"html" inDirectory:@"Res"];
    return [NSURL fileURLWithPath:path];
}
/// APP用户协议
+ (NSURL *)appProtocolURL {
    NSString *path = [NSBundle.mainBundle pathForResource:@"user_protocol" ofType:@"html" inDirectory:@"Res"];
    return [NSURL fileURLWithPath:path];
}
/// 开源协议
+ (NSURL *)appLicenseURL {
    NSString *path = [NSBundle.mainBundle pathForResource:@"license" ofType:@"html" inDirectory:@"Res"];
    return [NSURL fileURLWithPath:path];
}
@end
