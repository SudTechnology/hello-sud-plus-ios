//
//  UIDevice+Extension.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/19.
//

#import "DTUIDevice+Extension.h"

@implementation UIDevice(DTDeviceExtension)

/// 设备安全区
+(UIEdgeInsets)safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return [[[UIApplication sharedApplication] keyWindow] safeAreaInsets];
    } else {
        // Fallback on earlier versions
    }
    return UIEdgeInsetsZero;
}

/// 是否是iPhone x系列刘海屏设备
+(BOOL)isiPhoneXSeries {
    return kAppSafeTop > 20;
}
@end
