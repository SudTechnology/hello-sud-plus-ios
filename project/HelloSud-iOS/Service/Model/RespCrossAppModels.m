//
// Created by kaniel on 2022/11/24.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RespCrossAppModels.h"


@implementation RespGameListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"hotGameList": HSGameItem.class, @"allGameList": HSGameItem.class};
}
@end

@implementation RespStartCrossAppMatchModel
@end
