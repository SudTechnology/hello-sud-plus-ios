//
// Created by kaniel on 2022/4/28.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

/// PK状态下未选择游戏时展示视图
@interface PKGameEmptyView : BaseView
@property (nonatomic, copy)void(^onClickBlock)(void);
@property (nonatomic, assign)BOOL isRoomOwner;
@end