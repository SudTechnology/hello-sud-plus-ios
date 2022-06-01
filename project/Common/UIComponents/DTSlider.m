//
// Created by kaniel on 2022/5/17.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DTSlider.h"

@interface DTSlider()
/// 自定义高度
@property (nonatomic, assign)CGFloat customHeight;
@end



@implementation DTSlider {

}

- (instancetype)initWithCustomHeight:(CGFloat)customHeight {
    _customHeight = customHeight;
    return [super initWithFrame:CGRectZero];
}

// 控制slider的宽和高，这个方法才是真正的改变slider滑道的高的
- (CGRect)trackRectForBounds:(CGRect)bounds {
    if (self.customHeight > 0) {
        bounds.size.height = self.customHeight;
        self.layer.cornerRadius = 0.5;
    }
    return bounds;
}

// 改变滑块的触摸范围
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    rect.origin.x = rect.origin.x - 5;
    rect.size.width = rect.size.width + 10;
    return CGRectInset([super thumbRectForBounds:bounds trackRect:rect value:value], 5, 5);
}
@end
