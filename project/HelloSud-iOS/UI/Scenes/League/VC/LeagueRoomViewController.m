//
// Created by kaniel on 2022/6/1.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "LeagueRoomViewController.h"
#import "GuessMineView.h"
#import "SwitchAutoGuessPopView.h"
#import "GuessSelectPopView.h"
#import "GuessResultPopView.h"

@interface LeagueRoomViewController ()

/// 开启了自动竞猜
@property(nonatomic, assign) BOOL openAutoBet;
/// 是否是下一轮
@property(nonatomic, assign) BOOL isNextRound;
@property(nonatomic, assign) NSInteger betCoin;
@property(nonatomic, strong) RespGuessPlayerListModel *playerListModel;
@end

@implementation LeagueRoomViewController {

}

- (Class)serviceClass {
    return GuessRoomService.class;
}


- (void)dtAddViews {
    [super dtAddViews];


}

- (void)dtLayoutViews {
    [super dtLayoutViews];

}

- (void)dtConfigUI {
    [super dtConfigUI];

    [self reqData];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    [self showFingerAnimate];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];


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

}

/// 游戏玩家加入游戏状态变化
- (void)playerIsInGameStateChanged:(NSString *)userId {

}

/// 我的猜输赢挂件响应
- (void)onTapShowOpenAutoGuess:(id)tap {

    if (self.sudFSMMGDecorator.gameStateType == GameStateTypePlaying) {
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

    if (self.sudFSMMGDecorator.gameStateType == GameStateTypePlaying) {
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

}

/// 展示结果弹窗
- (void)showResultAlertView:(NSArray<GuessPlayerModel *> *)playerList winCoin:(NSInteger)winCoin {
    WeakSelf
    GuessResultPopView *v = [[GuessResultPopView alloc] init];
    v.againBlock = ^{
        // 下一轮游戏准备
        [weakSelf.sudFSTAPPDecorator notifyAppCommonSelfReady:YES];
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
    [GuessRoomService reqGuessPlayerList:self.sudFSMMGDecorator.onlineUserIdList roomId:roomId finished:^(RespGuessPlayerListModel *model) {
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
- (NSString *)onGetGameCfg {
    GameCfgModel *m = [GameCfgModel defaultCfgModel];
    m.ui.gameSettle.hide = YES;
    m.ui.lobby_players.hide = YES;
    m.ui.start_btn.custom = YES;
    m.ui.join_btn.custom = YES;
    NSString *jsonStr = [m toJSON];
    return jsonStr;
}

/// 接管加入游戏
- (void)onGameMGCommonSelfClickJoinBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickCancelJoinBtn *)model {
    [self.sudFSTAPPDecorator notifyAppComonSelfIn:YES seatIndex:-1 isSeatRandom:true teamId:1];
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
    [self.sudFSTAPPDecorator notifyAppComonSelfPlaying:true reportGameInfoExtras:dic.mj_JSONString];
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
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

#pragma mark lazy

@end
