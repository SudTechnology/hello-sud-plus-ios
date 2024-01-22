//
// Created by kaniel on 2022/4/1.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

/// 主播详情信息
@interface AnchorDetailView : BaseView
@property (nonatomic, strong)NSString *userId;
@property (nonatomic, strong)void(^clickSendGiftBlock)(void);
@end