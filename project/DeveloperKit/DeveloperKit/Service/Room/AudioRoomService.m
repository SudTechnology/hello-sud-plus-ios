//
//  AudioRoomService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "AudioRoomService.h"
#import "SuspendRoomView.h"

@interface AudioRoomService()
@end

@implementation AudioRoomService

/// 请求创建房间
/// @param sceneType 场景类型
/// @param gameLevel 游戏等级（适配当前门票场景）= -1
+ (void)reqCreateRoom:(NSInteger)sceneType gameLevel:(NSInteger)gameLevel {

    static BOOL isReqCreate = false;

    if (isReqCreate) {
        NSLog(@"there is req create room, so skip it");
        return;
    }
    isReqCreate = YES;
    NSMutableDictionary *dicParam = NSMutableDictionary.new;
    dicParam[@"sceneType"] = @(sceneType);
    if (AppService.shared.rtcType.length > 0) {
        dicParam[@"rtcType"] = AppService.shared.rtcType;
    }
    if (sceneType == SceneTypeTicket) {
        dicParam[@"gameLevel"] = @(gameLevel);
    }
    WeakSelf
    [HSHttpService postRequestWithURL:kINTERACTURL(@"room/create-room/v1") param:dicParam respClass:EnterRoomModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        isReqCreate = NO;
        EnterRoomModel *model = (EnterRoomModel *)resp;
        [AudioRoomService reqEnterRoom:model.roomId crossSecret:nil success:nil fail:nil];
    } failure:^(NSError *error) {
        isReqCreate = NO;
    }];
}

/// 请求进入房间
/// @param roomId 房间ID
+ (void)reqEnterRoom:(long)roomId crossSecret:(NSString *)crossSecret success:(nullable EmptyBlock)success fail:(nullable ErrorBlock)fail {
    WeakSelf

    // 如果存在挂起房间，则退出当前挂起房间
    if ([SuspendRoomView isShowSuspend]) {
        [SuspendRoomView exitRoom:^{
            [self handleEnterRoom:roomId crossSecret:crossSecret success:success fail:fail];
        }];
        return;
    }
    [self handleEnterRoom:roomId crossSecret:crossSecret success:success fail:fail];
}

/// 处理进入房间
/// @param roomId 房间ID
+ (void)handleEnterRoom:(long)roomId crossSecret:(NSString *)crossSecret success:(nullable EmptyBlock)success fail:(nullable ErrorBlock)fail {
    WeakSelf

    static BOOL isReqEnter = false;
    if (isReqEnter) {
        NSLog(@"there is req enter room, so skip it");
        return;
    }
    isReqEnter = YES;
    // 如果存在挂起房间，则退出当前挂起房间
    if ([SuspendRoomView isShowSuspend]) {
        [SuspendRoomView exitRoom:^{

        }];
        kAudioRoomService.currentRoomVC = nil;
    }
    NSMutableDictionary *dicParam = NSMutableDictionary.new;
    dicParam[@"roomId"] = @(roomId);
    if (AppService.shared.rtcType.length > 0) {
        dicParam[@"rtcType"] = AppService.shared.rtcType;
    }
    [HSHttpService postRequestWithURL:kINTERACTURL(@"room/enter-room/v1") param:dicParam respClass:EnterRoomModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        isReqEnter = NO;
        EnterRoomModel *model = (EnterRoomModel *) resp;
        model.crossSecret = crossSecret;
        if (kAudioRoomService.currentRoomVC != nil) {
            NSLog(@"there is a AudioRoomViewController in the stack");
            return;
        }

        AudioSceneConfigModel *config = [[AudioSceneConfigModel alloc] init];
        config.gameId = model.gameId;
        config.roomID = [NSString stringWithFormat:@"%ld", model.roomId];
        config.roomNumber = [NSString stringWithFormat:@"%ld", model.roomNumber];
        config.roomType = model.gameId == 0 ? HSAudio : HSGame;
        config.roomName = model.roomName;
        config.roleType = model.roleType;
        config.enterRoomModel = model;
        BaseSceneViewController *vc = [SceneFactory createSceneVC:model.sceneType configModel:config];
        [[AppUtil currentViewController].navigationController pushViewController:vc animated:true];
        if (success) {
            success();
        }
    }                         failure:^(NSError *error) {
        isReqEnter = NO;
        if (fail) {
            fail(error);
        }
    }];
}

/// 匹配开播的游戏，并进入游戏房间
/// @param gameId 游戏ID
/// @param gameLevel 游戏等级（适配当前门票场景）= -1
+ (void)reqMatchRoom:(long)gameId sceneType:(long)sceneType gameLevel:(NSInteger)gameLevel {
    WeakSelf

    static BOOL isMatchingRoom = false;
    if (isMatchingRoom) {
        NSLog(@"there is req match room, so skip it");
        return;
    }
    isMatchingRoom = YES;
    NSMutableDictionary *dicParam = NSMutableDictionary.new;
    dicParam[@"gameId"] = @(gameId);
    dicParam[@"sceneType"] = @(sceneType);
    if (AppService.shared.rtcType.length > 0) {
        dicParam[@"rtcType"] = AppService.shared.rtcType;
    }
    if (sceneType == SceneTypeTicket) {
        dicParam[@"gameLevel"] = @(gameLevel);
    }
    [HSHttpService postRequestWithURL:kINTERACTURL(@"room/match-room/v1") param:dicParam respClass:MatchRoomModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        MatchRoomModel *model = (MatchRoomModel *)resp;
        [AudioRoomService reqEnterRoom:model.roomId crossSecret:nil success:^{
            isMatchingRoom = NO;
        }                         fail:^(NSError *error) {
            [ToastUtil show:[error debugDescription]];
            isMatchingRoom = NO;
        }];
    } failure:^(NSError *error) {
        isMatchingRoom = NO;
    }];
}

/// 重置用户信息
- (void)resetRoomInfo {
    self.roleType = 0;
    self.micIndex = -1;
    self.currentRoomVC = nil;
}

/// 请求退出房间
/// @param roomId 房间ID
- (void)reqExitRoom:(long)roomId {
    [self resetRoomInfo];
//    [HSHttpService postRequestWithURL:kINTERACTURL(@"room/exit-room/v1") param:@{@"roomId": @(roomId)} respClass:ExitRoomModel.class showErrorToast:YES success:nil failure:nil];
}



/// 用户上麦或下麦
/// @param roomId 房间ID
/// @param micIndex 麦位索引
/// @param handleType 0：上麦 1: 下麦
- (void)reqSwitchMic:(long)roomId micIndex:(int)micIndex handleType:(int)handleType success:(nullable EmptyBlock)success fail:(nullable ErrorBlock)fail {
    
    if (success) success();
    
//    WeakSelf
//    [HSHttpService postRequestWithURL:kINTERACTURL(@"room/switch-mic/v1") param:@{@"roomId": @(roomId), @"micIndex": @(micIndex), @"handleType": @(handleType)} respClass:SwitchMicModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
//        SwitchMicModel *model = (SwitchMicModel *)resp;
//        if (handleType == 0) {
//            RoomCmdUpMicModel *upMicModel = [RoomCmdUpMicModel makeUpMicMsgWithMicIndex:micIndex];
//            weakSelf.micIndex = micIndex;
//            upMicModel.roleType = self.roleType;
//            upMicModel.streamID = model.streamId;
//            [weakSelf.currentRoomVC sendMsg:upMicModel isAddToShow:NO finished:nil];
//        } else {
//            weakSelf.micIndex = -1;
//            RoomCmdUpMicModel *downMicModel = [RoomCmdUpMicModel makeDownMicMsgWithMicIndex:micIndex];
//            downMicModel.streamID = nil;
//            [weakSelf.currentRoomVC sendMsg:downMicModel isAddToShow:NO finished:nil];
//        }
//        if (success) {
//            success();
//        }
//    } failure:fail];
}

/// 查询房间麦位列表
/// @param roomId 房间ID
- (void)reqMicList:(long)roomId success:(void(^)(NSArray<HSRoomMicList *> *micList))success fail:(ErrorBlock)fail {
    
    if (success) success(@[]);

//    [HSHttpService postRequestWithURL:kINTERACTURL(@"room/mic/list/v1") param:@{@"roomId": @(roomId)}  respClass:MicListModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
//        MicListModel *model = (MicListModel *)resp;
//        if (success) {
//            success(model.roomMicList);
//        }
//    } failure:fail];
}

/// 切换房间游戏接口
/// @param roomId 房间ID
- (void)reqSwitchGame:(long)roomId gameId:(int64_t)gameId success:(EmptyBlock)success fail:(ErrorBlock)fail {

    if (success) success();
//    [HSHttpService postRequestWithURL:kINTERACTURL(@"room/switch-game/v1") param:@{@"roomId": @(roomId), @"gameId": @(gameId)} respClass:SwitchGameModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
//        if (success) {
//            success();
//        }
//    } failure:fail];
}

/// 获取跨域房间列表
/// @param authSecret authSecret description
/// @param pageNumber pageNumber description
/// @param success success description
/// @param fail fail description
+ (void)reqCrossRoomList:(NSString *)authSecret pageNumber:(NSInteger)pageNumber success:(void (^)(NSArray <CrossRoomModel *> *roomList))success fail:(nullable ErrorBlock)fail {
    
    NSDictionary *dic = @{@"authSecret":@"", @"page_number":@(pageNumber), @"page_size":@(50)};
    [HSHttpService postRequestWithURL:kMGPURL(@"get_auth_room_list") param:dic respClass:RespCrossRoomListModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        RespCrossRoomListModel *model = (RespCrossRoomListModel *) resp;
        if (success) {
            success(model.roomInfos);
        }
    }                        failure:fail];
}

#pragma mark - Custom
+ (RoomCustomModel *)getCustomModel {
    RoomCustomModel *model = [SettingsService roomCustomModel];
    if (model) {
        return model;
    }
    NSDictionary *dataDic = [SettingsService readJsonLocalFileWithName:@"CustomCfgData"];
    RoomCustomModel *m = [RoomCustomModel mj_objectWithKeyValues:dataDic];
    return m;
}

+ (GameCfgModel *)getGameCfgModel {
    return [[self getCustomModel] getCfgModel];
}
@end
