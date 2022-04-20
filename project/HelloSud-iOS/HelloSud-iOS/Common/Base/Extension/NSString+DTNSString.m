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
@end