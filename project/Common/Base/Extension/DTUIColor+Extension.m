//
//  UIColor+Extension.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/19.
//

#import "DTUIColor+Extension.h"

@implementation UIColor(DTColorExtension)

/**
 16进制颜色转换为UIColor
 @param hex 16进制字符串（可以以0x开头，可以以#开头，也可以就是6位的16进制）
 @param opacity 透明度
 @return 16进制字符串对应的颜色
 */
+(UIColor *)dt_colorWithHexString:(NSString *)hex alpha:(float)opacity {
    NSString * cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    NSInteger length = [cString length];
    if (length < 6){
        return [UIColor blackColor];
    }
    
    if (length == 8) {
        // Separate into a, r, g, b substrings 兼容argb
        NSRange range;
        range.location = 0;
        range.length = 2;
        NSString * aString = [cString substringWithRange:range];
        
        range.location = 2;
        NSString * rString = [cString substringWithRange:range];
        
        range.location = 4;
        NSString * gString = [cString substringWithRange:range];
        
        range.location = 6;
        NSString * bString = [cString substringWithRange:range];
        
        // Scan values
        unsigned int a, r, g, b;
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        return [UIColor colorWithRed:((float)r / 255.0f)
                               green:((float)g / 255.0f)
                                blue:((float)b / 255.0f)
                               alpha:((float)a / 255.0f)];
    }
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString * rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString * gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString * bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:opacity];

}

/// 转换成图片
/// @return 返回图片
- (UIImage *)dt_toImage {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [self setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
