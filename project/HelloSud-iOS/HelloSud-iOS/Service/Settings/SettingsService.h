//
//  SettingsService.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 设置服务
@interface SettingsService : NSObject

/// APP隐私协议地址
+ (NSURL *)appPrivacyURL;

/// APP用户协议
+ (NSURL *)appProtocolURL;

/// 开源协议
+ (NSURL *)appLicenseURL;
@end

NS_ASSUME_NONNULL_END
