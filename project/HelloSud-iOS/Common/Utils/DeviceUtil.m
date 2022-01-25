//
//  DeviceUtil.m
//  HelloSud-iOS
//
//  Created by 123 on 2022/1/21.
//

#import "DeviceUtil.h"

@implementation DeviceUtil

+ (NSString *)getAppVersion {
    
    NSString *version = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if (version != nil) {
        return version;
    } else {
        return @"";
    }
}

+ (NSString *)getAppBuildCode {
    NSString *buildCode = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"];
    if (buildCode != nil) {
        return buildCode;
    } else {
        return @"";
    }
}

@end
