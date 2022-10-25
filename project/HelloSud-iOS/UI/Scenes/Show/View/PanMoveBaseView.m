//
// Created by kaniel on 2022/10/25.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "PanMoveBaseView.h"


@implementation PanMoveBaseView

- (void)dtConfigEvents {
    [super dtConfigEvents];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self addGestureRecognizer:pan];
}

- (void)onPan:(UIPanGestureRecognizer *)pan {

    CGPoint point = [pan locationInView:self.superview];
    if (pan.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.1 delay:0 options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut animations:^{
            self.center = point;
        }                completion:nil];
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        [UIView animateWithDuration:0.1 delay:0 options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut animations:^{
            if (point.y < 80) {
                self.center = CGPointMake(point.x, 80);
            } else if (point.y > kScreenHeight - 150) {
                self.center = CGPointMake(point.x, kScreenHeight - 150);
            } else {
                self.center = point;
            }
        }                completion:nil];
    } else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        CGRect frame = self.frame;
        CGFloat roundEntryViewWidth = self.mj_w;
        CGFloat roundEntryViewMargin = 20;
        // 设置横向坐标
        if (point.x > kScreenWidth / 2) {
            frame.origin.x = kScreenWidth - roundEntryViewMargin - roundEntryViewWidth;
        } else {
            frame.origin.x = roundEntryViewMargin;
        }
        // 设置最高点
        if (point.y < 80) {
            frame.origin.y = 80;
        }
        // 设置最低点
        if (point.y > kScreenHeight - 150) {
            frame.origin.y = kScreenHeight - 150;
        }
        [UIView animateWithDuration:0.1 delay:0 options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut animations:^{
            self.frame = frame;
        }                completion:nil];
    }
}
@end