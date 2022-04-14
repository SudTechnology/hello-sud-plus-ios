//
//  AudioRoomService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "AudioRoomService.h"

@interface AudioRoomService()
@property(nonatomic, assign)BOOL isReqCreate;
@property(nonatomic, assign)BOOL isReqEnter;
@property(nonatomic, assign)BOOL isMatchingRoom;
@end

@implementation AudioRoomService
+ (instancetype)shared {
    static AudioRoomService *g_manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        g_manager = AudioRoomService.new;
        [g_manager resetRoomInfo];
    });
    return g_manager;
}

/// 重置用户信息
- (void)resetRoomInfo {
    self.roleType = 0;
    self.micIndex = -1;
    self.currentRoomVC = nil;
}

/// 请求创建房间
/// @param sceneType 场景类型
/// @param gameLevel 游戏等级（适配当前门票场景）= -1
- (void)reqCreateRoom:(NSInteger)sceneType gameLevel:(NSInteger)gameLevel {
    if (self.isReqCreate) {
        NSLog(@"there is req create room, so skip it");
        return;
    }
    self.isReqCreate = YES;
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
        self.isReqCreate = NO;
        EnterRoomModel *model = (EnterRoomModel *)resp;
        [weakSelf reqEnterRoom:model.roomId success:nil fail:nil];
    } failure:^(NSError *error) {
        self.isReqCreate = NO;
    }];
}

/// 请求进入房间
/// @param roomId 房间ID
- (void)reqEnterRoom:(long)roomId success:(nullable EmptyBlock)success fail:(nullable ErrorBlock)fail {
    WeakSelf
    if (self.isReqEnter) {
        NSLog(@"there is req enter room, so skip it");
        return;
    }
    self.isReqEnter = YES;
    NSMutableDictionary *dicParam = NSMutableDictionary.new;
    dicParam[@"roomId"] = @(roomId);
    if (AppService.shared.rtcType.length > 0) {
        dicParam[@"rtcType"] = AppService.shared.rtcType;
    }
    [HSHttpService postRequestWithURL:kINTERACTURL(@"room/enter-room/v1") param:dicParam respClass:EnterRoomModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        self.isReqEnter = NO;
        EnterRoomModel *model = (EnterRoomModel *)resp;
        if (AudioRoomService.shared.currentRoomVC != nil) {
            NSLog(@"there is a AudioRoomViewController in the stack");
            return;
        }
        weakSelf.sceneType = model.sceneType;
        AppService.shared.ticket.ticketLevelType = model.gameLevel;
        weakSelf.roleType = model.roleType;
        AudioSceneConfigModel *config = [[AudioSceneConfigModel alloc] init];
        config.gameId = model.gameId;
        config.roomID = [NSString stringWithFormat:@"%ld", model.roomId];
        config.roomNumber = [NSString stringWithFormat:@"%ld", model.roomNumber];
        config.roomType = model.gameId == 0 ? HSAudio : HSGame;
        config.roomName = model.roomName;
        config.enterRoomModel = model;
        BaseSceneViewController *vc = [SceneFactory createSceneVC:weakSelf.sceneType configModel:config];
        AudioRoomService.shared.currentRoomVC = vc;
        [[AppUtil currentViewController].navigationController pushViewController:vc animated:true];
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        self.isReqEnter = NO;
        if (fail) {
            fail(error);
        }
    }];
}

/// 请求退出房间
/// @param roomId 房间ID
- (void)reqExitRoom:(long)roomId {
    [self resetRoomInfo];
    [HSHttpService postRequestWithURL:kINTERACTURL(@"room/exit-room/v1") param:@{@"roomId": @(roomId)} respClass:ExitRoomModel.class showErrorToast:YES success:nil failure:nil];
}

/// 匹配开播的游戏，并进入游戏房间
/// @param gameId 游戏ID
/// @param gameLevel 游戏等级（适配当前门票场景）= -1 
- (void)reqMatchRoom:(long)gameId sceneType:(long)sceneType gameLevel:(NSInteger)gameLevel {
    WeakSelf
    if (self.isMatchingRoom) {
        NSLog(@"there is req match room, so skip it");
        return;
    }
    self.isMatchingRoom = YES;
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
        [self reqEnterRoom:model.roomId success:^{
            weakSelf.isMatchingRoom = NO;
        } fail:^(NSError *error) {
            [ToastUtil show:[error debugDescription]];
            weakSelf.isMatchingRoom = NO;
        }];
    } failure:^(NSError *error) {
        weakSelf.isMatchingRoom = NO;
    }];
}

/// 用户上麦或下麦
/// @param roomId 房间ID
/// @param micIndex 麦位索引
/// @param handleType 0：上麦 1: 下麦
- (void)reqSwitchMic:(long)roomId micIndex:(int)micIndex handleType:(int)handleType success:(nullable EmptyBlock)success fail:(nullable ErrorBlock)fail {
    WeakSelf
    [HSHttpService postRequestWithURL:kINTERACTURL(@"room/switch-mic/v1") param:@{@"roomId": @(roomId), @"micIndex": @(micIndex), @"handleType": @(handleType)} respClass:SwitchMicModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        SwitchMicModel *model = (SwitchMicModel *)resp;
        if (handleType == 0) {
            RoomCmdUpMicModel *upMicModel = [RoomCmdUpMicModel makeUpMicMsgWithMicIndex:micIndex];
            weakSelf.micIndex = micIndex;
            upMicModel.roleType = self.roleType;
            upMicModel.streamID = model.streamId;
            [weakSelf.currentRoomVC sendMsg:upMicModel isAddToShow:NO];
        } else {
            weakSelf.micIndex = -1;
            RoomCmdUpMicModel *downMicModel = [RoomCmdUpMicModel makeDownMicMsgWithMicIndex:micIndex];
            downMicModel.streamID = nil;
            [weakSelf.currentRoomVC sendMsg:downMicModel isAddToShow:NO];
        }
        if (success) {
            success();
        }
    } failure:fail];
}

/// 查询房间麦位列表
/// @param roomId 房间ID
- (void)reqMicList:(long)roomId success:(void(^)(NSArray<HSRoomMicList *> *micList))success fail:(ErrorBlock)fail {

    [HSHttpService postRequestWithURL:kINTERACTURL(@"room/mic/list/v1") param:@{@"roomId": @(roomId)}  respClass:MicListModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        MicListModel *model = (MicListModel *)resp;
        if (success) {
            success(model.roomMicList);
        }
    } failure:fail];
}

/// 切换房间游戏接口
/// @param roomId 房间ID
- (void)reqSwitchGame:(long)roomId gameId:(long)gameId success:(EmptyBlock)success fail:(ErrorBlock)fail {

    [HSHttpService postRequestWithURL:kINTERACTURL(@"room/switch-game/v1") param:@{@"roomId": @(roomId), @"gameId": @(gameId)} respClass:SwitchGameModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (success) {
            success();
        }
    } failure:fail];
}

#pragma mark - TicketService
- (NSMutableArray <NSAttributedString *> *)getTicketRewardAttributedStrArr {
    return @[];
}
@end
