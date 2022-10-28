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

/// 服务类，子类返回对应服务类型，用于构建对应场景服务
- (Class)serviceClass {
    return [TicketRoomService class];
}

- (void)setConfigModel:(BaseSceneConfigModel *)configModel {
    [super setConfigModel:configModel];
    kTicketService.ticketLevelType = configModel.enterRoomModel.gameLevel;
}

#pragma mark - SudFSMMGListener

/// 获取游戏Config  【需要实现】
- (NSString *)onGetGameCfg {
    GameCfgModel *m = [GameCfgModel defaultCfgModel];
    m.ui.nft_avatar.hide = NO;
    m.ui.game_opening.hide = NO;
    m.ui.game_mvp.hide = NO;
    m.ui.lobby_players.hide = true;
    m.ui.ready_btn.custom = true;
    m.ui.start_btn.custom = true;
    m.ui.game_settle_again_btn.custom = true;
    return [m mj_JSONString];
}

/// 游戏: 准备按钮点击状态   MG_COMMON_SELF_CLICK_READY_BTN
- (void)onGameMGCommonSelfClickReadyBtn {
    WeakSelf
    if (![kTicketService getPopTicketJoin]) {
        TicketJoinPopView *node = TicketJoinPopView.new;
        node.ticketLevelType = kTicketService.ticketLevelType;
        [DTSheetView show:node rootView:AppUtil.currentWindow hiddenBackCover:false onCloseCallback:^{}];
        node.onJoinCallBack = ^(UIButton *sender) {
            [kTicketService reqJoinRoom:(long)self.roomID sceneId:kAudioRoomService.sceneType gameId:self.gameId gameLevel: kTicketService.ticketLevelType finished:^{
                [weakSelf.sudFSTAPPDecorator notifyAppCommonSelfReady:true];
            }];
        };
    } else {
        [kTicketService reqJoinRoom:(long)self.roomID sceneId:kAudioRoomService.sceneType gameId:self.gameId gameLevel: kTicketService.ticketLevelType finished:^{
            [weakSelf.sudFSTAPPDecorator notifyAppCommonSelfReady:true];
        }];
    }
}

/// 游戏: 开始游戏按钮点击状态   MG_COMMON_SELF_CLICK_START_BTN
- (void)onGameMGCommonSelfClickStartBtn {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(kTicketService.joinModel.gameSessionId), @"gameSessionId", nil];
    [self.sudFSTAPPDecorator notifyAppComonSelfPlaying:true reportGameInfoExtras:dic.mj_JSONString];
}

@end
