//
// Created by kaniel on 2022/6/1.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GuessRoomViewController.h"
#import "GuessMineView.h"
#import "SwitchAutoGuessPopView.h"
#import "GuessSelectPopView.h"
#import "GuessResultPopView.h"

@interface GuessRoomViewController ()
/// 猜我赢挂件视图
@property(nonatomic, strong) GuessMineView *guessMineView;
/// 导航自动竞猜导航视图
@property(nonatomic, strong) BaseView *autoGuessNavView;
@property(nonatomic, strong) UIImageView *autoNavImageView;
@property(nonatomic, strong) UILabel *autoTitleLabel;
/// 围观者导航视图
@property(nonatomic, strong) BaseView *normalGuessNavView;
@property(nonatomic, strong) MarqueeLabel *normalGuessNavLabel;

@property(nonatomic, assign) NSInteger betCoin;
@end

@implementation GuessRoomViewController {

}

- (Class)serviceClass {
    return GuessService.class;
}


- (void)dtAddViews {
    [super dtAddViews];
    [self.sceneView addSubview:self.guessMineView];
    [self.naviView addSubview:self.autoGuessNavView];
    [self.naviView addSubview:self.normalGuessNavView];

    [self.autoGuessNavView addSubview:self.autoNavImageView];
    [self.autoGuessNavView addSubview:self.autoTitleLabel];

    [self.normalGuessNavView addSubview:self.normalGuessNavLabel];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    CGFloat bottom = kAppSafeBottom + 51;
    [self.guessMineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-18));
        make.width.equalTo(@80);
        make.height.equalTo(@90);
        make.bottom.equalTo(@(-bottom));
    }];
    [self.autoGuessNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.naviView.roomModeView);
        make.height.equalTo(@20);
        make.width.equalTo(@0);
        make.trailing.equalTo(self.naviView.roomModeView.mas_leading).offset(-10);
        make.leading.greaterThanOrEqualTo(self.naviView.onlineImageView.mas_trailing).offset(10);
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
        make.width.greaterThanOrEqualTo(@0);
        make.trailing.equalTo(self.naviView.roomModeView.mas_leading).offset(-10);
        make.leading.greaterThanOrEqualTo(self.naviView.onlineImageView.mas_trailing).offset(10);
    }];
    [self.normalGuessNavLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@8);
        make.trailing.equalTo(@-8);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(self.normalGuessNavView);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.autoTitleLabel.text = @"自动竞猜";
    self.normalGuessNavLabel.text = @"猜输赢";
    [self reqData];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];

    [self.guessMineView updateBetCoin:self.betCoin];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
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
    [GuessService reqGuessPlayerList:playerUserIdList roomId:roomId finished:^(RespGuessPlayerListModel *model) {
        weakSelf.betCoin = model.betCoin;
        [weakSelf dtUpdateUI];
    }];
}

/// 游戏玩家加入游戏状态变化
- (void)playerIsInGameStateChanged:(NSString *)userId {
    if (![AppService.shared.loginUserID isEqualToString: userId]) {
        return;
    }

    BOOL isInGame = self.sudFSMMGDecorator.isInGame;
    if (!isInGame) {
        // 当前用户没有加入游戏
        [self showNaviAutoStateView:NO];
        self.guessMineView.hidden = YES;
        self.normalGuessNavView.hidden = NO;
        return;
    }
    // 当前用户加入了游戏
    self.guessMineView.hidden = NO;
    self.normalGuessNavView.hidden = YES;
}

/// 我的猜输赢挂件响应
- (void)onTap:(id)tap {
    [self showResultAlertView];
    return;
    WeakSelf
    SwitchAutoGuessPopView *v = [[SwitchAutoGuessPopView alloc]init];
    v.betCoin = self.betCoin;
    [v dtUpdateUI];
    v.onCloseBlock = ^{
        [DTSheetView close];
    };
    v.onOpenBlock = ^{
        // 开启的时候自动扣费
        [GuessService reqBet:2 coin:self.betCoin userList:@[AppService.shared.loginUserID] finished:^{
            [DTSheetView close];
            [weakSelf showNaviAutoStateView:YES];
        }];
    };
    [DTSheetView show:v onCloseCallback:^{
        
    }];
}

/// 自动竞猜状态开关响应
- (void)onTapAuto:(id)tap {
    WeakSelf
    [DTAlertView showTextAlert:@"是否关闭每轮自动猜自己赢?" sureText:@"确认关闭" cancelText:@"返回" onSureCallback:^{
        [weakSelf showNaviAutoStateView:NO];
    } onCloseCallback:^{
        [DTAlertView close];
    }];

}

/// 普通用户猜输赢开关响应
- (void)onTapNormal:(id)tap {
    GuessSelectPopView *v = [[GuessSelectPopView alloc]init];
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
            make.leading.greaterThanOrEqualTo(self.naviView.onlineImageView.mas_trailing).offset(10);
        }];
    } else {
        self.autoGuessNavView.hidden = YES;
        self.guessMineView.hidden = NO;
        [self.autoGuessNavView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.naviView.roomModeView);
            make.height.equalTo(@20);
            make.width.greaterThanOrEqualTo(@0);
            make.trailing.equalTo(self.naviView.roomModeView.mas_leading).offset(-10);
            make.leading.greaterThanOrEqualTo(self.naviView.onlineImageView.mas_trailing).offset(10);
        }];
    }
}

- (void)showResultAlertView {
    GuessResultPopView *v = [[GuessResultPopView alloc]init];
    v.backgroundColor = UIColor.clearColor;
    [DTAlertView show:v rootView:nil clickToClose:YES showDefaultBackground:NO onCloseCallback:^{

    }];
}

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

- (UILabel *)autoTitleLabel {
    if (!_autoTitleLabel) {
        _autoTitleLabel = [[UILabel alloc] init];
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
        _normalGuessNavLabel.textColor = UIColor.whiteColor;
        _normalGuessNavLabel.font = UIFONT_MEDIUM(12);
        _normalGuessNavLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _normalGuessNavLabel;
}
@end
