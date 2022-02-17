//
//  DTBlurEffectView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "DTBlurEffectView.h"

API_AVAILABLE(ios(10.0))
@interface DTBlurEffectView()

@property(nonatomic, strong)UIVisualEffect *theEffect;
@property(nonatomic, strong)UIViewPropertyAnimator *animator;
@end

@implementation DTBlurEffectView

- (instancetype)initWithEffect:(UIVisualEffect *)effect {
    if (self = [super initWithEffect:effect]) {
        self.theEffect = effect;
        WeakSelf
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:self queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            [weakSelf setNeedsDisplay];
        }];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self.animator stopAnimation:YES];
    WeakSelf
    if (@available(iOS 10.0, *)) {
        self.animator = [[UIViewPropertyAnimator alloc]initWithDuration:1 curve:UIViewAnimationCurveLinear animations:^{
            weakSelf.theEffect = self.theEffect;
        }];
    } else {
        // Fallback on earlier versions
    }
    self.animator.fractionComplete = self.blurLevel;
}
@end
