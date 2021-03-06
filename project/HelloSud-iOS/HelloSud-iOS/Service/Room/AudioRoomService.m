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
- (void)reqCreateRoom:(NSInteger)sceneType {
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
    WeakSelf
    [HttpService postRequestWithApi:kINTERACTURL(@"room/create-room/v1") param:dicParam success:^(NSDictionary *rootDict) {
        self.isReqCreate = NO;
        EnterRoomModel *model = [EnterRoomModel decodeModel:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.errorMsg];
            return;
        }
        [weakSelf reqEnterRoom:model.roomId success:nil fail:nil];
    } failure:^(id error) {
        self.isReqCreate = NO;
        [ToastUtil show:[error debugDescription]];
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
    [HttpService postRequestWithApi:kINTERACTURL(@"room/enter-room/v1") param:dicParam success:^(NSDictionary *rootDict) {
        self.isReqEnter = NO;
        EnterRoomModel *model = [EnterRoomModel decodeModel:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.errorMsg];
            return;
        }
        weakSelf.roleType = model.roleType;
        AudioRoomViewController *vc = [[AudioRoomViewController alloc] init];
        vc.gameId = model.gameId;
        vc.roomID = [NSString stringWithFormat:@"%ld", model.roomId];
        vc.roomType = model.gameId == 0 ? HSAudio : HSGame;
        vc.roomName = model.roomName;
        [[AppUtil currentViewController].navigationController pushViewController:vc animated:true];
        if (success) {
            success();
        }
    } failure:^(id error) {
        self.isReqEnter = NO;
        [ToastUtil show:[error debugDescription]];
        if (fail) {
            fail(error);
        }
    }];
}

/// 请求退出房间
/// @param roomId 房间ID
- (void)reqExitRoom:(long)roomId {
    [self resetRoomInfo];
    [HttpService postRequestWithApi:kINTERACTURL(@"room/exit-room/v1") param:@{@"roomId": @(roomId)} success:^(NSDictionary *rootDict) {
        ExitRoomModel *model = [ExitRoomModel decodeModel:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.errorMsg];
            return;
        }
        
    } failure:^(id error) {
        [ToastUtil show:[error debugDescription]];
    }];
}

/// 匹配开播的游戏，并进入游戏房间
/// @param gameId 游戏ID
- (void)reqMatchRoom:(long)gameId sceneType:(long)sceneType {
    WeakSelf
    NSMutableDictionary *dicParam = NSMutableDictionary.new;
    dicParam[@"gameId"] = @(gameId);
    dicParam[@"sceneType"] = @(sceneType);
    if (AppService.shared.rtcType.length > 0) {
        dicParam[@"rtcType"] = AppService.shared.rtcType;
    }
    [HttpService postRequestWithApi:kINTERACTURL(@"room/match-room/v1") param:dicParam success:^(NSDictionary *rootDict) {
        MatchRoomModel *model = [MatchRoomModel decodeModel:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.errorMsg];
            return;
        }
        weakSelf.roleType = model.roleType;
        AudioRoomViewController *vc = [[AudioRoomViewController alloc] init];
        vc.roomID = [NSString stringWithFormat:@"%ld", model.roomId];
        vc.gameId = model.gameId;
        vc.roomType = model.gameId == 0 ? HSAudio : HSGame;
        vc.roomName = model.roomName;
        [[AppUtil currentViewController].navigationController pushViewController:vc animated:true];
    } failure:^(id error) {
        [ToastUtil show:[error debugDescription]];
    }];
}

/// 用户上麦或下麦
/// @param roomId 房间ID
/// @param micIndex 麦位索引
/// @param handleType 0：上麦 1: 下麦
- (void)reqSwitchMic:(long)roomId micIndex:(int)micIndex handleType:(int)handleType success:(nullable EmptyBlock)success fail:(nullable ErrorBlock)fail {
    WeakSelf
    [HttpService postRequestWithApi:kINTERACTURL(@"room/switch-mic/v1") param:@{@"roomId": @(roomId), @"micIndex": @(micIndex), @"handleType": @(handleType)} success:^(NSDictionary *rootDict) {
        SwitchMicModel *model = [SwitchMicModel decodeModel:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.errorMsg];
            if (fail) {
                fail([NSError dt_errorWithCode:model.retCode msg:model.retMsg]);
            }
            return;
        }
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
        
    } failure:^(id error) {
        [ToastUtil show:[error debugDescription]];
        if (fail) {
            fail(error);
        }
    }];
}

/// 查询房间麦位列表
/// @param roomId 房间ID
- (void)reqMicList:(long)roomId success:(void(^)(NSArray<HSRoomMicList *> *micList))success fail:(ErrorBlock)fail {

    [HttpService postRequestWithApi:kINTERACTURL(@"room/mic/list/v1") param:@{@"roomId": @(roomId)} success:^(NSDictionary *rootDict) {
        MicListModel *model = [MicListModel decodeModel:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.errorMsg];
            if (fail) {
                fail([NSError dt_errorWithCode:model.retCode msg:model.retMsg]);
            }
            return;
        }
        if (success) {
            success(model.roomMicList);
        }
        
    } failure:^(id error) {
        [ToastUtil show:[error debugDescription]];
        if (fail) {
            fail(error);
        }
    }];
}

/// 切换房间游戏接口
/// @param roomId 房间ID
- (void)reqSwitchGame:(long)roomId gameId:(long)gameId success:(EmptyBlock)success fail:(ErrorBlock)fail {

    [HttpService postRequestWithApi:kINTERACTURL(@"room/switch-game/v1") param:@{@"roomId": @(roomId), @"gameId": @(gameId)} success:^(NSDictionary *rootDict) {
        SwitchGameModel *model = [SwitchGameModel decodeModel:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.errorMsg];
            if (fail) {
                fail([NSError dt_errorWithCode:model.retCode msg:model.retMsg]);
            }
            return;
        }
        if (success) {
            success();
        }
        
    } failure:^(id error) {
        [ToastUtil show:[error debugDescription]];
        if (fail) {
            fail(error);
        }
    }];
}


@end
