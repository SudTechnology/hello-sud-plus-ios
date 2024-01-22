//
//  ThirdGameViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2023/12/13.
//  Copyright © 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "ThirdGameViewController.h"
#import "ThirdGameView.h"

@interface ThirdGameViewController ()
@property(nonatomic, strong)ThirdGameView *thirdGameView;
@end

@implementation ThirdGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

//- (BOOL)isShowGameMic {
//    return NO;
//}
//
//- (BOOL)isShowAudioContent {
//    return NO;
//}
//
///// 是否显示添加通用机器人按钮
//- (BOOL)isShowAddRobotBtn {
//    return NO;
//}
//
///// 是否展示火箭
- (BOOL)shouldShowRocket {
    return NO;
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.view addSubview:self.thirdGameView];
    
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    CGFloat scale = 1.0;
    [self.thirdGameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@(kScreenWidth * scale + kAppSafeBottom));
        make.bottom.equalTo(@(0));
//        make.bottom.equalTo(@(-kAppSafeBottom));
    }];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf;
    self.thirdGameView.onCloseGameBlock = ^{
        [weakSelf handleChangeToGame:0];
    };
    self.thirdGameView.onGamePayBlock = ^{
        [UserService.shared reqAddUserCoin:^(int64_t i) {
            [weakSelf.thirdGameView updateCoin];
        } fail:^(NSString *str) {
            [ToastUtil show:str];
        }];
    };
}

- (void)dtConfigUI {
    [super dtConfigUI];
//    self.naviView.roomInfoView.hidden = YES;
//    self.msgTableView.hidden = YES;
//    self.robotView.hidden = YES;
//    self.operatorView.hidden = YES;
}

- (NSString *)onGetGameCfg {
    GameCfgModel *m = [GameCfgModel defaultCfgModel];
    m.ui.lobby_players.hide = NO;
    m.ui.nft_avatar.hide = NO;
    m.ui.game_opening.hide = NO;
    m.ui.game_mvp.hide = NO;
    m.ui.bullet_screens_btn.hide = NO;
    return [m mj_JSONString];
}

- (void)updateGameViewSize:(CGFloat)scale {
    [self.thirdGameView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kScreenWidth * scale + kAppSafeBottom));
    }];
}

- (ThirdGameView *)thirdGameView {
    if (!_thirdGameView) {
        _thirdGameView = ThirdGameView.new;
        _thirdGameView.hidden = YES;
    }
    return _thirdGameView;
}

- (void)loginGame {
    if (self.loadType == GameCategoryLoadTypH5) {
        [self reqGameToken];
        return;
    }
    [super loginGame];
}

- (void)logoutGame {
    if (self.loadType == GameCategoryLoadTypH5) {
        [self.thirdGameView destryGame];
        self.thirdGameView.hidden = YES;
        return;
    }
    [super logoutGame];
}


- (void)reqGameToken {
    WeakSelf
    ReqAppWebGameTokenModel *req = ReqAppWebGameTokenModel.new;
    req.roomId = self.roomID;
    req.gameId = [NSString stringWithFormat:@"%@", @(self.gameId)];
    [AudioRoomService reqWebGameToken:req success:^(RespWebGameTokenModel * _Nonnull resp) {
        DDLogDebug(@"game url:%@", resp.gameUrl);
        if (resp.gameUrl.length > 0) {
            weakSelf.thirdGameView.hidden = NO;
            [weakSelf.thirdGameView loadGame:resp.gameUrl];
        }
        if (resp.scale > 0) {
            [weakSelf updateGameViewSize:resp.scale];
        }
    } failure:nil];
}

@end
