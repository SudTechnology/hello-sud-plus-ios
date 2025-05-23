//
// Created by kaniel on 2022/12/5.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "InteractiveGameBaseballHandler.h"
#import "InteractiveGameManager.h"

@implementation InteractiveGameBaseballHandler

- (void)hideGameView:(BOOL)notifyGame {
    [super hideGameView:notifyGame];
    if (self.isGamePrepareOK && notifyGame) {
        [self.sudFSTAPPDecorator notifyAppBaseballHideGameScene];
    }
}

/// 展示游戏视图
- (void)showGameView:(BOOL)showMainView {
    [super showGameView:showMainView];
    self.isShowGame = YES;
    self.showMainView = showMainView;
    if (self.isGamePrepareOK && showMainView) {
        [self.sudFSTAPPDecorator notifyAppBaseballShowGameScene];
    }
}

/// 查询排行榜数据(棒球) MG_BASEBALL_RANKING
- (void)onGameMGBaseballRanking:(nonnull id <ISudFSMStateHandle>)handle model:(MGBaseballRanking *)model {

    [BaseballService reqRanking:model finished:^(AppBaseballRankingModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppBaseballRanking:respModel];
    }];
}


/// 查询我的排名(棒球) MG_BASEBALL_MY_RANKING
- (void)onGameMGBaseballMyRanking:(nonnull id <ISudFSMStateHandle>)handle model:(MGBaseballMyRanking *)model {
    [BaseballService reqMyRankingWithFinished:^(AppBaseballMyRankingModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppBaseballMyRanking:respModel];
    }];
}

/// 查询当前距离我的前后玩家数据(棒球) MG_BASEBALL_RANGE_INFO
- (void)onGameMGBaseballRangeInfo:(nonnull id <ISudFSMStateHandle>)handle model:(MGBaseballRangeInfo *)model {

    [BaseballService reqRangeInfo:model finished:^(AppBaseballRangeInfoModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppBaseballRangeInfo:respModel];
    }];
}

/// 前期准备完成(棒球) MG_BASEBALL_PREPARE_FINISH
- (void)onGameMGBaseballPrepareFinish:(nonnull id <ISudFSMStateHandle>)handle{
    self.isGamePrepareOK = YES;
    [self closeLoadingView];
    if (self.isShowGame && self.showMainView) {
        [self.sudFSTAPPDecorator notifyAppBaseballShowGameScene];
    }
}

/// 展示主界面(棒球) MG_BASEBALL_SHOW_GAME_SCENE
- (void)onGameMGBaseballShowGameScene:(nonnull id <ISudFSMStateHandle>)handle{
    DDLogDebug(@"mg：显示棒球主界面");
}

/// 隐藏主界面(棒球) MG_BASEBALL_HIDE_GAME_SCENE
- (void)onGameMGBaseballHideGameScene:(nonnull id <ISudFSMStateHandle>)handle{
    DDLogDebug(@"mg：隐藏棒球主界面");
    // 演示可以不销毁游戏，需要销毁时切换到下面方法即可
    [self hideGameView:NO];
//    [self.interactiveGameManager destoryGame];
}

/// 可点击区域(棒球) MG_BASEBALL_SET_CLICK_RECT
- (void)onGameMGBaseballSetClickRect:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomGameSetClickRect *)model{
    self.gameClickRect = model;
}

/// 创建订单 MG_COMMON_GAME_CREATE_ORDER
- (void)onGameMGCommonGameCreateOrder:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGameCreateOrderModel *)model {

    NSInteger coin = model.value * 5;
    NSString *msg = [NSString stringWithFormat:@"是否消费%@金币打%@次", @(coin), @(model.value)];
    [DTAlertView showTextAlert:msg sureText:@"确认" cancelText:@"取消" onSureCallback:^{
        [DTAlertView close];
        [BaseballService reqPlayBaseballWithNum:model.value roomId:kAudioRoomService.currentRoomVC.roomID cmd:model.cmd finished:^(BaseRespModel *respModel) {

        }];
    } onCloseCallback:^{
        [DTAlertView close];
    }];
}


/// 获取文本配置(棒球) MG_BASEBALL_TEXT_CONFIG
- (void)onGameMGBaseballTextConfig:(nonnull id <ISudFSMStateHandle>)handle {
    [BaseballService reqTextConfigWithFinished:^(AppBaseballTextConfigModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppBaseballTextConfig:respModel];
    }];
}
@end
