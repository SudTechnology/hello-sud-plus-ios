//
// Created by kaniel on 2022/4/20.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "NSString+DTNSString.h"
#import <CommonCrypto/CommonDigest.h>
#define CC_MD5_DIGEST_LENGTH 16

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

/// 转成md5
- (NSString*)dt_md5 {
    const char* original_str=[self UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x", digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr lowercaseString];
}

@end

@implementation NSAttributedString(DTNSAttributedString)

/// 将图片转换为富文本
/// @param image 图片
/// @param size 图片尺寸
/// @param offsetY 垂直偏移
+ (NSAttributedString *)dt_attrWithImage:(UIImage *)image size:(CGSize)size offsetY:(CGFloat)offsetY {
    NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, offsetY, size.width, size.height);
    NSAttributedString *attrStr1 = [NSAttributedString attributedStringWithAttachment:attachment];
    return attrStr1;
}

@end
