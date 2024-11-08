//
//  OrderentertainmentRoomSceneGameEventHandler.m
//  HelloSudPlus
//
//  Created by kaniel on 2024/3/19.
//  Copyright © 2024 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "OrderentertainmentRoomSceneGameEventHandler.h"

@implementation OrderentertainmentRoomSceneGameEventHandler
- (GameViewInfoModel *)onGetGameViewInfo {
    GameViewInfoModel *m = [super onGetGameViewInfo];
    m.view_game_rect.top = (kStatusBarHeight + 44);
    m.view_game_rect.bottom = (kAppSafeBottom + 150);
    return m;
}

/// 游戏: 游戏结算状态     MG_COMMON_GAME_SETTLE
- (void)onGameMGCommonGameSettle:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonGameSettleModel *)model {
    if ([self.vc respondsToSelector:@selector(onGameMGCommonGameSettle:model:)]) {
        [self.vc onGameMGCommonGameSettle:handle model:model];
    }
}
@end
