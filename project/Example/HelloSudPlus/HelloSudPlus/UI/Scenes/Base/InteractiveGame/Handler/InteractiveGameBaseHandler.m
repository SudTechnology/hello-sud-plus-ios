//
// Created by kaniel on 2022/12/5.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "InteractiveGameBaseHandler.h"
#import "InteractiveGameLoadingView.h"
#import "InteractiveGameManager.h"

@interface InteractiveGameBaseHandler ()

@property(nonatomic, strong) InteractiveGameLoadingView *rocketLoadingView;

@end

@implementation InteractiveGameBaseHandler

/// 展示游戏视图
- (void)showGameView:(BOOL)showMainView {
    self.isShowGame = YES;
    self.showMainView = showMainView;
}

/// 隐藏游戏视图
- (void)hideGameView:(BOOL)notifyGame {
    self.isShowGame = NO;
    self.showMainView = NO;
}

- (void)showLoadingView:(UIView *)gameView {
    [gameView.superview insertSubview:self.rocketLoadingView aboveSubview:gameView];
    [self.rocketLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    NSString *title = @"正在前往火箭台...";
    switch (self.interactiveGameManager.gameId) {
        case INTERACTIVE_GAME_BASEBALL_ID:{
            title = @"正在前往棒球...";
        }
            break;
        case INTERACTIVE_GAME_CRAZY_CAR_ID:{
            title = @"正在前往赛车...";
        }
            break;
        case INTERACTIVE_GAME_BIG_EATER_ID:{
            title = @"正在前往大胃王...";
        }
            break;
        default:
            break;
    }

    [self.rocketLoadingView showWithTitle:title];
}

/// 检测点是否在游戏可点击区域，如果游戏没有指定，则默认游戏需要响应该点，返回YES;否则按照游戏指定区域判断是否在区域内，在则返回YES,不在则返回NO
/// @param clickPoint 点击事件点
/// @return
- (BOOL)checkIfPointInGameClickRect:(CGPoint)clickPoint {
    if (!self.gameClickRect || self.gameClickRect.list.count == 0) {
        return YES;
    }
    CGFloat scale = 1;
    if (UIScreen.mainScreen.nativeScale > 0) {
        scale = UIScreen.mainScreen.nativeScale;
    }

    for (GameSetClickRectItem *item in self.gameClickRect.list) {
        CGRect rect = CGRectMake(item.x / scale, item.y / scale, item.width / scale, item.height / scale);
        if (CGRectContainsPoint(rect, clickPoint)) {
            return YES;
        }
    }
    return NO;
}

- (void)closeLoadingView {
    if (_rocketLoadingView) {
        [_rocketLoadingView close];
        [_rocketLoadingView removeFromSuperview];
        _rocketLoadingView = nil;
    }
}

- (InteractiveGameLoadingView *)rocketLoadingView {
    if (!_rocketLoadingView) {
        _rocketLoadingView = InteractiveGameLoadingView.new;
    }
    return _rocketLoadingView;
}

#pragma mark =======SudFSMMGListener=======

/// 游戏开始
- (void)onGameStarted {
    DDLogDebug(@"onGameStarted");
    [self closeLoadingView];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)onGameDestroyed {
    DDLogDebug(@"onGameDestroyed");
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (GameViewInfoModel *)onGetGameViewInfo {

    GameViewInfoModel *m = [super onGetGameViewInfo];
    m.view_game_rect.top = (kStatusBarHeight + 120) ;
    m.view_game_rect.left = 0;
    m.view_game_rect.bottom = (kAppSafeBottom + 150) ;
    m.view_game_rect.right = 0;
    return m;
}


- (void)onGetCode:(nonnull NSString *)userId success:(nonnull SudGmSuccessStringBlock)success fail:(nonnull SudGmFailedBlock)fail {
    NSString *appID = AppService.shared.configModel.sudCfg.appId;
    NSString *appKey = AppService.shared.configModel.sudCfg.appKey;
    if (appID.length == 0 || appKey.length == 0) {
        [ToastUtil show:@"Game appID or appKey is empty"];
        if (fail) {
            fail(-1, @"appID is empty");
        }
        return;
    }
    WeakSelf
    [GameService.shared reqGameLoginWithAppId:appID success:^(RespGameInfoModel *gameInfo) {
        if (success) {
            success(gameInfo.code);
        }
    }                                    fail:^(NSError *error) {
        [ToastUtil show:error.debugDescription];
        [weakSelf.interactiveGameManager clearLoadGameState];
        if (fail) {
            fail(error.code, error.debugDescription);
        }
    }];
}
@end
