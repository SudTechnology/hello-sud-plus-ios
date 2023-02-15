//
//  RespCrossRoomListModel.m
//  DeveloperKit
//
//  Created by kaniel on 2022/7/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RespCrossRoomListModel.h"

@implementation CrossRoomModel

@end

@implementation RespCrossRoomListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"roomInfos":CrossRoomModel.class};
}
@end


@implementation RespCrossMatchRoomModel
@end
