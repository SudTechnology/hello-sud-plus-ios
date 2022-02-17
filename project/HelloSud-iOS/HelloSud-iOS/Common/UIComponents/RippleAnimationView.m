//
//  RippleAnimationView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/26.
//

#import "RippleAnimationView.h"
@interface RippleAnimationView()

@property(nonatomic, strong)CALayer * aniLayer;
/// 是否正在动画
@property(nonatomic, assign)BOOL isAnimating;
/// 指定大小, 不指定时默认使用控件大小
@property(nonatomic, assign)CGSize animateSize;
@property(nonatomic, strong)NSTimer * timer;

@end

@implementation RippleAnimationView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.rate = 1.8;
        self.duration = 3.5;
        self.pulsingCount = 4;
        self.isAnimating = NO;
    }
    return self;
}

/// 启动动画
/// @param isRepeat 是否重复
- (void)startAnimate:(BOOL)isRepeat {
    if (self.isAnimating) {
        /// 如果正在播放中，再继续启动动画时，重新开启延迟定时器即可
        if (!isRepeat) {
            /// 非重复的启动一个定时器延迟关闭
            [self reBeginTimer];
        }
        return;
    }
    if (!isRepeat) {
        /// 非重复的启动一个定时器延迟关闭
        [self reBeginTimer];
    }
    [self removeAnimate];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeAnimate) object:self];
    self.isAnimating = YES;
    self.aniLayer = [CALayer layer];
    for (int i = 0; i < self.pulsingCount; ++i) {
        NSArray *arr = [self animationArray];
        CAAnimationGroup *group = [self groupAnimations:arr index:i];
        CALayer *pulsingLayer = [self makePulsingLayer:self.frame animation:group];
        [self.aniLayer addSublayer:pulsingLayer];
    }
    if (self.aniLayer) {
        [self.layer addSublayer:self.aniLayer];
    }
}

/// 关闭动画
/// @param rightNow 是否立马关闭
- (void)stopAnimate:(BOOL)rightNow {
    if (rightNow) {
        [self removeAnimate];
    } else {
        if (self.isAnimating) {
            /// 标记动画状态，等待完成后根据这个状态来结束，防止动画消失得过于冲突
            [self performSelector:@selector(removeAnimate) withObject:self afterDelay:self.duration];
        }
    }
}
/// 重新开启一个定时器
- (void)reBeginTimer {
 
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
}
/// 关闭定时器
- (void)closeTimer {
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)onTimer:(id)tiemr {
    [self removeAnimate];
}

- (NSArray<CAAnimation*>*)animationArray {
    CABasicAnimation * scale = [self scaleAnimation];
    CAKeyframeAnimation * background = [self backgroundColorAnimation];
    return @[scale, background];
}

- (CABasicAnimation *)scaleAnimation {
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    ani.fromValue = @1;
    ani.toValue = @(self.rate);
    return ani;
}

- (CAKeyframeAnimation *)backgroundColorAnimation {
    CAKeyframeAnimation *ani = [CAKeyframeAnimation animationWithKeyPath:@"borderColor"];
    ani.values = self.animateColors;
    ani.keyTimes = @[@0.1, @0.3, @0.7, @0.9];
    return ani;
}

- (CAAnimationGroup*)groupAnimations:(NSArray<CAAnimation*>*)arr index:(NSInteger)index {
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    CAAnimationGroup * group = CAAnimationGroup.new;
    group.fillMode = kCAFillModeBackwards;
    group.beginTime = CACurrentMediaTime() + (CFTimeInterval)index * self.duration / (CFTimeInterval)self.pulsingCount;
    group.duration = self.duration;
    group.repeatCount = HUGE;
    group.timingFunction = defaultCurve;
    group.animations = arr;
    group.removedOnCompletion = NO;
    return group;
}

- (CALayer *)makePulsingLayer:(CGRect)rect animation:(CAAnimationGroup *)animation {
    CALayer * pulsingLayer = [CALayer layer];
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    if (self.animateSize.width > 0 && self.animateSize.height > 0) {
        w = self.animateSize.width;
        h = self.animateSize.height;
    }
    pulsingLayer.frame = CGRectMake(0, 0, w, h);
    pulsingLayer.backgroundColor = self.animateBackgroundColor.CGColor;
    pulsingLayer.cornerRadius = w / 2;
    pulsingLayer.borderWidth = 2;
    [pulsingLayer addAnimation:animation forKey:@"plulsing"];
    return pulsingLayer;
}

- (void)removeAnimate {
    self.isAnimating = NO;
    [self closeTimer];
    [self.aniLayer removeAllAnimations];
    [self.aniLayer removeFromSuperlayer];
}
@end
