//
//  CrossAppSceneGameEventHandler.m
//  HelloSudPlus
//
//  Created by kaniel on 2024/3/19.
//  Copyright © 2024 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "CrossAppSceneGameEventHandler.h"
#import "CrossAppViewController.h"

@implementation CrossAppSceneGameEventHandler
/// 游戏: 结算界面关闭按钮点击状态   MG_COMMON_SELF_CLICK_GAME_SETTLE_CLOSE_BTN
- (void)onGameMGCommonSelfClickGameSettleCloseBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickGameSettleCloseBtn *)model {
    if ([self.vc isKindOfClass:CrossAppViewController.class]) {
        CrossAppViewController *vc = (CrossAppViewController *)self.vc;
        [vc onGameMGCommonSelfClickGameSettleCloseBtn:handle model:model];
    }
}
@end
