//
// Created by kaniel on 2022/4/20.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "NSString+DTNSString.h"


@implementation NSString (DTNSString)
/// 大小写不敏感比对
/// @param dest
/// @return
- (BOOL)dt_isInsensitiveEqualToString:(NSString *)dest {
    return [self caseInsensitiveCompare:dest] == NSOrderedSame;
}

/// 转成URL，包含对http处理
/// @return
- (NSURL *)dt_toURL {
    if ([self hasPrefix:@"http"]) {
        return [[NSURL alloc] initWithString:self];
    }
    return [NSURL fileURLWithPath:self];
}
@end