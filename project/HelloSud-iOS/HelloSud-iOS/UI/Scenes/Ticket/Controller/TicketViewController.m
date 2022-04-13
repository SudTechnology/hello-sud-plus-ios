//
//  TicketViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/18.
//

#import "TicketViewController.h"
#import "TicketJoinPopView.h"

@interface TicketViewController ()

@end

@implementation TicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - SudFSMMGListener

/// 获取游戏Config  【需要实现】
- (NSString *)onGetGameCfg {
    LobbyPlayers *l = [[LobbyPlayers alloc] init];
    l.hide = true;
    GameCfgStartBtn *start_btn = [[GameCfgStartBtn alloc] init];
    start_btn.custom = true;
    GameCfgReadyBtn *ready_btn = [[GameCfgReadyBtn alloc] init];
    ready_btn.custom = true;
    GameSettleAgainBtn *game_settle_again_btn = [[GameSettleAgainBtn alloc] init];
    game_settle_again_btn.custom = true;
    GameUi *ui = [[GameUi alloc] init];
    ui.lobby_players = l;
    ui.ready_btn = ready_btn;
    ui.start_btn = start_btn;
    ui.game_settle_again_btn = game_settle_again_btn;
    GameCfgModel *m = [[GameCfgModel alloc] init];
    m.ui = ui;
    return [m mj_JSONString];
}

/// 游戏: 准备按钮点击状态   MG_COMMON_SELF_CLICK_READY_BTN
- (void)onGameMGCommonSelfClickReadyBtn {
    if (![AppService.shared.ticket getPopTicketJoin]) {
        TicketJoinPopView *node = TicketJoinPopView.new;
        node.ticketLevelType = AppService.shared.ticket.ticketLevelType;
        [DTSheetView show:node rootView:AppUtil.currentWindow hiddenBackCover:false onCloseCallback:^{}];
        WeakSelf
        node.onJoinCallBack = ^(UIButton *sender) {
            [AppService.shared.ticket reqJoinRoom:(long)self.roomID sceneId:AudioRoomService.shared.sceneType gameId:self.gameId gameLevel: AppService.shared.ticket.ticketLevelType finished:^{
                [weakSelf.sudFSTAPPDecorator notifyAppComonSetReady:true];
            }];
        };
    } else {
        [self.sudFSTAPPDecorator notifyAppComonSetReady:true];
    }
}

/// 游戏: 开始游戏按钮点击状态   MG_COMMON_SELF_CLICK_START_BTN
- (void)onGameMGCommonSelfClickStartBtn {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(AppService.shared.ticket.joinModel.gameSessionId), @"gameSessionId", nil];
    [self.sudFSTAPPDecorator notifyAppComonSelfPlaying:true reportGameInfoExtras:dic.mj_JSONString];
}

#pragma mark - GAME

/// 系统消息背景颜色
- (UIColor *)systemMsgBgColor {
    return [UIColor dt_colorWithHexString:@"#C84319" alpha:0.7];
}

/// 系统消息文本颜色
- (UIColor *)systemMsgTextColor {
    return [UIColor dt_colorWithHexString:@"#FFE77D" alpha:1];
}
@end
