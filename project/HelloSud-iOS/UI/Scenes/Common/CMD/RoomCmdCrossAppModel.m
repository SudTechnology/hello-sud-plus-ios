//
// Created by kaniel on 2022/4/25.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RoomCmdCrossAppModel.h"

@implementation RoomCmdCrossAppJoinGroupModel {

}
@end

@implementation RoomCmdCrossAppPersonChangedModel
@end

@implementation RoomCmdCrossAppPersonMatchStateChangedModel

@end


@implementation UserIndexInfo
@end

/// 队长变更
@implementation RoomCmdCrossAppGroupOwnerChangedModel
+(NSDictionary*)mj_objectClassInArray{
    return @{@"userList":UserIndexInfo.class};
}
@end

/// 组队游戏变更
@implementation RoomCmdCrossAppGroupGameChangedModel
@end