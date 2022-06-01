//
//  BaseView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/19.
//

#import "BaseView.h"

@interface BaseView ()
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
/// 渐变图层
@property (nonatomic, strong) CAGradientLayer *gradient;
@property (nonatomic, assign) UIRectCorner corners;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) BOOL isCorners;

@end

@implementation BaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self dtAddViews];
        [self dtLayoutViews];
        [self dtConfigEvents];
        [self dtConfigUI];
        [self dtUpdateUI];
    }
    return self;
}

/// 增加子view
- (void)dtAddViews {
    
}

/// 布局视图
- (void)dtLayoutViews {
    
}

/// 配置事件
- (void)dtConfigEvents {
    
}

/// 试图初始化
- (void)dtConfigUI {
    
}

/// 更新UI
- (void)dtUpdateUI {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.gradient) {
        self.gradient.frame = self.bounds;
    }
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
    self.isCorners = cornerRadius > 0 ? true : false;
    self.corners = corners;
    self.cornerRadius = cornerRadius;
}

/// 移除剪切
- (void)dtRemoveRoundCorners {
    self.isCorners = false;
    self.layer.mask = nil;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
    }
    return _shapeLayer;
}


/// 增加渐变图层
/// @param locations <#locations description#>
/// @param colors <#colors description#>
/// @param startPoint <#startPoint description#>
/// @param endPoint <#endPoint description#>
- (void)dtAddGradientLayer:(NSArray<NSNumber *>*)locations colors:(NSArray*)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint cornerRadius:(NSInteger)cornerRadius {
    if (self.gradient != nil) {
        [self.gradient removeFromSuperlayer];
    }
    self.gradient = [[CAGradientLayer alloc]init];
    self.gradient.frame = self.bounds;
    self.gradient.colors = colors;
    self.gradient.locations = locations;
    self.gradient.startPoint = startPoint;
    self.gradient.endPoint = endPoint;
    self.gradient.cornerRadius = cornerRadius;
    [self.layer insertSublayer:self.gradient atIndex:0];
}

/// 移除渐变图层
- (void)dtRemoveGradient {
    if (self.gradient) {
        [self.gradient removeFromSuperlayer];
        self.gradient = nil;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *v = [super hitTest:point withEvent:event];
    if (self.hitTestChangedCallback) {
        UIView *changedView = self.hitTestChangedCallback(v);
        // 如果返回视图不是透传视图，则穿透到返回视图中去
        if (changedView && changedView != v) {
            return [changedView hitTest:point withEvent:event];
        }
    }
    return v;
}

@end
