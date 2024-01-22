//
// Created by kaniel on 2023/8/15.
// Copyright (c) 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RoomCmd3dMicChangedModel.h"

@implementation RoomCmd3dMicChangedModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"seats": AppCustomCrSeatItemModel.class};
}
@end