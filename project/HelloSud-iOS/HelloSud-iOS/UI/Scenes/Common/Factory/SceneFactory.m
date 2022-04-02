//
// Created by kaniel on 2022/3/22.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SceneFactory.h"
#import "AudioRoomViewController.h"
#import "BaseSceneConfigModel.h"
#import "TicketViewController.h"
#import "ASRViewController.h"

@implementation SceneFactory {

}

+ (BaseSceneViewController *)createSceneVC:(SceneType)sceneType configModel:(BaseSceneConfigModel *)configModel {
    BaseSceneViewController *vc = nil;
    switch (sceneType) {
        case SceneTypeAudio:
            vc =  [[AudioRoomViewController alloc] init];
            break;
        case SceneTypeTicket:
            vc =  [[TicketViewController alloc] init];
            break;
        case SceneTypeASR:
            vc =  [[ASRViewController alloc] init];
            break;
        default:
            vc = [[BaseSceneViewController alloc] init];
            break;
    }
    vc.configModel = configModel;
    return vc;
}

@end
