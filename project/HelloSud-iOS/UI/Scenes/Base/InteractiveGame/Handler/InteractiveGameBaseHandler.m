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

/// 获取游戏View信息  【需要实现】
- (void)onGetGameViewInfo:(nonnull id <ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    CGFloat scale = [[UIScreen mainScreen] nativeScale];
    GameViewInfoModel *m = [[GameViewInfoModel alloc] init];
    m.view_size.width = kScreenWidth * scale;
    m.view_size.height = kScreenHeight * scale;
    m.view_game_rect.top = (kStatusBarHeight + 120) * scale;
    m.view_game_rect.left = 0;
    m.view_game_rect.bottom = (kAppSafeBottom + 150) * scale;
    m.view_game_rect.right = 0;

    m.ret_code = 0;
    m.ret_msg = @"success";
    [handle success:m.mj_JSONString];
}

/// 短期令牌code过期  【需要实现】
- (void)onExpireCode:(nonnull id <ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    // 请求业务服务器刷新令牌 Code更新
    [GameService.shared reqGameLoginWithAppId:nil success:^(RespGameInfoModel *gameInfo) {
        // 调用游戏接口更新令牌
        [self.sudFSTAPPDecorator updateCode:gameInfo.code];
        // 回调成功结果
        [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
    }                                    fail:^(NSError *error) {
        [ToastUtil show:error.debugDescription];
        // 回调失败结果
        [handle failure:[self.sudFSMMGDecorator handleMGFailure]];
    }];
}
@end
