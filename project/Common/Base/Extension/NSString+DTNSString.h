//
// Created by kaniel on 2022/4/20.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DTNSString)
- (NSString *)localized;
/// 大小写不敏感比对
/// @param dest
/// @return
- (BOOL)dt_isInsensitiveEqualToString:(NSString *)dest;
/// 转成URL，包含对http处理
/// @return
- (NSURL *)dt_toURL;
/// 转成md5
- (NSString*)dt_md5;
/// 本地化语言
- (NSString *)dt_lan;
@end


@interface NSAttributedString(DTNSAttributedString)

/// 将图片转换为富文本
/// @param image 图片
/// @param size 图片尺寸
/// @param offsetY 垂直偏移
+ (NSAttributedString *)dt_attrWithImage:(UIImage *)image size:(CGSize)size offsetY:(CGFloat)offsetY;
@end
