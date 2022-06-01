//
//  DeviceUtil.m
//  HelloSud-iOS
//
//  Created by 123 on 2022/1/21.
//

#import "DeviceUtil.h"
#import <AVFoundation/AVFoundation.h>>

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

+ (NSString *)getIdfv {
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}

+ (NSString *)getSystemVersion {
    return [UIDevice currentDevice].systemVersion;
}


/// 检测权限
/// @param result 结果回调
+ (void)checkMicAuth:(void(^)(BOOL isAuth))result {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status != AVAuthorizationStatusAuthorized) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    result(granted);
                });
            }
        }];
        return;
    }
    if (result) {
        result(YES);
    }
}

@end
