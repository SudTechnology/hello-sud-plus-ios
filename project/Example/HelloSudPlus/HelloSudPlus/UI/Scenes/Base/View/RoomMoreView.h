//
// Created by kaniel on 2022/4/18.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

/// 房间更多操作视图
@interface RoomMoreView : BaseView
@property (nonatomic, copy) EmptyBlock suspendCallback;
@property (nonatomic, copy) EmptyBlock exitCallback;
@end