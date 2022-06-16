//
//  RespDanmakuModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/16.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RespDanmakuModel.h"

@implementation DanmakuCallWarcraftModel

@end

@implementation DanmakuJoinTeamModel

@end

@implementation RespDanmakuListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"callWarcraftInfoList": [DanmakuCallWarcraftModel class],
            @"joinTeamList": [DanmakuJoinTeamModel class]};
}
@end