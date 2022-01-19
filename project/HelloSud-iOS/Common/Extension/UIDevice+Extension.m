//
//  UIDevice+Extension.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/19.
//

#import "UIDevice+Extension.h"

@implementation UIDevice(Extension)

/// 设备安全区
+(UIEdgeInsets)safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return [[[UIApplication sharedApplication] keyWindow] safeAreaInsets];
    } else {
        // Fallback on earlier versions
    }
    return UIEdgeInsetsZero;
}
@end
