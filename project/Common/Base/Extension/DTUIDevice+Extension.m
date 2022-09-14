//
//  UIDevice+Extension.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/19.
//

#import "DTUIDevice+Extension.h"

@implementation UIDevice(DTDeviceExtension)

/// 设备安全区
+(UIEdgeInsets)dt_safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return [[[UIApplication sharedApplication] keyWindow] safeAreaInsets];
    } else {
        // Fallback on earlier versions
        return UIEdgeInsetsMake(20, 0, 0, 0);
    }
}

/// 是否是iPhone x系列刘海屏设备
+(BOOL)dt_isiPhoneXSeries {
    return kAppSafeTop > 20;
}
@end
