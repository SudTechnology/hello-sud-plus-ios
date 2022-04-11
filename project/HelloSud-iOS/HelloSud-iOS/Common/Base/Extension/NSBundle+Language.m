//
//  NSBundle+Language.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/23.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "NSBundle+Language.h"
#import <objc/runtime.h>

@implementation NSBundle (Language)

+ (void)load {
    NSLog(@">>>currentLanguage:%@", [self currentLanguage]);
    Method ori = class_getInstanceMethod(self, @selector(localizedStringForKey:value:table:));
    Method cur = class_getInstanceMethod(self, @selector(dt_localizedStringForKey:value:table:));
    method_exchangeImplementations(ori, cur);
}


- (NSString *)dt_localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSBundle currentLanguage] ofType:@"lproj"];
    if (path.length > 0) {
        NSBundle *bundle = [NSBundle bundleWithPath:path];
        return [bundle dt_localizedStringForKey:key value:value table:tableName];
    }
    return [self dt_localizedStringForKey:key value:value table:tableName];
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
