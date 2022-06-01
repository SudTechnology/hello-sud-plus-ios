//
//  UIDevice+Extension.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 设备扩展
@interface UIDevice(DTDeviceExtension)

/// 设备安全区
+(UIEdgeInsets)dt_safeAreaInsets;

/// 是否是iPhone x系列刘海屏设备
+(BOOL)dt_isiPhoneXSeries;
@end

NS_ASSUME_NONNULL_END
