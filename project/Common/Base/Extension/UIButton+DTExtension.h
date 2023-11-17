//
// Created by kaniel on 2023/8/3.
// Copyright (c) 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton (DTExtension)
/// 点击事件
/// @param clickBlock
- (void)dt_onClick:(void (^)(UIButton *sender))clickBlock;
@end