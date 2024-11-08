//
//  LeagueRoomSceneGameEventHandler.m
//  HelloSudPlus
//
//  Created by kaniel on 2024/3/19.
//  Copyright © 2024 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "LeagueRoomSceneGameEventHandler.h"
#import "LeagueRoomViewController.h"

@implementation LeagueRoomSceneGameEventHandler
/// 接管加入游戏
- (void)onGameMGCommonSelfClickJoinBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickJoinBtn *)model {
    if ([self.vc respondsToSelector:@selector(onGameMGCommonSelfClickJoinBtn:model:)]) {
        [self.vc onGameMGCommonSelfClickJoinBtn:handle model:model];
    }
}

/// 游戏: 游戏结算状态     MG_COMMON_GAME_SETTLE
- (void)onGameMGCommonGameSettle:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSettleModel *)model{
    if ([self.vc respondsToSelector:@selector(onGameMGCommonGameSettle:model:)]) {
        [self.vc onGameMGCommonGameSettle:handle model:model];
    }
}

/// 游戏: 游戏状态   MG_COMMON_GAME_STATE
- (void)onGameMGCommonGameState:(id <ISudFSMStateHandle>)handle model:(MGCommonGameState *)model {
    if ([self.vc respondsToSelector:@selector(onGameMGCommonGameState:model:)]) {
        [self.vc onGameMGCommonGameState:handle model:model];
    }
}
@end
