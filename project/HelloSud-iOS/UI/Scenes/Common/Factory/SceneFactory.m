//
// Created by kaniel on 2022/3/22.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SceneFactory.h"
#import "AudioRoomViewController.h"
#import "BaseSceneConfigModel.h"
#import "TicketViewController.h"
#import "ASRViewController.h"
#import "OrderentertainmentViewController.h"
#import "CrossRoomViewController.h"
#import "CustomRoomViewController.h"
#import "GuessRoomViewController.h"
#import "DanmakuRoomViewController.h"

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
        case SceneTypeOrder:
            vc =  [[OrderentertainmentViewController alloc] init];
            break;
        case SceneTypeCross:
            vc = [[CrossRoomViewController alloc]init];
            break;
        case SceneTypeCustom:
            vc = [[CustomRoomViewController alloc]init];
            break;
        case SceneTypeGuess:
            vc = [[GuessRoomViewController alloc]init];
            break;
        case SceneTypeDanmaku:
            vc = [[DanmakuRoomViewController alloc]init];
            break;
        default:
            vc = [[BaseSceneViewController alloc] init];
            break;
    }
    [vc createService];
    vc.service.sceneType = configModel.enterRoomModel.sceneType;
    vc.service.roleType = configModel.enterRoomModel.roleType;
    vc.configModel = configModel;
    return vc;
}

@end
