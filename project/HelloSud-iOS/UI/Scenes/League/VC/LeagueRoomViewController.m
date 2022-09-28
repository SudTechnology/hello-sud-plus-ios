//
// Created by kaniel on 2022/6/1.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "LeagueRoomViewController.h"
#import "GuessMineView.h"
#import "LeagueResultPopView.h"
#import "LeagueModel.h"

@interface LeagueRoomViewController ()

/// 开启了自动竞猜
@property(nonatomic, assign) BOOL openAutoBet;
/// 是否是下一轮
@property(nonatomic, assign) BOOL isNextRound;
@property(nonatomic, assign) NSInteger betCoin;
@property(nonatomic, strong) RespGuessPlayerListModel *playerListModel;
/// 局索引
@property(nonatomic, assign) NSInteger roundIndex;
@property(nonatomic, strong) NSArray <LeaguePlayerModel *> *nextRoundPlayerList;
@end

@implementation LeagueRoomViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
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

}

/// 展示自动竞猜状态视图
/// @param show  show
- (void)showNaviAutoStateView:(BOOL)show {

}

/// 展示结果弹窗
- (void)showResultAlertView:(NSArray<LeaguePlayerModel *> *)playerList winCoin:(NSInteger)winCoin {
    WeakSelf
    LeagueResultPopView *v = [[LeagueResultPopView alloc] init];
    v.resultStateType = LeagueResultTypeNotJoinFirstResult;
    v.continueBlock = ^{
        // 下一轮游戏准备
        [weakSelf.sudFSTAPPDecorator notifyAppCommonSelfReady:YES];
        [weakSelf addNextRoundRobot];
    };
    v.dataList = playerList;
    BOOL isPlayer = false;
    NSMutableArray *nextRoundPlayerList = NSMutableArray.new;
    for (int i = 0; i < playerList.count; ++i) {
        LeaguePlayerModel *m = playerList[i];
        if (self.roundIndex == 1 && m.rank < 3 && nextRoundPlayerList.count < 3) {
            [nextRoundPlayerList addObject:m];
        }
        self.nextRoundPlayerList = nextRoundPlayerList;
        if (m.userId == AppService.shared.loginUserID.longLongValue) {
            isPlayer = true;
            // me
            if (self.roundIndex == 1) {
                if (m.rank <= 3) {
                    v.resultStateType = LeagueResultTypeJoinFirstBeforeThree;
                } else {
                    v.resultStateType = LeagueResultTypeJoinFirstAfterThree;
                }
            } else if (self.roundIndex == 2) {
                // 第二轮
                if (m.rank == 1) {
                    v.resultStateType = LeagueResultTypeJoinEndFirst;
                } else {
                    v.resultStateType = LeagueResultTypeJoinEndLose;
                }
            }
        }
        if (self.roundIndex == 1 && m.rank <= 3) {
            m.isWin = true;
        } else if (self.roundIndex == 2 && m.rank == 1) {
            m.isWin = true;
        } else {
            m.isWin = false;
        }
    }
    if (!isPlayer) {
        // 非玩家
        if (self.roundIndex == 1) {
            v.resultStateType = LeagueResultTypeNotJoinFirstResult;
        } else if (self.roundIndex == 2) {
            // 第二轮
            v.resultStateType = LeagueResultTypeNotJoinEndResult;
        }
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
    NSMutableArray *playerResultList = NSMutableArray.new;
    for (int i = 0; i < results.count; ++i) {
        MGCommonGameSettleResults *m = results[i];
        if (!m.uid) {
            DDLogError(@"result uid is empty");
            continue;
        }
        [playerUserIdList addObject:m.uid];
        dic[m.uid] = m;
        HSUserInfoModel *infoModel = [UserService.shared getCacheUserInfo:m.uid.longLongValue];
        LeaguePlayerModel *playerModel = LeaguePlayerModel.new;
        playerModel.header = infoModel.headImage;
        playerModel.nickname = infoModel.nickname;
        playerModel.userId = m.uid.longLongValue;
        playerModel.award = m.award;
        playerModel.rank = m.rank;
        playerModel.score = m.score;
        playerModel.gender = infoModel.gender;
        playerModel.isRobot = infoModel.ai;
        [playerResultList addObject:playerModel];

    }
    [weakSelf showResultAlertView:playerResultList winCoin:self.playerListModel.winCoin];
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

- (void)checkAddOtherRobot:(void (^)(void))completed {
    switch (self.roundIndex) {
        case 1: {

            // 第一轮
            NSInteger playerCount = self.sudFSMMGDecorator.onlineUserIdList.count;
            NSInteger totalCount = self.totalGameUserCount;
            if (totalCount > playerCount) {
                // 补全剩余麦位
                NSInteger count = totalCount - playerCount;
                NSMutableArray *waitForAddToGameList = NSMutableArray.new;
                BOOL noAvailableRobot = false;
                for (int i = 0; i < count; ++i) {
                    if (noAvailableRobot) {
                        break;
                    }
                    BOOL addRobot = false;
                    for (RobotInfoModel *m in self.cacheRobotList) {
                        if (![self.sudFSMMGDecorator isPlayerInGame:[NSString stringWithFormat:@"%@", @(m.userId)]]) {
                            [waitForAddToGameList addObject:m];
                            addRobot = YES;
                            continue;
                        }

                    }
                    if (!addRobot) {
                        // 标记没有可用机器人了
                        noAvailableRobot = YES;
                    }
                }
                [self addRobotToGame:waitForAddToGameList];
            }
        }
            break;
        case 2: {

            // 第二轮
        }
            break;
        default:
            break;
    }
    if (completed) {
        completed();
    }
}

/// 添加下一轮游戏机器人
- (void)addNextRoundRobot {

    NSMutableArray *robotList = NSMutableArray.new;
    for (LeaguePlayerModel *m in self.nextRoundPlayerList) {
        if (m.isRobot) {
            RobotInfoModel *robotInfoModel = RobotInfoModel.new;
            robotInfoModel.avatar = m.header;
            robotInfoModel.gender = m.gender;
            robotInfoModel.name = m.nickname;
            robotInfoModel.userId = m.userId;
            [robotList addObject:robotInfoModel];
        }
    }
    [self addRobotToGame:robotList];
}

#pragma mark game events

/// 获取游戏Config  【需要实现】
- (NSString *)onGetGameCfg {
    GameCfgModel *m = [GameCfgModel defaultCfgModel];
    m.ui.lobby_game_setting.hide = YES;
    m.ui.gameSettle.hide = YES;
    m.ui.lobby_players.hide = NO;
    m.ui.start_btn.custom = YES;
    m.ui.join_btn.custom = YES;
    NSString *jsonStr = [m toJSON];
    return jsonStr;
}

/// 接管加入游戏
- (void)onGameMGCommonSelfClickJoinBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickCancelJoinBtn *)model {
    [self.sudFSTAPPDecorator notifyAppComonSelfIn:YES seatIndex:-1 isSeatRandom:true teamId:1];
}

/// 游戏: 开始游戏按钮点击状态   MG_COMMON_SELF_CLICK_START_BTN
- (void)onGameMGCommonSelfClickStartBtn {
    DDLogDebug(@"onGameMGCommonSelfClickStartBtn");
    WeakSelf
    weakSelf.roundIndex++;
    [self checkAddOtherRobot:^{
        NSDictionary *dic = @{};
        [weakSelf.sudFSTAPPDecorator notifyAppComonSelfPlaying:true reportGameInfoExtras:dic.mj_JSONString];
    }];
}

/// 游戏: 游戏状态   MG_COMMON_GAME_STATE
- (void)onGameMGCommonGameState:(id <ISudFSMStateHandle>)handle model:(MGCommonGameState *)model {
    [super onGameMGCommonGameState:handle model:model];
    DDLogDebug(@"onGameMGCommonGameState：%@", @(model.gameState));
}

/// 游戏: 游戏结算状态     MG_COMMON_GAME_SETTLE
- (void)onGameMGCommonGameSettle:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSettleModel *)model {

    self.isNextRound = YES;
    // 展示游戏结果
    NSMutableArray *playerUserIdList = [[NSMutableArray alloc] init];
    for (MGCommonGameSettleResults *m in model.results) {
        if (m.uid) {
            [playerUserIdList addObject:m.uid];
        }
    }
    WeakSelf
    [UserService.shared asyncCacheUserInfo:playerUserIdList forceRefresh:NO finished:^{
        [weakSelf handlePlayerGameResult:model.results];
    }];

    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

#pragma mark lazy

@end