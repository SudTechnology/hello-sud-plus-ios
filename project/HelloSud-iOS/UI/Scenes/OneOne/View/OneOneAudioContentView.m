//
// Created by kaniel on 2022/10/10.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "OneOneAudioContentView.h"
#import "SuspendRoomView.h"

@interface OneOneAudioContentView ()
@property(nonatomic, strong) UIButton *suspendBtn;
@property(nonatomic, strong) UIButton *hangupBtn;
@property(nonatomic, strong) UIButton *micBtn;
@property(nonatomic, strong) UIButton *gameBtn;
@property(nonatomic, strong) UIButton *speakerBtn;
@property(nonatomic, strong) UILabel *timeLabel;

@property(nonatomic, strong) UIView *micContentView;
@property(nonatomic, strong) UIButton *leftUserHeadBtn;
@property(nonatomic, strong) UILabel *leftUserNameLabel;
@property(nonatomic, strong) UIButton *rightUserHeadBtn;
@property(nonatomic, strong) UILabel *rightUserNameLabel;
@property(nonatomic, strong) UIView *addRobotView;
@end

@implementation OneOneAudioContentView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.suspendBtn];
    [self addSubview:self.hangupBtn];
    [self addSubview:self.micBtn];
    [self addSubview:self.gameBtn];
    [self addSubview:self.speakerBtn];
    [self addSubview:self.timeLabel];
    [self addSubview:self.micContentView];
    [self.micContentView addSubview:self.leftUserHeadBtn];
    [self.micContentView addSubview:self.leftUserNameLabel];
    [self.micContentView addSubview:self.rightUserHeadBtn];
    [self.micContentView addSubview:self.rightUserNameLabel];
    [self.micContentView addSubview:self.addRobotView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
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

    [self.leftUserHeadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(@0);
        make.width.height.equalTo(@80);
    }];
    [self.leftUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftUserHeadBtn.mas_bottom).offset(6);
        make.leading.trailing.equalTo(self.leftUserHeadBtn);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.rightUserHeadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.equalTo(@0);
        make.width.height.equalTo(@80);
    }];
    [self.rightUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightUserHeadBtn.mas_bottom).offset(6);
        make.leading.trailing.equalTo(self.rightUserHeadBtn);
        make.height.greaterThanOrEqualTo(@0);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.timeLabel.text = @"03:38";
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.hangupBtn addTarget:self action:@selector(onHangupBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onHangupBtnClick:(id)sender {
    if (self.hangupBlock) self.hangupBlock();
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
        [_micBtn setImage:[UIImage imageNamed:@"oneone_mic_open"] forState:UIControlStateNormal];
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
        [_speakerBtn setImage:[UIImage imageNamed:@"oneone_speaker_open"] forState:UIControlStateNormal];
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

- (UIButton *)leftUserHeadBtn {
    if (!_leftUserHeadBtn) {
        _leftUserHeadBtn = UIButton.new;

    }
    return _leftUserHeadBtn;
}

- (UIButton *)rightUserHeadBtn {
    if (!_rightUserHeadBtn) {
        _rightUserHeadBtn = UIButton.new;
        [_rightUserHeadBtn setImage:[UIImage imageNamed:@"oneone_add"] forState:UIControlStateNormal];
    }
    return _rightUserHeadBtn;
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
        [_addRobotView addSubview:iconImageView];
        [_addRobotView addSubview:titleLabel];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.leading.equalTo(@6);
           make.width.height.equalTo(@16);
           make.centerY.equalTo(_addRobotView);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(iconImageView.mas_trailing).offset(8);
            make.width.height.equalTo(@16);
            make.centerY.equalTo(_addRobotView);
            make.trailing.equalTo(@-8);
        }];
    }
    return _addRobotView;
}

- (UILabel *)leftUserNameLabel {
    if (!_leftUserNameLabel) {
        _leftUserNameLabel = UILabel.new;
        _leftUserNameLabel.textAlignment = NSTextAlignmentCenter;
        _leftUserNameLabel.font = UIFONT_MEDIUM(14);
        _leftUserNameLabel.textColor = HEX_COLOR(@"#ffffff");
        _leftUserNameLabel.numberOfLines = 0;
    }
    return _leftUserNameLabel;
}

- (UILabel *)rightUserNameLabel {
    if (!_rightUserNameLabel) {
        _rightUserNameLabel = UILabel.new;
        _rightUserNameLabel.textAlignment = NSTextAlignmentCenter;
        _rightUserNameLabel.font = UIFONT_MEDIUM(14);
        _rightUserNameLabel.textColor = HEX_COLOR(@"#ffffff");
        _rightUserNameLabel.numberOfLines = 0;
    }
    return _rightUserNameLabel;
}

@end
