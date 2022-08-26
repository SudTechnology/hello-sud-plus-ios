//
//  DTUIImage+Extension.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/8/16.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 图片扩展
@interface UIImage (Extension)
/// 将图片切成带边框圆形
/// @param borderWidth
/// @param borderColor
/// @return
- (UIImage *)dt_circleImageWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/// 将图片切成圆形
/// @return
- (UIImage *)dt_circleImage;
@end

NS_ASSUME_NONNULL_END
