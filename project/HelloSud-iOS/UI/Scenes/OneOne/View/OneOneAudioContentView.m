//
// Created by kaniel on 2022/10/10.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "OneOneAudioContentView.h"
#import "SuspendRoomView.h"
#import "OneOneAudioMicroView.h"

@interface OneOneAudioContentView ()
@property(nonatomic, strong) UIButton *suspendBtn;
@property(nonatomic, strong) UIButton *hangupBtn;
@property(nonatomic, strong) UIButton *micBtn;
@property(nonatomic, strong) UIButton *gameBtn;
@property(nonatomic, strong) UIButton *speakerBtn;
@property(nonatomic, strong) UILabel *timeLabel;

@property(nonatomic, strong) UIView *micContentView;

@property(nonatomic, strong) OneOneAudioMicroView *leftMicView;
@property(nonatomic, strong) OneOneAudioMicroView *rightMicView;
@property(nonatomic, strong) UIImageView *vsImageView;
@property(nonatomic, strong) UIImageView *topCoverImageView;
@property(nonatomic, strong) UIImageView *bottomCoverImageView;

@property(nonatomic, strong) UIView *addRobotView;
/// 语音按钮状态类型
@property(nonatomic, assign) OneOneAudioMicType micStateType;
/// 外放按钮状态类型
@property(nonatomic, assign) OneOneAudioSpeakerType speakerStateType;
@property(nonatomic, assign) BOOL isGameState;
@end

@implementation OneOneAudioContentView

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
    [self addSubview:self.topCoverImageView];
    [self addSubview:self.bottomCoverImageView];
    [self addSubview:self.suspendBtn];
    [self addSubview:self.hangupBtn];
    [self addSubview:self.micBtn];
    [self addSubview:self.gameBtn];
    [self addSubview:self.speakerBtn];
    [self addSubview:self.timeLabel];
    [self addSubview:self.micContentView];
    [self.micContentView addSubview:self.leftMicView];
    [self.micContentView addSubview:self.rightMicView];
    [self.micContentView addSubview:self.vsImageView];

    self.leftMicView.model = kAudioRoomService.currentRoomVC.dicMicModel[@"0"];
    self.rightMicView.model = kAudioRoomService.currentRoomVC.dicMicModel[@"1"];
    [self.micContentView addSubview:self.addRobotView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.topCoverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(@0);
        make.height.equalTo(@158);
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
    [self.hangupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@32);
        make.top.equalTo(@(kAppSafeTop + 6));
        make.trailing.equalTo(@-16);
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
    [self.speakerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.gameBtn);
        make.bottom.equalTo(self.gameBtn);
        make.leading.equalTo(self.gameBtn.mas_trailing).offset(40);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
        make.bottom.equalTo(self.gameBtn.mas_top).offset(-17);
    }];

    [self.micContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@130);
        make.leading.equalTo(@58);
        make.trailing.equalTo(@-58);
        make.top.equalTo(self.suspendBtn.mas_bottom).offset(56);
    }];
    [self.leftMicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(@0);
        make.width.equalTo(@80);
        make.height.equalTo(@110);
    }];
    [self.rightMicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.equalTo(@0);
        make.width.equalTo(@80);
        make.height.equalTo(@110);
    }];
    [self.vsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@33);
        make.height.equalTo(@48);
        make.centerX.equalTo(self);
        make.top.equalTo(self.leftMicView).offset(15);
    }];
    [self.addRobotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.rightMicView).offset(10);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@32);
        make.centerX.equalTo(self.rightMicView);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.timeLabel.text = @"00 : 00";

}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    [self.hangupBtn addTarget:self action:@selector(onHangupBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.gameBtn addTarget:self action:@selector(onGameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.micBtn addTarget:self action:@selector(onMicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.speakerBtn addTarget:self action:@selector(onSpeakerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *robotViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAddRobotViewTap:)];
    [self.addRobotView addGestureRecognizer:robotViewTap];
    self.leftMicView.micUserChangedBlock = ^(AudioRoomMicModel *micModel) {
        [weakSelf updateAddRobotViewPos];
    };
    self.rightMicView.micUserChangedBlock = ^(AudioRoomMicModel *micModel) {
        [weakSelf updateAddRobotViewPos];
    };
    self.leftMicView.onTapCallback = ^(AudioRoomMicModel *micModel) {
        [weakSelf handleMicClick:micModel];
    };
    self.rightMicView.onTapCallback = ^(AudioRoomMicModel *micModel) {
        [weakSelf handleMicClick:micModel];
    };
}

- (void)handleMicClick:(AudioRoomMicModel *)micModel {
    if (micModel.user == nil) {
        /// 无人，上麦
        [kAudioRoomService reqSwitchMic:kAudioRoomService.currentRoomVC.roomID.integerValue micIndex:(int) micModel.micIndex handleType:0 proxyUser:nil success:nil fail:nil];
        return;
    }
}

- (void)updateAddRobotViewPos {
    if (self.leftMicView.model.user && self.rightMicView.model.user) {
        self.addRobotView.hidden = YES;
        return;
    }
    if (self.rightMicView.model.user == nil) {
        self.addRobotView.hidden = NO;
        [self.addRobotView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.rightMicView).offset(10);
            make.width.greaterThanOrEqualTo(@0);
            make.height.equalTo(@32);
            make.centerX.equalTo(self.rightMicView);
        }];
    } else if (self.leftMicView.model.user == nil) {
        self.addRobotView.hidden = NO;
        [self.addRobotView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.leftMicView).offset(10);
            make.width.greaterThanOrEqualTo(@0);
            make.height.equalTo(@32);
            make.centerX.equalTo(self.leftMicView);
        }];
    }
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
    if (self.micStateChangedBlock) self.micStateChangedBlock(self.micBtn.selected ? OneOneAudioMicTypeOpen : OneOneAudioMicTypeClose);
}

- (void)onSpeakerBtnClick:(id)sender {
    self.speakerBtn.selected = !self.speakerBtn.selected;
    if (self.speakerStateChangedBlock) self.speakerStateChangedBlock(self.speakerBtn.selected ? OneOneAudioSpeakerTypeOpen : OneOneAudioSpeakerTypeClose);
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
            CGAffineTransform transScale = CGAffineTransformMakeScale(0.75, 0.75);
            CGFloat y = self.micContentView.mj_y - self.suspendBtn.mj_y + self.micContentView.mj_h * (1 - 0.75) / 2;
            CGAffineTransform transMove = CGAffineTransformMakeTranslation(0, -y);
            CGAffineTransform transGroup = CGAffineTransformConcat(transScale, transMove);
            self.micContentView.transform = transGroup;
            self.vsImageView.alpha = 1;
            self.topCoverImageView.alpha = 1;
            self.bottomCoverImageView.alpha = 1;
        }];

        [self.gameBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@32);
            make.bottom.equalTo(@(-kAppSafeBottom - 4));
            make.trailing.equalTo(@-17);
        }];
        [self.micBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(self.gameBtn);
            make.bottom.equalTo(self.gameBtn);
            make.leading.equalTo(@16);
        }];
        [self.speakerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(self.gameBtn);
            make.bottom.equalTo(self.micBtn);
            make.leading.equalTo(self.micBtn.mas_trailing).offset(10);
        }];
        self.timeLabel.hidden = YES;
        self.gameBtn.backgroundColor = HEX_COLOR_A(@"#000000", 0.4);
        self.micBtn.backgroundColor = HEX_COLOR_A(@"#000000", 0.4);
        self.speakerBtn.backgroundColor = HEX_COLOR_A(@"#000000", 0.4);
        [self.gameBtn dt_cornerRadius:16];
        [self.micBtn dt_cornerRadius:16];
        [self.speakerBtn dt_cornerRadius:16];
        [self.gameBtn setImage:[UIImage imageNamed:@"oneone_game_game"] forState:UIControlStateNormal];
        [self.micBtn setImage:[UIImage imageNamed:@"oneone_game_mic_close"] forState:UIControlStateNormal];
        [self.micBtn setImage:[UIImage imageNamed:@"room_voice_open_mic"] forState:UIControlStateSelected];
        [self.speakerBtn setImage:[UIImage imageNamed:@"oneone_game_speaker_close"] forState:UIControlStateNormal];
        [self.speakerBtn setImage:[UIImage imageNamed:@"oneone_game_speaker_open"] forState:UIControlStateSelected];
    } else {
        self.vsImageView.alpha = 0;
        self.topCoverImageView.alpha = 0;
        self.bottomCoverImageView.alpha = 0;
        self.timeLabel.hidden = NO;
        self.gameBtn.backgroundColor = nil;
        self.micBtn.backgroundColor = nil;
        self.speakerBtn.backgroundColor = nil;
        [self.gameBtn dt_cornerRadius:0];
        [self.micBtn dt_cornerRadius:0];
        [self.speakerBtn dt_cornerRadius:0];
        [self.gameBtn setImage:[UIImage imageNamed:@"oneone_game"] forState:UIControlStateNormal];
        [self.micBtn setImage:[UIImage imageNamed:@"oneone_mic_close"] forState:UIControlStateNormal];
        [self.micBtn setImage:[UIImage imageNamed:@"oneone_mic_open"] forState:UIControlStateSelected];
        [self.speakerBtn setImage:[UIImage imageNamed:@"oneone_speaker_close"] forState:UIControlStateNormal];
        [self.speakerBtn setImage:[UIImage imageNamed:@"oneone_speaker_open"] forState:UIControlStateSelected];
        [UIView animateWithDuration:0.25 animations:^{
            self.micContentView.transform = CGAffineTransformIdentity;
        }];
        [self.gameBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@64);
            make.bottom.equalTo(@(-kAppSafeBottom - 16));
            make.centerX.equalTo(self);
        }];
        [self.micBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(self.gameBtn);
            make.bottom.equalTo(self.gameBtn);
            make.trailing.equalTo(self.gameBtn.mas_leading).offset(-40);
        }];
        [self.speakerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(self.gameBtn);
            make.bottom.equalTo(self.gameBtn);
            make.leading.equalTo(self.gameBtn.mas_trailing).offset(40);
        }];
    }
}

- (void)updateDuration:(NSInteger)duration {
    NSInteger minute = duration / 60;
    NSInteger second = duration - minute * 60;
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld : %02ld", minute, second];
}

- (void)changeMicState:(OneOneAudioMicType)stateType {
    self.micStateType = stateType;
    self.micBtn.selected = stateType == OneOneAudioMicTypeOpen;
}

- (void)changeSpeakerState:(OneOneAudioSpeakerType)stateType {
    self.speakerStateType = stateType;
    self.speakerBtn.selected = stateType == OneOneAudioMicTypeOpen;
}

- (UIView *)micContentView {
    if (!_micContentView) {
        _micContentView = UIView.new;
    }
    return _micContentView;
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
        [_hangupBtn setImage:[UIImage imageNamed:@"oneone_hangup"] forState:UIControlStateNormal];
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

- (UIButton *)speakerBtn {
    if (!_speakerBtn) {
        _speakerBtn = UIButton.new;
        [_speakerBtn setImage:[UIImage imageNamed:@"oneone_speaker_close"] forState:UIControlStateNormal];
        [_speakerBtn setImage:[UIImage imageNamed:@"oneone_speaker_open"] forState:UIControlStateSelected];
    }
    return _speakerBtn;
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

- (OneOneAudioMicroView *)leftMicView {
    if (!_leftMicView) {
        _leftMicView = OneOneAudioMicroView.new;
        _leftMicView.headWidth = 80;
    }
    return _leftMicView;
}

- (OneOneAudioMicroView *)rightMicView {
    if (!_rightMicView) {
        _rightMicView = OneOneAudioMicroView.new;
        _rightMicView.headWidth = 80;
    }
    return _rightMicView;
}

- (UIImageView *)vsImageView {
    if (!_vsImageView) {
        _vsImageView = UIImageView.new;
        _vsImageView.image = [UIImage imageNamed:@"oneone_game_vs"];
        _vsImageView.alpha = 0;
    }
    return _vsImageView;
}

- (UIImageView *)topCoverImageView {
    if (!_topCoverImageView) {
        _topCoverImageView = UIImageView.new;
        _topCoverImageView.image = [UIImage imageNamed:@"oneone_game_top_cover"];
        _topCoverImageView.alpha = 0;
    }
    return _topCoverImageView;
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
