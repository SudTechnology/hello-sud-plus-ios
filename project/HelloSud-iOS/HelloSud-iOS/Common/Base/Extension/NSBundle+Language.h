//
//  NSBundle+Language.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/23.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (Language)

+ (BOOL)isChineseLanguage;
+ (NSString *)currentLanguage;

@end

NS_ASSUME_NONNULL_END
