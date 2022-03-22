//
// Created by kaniel on 2022/3/22.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseSceneViewController.h"
#import "BaseSceneConfigModel.h"

@class BaseSceneConfigModel;

/// 场景类
typedef NS_ENUM(NSInteger, SceneFactoryType) {
    SceneFactoryTypeVoice = 0,
};

/// 场景工厂
@interface SceneFactory : NSObject

/// 构建场景控制器
/// @param sceneType
/// @return
+ (BaseSceneViewController *)createSceneVC:(SceneFactoryType)sceneType configModel:(BaseSceneConfigModel*)configModel;
@end