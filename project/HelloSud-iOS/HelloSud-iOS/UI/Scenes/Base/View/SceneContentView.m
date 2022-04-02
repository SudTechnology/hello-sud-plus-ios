//
// Created by kaniel on 2022/4/2.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SceneContentView.h"


@implementation SceneContentView

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