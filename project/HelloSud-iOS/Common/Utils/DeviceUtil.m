//
//  DeviceUtil.m
//  HelloSud-iOS
//
//  Created by 123 on 2022/1/21.
//

#import "DeviceUtil.h"

@implementation DeviceUtil

+ (NSString *)getAppVersion {
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleShortVersionString"];
    if (version != nil) {
        return version;
    } else {
        return @"";
    }
}

+ (NSString *)getAppBuildCode {
    NSString *buildCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleVersion"];
    if (buildCode != nil) {
        return buildCode;
    } else {
        return @"";
    }
}

@end
