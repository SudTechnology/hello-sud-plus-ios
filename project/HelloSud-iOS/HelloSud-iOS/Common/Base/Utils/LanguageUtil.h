//
//  LanguageUtil.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/23.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LanguageUtil : NSObject

/**
 用户自定义使用的语言，当传nil时，等同于resetSystemLanguage
 */
@property (class, nonatomic, strong, nullable) NSString *userLanguage;
/**
 重置系统语言
 */
+ (void)resetSystemLanguage;

/// 是否语言从右到左，目前阿拉伯语
+ (BOOL)isLanguageRTL;

/// 更新APP语言方向
+ (void)updateRTL;
@end

NS_ASSUME_NONNULL_END
