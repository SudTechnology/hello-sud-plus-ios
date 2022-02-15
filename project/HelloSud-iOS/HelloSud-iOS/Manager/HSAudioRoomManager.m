//
//  HSAudioRoomManager.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "HSAudioRoomManager.h"

@implementation HSAudioRoomManager
+ (instancetype)shared {
    static HSAudioRoomManager *g_manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        g_manager = HSAudioRoomManager.new;
    });
    return g_manager;
}

/// 重置用户信息
- (void)resetRoomInfo {
    self.roleType = 0;
    self.micIndex = -1;
}

/// 请求进入房间
/// @param roomId 房间ID
- (void)reqEnterRoom:(long)roomId {
    WeakSelf
    NSMutableDictionary *dicParam = NSMutableDictionary.new;
    dicParam[@"roomId"] = @(roomId);
    if (HSAppManager.shared.rtcType.length > 0) {
        dicParam[@"rtcType"] = HSAppManager.shared.rtcType;
    }
    [RequestService postRequestWithApi:kINTERACTURL(@"room/enter-room/v1") param:dicParam success:^(NSDictionary *rootDict) {
        HSEnterRoomModel *model = [HSEnterRoomModel decodeModel:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.errorMsg];
            return;
        }
        HSAudioRoomViewController *vc = [[HSAudioRoomViewController alloc] init];
        vc.gameId = model.gameId;
        vc.roomID = [NSString stringWithFormat:@"%ld", model.roomId];
        vc.roomType = model.gameId == 0 ? HSAudio : HSGame;
        vc.roomName = model.roomName;
        weakSelf.roleType = model.roleType;
        [[AppUtil currentViewController].navigationController pushViewController:vc animated:true];
    } failure:^(id error) {
        [ToastUtil show:[error debugDescription]];
    }];
}

/// 请求退出房间
/// @param roomId 房间ID
- (void)reqExitRoom:(long)roomId {
    [self resetRoomInfo];
    [RequestService postRequestWithApi:kINTERACTURL(@"room/exit-room/v1") param:@{@"roomId": @(roomId)} success:^(NSDictionary *rootDict) {
        HSExitRoomModel *model = [HSExitRoomModel decodeModel:rootDict];
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
    if (HSAppManager.shared.rtcType.length > 0) {
        dicParam[@"rtcType"] = HSAppManager.shared.rtcType;
    }
    [RequestService postRequestWithApi:kINTERACTURL(@"room/match-room/v1") param:dicParam success:^(NSDictionary *rootDict) {
        HSMatchRoomModel *model = [HSMatchRoomModel decodeModel:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.errorMsg];
            return;
        }
        HSAudioRoomViewController *vc = [[HSAudioRoomViewController alloc] init];
        vc.roomID = [NSString stringWithFormat:@"%ld", model.roomId];
        vc.gameId = model.gameId;
        vc.roomType = model.gameId == 0 ? HSAudio : HSGame;
        vc.roomName = model.roomName;
        weakSelf.roleType = model.roleType;
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
    
    [RequestService postRequestWithApi:kINTERACTURL(@"room/switch-mic/v1") param:@{@"roomId": @(roomId), @"micIndex": @(micIndex), @"handleType": @(handleType)} success:^(NSDictionary *rootDict) {
        HSSwitchMicModel *model = [HSSwitchMicModel decodeModel:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.errorMsg];
            if (fail) {
                fail([NSError hsErrorWithCode:model.retCode msg:model.retMsg]);
            }
            return;
        }
        if (handleType == 0) {
            HSAudioMsgMicModel *upMicModel = [HSAudioMsgMicModel makeUpMicMsgWithMicIndex:micIndex];
            self.micIndex = micIndex;
            upMicModel.roleType = self.roleType;
            upMicModel.streamID = model.streamId;
            [self.currentRoomVC sendMsg:upMicModel isAddToShow:NO];
        } else {
            HSAudioMsgMicModel *downMicModel = [HSAudioMsgMicModel makeDownMicMsgWithMicIndex:micIndex];
            downMicModel.streamID = nil;
            [self.currentRoomVC sendMsg:downMicModel isAddToShow:NO];
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

    [RequestService postRequestWithApi:kINTERACTURL(@"room/mic/list/v1") param:@{@"roomId": @(roomId)} success:^(NSDictionary *rootDict) {
        HSMicListModel *model = [HSMicListModel decodeModel:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.errorMsg];
            if (fail) {
                fail([NSError hsErrorWithCode:model.retCode msg:model.retMsg]);
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

    [RequestService postRequestWithApi:kINTERACTURL(@"room/switch-game/v1") param:@{@"roomId": @(roomId), @"gameId": @(gameId)} success:^(NSDictionary *rootDict) {
        HSSwitchGameModel *model = [HSSwitchGameModel decodeModel:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.errorMsg];
            if (fail) {
                fail([NSError hsErrorWithCode:model.retCode msg:model.retMsg]);
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
