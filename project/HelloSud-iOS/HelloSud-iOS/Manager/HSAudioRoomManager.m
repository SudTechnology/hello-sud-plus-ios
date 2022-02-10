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

/// 请求进入房间
/// @param roomId 房间ID
- (void)reqEnterRoom:(long)roomId {
    [RequestService postRequestWithApi:kINTERACTURL(@"room/enter-room/v1") param:@{@"roomId": @(roomId)} success:^(NSDictionary *rootDict) {
        HSEnterRoomModel *model = [HSEnterRoomModel mj_objectWithKeyValues:rootDict];
        if (model.retCode != 0) {
            [SVProgressHUD showErrorWithStatus:model.retMsg];
            return;
        }
        HSAudioRoomViewController *vc = [[HSAudioRoomViewController alloc] init];
        vc.roomID = [NSString stringWithFormat:@"%ld", model.data.roomId];
        vc.roomType = model.data.gameId == 0 ? HSAudio : HSGame;
        [[AppUtil currentViewController].navigationController pushViewController:vc animated:true];
    } failure:^(id error) {
        [SVProgressHUD showErrorWithStatus:[error debugDescription]];
    }];
}

/// 请求退出房间
/// @param roomId 房间ID
- (void)reqExitRoom:(long)roomId{
    [RequestService postRequestWithApi:kINTERACTURL(@"room/exit-room/v1") param:@{@"roomId": @(roomId)} success:^(NSDictionary *rootDict) {
        HSExitRoomModel *model = [HSExitRoomModel mj_objectWithKeyValues:rootDict];
        if (model.retCode != 0) {
            [SVProgressHUD showErrorWithStatus:model.retMsg];
            return;
        }
        
    } failure:^(id error) {
        [SVProgressHUD showErrorWithStatus:[error debugDescription]];
    }];
}

/// 匹配开播的游戏，并进入游戏房间
/// @param gameId 游戏ID
- (void)reqMatchRoom:(long)gameId sceneType:(long)sceneType {
    [RequestService postRequestWithApi:kINTERACTURL(@"room/match-room/v1") param:@{@"gameId": @(gameId), @"sceneType": @(sceneType)} success:^(NSDictionary *rootDict) {
        HSMatchRoomModel *model = [HSMatchRoomModel mj_objectWithKeyValues:rootDict];
        if (model.retCode != 0) {
            [SVProgressHUD showErrorWithStatus:model.retMsg];
            return;
        }
        HSAudioRoomViewController *vc = [[HSAudioRoomViewController alloc] init];
        vc.roomID = [NSString stringWithFormat:@"%ld", model.data.roomId];
        vc.gameId = model.data.gameId;
        vc.roomType = model.data.gameId == 0 ? HSAudio : HSGame;
//        vc.roomType = HSAudio;
        [[AppUtil currentViewController].navigationController pushViewController:vc animated:true];
    } failure:^(id error) {
        [SVProgressHUD showErrorWithStatus:[error debugDescription]];
    }];
}

/// 用户上麦或下麦
/// @param roomId 房间ID
/// @param micIndex 麦位索引
/// @param handleType 0：上麦 1: 下麦
- (void)reqSwitchMic:(long)roomId micIndex:(int)micIndex handleType:(int)handleType {
    WeakSelf
    [RequestService postRequestWithApi:kINTERACTURL(@"room/switch-mic/v1") param:@{@"roomId": @(roomId), @"micIndex": @(micIndex), @"handleType": @(handleType)} success:^(NSDictionary *rootDict) {
        HSSwitchMicModel *model = [HSSwitchMicModel mj_objectWithKeyValues:rootDict];
        if (model.retCode != 0) {
            [SVProgressHUD showErrorWithStatus:model.retMsg];
            return;
        }
        if (handleType == 0) {
            HSAudioMsgMicModel *upMicModel = [HSAudioMsgMicModel makeUpMicMsgWithMicIndex:micIndex];
            upMicModel.streamID = model.data.streamId;
            [self.currentRoomVC sendMsg:upMicModel isAddToShow:YES];
        } else {
            HSAudioMsgMicModel *downMicModel = [HSAudioMsgMicModel makeDownMicMsgWithMicIndex:micIndex];
            downMicModel.streamID = nil;
            [self.currentRoomVC sendMsg:downMicModel isAddToShow:YES];
        }
        
    } failure:^(id error) {
        [SVProgressHUD showErrorWithStatus:[error debugDescription]];
    }];
}

/// 查询房间麦位列表
/// @param roomId 房间ID
- (void)reqMicList:(long)roomId success:(void(^)(NSArray<HSRoomMicList *> *micList))success fail:(ErrorBlock)fail {
    WeakSelf
    [RequestService postRequestWithApi:kINTERACTURL(@"room/mic/list/v1") param:@{@"roomId": @(roomId)} success:^(NSDictionary *rootDict) {
        HSMicListModel *model = [HSMicListModel mj_objectWithKeyValues:rootDict];
        if (model.retCode != 0) {
            [SVProgressHUD showErrorWithStatus:model.retMsg];
            if (fail) {
                fail([NSError hsErrorWithCode:model.retCode msg:model.retMsg]);
            }
            return;
        }
        if (success) {
            success(model.data.roomMicList);
        }
        
    } failure:^(id error) {
        [SVProgressHUD showErrorWithStatus:[error debugDescription]];
        if (fail) {
            fail(error);
        }
    }];
}

/// 切换房间游戏接口
/// @param roomId 房间ID
- (void)reqSwitchGame:(long)roomId gameId:(long)gameId success:(EmptyBlock)success fail:(ErrorBlock)fail {

    [RequestService postRequestWithApi:kINTERACTURL(@"room/switch-game/v1") param:@{@"roomId": @(roomId), @"gameId": @(gameId)} success:^(NSDictionary *rootDict) {
        HSSwitchGameModel *model = [HSSwitchGameModel mj_objectWithKeyValues:rootDict];
        if (model.retCode != 0) {
            [SVProgressHUD showErrorWithStatus:model.retMsg];
            if (fail) {
                fail([NSError hsErrorWithCode:model.retCode msg:model.retMsg]);
            }
            return;
        }
        if (success) {
            success();
        }
        
    } failure:^(id error) {
        [SVProgressHUD showErrorWithStatus:[error debugDescription]];
        if (fail) {
            fail(error);
        }
    }];
}


@end