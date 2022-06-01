//
//  NSBundle+Language.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/23.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "NSBundle+Language.h"

@implementation NSBundle (Language)

static NSBundle *currentLanguageBundle = nil;

/// 当前多语言bundle
+ (NSBundle *)currentLanguageBundle {
    if (!currentLanguageBundle) {
        [self resetLanguageBundle];
    }
    return currentLanguageBundle;
}

/// 重置多语言bundle
+ (void)resetLanguageBundle {
    NSString *language = [NSBundle currentLanguage];
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSBundle currentLanguage] ofType:@"lproj"];
    if (path == nil) {
        language =  @"en";
        if (@available(iOS 10.0, *)) {
            language = [language stringByReplacingOccurrencesOfString: [NSString stringWithFormat:@"-%@", NSLocale.currentLocale.countryCode] withString:@""];
        } else {
            // Fallback on earlier versions
        }
        path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    }
    if (path.length > 0) {
        currentLanguageBundle = [NSBundle bundleWithPath:path];
    }
    /// 同步配置mj刷新多语言
    [MJRefreshConfig.defaultConfig setLanguageCode:language];
}

+ (BOOL)isChineseLanguage {
    NSString *currentLanguage = [self currentLanguage];
    return [currentLanguage hasPrefix:@"zh-Hans"];
}

+ (NSString *)currentLanguage {
    NSString *language =  [LanguageUtil userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    if (@available(iOS 10.0, *)) {
        language = [language stringByReplacingOccurrencesOfString: [NSString stringWithFormat:@"-%@", NSLocale.currentLocale.countryCode] withString:@""];
    } else {
        // Fallback on earlier versions
    }
    return language;
}

@end
