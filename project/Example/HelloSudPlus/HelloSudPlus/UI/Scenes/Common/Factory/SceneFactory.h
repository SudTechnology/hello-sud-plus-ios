//
// Created by kaniel on 2022/3/22.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseSceneViewController.h"
#import "BaseSceneViewController+IM.h"
#import "BaseSceneViewController+Game.h"
#import "BaseSceneViewController+Voice.h"
#import "BaseSceneConfigModel.h"
#import "AudioRoomService.h"

/// 游戏加载方式
typedef NS_ENUM(NSInteger, GameCategoryLoadType ) {
    GameCategoryLoadTypSdk = 0,
    GameCategoryLoadTypH5 = 1,
    GameCategoryLoadTypVideo = 2,
};


/// 加载场景参数
@interface SceneParamModel : NSObject
@property(nonatomic, assign)SceneType sceneType;
@property(nonatomic, strong)BaseSceneConfigModel *configModel;
@property(nonatomic, assign)NSInteger loadType;// 游戏加载类型
@property(nonatomic, assign)GameCategoryLoadType tabType;// 应用tab，1: scene, 2: game
@end

/// 场景工厂
@interface SceneFactory : NSObject

/// 构建场景控制器
+ (BaseSceneViewController *)createSceneVC:(SceneParamModel *)paramModel;
@end
