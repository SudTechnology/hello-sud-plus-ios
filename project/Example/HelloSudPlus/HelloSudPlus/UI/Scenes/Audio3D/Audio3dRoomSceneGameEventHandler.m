//
//  Audio3dRoomSceneGameEventHandler.m
//  HelloSudPlus
//
//  Created by kaniel on 2024/3/19.
//  Copyright © 2024 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "Audio3dRoomSceneGameEventHandler.h"
#import "Audio3DRoomViewController.h"

@implementation Audio3dRoomSceneGameEventHandler

/// 请求房间数据 MG_CUSTOM_CR_ROOM_INIT_DATA
- (void)onGameMGCustomCrRoomInitData:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomCrRoomInitData *)model {
    if( [self.vc isKindOfClass:Audio3DRoomViewController.class]) {
        Audio3DRoomViewController *vc = (Audio3DRoomViewController *)self.vc;
        [vc onGameMGCustomCrRoomInitData:handle model:model];
    }
}

/// 点击主播位或老板位通知 MG_CUSTOM_CR_CLICK_SEAT
- (void)onGameMGCustomCrClickSeat:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomCrClickSeat *)model {
    if( [self.vc isKindOfClass:Audio3DRoomViewController.class]) {
        Audio3DRoomViewController *vc = (Audio3DRoomViewController *)self.vc;
        [vc onGameMGCustomCrClickSeat:handle model:model];
    }
}

/// 游戏加载进度(loadMG)
/// @param stage start=1,loading=2,end=3
/// @param retCode 错误码，0成功
/// @param progress [0, 100]
/// 最低版本：v1.1.30.xx
- (void)onGameLoadingProgress:(int)stage retCode:(int)retCode progress:(int)progress {
    if( [self.vc isKindOfClass:Audio3DRoomViewController.class]) {
        Audio3DRoomViewController *vc = (Audio3DRoomViewController *)self.vc;
        [vc onGameLoadingProgress:stage retCode:retCode progress:progress];
    }
}
@end
