//
// Created by kaniel on 2022/3/22.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SceneFactory.h"
#import "AudioRoomViewController.h"
#import "BaseSceneConfigModel.h"


@implementation SceneFactory {

}

+ (BaseSceneViewController *)createSceneVC:(SceneFactoryType)sceneType configModel:(BaseSceneConfigModel *)configModel {
    BaseSceneViewController *vc = nil;
    switch (sceneType) {
        case SceneFactoryTypeVoice:
            vc =  [[AudioRoomViewController alloc] init];
            break;
        default:
            vc = [[BaseSceneViewController alloc] init];
            break;
    }
    vc.configModel = configModel;
    return vc;
}

@end