//
// Created by kaniel on 2022/11/24.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

/// 游戏列表
@interface RespGameListModel : BaseRespModel
@property(nonatomic, strong) NSArray<HSGameItem *> *hotGameList;
@property(nonatomic, strong) NSArray<HSGameItem *> *allGameList;
@end

/// 响应开始跨APP匹配
@interface RespStartCrossAppMatchModel : BaseRespModel
@property (nonatomic, strong)NSString *groupId;
@end