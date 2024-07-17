//
//  InteractiveGameBigEaterHandler.m
//  HelloSud-iOS
//
//  Created by kaniel on 2023/6/16.
//  Copyright © 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "InteractiveGameBigEaterHandler.h"
#import "InteractiveGameManager.h"

@implementation InteractiveGameBigEaterHandler


- (void)onGameStarted {
    [super onGameStarted];

}

- (void)hideGameView:(BOOL)notifyGame {
    [super hideGameView:notifyGame];
    if (self.isGamePrepareOK && notifyGame) {
        [self.sudFSTAPPDecorator notifyAppCommonHideGameScene];
    }
}

/// 展示游戏视图
- (void)showGameView:(BOOL)showMainView {
    [super showGameView:showMainView];
    self.isShowGame = YES;
    self.showMainView = showMainView;
    if (self.isGamePrepareOK && showMainView) {
        [self.sudFSTAPPDecorator notifyAppCommonShowGameScene];
    }
}

- (GameViewInfoModel *)onGetGameViewInfo {
    GameViewInfoModel *m = [[GameViewInfoModel alloc] init];
    m.view_size.width = kScreenWidth;
    m.view_size.height = kScreenHeight;
    m.view_game_rect.top = (kScreenHeight - kScreenWidth * 1.1);
    m.view_game_rect.left = 0;
    m.view_game_rect.bottom = 0;
    m.view_game_rect.right = 0;

    return m;
}

/// 可点击区域(棒球) MG_BASEBALL_SET_CLICK_RECT
- (void)onGameMGCommonSetClickRect:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonSetClickRect *)model{
    self.gameClickRect = model;
}


- (void)onGameMGCommonHideGameScene:(nonnull id <ISudFSMStateHandle>)handle {
    DDLogDebug(@"mg：隐藏主界面");
//    [self hideGameView];
    [self.interactiveGameManager destoryGame];
}


- (void)onGameMGCommonShowGameScene:(nonnull id <ISudFSMStateHandle>)handle {
    DDLogDebug(@"mg：显示主界面");
}

- (void)onGameMGCommonPrepareFinish:(nonnull id <ISudFSMStateHandle>)handle {
    DDLogDebug(@"mg：前期准备完成");
    self.isGamePrepareOK = YES;
    [self closeLoadingView];
    if (self.isShowGame && self.showMainView) {
        [self.sudFSTAPPDecorator notifyAppCommonShowGameScene];
    }
    AppCommonGameCustomHelpInfo *model = AppCommonGameCustomHelpInfo.new;
    model.content = @[@"Odds for each car are calculated based on dynamic odds\nDynamic odds = total bets / bets on this car"];
    [self.sudFSTAPPDecorator notifyAppCommonCustomHelpInfo:model];
}

- (void)onGameMGCommonUsersInfo:(id<ISudFSMStateHandle>)handle model:(MgCommonUsersInfoModel *)model {
    
    DDLogDebug(@"mg:获取用户信息");
    [UserService.shared asyncCacheUserInfo:model.uids forceRefresh:NO finished:^{
        
        AppCommonUsersInfo *m = AppCommonUsersInfo.new;
        NSMutableArray *arr = NSMutableArray.new;
        for (NSString *uid in model.uids) {
            HSUserInfoModel *user = [UserService.shared getCacheUserInfo:uid.integerValue];
            AppCommonUsersInfoItem *item = AppCommonUsersInfoItem.new;
            item.uid = uid;
            item.name = user.nickname;
            item.avatar = user.avatar;
            [arr addObject:item];
        }
        m.infos = arr;
        [self.sudFSTAPPDecorator notifyAppCommonUsersInfo:m];
            
    }];

}

/// 创建订单 MG_COMMON_GAME_CREATE_ORDER
- (void)onGameMGCommonGameCreateOrder:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGameCreateOrderModel *)model {

    ReqAppOrderModel *reqModel = ReqAppOrderModel.new;
    reqModel.roomId = kAudioRoomService.currentRoomVC.roomID;
    reqModel.gameId = self.gameId;
    reqModel.value = model.value;
    reqModel.cmd = model.cmd;
    reqModel.fromUid = model.fromUid;
    reqModel.toUid = model.toUid;
    reqModel.payload = model.payload;
    
    [AudioRoomService reqAppOrder:reqModel finished:^(BaseRespModel * _Nonnull respModel) {
        DDLogDebug(@"reqAppOrder success");
        AppCommonGameCreateOrderResult *m = AppCommonGameCreateOrderResult.new;
        m.result = 1;
        [self.sudFSTAPPDecorator notifyAppCommonGameCreateOrderResult:m];
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"reqAppOrder fail:%@", error.debugDescription);
        AppCommonGameCreateOrderResult *m = AppCommonGameCreateOrderResult.new;
        m.result = 0;
        [self.sudFSTAPPDecorator notifyAppCommonGameCreateOrderResult:m];
    }];
}

/// 游戏通知app获取积分 MG_COMMON_GAME_SCORE
- (void)onGameMGCommonGameGetScore:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameGetScoreModel *)model {
    DDLogDebug(@"onGameMGCommonGameScore");
    [UserService.shared reqUserCoinDetail:^(int64_t i) {
        DDLogError(@"onGameMGCommonGameScore notify game score:%@", @(i));
        AppCommonGameScore *m = AppCommonGameScore.new;
        m.score = i;
        [self.sudFSTAPPDecorator notifyAppCommonGameScore:m];
    }                                fail:^(NSString *str) {
        DDLogError(@"onGameMGCommonGameScore req user coin err:%@", str);
    }];
}

@end
