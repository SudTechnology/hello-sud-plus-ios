//
//  SettingsService.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/17.
//

#import <Foundation/Foundation.h>
#import "SwitchLangModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 设置服务
@interface SettingsService : NSObject

/// APP隐私协议地址
+ (NSURL *)appPrivacyURL;

/// APP用户协议
+ (NSURL *)appProtocolURL;

/// 开源协议
+ (NSURL *)appLicenseURL;

+ (NSString *)getCurLanguageLocale;
/// 不支持的语言
+ (BOOL)isNotSupportLanguage;

+ (NSArray <SwitchLangModel *> *)getLanguageArr;
@end

NS_ASSUME_NONNULL_END


@interface NSString (Language)

- (NSString *)languageCountryCode;

@end
