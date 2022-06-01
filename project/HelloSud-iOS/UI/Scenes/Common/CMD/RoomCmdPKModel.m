//
// Created by kaniel on 2022/4/25.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RoomCmdPKModel.h"


@implementation RoomCmdPKAckInviteModel {

}
@end

/// 开始跨房PK model
@implementation RoomCmdPKStartedModel

@end


@implementation RoomGameResultModel
@end

@implementation RoomUserRankInfoModel
@end


@implementation RoomPKGameResultContentModel
+(NSDictionary*)mj_objectClassInArray{
    return @{@"userRankInfoList":RoomUserRankInfoModel.class};
}

@end

/// 跨房PK游戏结果指令 model
@implementation RoomPKGameResultCMDModel
@end