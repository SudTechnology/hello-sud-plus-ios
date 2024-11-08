//
// Created by kaniel on 2022/6/1.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GuessRoomViewController.h"
#import "GuessMineView.h"
#import "SwitchAutoGuessPopView.h"
#import "GuessSelectPopView.h"
#import "GuessResultPopView.h"
#import "GuessRoomSceneGameEventHandler.h"

@interface GuessRoomViewController ()
/// 猜我赢挂件视图
@property(nonatomic, strong) GuessMineView *guessMineView;
/// 导航自动竞猜导航视图
@property(nonatomic, strong) BaseView *autoGuessNavView;
@property(nonatomic, strong) UIImageView *autoNavImageView;
@property(nonatomic, strong) MarqueeLabel *autoTitleLabel;
/// 围观者导航视图
@property(nonatomic, strong) BaseView *normalGuessNavView;
@property(nonatomic, strong) MarqueeLabel *normalGuessNavLabel;
@property(nonatomic, strong) UIImageView *fingerImageView;
/// 开启了自动竞猜
@property(nonatomic, assign) BOOL openAutoBet;
/// 是否是下一轮
@property(nonatomic, assign) BOOL isNextRound;
@property(nonatomic, assign) NSInteger betCoin;
@property(nonatomic, strong) RespGuessPlayerListModel *playerListModel;
@end

@implementation GuessRoomViewController {

}

- (Class)serviceClass {
    return GuessRoomService.class;
}


- (void)dtAddViews {
    [super dtAddViews];
    [self.sceneView addSubview:self.guessMineView];
    [self.naviView addSubview:self.autoGuessNavView];
    [self.naviView addSubview:self.normalGuessNavView];

    [self.autoGuessNavView addSubview:self.autoNavImageView];
    [self.autoGuessNavView addSubview:self.autoTitleLabel];

    [self.normalGuessNavView addSubview:self.normalGuessNavLabel];
    [self.naviView addSubview:self.fingerImageView];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.normalGuessNavLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.autoTitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

    [self.guessMineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-16));
        make.width.equalTo(@80);
        make.height.equalTo(@90);
        make.bottom.equalTo(self.robotView.mas_top).offset(-12);
    }];
    [self.autoGuessNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.naviView.roomModeView);
        make.height.equalTo(@20);
        make.width.equalTo(@0);
        make.trailing.equalTo(self.naviView.roomModeView.mas_leading).offset(-10);
        make.leading.greaterThanOrEqualTo(self.naviView.roomInfoView.mas_trailing).offset(10);
    }];
    [self.autoNavImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-1);
        make.width.height.equalTo(@18);
        make.centerY.equalTo(self.autoGuessNavView);
    }];
    [self.autoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@7);
        make.trailing.equalTo(self.autoNavImageView.mas_leading);
        make.width.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.autoGuessNavView);
    }];
    [self.normalGuessNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.naviView.roomModeView);
        make.height.equalTo(@20);
        make.trailing.equalTo(self.naviView.roomModeView.mas_leading).offset(-10);
        make.leading.greaterThanOrEqualTo(self.naviView.roomInfoView.mas_trailing).offset(10);
    }];
    [self.normalGuessNavLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@8);
        make.trailing.equalTo(@-8);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(self.normalGuessNavView);
    }];
    [self.fingerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (LanguageUtil.isLanguageRTL) {
            make.trailing.equalTo(self.normalGuessNavView.mas_leading);
        } else {
            make.leading.equalTo(self.normalGuessNavView.mas_trailing);
        }
        make.top.equalTo(self.normalGuessNavView.mas_bottom);
        make.width.equalTo(@31);
        make.height.equalTo(@26);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.autoTitleLabel.text = NSString.dt_room_guess_auto_guess;
    self.normalGuessNavLabel.text = NSString.dt_room_guess_win_lose;
    [self reqData];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    [self.guessMineView updateBetCoin:self.betCoin];
    [self showFingerAnimate];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapShowOpenAutoGuess:)];
    [self.guessMineView addGestureRecognizer:tap];

    UITapGestureRecognizer *tapAuto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAuto:)];
    [self.autoGuessNavView addGestureRecognizer:tapAuto];

    UITapGestureRecognizer *tapNormal = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapNormal:)];
    [self.normalGuessNavView addGestureRecognizer:tapNormal];

}

- (void)reqData {
    WeakSelf
    NSArray *playerUserIdList = @[AppService.shared.loginUserID ? AppService.shared.loginUserID : @""];
    NSString *roomId = kGuessService.currentRoomVC.roomID;
    [GuessRoomService reqGuessPlayerList:playerUserIdList roomId:roomId finished:^(RespGuessPlayerListModel *model) {
        weakSelf.betCoin = model.betCoin;
        [weakSelf dtUpdateUI];
    }];
}

- (void)showFingerAnimate {

    [self.fingerImageView.layer removeAllAnimations];
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.duration = 1.6;
    group.repeatCount = CGFLOAT_MAX;
    group.removedOnCompletion = YES;
    group.fillMode = kCAFillModeRemoved;

    CABasicAnimation *moveDown = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
    // 设置运动形式
    [moveDown setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    // 设置开始位置
    moveDown.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    moveDown.toValue = [NSValue valueWithCGPoint:CGPointMake(-10, -10)];
    moveDown.removedOnCompletion = NO;
    moveDown.duration = 0.8;
    moveDown.repeatCount = 1;
    moveDown.fillMode = kCAFillModeForwards;

    CABasicAnimation *moveUp = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
    // 设置运动形式
    [moveUp setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    moveUp.fromValue = [NSValue valueWithCGPoint:CGPointMake(-10, -10)];;
    moveUp.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    moveUp.duration = 0.8;
    moveUp.beginTime = 0.8;
    moveUp.repeatCount = 1;
    moveUp.removedOnCompletion = NO;
    moveUp.fillMode = kCAFillModeForwards;

    group.animations = @[moveDown, moveUp];
    [self.fingerImageView.layer addAnimation:group forKey:@"moveAnimate"];
}

/// 游戏玩家加入游戏状态变化
- (void)playerIsInGameStateChanged:(NSString *)userId {
    if (![AppService.shared.loginUserID isEqualToString:userId]) {
        return;
    }

    BOOL isInGame = self.gameEventHandler.sudFSMMGDecorator.isInGame;
    if (!isInGame) {
        // 当前用户没有加入游戏
        [self showNaviAutoStateView:NO];
        self.guessMineView.hidden = YES;
        self.normalGuessNavView.hidden = NO;
        self.fingerImageView.hidden = NO;
        return;
    }
    // 当前用户加入了游戏

    // 如果未开启自动竞猜，展示挂件
    if (!self.openAutoBet) {
        self.guessMineView.hidden = NO;
    } else {
        [self showNaviAutoStateView:YES];
    }
    self.normalGuessNavView.hidden = YES;
    self.fingerImageView.hidden = YES;
}

/// 我的猜输赢挂件响应
- (void)onTapShowOpenAutoGuess:(id)tap {

    if (self.gameEventHandler.sudFSMMGDecorator.gameStateType == GameStateTypePlaying) {
        [ToastUtil show:NSString.dt_room_guess_gameing_not_open];
        return;
    }
    WeakSelf
    SwitchAutoGuessPopView *v = [[SwitchAutoGuessPopView alloc] init];
    v.betCoin = self.betCoin;
    [v dtUpdateUI];
    v.onCloseBlock = ^{
        [DTSheetView close];
    };
    v.onOpenBlock = ^{
        // 开启的时候自动扣费
        [GuessRoomService reqBet:2 coin:self.betCoin userList:@[AppService.shared.loginUserID] finished:^{
            [DTSheetView close];
            DDLogDebug(@"onTapShowOpenAutoGuess 开启自动扣费：投注成功");
            weakSelf.openAutoBet = YES;
            [weakSelf showNaviAutoStateView:YES];
            // 自己押注消息
            AudioUserModel *userModel = AudioUserModel.new;
            userModel.userID = AppService.shared.login.loginUserInfo.userID;
            userModel.name = AppService.shared.login.loginUserInfo.name;
            userModel.icon = AppService.shared.login.loginUserInfo.icon;
            userModel.sex = AppService.shared.login.loginUserInfo.sex;
            [kGuessService sendBetNotifyMsg:weakSelf.roomID betUsers:@[userModel]];
        }                failure:^(NSError *error) {
            [ToastUtil show:error.dt_errMsg];
        }];
    };
    [DTSheetView show:v onCloseCallback:^{

    }];
}

/// 自动竞猜状态开关响应
- (void)onTapAuto:(id)tap {

    if (self.gameEventHandler.sudFSMMGDecorator.gameStateType == GameStateTypePlaying) {
        [ToastUtil show:NSString.dt_room_guess_gaming_not_close];
        return;
    }
    WeakSelf
    [DTAlertView showTextAlert:NSString.dt_room_guess_close_auto sureText:NSString.dt_common_close cancelText:NSString.dt_common_back onSureCallback:^{
        weakSelf.openAutoBet = NO;
        [weakSelf showNaviAutoStateView:NO];
    }          onCloseCallback:^{
        [DTAlertView close];
    }];

}

/// 普通用户猜输赢开关响应
- (void)onTapNormal:(id)tap {
    GuessSelectPopView *v = [[GuessSelectPopView alloc] init];
    v.mj_h = kScreenHeight * 0.77;
    [DTSheetView show:v onCloseCallback:^{

    }];
}

/// 展示自动竞猜状态视图
/// @param show  show
- (void)showNaviAutoStateView:(BOOL)show {
    if (show) {
        self.autoGuessNavView.hidden = NO;
        self.guessMineView.hidden = YES;
        [self.autoGuessNavView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.naviView.roomModeView);
            make.height.equalTo(@20);
            make.width.greaterThanOrEqualTo(@0);
            make.trailing.equalTo(self.naviView.roomModeView.mas_leading).offset(-10);
            make.leading.greaterThanOrEqualTo(self.naviView.roomInfoView.mas_trailing).offset(10);
        }];
    } else {
        self.autoGuessNavView.hidden = YES;
        self.guessMineView.hidden = NO;
        [self.autoGuessNavView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.naviView.roomModeView);
            make.height.equalTo(@20);
            make.width.greaterThanOrEqualTo(@0);
            make.trailing.equalTo(self.naviView.roomModeView.mas_leading).offset(-10);
            make.leading.greaterThanOrEqualTo(self.naviView.roomInfoView.mas_trailing).offset(10);
        }];
    }
    [self.naviView layoutIfNeeded];
}

/// 展示结果弹窗
- (void)showResultAlertView:(NSArray<GuessPlayerModel *> *)playerList winCoin:(NSInteger)winCoin {
    WeakSelf
    GuessResultPopView *v = [[GuessResultPopView alloc] init];
    v.againBlock = ^{
        // 下一轮游戏准备
        [weakSelf.gameEventHandler.sudFSTAPPDecorator notifyAppCommonSelfReady:YES];
    };
    v.dataList = playerList;
    v.winCoin = winCoin;
    BOOL isSupport = NO;
    BOOL isWin = NO;
    for (int i = 0; i < playerList.count; ++i) {
        if (playerList[i].support) {
            isSupport = YES;
            if (playerList[i].rank == 1) {
                isWin = YES;
            }
        }
    }
    if (isWin) {
        v.resultStateType = GuessResultPopViewTypeWin;
    } else if (isSupport) {
        v.resultStateType = GuessResultPopViewTypeLose;
    } else {
        v.resultStateType = GuessResultPopViewTypeNotBet;
    }
    [v dtUpdateUI];
    v.backgroundColor = UIColor.clearColor;
    [DTAlertView show:v rootView:nil clickToClose:YES showDefaultBackground:NO onCloseCallback:^{

    }];
}

/// 处理游戏结果
/// @param results results
- (void)handlePlayerGameResult:(NSArray<MGCommonGameSettleResults *> *)results {
    WeakSelf

    NSMutableArray *playerUserIdList = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < results.count; ++i) {
        MGCommonGameSettleResults *m = results[i];
        if (m.uid) {
            [playerUserIdList addObject:m.uid];
            dic[m.uid] = m;
        }
    }
    NSArray *arr = self.playerListModel.playerList;
    for (int i = 0; i < arr.count; ++i) {
        GuessPlayerModel *m = arr[i];
        MGCommonGameSettleResults *resultModel = dic[[NSString stringWithFormat:@"%@", @(m.userId)]];
        if (resultModel) {
            m.rank = resultModel.rank;
            m.award = resultModel.award;
            m.score = resultModel.score;
        }
    }
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(GuessPlayerModel *_Nonnull obj1, GuessPlayerModel *_Nonnull obj2) {
        return obj1.rank > obj2.rank;
    }];
    [weakSelf showResultAlertView:arr winCoin:self.playerListModel.winCoin];
}

/// 处理业务指令
- (void)handleBusyCommand:(NSInteger)cmd command:(NSString *)command {
    WeakSelf
    switch (cmd) {
        case CMD_ROOM_QUIZ_BET: {
            // 押注公屏
            RoomCmdGuessBetNotifyModel *model = [RoomCmdGuessBetNotifyModel fromJSON:command];
            [weakSelf showBetScreenMsg:model];
        }
            break;
        default:
            break;
    }
}

- (void)showBetScreenMsg:(RoomCmdGuessBetNotifyModel *)model {

    NSArray <AudioUserModel *> *arrUsers = model.recUser;
    for (int i = 0; i < arrUsers.count; ++i) {
        AudioUserModel *user = arrUsers[i];
        NSString *content = @"";
        if ([user.userID isEqualToString:model.sendUser.userID]) {
            content = [NSString stringWithFormat:NSString.dt_room_guess_win_msg_fmt, model.sendUser.name];
        } else {
            content = [NSString stringWithFormat:NSString.dt_room_guess_diff_user_win_msg_fmt, model.sendUser.name, user.name];
        }
        [self addBetPublicMsgContent:content];
    }
}

- (void)addBetPublicMsgContent:(NSString *)content {
    if (content.length == 0) {
        return;
    }
    NSMutableAttributedString *attrMsg = [[NSMutableAttributedString alloc] initWithString:content];
    if (attrMsg.length > 0) {
        attrMsg.yy_lineSpacing = 6;
        attrMsg.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        attrMsg.yy_color = [UIColor dt_colorWithHexString:@"#ffffff" alpha:1];
        AudioMsgSystemModel *msgModel = [AudioMsgSystemModel makeMsgWithAttr:attrMsg];
        /// 公屏添加消息
        [self addMsg:msgModel isShowOnScreen:YES];
    }
}

/// 获取下注列表
- (void)reqBetList {
    WeakSelf
    NSString *roomId = kGuessService.currentRoomVC.roomID;
    [GuessRoomService reqGuessPlayerList:self.gameEventHandler.sudFSMMGDecorator.getJoinedGamePlayerIdList roomId:roomId finished:^(RespGuessPlayerListModel *model) {
        weakSelf.betCoin = model.betCoin;
        weakSelf.playerListModel = model;
    }];
}

/// 请求自动下注
/// @param finished finished
- (void)reqAutoBet:(void (^)(BOOL success))finished {
    WeakSelf
    [GuessRoomService reqBet:2 coin:weakSelf.betCoin userList:@[AppService.shared.loginUserID] finished:^{
        DDLogDebug(@"自动下注：投注成功");
        if (finished) finished(YES);

    }                failure:^(NSError *error) {
        if (error.code == 3005) {
            [ToastUtil show:NSString.dt_room_guess_no_more_money];
            weakSelf.openAutoBet = NO;
            [weakSelf showNaviAutoStateView:NO];
        } else {
            [ToastUtil show:error.dt_errMsg];
        }
        DDLogError(@"开启自动扣费：失败：%@", error.dt_errMsg);
        if (finished) finished(NO);
    }];

}

#pragma mark game events

/// 获取游戏Config  【需要实现】
- (GameCfgModel *)onGetGameCfg {
    GameCfgModel *m = [GameCfgModel defaultCfgModel];
    m.ui.nft_avatar.hide = NO;
    m.ui.game_opening.hide = NO;
    m.ui.game_mvp.hide = NO;
    m.ui.gameSettle.hide = YES;
    m.ui.lobby_players.hide = YES;
    m.ui.start_btn.custom = YES;
    m.ui.join_btn.custom = YES;
    return m;
}

/// 接管加入游戏
- (void)onGameMGCommonSelfClickJoinBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickJoinBtn *)model {
    [self.gameEventHandler.sudFSTAPPDecorator notifyAppComonSelfIn:YES seatIndex:-1 isSeatRandom:true teamId:1];
    if (self.openAutoBet) {
        [self showNaviAutoStateView:YES];
    } else {
        [self onTapShowOpenAutoGuess:nil];
    }
}

/// 游戏: 开始游戏按钮点击状态   MG_COMMON_SELF_CLICK_START_BTN
- (void)onGameMGCommonSelfClickStartBtn {
    // 通过游戏透传业务竞猜场景ID到业务服务端
    NSDictionary *dic = @{@"sceneId": @(self.configModel.enterRoomModel.sceneType)};
    [self.gameEventHandler.sudFSTAPPDecorator notifyAppComonSelfPlaying:true reportGameInfoExtras:dic.mj_JSONString];
    DDLogDebug(@"onGameMGCommonSelfClickStartBtn");

}

/// 游戏: 游戏状态   MG_COMMON_GAME_STATE
- (void)onGameMGCommonGameState:(id <ISudFSMStateHandle>)handle model:(MGCommonGameState *)model {
    [super onGameMGCommonGameState:handle model:model];
    DDLogDebug(@"onGameMGCommonGameState：%@", @(model.gameState));
    // 游戏进行开始时，扣费
    if (model.gameState == MGCommonGameStateTypeLoading) {
        WeakSelf
        if (!(self.openAutoBet && self.isNextRound)) {
            [self reqBetList];
            return;
        }
        /// 开启了自动扣费
        DDLogDebug(@"开启了自动扣费");
        [self reqAutoBet:^(BOOL success) {
            [self reqBetList];
        }];
    } else if (model.gameState == MGCommonGameStateTypePlaying) {
        [self reqBetList];
    }
}

/// 游戏: 游戏结算状态     MG_COMMON_GAME_SETTLE
- (void)onGameMGCommonGameSettle:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSettleModel *)model {

    self.isNextRound = YES;
    // 展示游戏结果
    [self handlePlayerGameResult:model.results];
    [handle success:[self.gameEventHandler.sudFSMMGDecorator handleMGSuccess]];
}

#pragma mark lazy

- (GuessMineView *)guessMineView {
    if (!_guessMineView) {
        _guessMineView = [[GuessMineView alloc] init];
        _guessMineView.hidden = YES;
    }
    return _guessMineView;
}

- (BaseView *)autoGuessNavView {
    if (!_autoGuessNavView) {
        _autoGuessNavView = [[BaseView alloc] init];
        _autoGuessNavView.backgroundColor = HEX_COLOR(@"#35C543");
        _autoGuessNavView.hidden = YES;
        [_autoGuessNavView dt_cornerRadius:10];
    }
    return _autoGuessNavView;
}

- (UIImageView *)autoNavImageView {
    if (!_autoNavImageView) {
        _autoNavImageView = [[UIImageView alloc] init];
        _autoNavImageView.contentMode = UIViewContentModeScaleAspectFill;
        _autoNavImageView.clipsToBounds = YES;
        _autoNavImageView.image = [UIImage imageNamed:@"guess_auto_state"];
    }
    return _autoNavImageView;
}

- (MarqueeLabel *)autoTitleLabel {
    if (!_autoTitleLabel) {
        _autoTitleLabel = [[MarqueeLabel alloc] init];
        _autoTitleLabel.font = UIFONT_BOLD(12);
        _autoTitleLabel.textColor = HEX_COLOR(@"#FFFFFF");
        _autoTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _autoTitleLabel;
}

- (BaseView *)normalGuessNavView {
    if (!_normalGuessNavView) {
        _normalGuessNavView = [[BaseView alloc] init];
        [_normalGuessNavView dtAddGradientLayer:@[@0, @1] colors:@[(id) HEX_COLOR(@"#FCE58B").CGColor, (id) HEX_COLOR(@"#FFA81C").CGColor] startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) cornerRadius:0];
    }
    return _normalGuessNavView;
}

- (MarqueeLabel *)normalGuessNavLabel {
    if (!_normalGuessNavLabel) {
        _normalGuessNavLabel = [[MarqueeLabel alloc] init];
        _normalGuessNavLabel.text = NSString.dt_room_start_pk;
        _normalGuessNavLabel.textColor = HEX_COLOR(@"#482500");
        _normalGuessNavLabel.font = UIFONT_MEDIUM(12);
        _normalGuessNavLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _normalGuessNavLabel;
}

- (UIImageView *)fingerImageView {
    if (!_fingerImageView) {
        _fingerImageView = [[UIImageView alloc] init];
        _fingerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _fingerImageView.clipsToBounds = YES;
        _fingerImageView.image = [UIImage imageNamed:@"guess_finger_guide"];
    }
    return _fingerImageView;
}

- (BaseSceneGameEventHandler *)createGameEventHandler {
    return GuessRoomSceneGameEventHandler.new;
}
@end
