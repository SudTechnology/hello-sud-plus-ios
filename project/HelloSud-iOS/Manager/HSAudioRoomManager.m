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
    WeakSelf
    [RequestService postRequestWithApi:kBASEURL(@"room/enter/v1") param:@{@"roomId": @(roomId)} success:^(NSDictionary *rootDict) {
        HSEnterRoomModel *model = [HSEnterRoomModel mj_objectWithKeyValues:rootDict];
        if (model.retCode != 0) {
            [SVProgressHUD showErrorWithStatus:model.retMsg];
            return;
        }
        
    } failure:^(id error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

/// 请求退出房间
/// @param roomId 房间ID
- (void)reqExitRoom:(long)roomId {
    WeakSelf
    [RequestService postRequestWithApi:kBASEURL(@"room/exit/v1") param:@{@"roomId": @(roomId)} success:^(NSDictionary *rootDict) {
        HSExitRoomModel *model = [HSExitRoomModel mj_objectWithKeyValues:rootDict];
        if (model.retCode != 0) {
            [SVProgressHUD showErrorWithStatus:model.retMsg];
            return;
        }
        
    } failure:^(id error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

/// 匹配开播的游戏，并进入游戏房间
/// @param gameId 游戏ID
- (void)reqMatchRoom:(long)gameId {
    WeakSelf
    [RequestService postRequestWithApi:kBASEURL(@"room/match/v1") param:@{@"gameId": @(gameId)} success:^(NSDictionary *rootDict) {
        HSMatchRoomModel *model = [HSMatchRoomModel mj_objectWithKeyValues:rootDict];
        if (model.retCode != 0) {
            [SVProgressHUD showErrorWithStatus:model.retMsg];
            return;
        }
        
    } failure:^(id error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

/// 用户上麦或下麦
/// @param roomId 房间ID
/// @param micIndex 麦位索引
/// @param handleType 0：上麦 1: 下麦
- (void)reqSwitchMic:(long)roomId micIndex:(int)micIndex handleType:(int)handleType {
    WeakSelf
    [RequestService postRequestWithApi:kBASEURL(@"room/mic/switch/v1") param:@{@"roomId": @(roomId), @"micIndex": @(micIndex), @"handleType": @(handleType)} success:^(NSDictionary *rootDict) {
        HSSwitchMicModel *model = [HSSwitchMicModel mj_objectWithKeyValues:rootDict];
        if (model.retCode != 0) {
            [SVProgressHUD showErrorWithStatus:model.retMsg];
            return;
        }
        
    } failure:^(id error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

/// 查询房间麦位列表
/// @param roomId 房间ID
- (void)reqMicList:(long)roomId {
    WeakSelf
    [RequestService postRequestWithApi:kBASEURL(@"room/mic/list/v1") param:@{@"roomId": @(roomId)} success:^(NSDictionary *rootDict) {
        HSMicListModel *model = [HSMicListModel mj_objectWithKeyValues:rootDict];
        if (model.retCode != 0) {
            [SVProgressHUD showErrorWithStatus:model.retMsg];
            return;
        }
        
    } failure:^(id error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

/// 切换房间游戏接口
/// @param roomId 房间ID
- (void)reqSwitchGame:(long)roomId gameId:(long)gameId {
    WeakSelf
    [RequestService postRequestWithApi:kBASEURL(@"room/game/switch/v1") param:@{@"roomId": @(roomId), @"gameId": @(gameId)} success:^(NSDictionary *rootDict) {
        HSSwitchGameModel *model = [HSSwitchGameModel mj_objectWithKeyValues:rootDict];
        if (model.retCode != 0) {
            [SVProgressHUD showErrorWithStatus:model.retMsg];
            return;
        }
        
    } failure:^(id error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

@end
