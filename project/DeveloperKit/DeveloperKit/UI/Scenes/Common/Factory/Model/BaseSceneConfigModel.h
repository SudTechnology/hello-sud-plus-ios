//
// Created by kaniel on 2022/3/22.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

/// 场景配置model
@interface BaseSceneConfigModel : NSObject
@property(nonatomic, assign) int64_t gameId;
@property(nonatomic, copy) NSString * roomID;
@property(nonatomic, copy) NSString * roomNumber;
@property(nonatomic, copy) NSString *roomName;
@property(nonatomic, strong)EnterRoomModel *enterRoomModel;
/// 房间角色 1 为房主
@property (nonatomic, assign)NSInteger roleType;
@end

/// 场景配置model
@interface AudioSceneConfigModel : BaseSceneConfigModel

@property (nonatomic, assign)NSInteger roomType;
@end

