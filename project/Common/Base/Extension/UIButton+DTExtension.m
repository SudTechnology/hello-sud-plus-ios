//
// Created by kaniel on 2023/8/3.
// Copyright (c) 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "UIButton+DTExtension.h"
#import <objc/runtime.h>

typedef void(^ButtonBlock)(UIButton *btn);

@implementation UIButton (DTExtension)
static char ActionTag;

/// 点击事件
/// @param clickBlock
- (void)dt_onClick:(void (^)(UIButton *sender))clickBlock {
    objc_setAssociatedObject(self, &ActionTag, clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(dt_action:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dt_action:(id)sender {
    ButtonBlock blockAction = (ButtonBlock) objc_getAssociatedObject(self, &ActionTag);
    if (blockAction) {
        blockAction(self);
    }
}
@end