//
// Created by kaniel on 2022/3/22.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnterRoomModel.h"

/// 场景配置model
@interface BaseSceneConfigModel : NSObject
@property(nonatomic, assign) NSInteger gameId;
@property(nonatomic, copy) NSString * roomID;
@property(nonatomic, copy) NSString * roomNumber;
@property(nonatomic, copy) NSString *roomName;
@property(nonatomic, strong)EnterRoomModel *enterRoomModel;
/// 房间角色 1 为房主
@property (nonatomic, assign)NSInteger roleType;
// 加载游戏方式
@property (nonatomic, assign)NSInteger loadGameType;
@property (nonatomic, assign)NSInteger tabType;
@end

/// 场景配置model
@interface AudioSceneConfigModel : BaseSceneConfigModel

@property (nonatomic, assign)NSInteger roomType;

@end

