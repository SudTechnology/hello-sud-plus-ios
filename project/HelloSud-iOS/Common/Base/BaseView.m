//
//  BaseView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/19.
//

#import "BaseView.h"

@interface BaseView ()
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, assign) UIRectCorner corners;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) BOOL isCorners;

@end

@implementation BaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self hsAddViews];
        [self hsLayoutViews];
        [self hsConfigEvents];
        [self hsConfigUI];
        [self hsUpdateUI];
    }
    return self;
}

/// 增加子view
- (void)hsAddViews {
    
}

/// 布局视图
- (void)hsLayoutViews {
    
}

/// 配置事件
- (void)hsConfigEvents {
    
}

/// 试图初始化
- (void)hsConfigUI {
    
}

/// 更新UI
- (void)hsUpdateUI {
    
}

- (void)layoutSubviews {
    if (self.isCorners == false) {
        return;
    }
    self.shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:self.corners cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)].CGPath;
    self.layer.mask = self.shapeLayer;
}

/**
 切部分圆角
 
 UIRectCorner有五种
 UIRectCornerTopLeft //上左
 UIRectCornerTopRight //上右
 UIRectCornerBottomLeft // 下左
 UIRectCornerBottomRight // 下右
 UIRectCornerAllCorners // 全部
 
 @param cornerRadius 圆角半径
 */
- (void)setPartRoundCorners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius {
    self.isCorners = true;
    self.corners = corners;
    self.cornerRadius = cornerRadius;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
    }
    return _shapeLayer;
}

@end
