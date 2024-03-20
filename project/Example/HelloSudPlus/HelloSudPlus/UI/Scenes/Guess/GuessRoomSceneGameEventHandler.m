//
//  GuessRoomSceneGameEventHandler.m
//  HelloSudPlus
//
//  Created by kaniel on 2024/3/19.
//  Copyright © 2024 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GuessRoomSceneGameEventHandler.h"

@implementation GuessRoomSceneGameEventHandler
/// 接管加入游戏
- (void)onGameMGCommonSelfClickJoinBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickCancelJoinBtn *)model {
    if ([self.vc respondsToSelector:@selector(onGameMGCommonSelfClickJoinBtn:model:)]) {
        [self onGameMGCommonSelfClickJoinBtn:handle model:model];
    }
}
/// 游戏: 游戏状态   MG_COMMON_GAME_STATE
- (void)onGameMGCommonGameState:(id <ISudFSMStateHandle>)handle model:(MGCommonGameState *)model {
    if ([self.vc respondsToSelector:@selector(onGameMGCommonGameState:model:)]) {
        [self onGameMGCommonGameState:handle model:model];
    }
}

/// 游戏: 游戏结算状态     MG_COMMON_GAME_SETTLE
- (void)onGameMGCommonGameSettle:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSettleModel *)model {
    if ([self.vc respondsToSelector:@selector(onGameMGCommonGameSettle:model:)]) {
        [self onGameMGCommonGameSettle:handle model:model];
    }
}
@end
