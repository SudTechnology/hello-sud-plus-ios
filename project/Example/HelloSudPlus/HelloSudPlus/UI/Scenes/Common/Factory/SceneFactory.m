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
#import "DiscoRoomViewController.h"
#import "LeagueRoomViewController.h"
#import "../../CrossApp/VC/CrossAppViewController.h"
#import "DanmakuVerticalRoomViewController.h"
#import "Audio3DRoomViewController.h"
#import "ThirdGameViewController.h"

@implementation SceneParamModel


@end

@implementation SceneFactory {
    
}

+ (BaseSceneViewController *)createSceneVC:(SceneParamModel *)paramModel {
    if (paramModel.tabType == 2) {
        return [self handleGameTab:paramModel];
    }
    return [self handleSceneTab:paramModel];
}

+ (BaseSceneViewController *)handleGameTab:(SceneParamModel *)paramModel {
    BaseSceneViewController *vc = nil;
    
    switch (paramModel.sceneType) {
        case SceneTypeGameCategoryDanmaku:
            vc = [[DanmakuVerticalRoomViewController alloc]init];
            break;
        case SceneTypeGameCategory3DAudio:
            vc = Audio3DRoomViewController.new;
            break;
        default:
            vc = [[ThirdGameViewController alloc] init];
            break;
    }
    [vc createService];
    vc.service.sceneType = paramModel.configModel.enterRoomModel.sceneType;
    vc.service.roleType = paramModel.configModel.enterRoomModel.roleType;
    vc.configModel = paramModel.configModel;
    return vc;
}

+ (BaseSceneViewController *)handleSceneTab:(SceneParamModel *)paramModel {
    
    BaseSceneViewController *vc = nil;
    
    switch (paramModel.sceneType) {
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
        case SceneTypeDisco:
            vc = [[DiscoRoomViewController alloc]init];
            break;
        case SceneTypeLeague:
            vc = [[LeagueRoomViewController alloc]init];
            break;
        case SceneTypeCrossApp:
            vc = [[CrossAppViewController alloc]init];
            break;
        case  SceneTypeCrossDomain:
            vc = [[AudioRoomViewController alloc] init];
            break;
        case SceneTypeVertical:
        case SceneTypeGameCategoryDanmaku:
            vc = [[DanmakuVerticalRoomViewController alloc]init];
            break;
        case SceneTypeAudio3D:
            vc = Audio3DRoomViewController.new;
            break;
            
        case SceneTypeGameCategoryAudio:// 语音互动类
        case SceneTypeGameCategoryRealTimePvP://    实时竞技类
        case SceneTypeGameCategoryChess://    经典棋类
        case SceneTypeGameCategoryCard://    经典牌类
        case SceneTypeGameCategoryBoard://    经典桌游类
        case SceneTypeGameCategoryParty://    组队竞技
        case SceneTypeGameCategoryCasual://    休闲娱乐类
        case SceneTypeGameCategoryInteractive://    互动礼物
        case SceneTypeGameCategoryBetting://    Betting Games
        case SceneTypeGameCategoryLingxian:
            vc = ThirdGameViewController.new;
            break;
        default:
            vc = [[AudioRoomViewController alloc] init];
            break;
    }
    [vc createService];
    vc.service.sceneType = paramModel.configModel.enterRoomModel.sceneType;
    vc.service.roleType = paramModel.configModel.enterRoomModel.roleType;
    vc.configModel = paramModel.configModel;
    return vc;
}



@end
