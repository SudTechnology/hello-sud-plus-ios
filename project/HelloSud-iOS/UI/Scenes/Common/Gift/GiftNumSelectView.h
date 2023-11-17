//
// Created by kaniel on 2023/8/7.
// Copyright (c) 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

/// 礼物数量选择视图
@interface GiftNumSelectView : BaseView
@property (nonatomic, strong)void(^numSelectedBlock)(NSInteger num);
@end