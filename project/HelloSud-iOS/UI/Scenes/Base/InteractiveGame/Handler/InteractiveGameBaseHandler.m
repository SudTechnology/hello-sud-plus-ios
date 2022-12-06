//
// Created by kaniel on 2022/12/5.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "InteractiveGameBaseHandler.h"
#import "RocketLoadingView.h"

@interface InteractiveGameBaseHandler()

@property(nonatomic, strong) RocketLoadingView *rocketLoadingView;
@end

@implementation InteractiveGameBaseHandler

- (void)showLoadingView:(UIView *)gameView {
    [gameView.superview insertSubview:self.rocketLoadingView aboveSubview:gameView];
    [self.rocketLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.rocketLoadingView show];
}

- (void)closeLoadingView {
    if (_rocketLoadingView) {
        [_rocketLoadingView close];
        [_rocketLoadingView removeFromSuperview];
        _rocketLoadingView = nil;
    }
}

- (RocketLoadingView *)rocketLoadingView {
    if (!_rocketLoadingView) {
        _rocketLoadingView = RocketLoadingView.new;
    }
    return _rocketLoadingView;
}

#pragma mark =======SudFSMMGListener=======


/// 获取游戏Config  【需要实现】
- (void)onGetGameCfg:(nonnull id <ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    GameCfgModel *m = [GameCfgModel defaultCfgModel];
    m.ui.lobby_players.hide = true;
    m.ui.nft_avatar.hide = NO;
    m.ui.game_opening.hide = NO;
    m.ui.game_mvp.hide = NO;
    [handle success:[m mj_JSONString]];
}

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
    [GameService.shared reqGameLoginWithSuccess:^(RespGameInfoModel *_Nonnull gameInfo) {
        // 调用游戏接口更新令牌
        [self.sudFSTAPPDecorator updateCode:gameInfo.code];
        // 回调成功结果
        [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
    }                                      fail:^(NSError *error) {
        [ToastUtil show:error.debugDescription];
        // 回调失败结果
        [handle failure:[self.sudFSMMGDecorator handleMGFailure]];
    }];
}
@end