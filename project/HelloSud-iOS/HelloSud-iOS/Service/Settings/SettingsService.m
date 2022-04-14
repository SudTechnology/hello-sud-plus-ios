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

/// 默认英文
+ (NSString *)getCurLanguageLocale {
    NSString *language = [SettingsService getCurLanguage];
    if ([language isEqualToString:@""]) {
        return @"en-US";
    }
    return language;
}

/// 不支持的语言
+ (BOOL)isNotSupportLanguage {
    NSString *language = [SettingsService getCurLanguage];
    if ([language isEqualToString:@""]) {
        return true;
    }
    return false;
}

/// 获取当前
+ (NSString *)getCurLanguage {
    NSString *local = [NSLocale preferredLanguages].firstObject;
    NSArray <SwitchLangModel *>*dataArray = [self getLanguageArr];
    for (SwitchLangModel *m in dataArray) {
        if (m.language == nil) {
            continue;
        }
        if ([local containsString:m.language]) {
            return m.locale;
        }
    }
    return @"";
}

+ (NSArray <SwitchLangModel *> *)getLanguageArr {
    SwitchLangModel *m_0 = [SwitchLangModel new];
    m_0.title = NSString.dt_follow_system;
    m_0.language = nil;
    m_0.isSelect = YES;
    
    SwitchLangModel *m_1 = [SwitchLangModel new];
    m_1.title = @"简体中文";
    m_1.language = [@"zh-Hans" languageCountryCode];
    m_1.locale = @"zh-CN";
    
    SwitchLangModel *m_2 = [SwitchLangModel new];
    m_2.title = @"繁體中文";
    m_2.language = [@"zh-Hant" languageCountryCode];
    m_2.locale = @"zh-TW";
    
    SwitchLangModel *m_3 = [SwitchLangModel new];
    m_3.title = @"English";
    m_3.language = [@"en" languageCountryCode];
    m_3.locale = @"en-US";
    
    SwitchLangModel *m_4 = [SwitchLangModel new];
    m_4.title = @"لغة عربية";
    m_4.language = [@"ar" languageCountryCode];
    m_4.locale = @"ar-SA";
    
    SwitchLangModel *m_5 = [SwitchLangModel new];
    m_5.title = @"Bahasa Indonesia";
    m_5.language = [@"id" languageCountryCode];
    m_5.locale = @"id-ID";
    
    SwitchLangModel *m_6 = [SwitchLangModel new];
    m_6.title = @"Bahasa Melayu";
    m_6.language = [@"ms" languageCountryCode];
    m_6.locale = @"ms-MY";
    
    SwitchLangModel *m_7 = [SwitchLangModel new];
    m_7.title = @"ภาษาไทย";
    m_7.language = [@"th" languageCountryCode];
    m_7.locale = @"th-TH";
    
    SwitchLangModel *m_8 = [SwitchLangModel new];
    m_8.title = @"Tiếng Việt";
    m_8.language = [@"vi" languageCountryCode];
    m_8.locale = @"vi-VN";
    
    SwitchLangModel *m_9 = [SwitchLangModel new];
    m_9.title = @"한국어";
    m_9.language = [@"ko" languageCountryCode];
    m_9.locale = @"ko-KR";
    
    SwitchLangModel *m_10 = [SwitchLangModel new];
    m_10.title = @"Español";
    m_10.language = [@"es" languageCountryCode];
    m_10.locale = @"es-ES";
    
    SwitchLangModel *m_11 = [SwitchLangModel new];
    m_11.title = @"日本語";
    m_11.language = [@"ja" languageCountryCode];
    m_11.locale = @"ja-JP";
    
    NSArray <SwitchLangModel *>*dataArray = @[m_0, m_1, m_2, m_3, m_4, m_5, m_6, m_7, m_8, m_9, m_10, m_11];
    return dataArray;
}

@end


@implementation NSString (Language)

- (NSString *)languageCountryCode {
    if (@available(iOS 10.0, *)) {
        return [NSString stringWithFormat:@"%@-%@", self, NSLocale.currentLocale.countryCode];
    } else {
        return self;
    }
}

@end
