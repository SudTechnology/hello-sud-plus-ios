//
// Created by kaniel on 2022/3/22.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

/// 场景配置model
@interface BaseSceneConfigModel : NSObject
@property(nonatomic, assign) NSInteger gameId;
@property(nonatomic, copy) NSString * roomID;
@property(nonatomic, copy) NSString *roomName;
@end

/// 场景配置model
@interface AudioSceneConfigModel : BaseSceneConfigModel
@property (nonatomic, assign)NSInteger roomType;
@end

