//
// Created by kaniel on 2023/8/15.
// Copyright (c) 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RoomBaseCMDModel.h"

/// 3D语聊房麦位状态变更
@interface RoomCmd3dMicChangedModel : RoomBaseCMDModel
@property(nonatomic, strong) NSArray <AppCustomCrSeatItemModel *> *seats;
@end