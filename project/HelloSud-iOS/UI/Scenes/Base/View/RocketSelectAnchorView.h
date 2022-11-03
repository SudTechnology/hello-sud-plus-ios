//
// Created by kaniel on 2022/11/3.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

/// 火箭互动礼物选择主播视图
@interface RocketSelectAnchorView : BaseView
@property (nonatomic, copy)void(^confirmBlock)(NSArray<AudioRoomMicModel *> *userList);
@end