//
// Created by kaniel on 2022/10/10.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "OneOneVideoContentView.h"
#import "SuspendRoomView.h"
#import "OneOneAudioMicroView.h"

@interface OneOneVideoContentView ()
@property(nonatomic, strong) UIButton *suspendBtn;
@property(nonatomic, strong) UIButton *hangupBtn;
@property(nonatomic, strong) UIButton *micBtn;
@property(nonatomic, strong) UIButton *gameBtn;
@property(nonatomic, strong) UILabel *timeLabel;

@property(nonatomic, strong) UIImageView *bottomContentView;
@property(nonatomic, strong) UIImageView *bottomUpBgImageView;
@property(nonatomic, strong) UIImageView *bottomUpIconImageView;
@property(nonatomic, strong) UIButton *bottomTopBtn;

@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIImageView *otherHeaderImageView;
@property(nonatomic, strong) UILabel *otherNameLabel;
@property(nonatomic, strong) UIImageView *bottomCoverImageView;

@property(nonatomic, strong) UIView *addRobotView;
@property(nonatomic, strong) UIView *myVideoView;
@property(nonatomic, strong) UIView *otherVideoView;
/// 语音按钮状态类型
@property(nonatomic, assign) OneOneVideoMicType micStateType;
@property(nonatomic, assign) BOOL isGameState;
@property(nonatomic, strong) AudioRoomMicModel *otherMicModel;
@end

@implementation OneOneVideoContentView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *v = [super hitTest:point withEvent:event];
    // 穿透
    if (v == self) {
        return nil;
    }
    return v;
}

- (void)dtAddViews {
    [super dtAddViews];

    [self addSubview:self.otherVideoView];
    [self.otherVideoView addSubview:self.bgImageView];
    [self addSubview:self.otherHeaderImageView];
    [self addSubview:self.otherNameLabel];
    [self addSubview:self.bottomCoverImageView];
    [self addSubview:self.suspendBtn];

    [self addSubview:self.addRobotView];
    [self addSubview:self.myVideoView];
    [self addSubview:self.bottomContentView];

    [self.bottomContentView addSubview:self.hangupBtn];
    [self.bottomContentView addSubview:self.micBtn];
    [self.bottomContentView addSubview:self.gameBtn];
    [self.bottomContentView addSubview:self.timeLabel];

    [self.bottomContentView addSubview:self.bottomUpBgImageView];
    [self.bottomContentView addSubview:self.bottomUpIconImageView];
    [self.bottomContentView addSubview:self.bottomTopBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(@0);
    }];
    [self.otherVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(@0);
    }];
    [self.otherHeaderImageView dt_cornerRadius:24];
    [self.otherHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.top.equalTo(self.suspendBtn.mas_bottom).offset(16);
        make.width.height.equalTo(@48);
    }];
    [self.otherNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.otherHeaderImageView.mas_trailing).offset(8);
        make.centerY.equalTo(self.otherHeaderImageView);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.bottomCoverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(@0);
        make.height.equalTo(@158);
    }];
    [self.suspendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@32);
        make.top.equalTo(@(kAppSafeTop + 6));
        make.leading.equalTo(@16);
    }];

    [self.gameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@64);
        make.bottom.equalTo(@(-kAppSafeBottom - 16));
        make.centerX.equalTo(self);
    }];
    [self.micBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.gameBtn);
        make.bottom.equalTo(self.gameBtn);
        make.trailing.equalTo(self.gameBtn.mas_leading).offset(-40);
    }];
    [self.hangupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.gameBtn);
        make.bottom.equalTo(self.gameBtn);
        make.leading.equalTo(self.gameBtn.mas_trailing).offset(40);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
        make.bottom.equalTo(self.gameBtn.mas_top).offset(-17);
    }];

    [self.bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@180);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];

    [self.bottomUpBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@51);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.top.equalTo(@0);
    }];

    [self.bottomUpIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@14);
        make.width.equalTo(@24);
        make.top.equalTo(@2);
        make.centerX.equalTo(self.bottomContentView);
    }];

    [self.bottomTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(@100);
        make.top.equalTo(@0);
        make.centerX.equalTo(self.bottomContentView);
    }];

    [self.addRobotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.otherHeaderImageView.mas_bottom).offset(18);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@32);
        make.leading.equalTo(self.otherHeaderImageView);
    }];
    [self.myVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-16);
        make.top.equalTo(self.otherHeaderImageView);
        make.width.equalTo(@80);
        make.height.equalTo(@107);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.otherMicModel = kAudioRoomService.currentRoomVC.dicMicModel[@"1"];
    self.timeLabel.text = @"00 : 00";
    self.bgImageView.image = [UIImage imageNamed:@"oneone_video_default_bg"];

}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (self.otherMicModel.user) {
        NSString *icon = self.otherMicModel.user.icon;
        if (icon) {
            [self.otherHeaderImageView sd_setImageWithURL:[[NSURL alloc] initWithString:icon] placeholderImage:[UIImage imageNamed:@"oneone_video_head_default"]];
        }
        self.otherNameLabel.text = self.otherMicModel.user.name;
        if (self.otherMicModel.user.isRobot) {
            self.bgImageView.image = [UIImage imageNamed:@"oneone_video_robot_bg"];
        }
        self.addRobotView.hidden = YES;
    } else {
        self.otherHeaderImageView.image = [UIImage imageNamed:@"oneone_video_head_default"];
        self.otherNameLabel.text = @"等待对方加入";
        self.bgImageView.image = [UIImage imageNamed:@"oneone_video_default_bg"];
        self.addRobotView.hidden = NO;
    }
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    [self.hangupBtn addTarget:self action:@selector(onHangupBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.gameBtn addTarget:self action:@selector(onGameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.micBtn addTarget:self action:@selector(onMicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomTopBtn addTarget:self action:@selector(onBottomTopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *robotViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAddRobotViewTap:)];
    [self.addRobotView addGestureRecognizer:robotViewTap];

    [[NSNotificationCenter defaultCenter] addObserverForName:NTF_MIC_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *_Nonnull note) {
        RoomCmdUpMicModel *msgModel = note.userInfo[@"msgModel"];
        if ([msgModel isKindOfClass:RoomCmdUpMicModel.class]) {

            BOOL isSameMicUser = weakSelf.otherMicModel.user != nil && [msgModel.sendUser.userID isEqualToString:weakSelf.otherMicModel.user.userID];
            // 操作麦位与当前符合
            if (msgModel.micIndex == weakSelf.otherMicModel.micIndex) {
                DDLogDebug(@"NTF_MIC_CHANGED msg info:%@", [msgModel mj_JSONString]);
                if (msgModel.cmd == CMD_DOWN_MIC_NOTIFY) {
                    // 下麦,清空用户信息
                    if (isSameMicUser) {
                        weakSelf.otherMicModel.user = nil;
                    }
                } else {
                    weakSelf.otherMicModel.user = msgModel.sendUser;
                    weakSelf.otherMicModel.user.roleType = msgModel.roleType;
                    weakSelf.otherMicModel.streamID = msgModel.streamID;
                }
            } else if (isSameMicUser) {
                DDLogDebug(@"NTF_MIC_CHANGED msg info:%@", [msgModel mj_JSONString]);
                // 当前用户ID与切换用户ID一致，则清除掉
                weakSelf.otherMicModel.user = nil;
            }
            [weakSelf dtUpdateUI];
        } else {
            [weakSelf dtUpdateUI];
        }
    }];
}

- (void)handleMicClick:(AudioRoomMicModel *)micModel {
    if (micModel.user == nil) {
        /// 无人，上麦
        [kAudioRoomService reqSwitchMic:kAudioRoomService.currentRoomVC.roomID.integerValue micIndex:(int) micModel.micIndex handleType:0 proxyUser:nil success:nil fail:nil];
        return;
    }
}

- (void)updateAddRobotViewPos {
//    if (self.leftMicView.model.user && self.rightMicView.model.user) {
//        self.addRobotView.hidden = YES;
//        return;
//    }
//    if (self.rightMicView.model.user == nil) {
//        self.addRobotView.hidden = NO;
//
//    } else if (self.leftMicView.model.user == nil) {
//        self.addRobotView.hidden = NO;
//
//    }
}


- (void)onAddRobotViewTap:(id)tap {
    if (self.addRobotBlock) self.addRobotBlock();
}

- (void)onHangupBtnClick:(id)sender {
    if (self.hangupBlock) self.hangupBlock();
}

- (void)onGameBtnClick:(id)sender {
    if (self.selecteGameBlock) self.selecteGameBlock();
}

- (void)onMicBtnClick:(id)sender {
    self.micBtn.selected = !self.micBtn.selected;
    if (self.micStateChangedBlock) self.micStateChangedBlock(self.micBtn.selected ? OneOneVideoMicTypeOpen : OneOneVideoMicTypeClose);
}

- (void)onBottomTopBtnClick:(id)sender {
    self.bottomTopBtn.selected = !self.bottomTopBtn.selected;
    if (self.bottomTopBtn.selected) {
        // 展开
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomContentView.transform = CGAffineTransformIdentity;
        }];
        self.bottomUpBgImageView.alpha = 0;
        self.bottomContentView.image = [UIImage imageNamed:@"oneone_video_game_bottom_open"];
        self.bottomUpIconImageView.image = [UIImage imageNamed:@"oneone_video_game_down"];
    } else {
        // 收起
        [UIView animateWithDuration:0.25 animations:^{
            CGAffineTransform trans = CGAffineTransformMakeTranslation(0, 130);
            self.bottomContentView.transform = trans;
            self.bottomCoverImageView.alpha = 1;
            self.bottomUpBgImageView.alpha = 1;
        } completion:^(BOOL finished) {
            self.bottomContentView.alpha = 1;
            self.bottomUpIconImageView.alpha = 1;
            self.bottomContentView.image = nil;
        }];

        self.bottomUpIconImageView.image = [UIImage imageNamed:@"oneone_video_game_up"];

    }

}

- (void)onSpeakerBtnClick:(id)sender {

}

- (void)onRightUserHeadBtnClick:(id)sender {
    [self changeUIState:YES];
}

- (void)onLeftUserHeadBtnClick:(id)sender {
    [self changeUIState:NO];
}

/// 切换UI状态
/// @param isGameState 是否处于游戏中
- (void)changeUIState:(BOOL)isGameState {
    if (self.isGameState == isGameState) {
        return;
    }
    self.isGameState = isGameState;
    if (isGameState) {
        // 游戏状态UI
        [UIView animateWithDuration:0.25 animations:^{
            CGAffineTransform trans = CGAffineTransformMakeTranslation(0, 130);
            self.bottomContentView.transform = trans;
            self.bottomCoverImageView.alpha = 1;
        } completion:^(BOOL finished) {
            self.bottomContentView.alpha = 1;
            self.bottomUpBgImageView.alpha = 1;
            self.bottomUpIconImageView.alpha = 1;
        }];

        self.timeLabel.hidden = YES;
        self.bottomUpIconImageView.image = [UIImage imageNamed:@"oneone_video_game_up"];
        self.bottomTopBtn.enabled = YES;
        self.addRobotView.alpha = 0;
        self.otherHeaderImageView.hidden = YES;
        self.otherNameLabel.hidden = YES;

        [self.otherVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self.myVideoView);
            make.top.equalTo(self.myVideoView);
            make.leading.equalTo(@16);
        }];
    } else {
        self.bottomTopBtn.enabled = NO;
        self.bottomCoverImageView.alpha = 0;
        self.bottomContentView.image = nil;
        self.bottomUpIconImageView.alpha = 0;
        self.bottomUpBgImageView.alpha = 0;
        self.timeLabel.hidden = NO;
        self.bottomTopBtn.selected = NO;
        self.otherHeaderImageView.hidden = NO;
        self.otherNameLabel.hidden = NO;
        self.addRobotView.alpha = 1;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomContentView.transform = CGAffineTransformIdentity;
        }];
        [self.otherVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.bottom.equalTo(@0);
        }];
    }
}

- (void)updateDuration:(NSInteger)duration {
    NSInteger minute = duration / 60;
    NSInteger second = duration - minute * 60;
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld : %02ld", minute, second];
}

- (void)changeMicState:(OneOneVideoMicType)stateType {
    self.micStateType = stateType;
    self.micBtn.selected = stateType == OneOneVideoMicTypeOpen;
}


- (UIButton *)bottomTopBtn {
    if (!_bottomTopBtn) {
        _bottomTopBtn = UIButton.new;
    }
    return _bottomTopBtn;
}

- (UIButton *)suspendBtn {
    if (!_suspendBtn) {
        _suspendBtn = UIButton.new;
        [_suspendBtn setImage:[UIImage imageNamed:@"oneone_suspend"] forState:UIControlStateNormal];
    }
    return _suspendBtn;
}

- (UIButton *)hangupBtn {
    if (!_hangupBtn) {
        _hangupBtn = UIButton.new;
        [_hangupBtn setImage:[UIImage imageNamed:@"oneone_video_hangup"] forState:UIControlStateNormal];
    }
    return _hangupBtn;
}

- (UIButton *)micBtn {
    if (!_micBtn) {
        _micBtn = UIButton.new;
        [_micBtn setImage:[UIImage imageNamed:@"oneone_mic_close"] forState:UIControlStateNormal];
        [_micBtn setImage:[UIImage imageNamed:@"oneone_mic_open"] forState:UIControlStateSelected];
    }
    return _micBtn;
}

- (UIButton *)gameBtn {
    if (!_gameBtn) {
        _gameBtn = UIButton.new;
        [_gameBtn setImage:[UIImage imageNamed:@"oneone_game"] forState:UIControlStateNormal];
    }
    return _gameBtn;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.new;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = UIFONT_SEMI_BOLD(24);
        _timeLabel.textColor = HEX_COLOR(@"#ffffff");
    }
    return _timeLabel;
}

- (UILabel *)otherNameLabel {
    if (!_otherNameLabel) {
        _otherNameLabel = UILabel.new;
        _otherNameLabel.font = UIFONT_REGULAR(14);
        _otherNameLabel.textColor = HEX_COLOR(@"#ffffff");
    }
    return _otherNameLabel;
}


- (UIView *)addRobotView {
    if (!_addRobotView) {
        _addRobotView = UIView.new;
        _addRobotView.backgroundColor = HEX_COLOR_A(@"#000000", 0.6);
        [_addRobotView dt_cornerRadius:4];
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"oneone_add_robot"]];
        UILabel *titleLabel = UILabel.new;
        titleLabel.font = UIFONT_MEDIUM(14);
        titleLabel.textColor = HEX_COLOR(@"#ffffff");
        titleLabel.text = @"添加机器人";
        [_addRobotView addSubview:iconImageView];
        [_addRobotView addSubview:titleLabel];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@6);
            make.width.height.equalTo(@24);
            make.centerY.equalTo(_addRobotView);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(iconImageView.mas_trailing).offset(8);
            make.width.height.greaterThanOrEqualTo(@0);
            make.centerY.equalTo(_addRobotView);
            make.trailing.equalTo(@-8);
        }];
    }
    return _addRobotView;
}

- (UIView *)myVideoView {
    if (!_myVideoView) {
        _myVideoView = UIView.new;
    }
    return _myVideoView;
}

- (UIView *)otherVideoView {
    if (!_otherVideoView) {
        _otherVideoView = UIView.new;
        _otherVideoView.clipsToBounds = YES;
    }
    return _otherVideoView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = UIImageView.new;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (UIImageView *)otherHeaderImageView {
    if (!_otherHeaderImageView) {
        _otherHeaderImageView = UIImageView.new;
        _otherHeaderImageView.image = [UIImage imageNamed:@"oneone_video_head_default"];
    }
    return _otherHeaderImageView;
}

- (UIImageView *)bottomContentView {
    if (!_bottomContentView) {
        _bottomContentView = UIImageView.new;
        _bottomContentView.userInteractionEnabled = YES;
    }
    return _bottomContentView;
}

- (UIImageView *)bottomUpBgImageView {
    if (!_bottomUpBgImageView) {
        _bottomUpBgImageView = UIImageView.new;
        _bottomUpBgImageView.image = [UIImage imageNamed:@"oneone_video_game_bottom"];
        _bottomUpBgImageView.alpha = 0;
    }
    return _bottomUpBgImageView;
}
- (UIImageView *)bottomUpIconImageView {
    if (!_bottomUpIconImageView) {
        _bottomUpIconImageView = UIImageView.new;
        _bottomUpIconImageView.image = [UIImage imageNamed:@"oneone_video_game_up"];
        _bottomUpIconImageView.alpha = 0;
    }
    return _bottomUpIconImageView;
}

- (UIImageView *)bottomCoverImageView {
    if (!_bottomCoverImageView) {
        _bottomCoverImageView = UIImageView.new;
        _bottomCoverImageView.image = [UIImage imageNamed:@"oneone_game_bottom_cover"];
        _bottomCoverImageView.alpha = 0;
    }
    return _bottomCoverImageView;
}

@end
