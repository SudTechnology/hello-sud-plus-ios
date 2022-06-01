//
//  LanguageUtil.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/23.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "LanguageUtil.h"
#import "NSBundle+Language.h"
static NSString *const DTUserLanguageKey = @"DTUserLanguageKey";
#define STANDARD_USER_DEFAULT  [NSUserDefaults standardUserDefaults]

@implementation LanguageUtil

#pragma mark - Language
+ (void)setUserLanguage:(NSString *)userLanguage {
    //跟随手机系统
    if (userLanguage.length == 0) {
        [self resetSystemLanguage];
        [NSBundle resetLanguageBundle];
        [self updateRTL];
        return;
    }
    //用户自定义
    [STANDARD_USER_DEFAULT setValue:userLanguage forKey:DTUserLanguageKey];
    [STANDARD_USER_DEFAULT setValue:@[userLanguage] forKey:@"AppleLanguages"];
    [STANDARD_USER_DEFAULT synchronize];
    [NSBundle resetLanguageBundle];
    [self updateRTL];
}

+ (NSString *)userLanguage {
    return [STANDARD_USER_DEFAULT valueForKey:DTUserLanguageKey];
}

//** 重置系统语言 */
+ (void)resetSystemLanguage {
    [STANDARD_USER_DEFAULT removeObjectForKey:DTUserLanguageKey];
    [STANDARD_USER_DEFAULT setValue:nil forKey:@"AppleLanguages"];
    [STANDARD_USER_DEFAULT synchronize];
}

/// 是否语言从右到左，目前阿拉伯语
+ (BOOL)isLanguageRTL {
    NSString *lang = NSBundle.currentLanguage;
    return [lang hasPrefix:@"ar"];
}

/// 更新APP语言方向
+ (void)updateRTL {
    if ([self isLanguageRTL]) {
        
        [UIView appearance].semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        [UISearchBar appearance].semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        [[UINavigationBar appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    } else {
        [UIView appearance].semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
        [UISearchBar appearance].semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
        [[UINavigationBar appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
}


@end
