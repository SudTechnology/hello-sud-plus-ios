//
// Created by kaniel on 2022/6/7.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

/// 更多竞猜头部cell模型
@interface MoreGuessHeaderCellModel : BaseModel
/// 时长
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger leftSupportCoin;
@property (nonatomic, assign) NSInteger rightSupportCoin;
@end