//
// Created by kaniel on 2022/4/20.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DTNSString)
/// 大小写不敏感比对
/// @param dest
/// @return
- (BOOL)dt_isInsensitiveEqualToString:(NSString *)dest;
/// 转成URL，包含对http处理
/// @return
- (NSURL *)dt_toURL;
/// 转成md5
- (NSString*)dt_md5;
@end