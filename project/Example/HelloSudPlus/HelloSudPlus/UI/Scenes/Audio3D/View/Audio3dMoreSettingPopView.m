//
// Created by kaniel on 2023/8/3.
// Copyright (c) 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "Audio3dMoreSettingPopView.h"

@interface Audio3dMoreSettingPopView ()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *rotateBtn;
@property(nonatomic, strong) UIButton *lightBtn;
@property(nonatomic, strong) UIButton *voiceBtn;
@property(nonatomic, strong) UILabel *rotateLabel;
@property(nonatomic, strong) UILabel *lightLabel;
@property(nonatomic, strong) UILabel *voiceLabel;

@property(nonatomic, strong) DTPaddingLabel *rotateStateLabel;
@property(nonatomic, strong) DTPaddingLabel *lightStateLabel;
@property(nonatomic, strong) DTPaddingLabel *voiceStateLabel;
@property(nonatomic, assign) BOOL isRotateStateOpen;
@property(nonatomic, assign) BOOL isLightStateOpen;
@property(nonatomic, assign) BOOL isVoiceStateOpen;
@end

@implementation Audio3dMoreSettingPopView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.titleLabel];
    [self addSubview:self.rotateBtn];
    [self addSubview:self.lightBtn];
    [self addSubview:self.voiceBtn];

    [self addSubview:self.rotateStateLabel];
    [self addSubview:self.lightStateLabel];
    [self addSubview:self.voiceStateLabel];

    [self addSubview:self.rotateLabel];
    [self addSubview:self.lightLabel];
    [self addSubview:self.voiceLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    self.backgroundColor = HEX_COLOR(@"#F5F6FB");
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@25);
        make.leading.equalTo(@16);
        make.width.height.greaterThanOrEqualTo(@0);
    }];

    [self.rotateStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@12);
        make.width.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.rotateBtn.mas_bottom);
        make.centerX.equalTo(self.rotateBtn);
    }];
    [self.rotateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@12);
        make.width.greaterThanOrEqualTo(@0);
        make.centerX.equalTo(self.rotateBtn);
        make.top.equalTo(self.rotateStateLabel.mas_bottom).offset(12);
    }];
    [self.lightStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@12);
        make.width.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.lightBtn.mas_bottom);
        make.centerX.equalTo(self.lightBtn);
    }];
    [self.lightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@12);
        make.width.greaterThanOrEqualTo(@0);
        make.centerX.equalTo(self.lightBtn);
        make.top.equalTo(self.lightStateLabel.mas_bottom).offset(12);
    }];
    [self.voiceStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@12);
        make.width.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.voiceBtn.mas_bottom);
        make.centerX.equalTo(self.voiceBtn);
    }];
    [self.voiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@12);
        make.width.greaterThanOrEqualTo(@0);
        make.centerX.equalTo(self.voiceBtn);
        make.top.equalTo(self.voiceStateLabel.mas_bottom).offset(12);
    }];

    NSArray *arr = @[self.rotateBtn, self.lightBtn, self.voiceBtn];
    [arr dt_mas_distributeSudokuViewsWithFixedItemWidth:56 fixedItemHeight:56 fixedLineSpacing:0 fixedInteritemSpacing:0 warpCount:3 topSpacing:76 bottomSpacing:92 leadSpacing:0 tailSpacing:0];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    [self.rotateBtn dt_onClick:^(UIButton *sender) {
        sender.selected = !sender.selected;
        if (weakSelf.rotateChangedBlock) {
            weakSelf.rotateChangedBlock(sender.selected);
        }
    }];
    [self.lightBtn dt_onClick:^(UIButton *sender) {
        sender.selected = !sender.selected;
        if (weakSelf.lightChangedBlock) {
            weakSelf.lightChangedBlock(sender.selected);
        }
    }];
    [self.voiceBtn dt_onClick:^(UIButton *sender) {
        sender.selected = !sender.selected;
        if (weakSelf.voiceChangedBlock) {
            weakSelf.voiceChangedBlock(sender.selected);
        }
    }];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];

    self.rotateBtn.selected = self.isRotateStateOpen;
    self.lightBtn.selected = self.isLightStateOpen;
    self.voiceBtn.selected = self.isVoiceStateOpen;
    if (self.isRotateStateOpen) {
        self.rotateStateLabel.backgroundColor = HEX_COLOR(@"#6CA545");
        self.rotateStateLabel.text = @"dt_audio3d_setting_state_open".dt_lan;
    } else {
        self.rotateStateLabel.backgroundColor = HEX_COLOR(@"#F55050");
        self.rotateStateLabel.text = @"dt_audio3d_setting_state_close".dt_lan;
    }
    if (self.isLightStateOpen) {
        self.lightStateLabel.backgroundColor = HEX_COLOR(@"#6CA545");
        self.lightStateLabel.text = @"dt_audio3d_setting_state_open".dt_lan;
    } else {
        self.lightStateLabel.backgroundColor = HEX_COLOR(@"#F55050");
        self.lightStateLabel.text = @"dt_audio3d_setting_state_close".dt_lan;
    }
    if (self.isVoiceStateOpen) {
        self.voiceStateLabel.backgroundColor = HEX_COLOR(@"#6CA545");
        self.voiceStateLabel.text = @"dt_audio3d_setting_state_open".dt_lan;
    } else {
        self.voiceStateLabel.backgroundColor = HEX_COLOR(@"#F55050");
        self.voiceStateLabel.text = @"dt_audio3d_setting_state_close".dt_lan;
    }
}

- (void)updateConfig:(Audio3dConfigStateModel *)configStateModel {
    self.isVoiceStateOpen = configStateModel.isVoiceStateOpen;
    self.isRotateStateOpen = configStateModel.isRotateStateOpen;
    self.isLightStateOpen = configStateModel.isLightStateOpen;
    [self dtUpdateUI];
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"dt_audio3d_more_title".dt_lan;
        _titleLabel.font = UIFONT_HEAVY(18);
        _titleLabel.textColor = HEX_COLOR(@"#000000");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)rotateBtn {
    if (!_rotateBtn) {
        _rotateBtn = [[UIButton alloc] init];
        [_rotateBtn setImage:[UIImage imageNamed:@"audio3d_rotate_off"] forState:UIControlStateNormal];
        [_rotateBtn setImage:[UIImage imageNamed:@"audio3d_rotate"] forState:UIControlStateSelected];
    }
    return _rotateBtn;
}

- (UIButton *)lightBtn {
    if (!_lightBtn) {
        _lightBtn = [[UIButton alloc] init];
        [_lightBtn setImage:[UIImage imageNamed:@"audio3d_light_off"] forState:UIControlStateNormal];
        [_lightBtn setImage:[UIImage imageNamed:@"audio3d_light"] forState:UIControlStateSelected];
    }
    return _lightBtn;
}

- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [[UIButton alloc] init];
        [_voiceBtn setImage:[UIImage imageNamed:@"audio3d_voice_off"] forState:UIControlStateNormal];
        [_voiceBtn setImage:[UIImage imageNamed:@"audio3d_voice"] forState:UIControlStateSelected];
    }
    return _voiceBtn;
}

- (UILabel *)rotateLabel {
    if (!_rotateLabel) {
        _rotateLabel = [[UILabel alloc] init];
        _rotateLabel.text = @"dt_audio3d_rotate_title".dt_lan;
        _rotateLabel.font = UIFONT_BOLD(12);
        _rotateLabel.textColor = HEX_COLOR(@"#000000");
        _rotateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rotateLabel;
}

- (UILabel *)lightLabel {
    if (!_lightLabel) {
        _lightLabel = [[UILabel alloc] init];
        _lightLabel.text = @"dt_audio3d_light_title".dt_lan;
        _lightLabel.font = UIFONT_BOLD(12);
        _lightLabel.textColor = HEX_COLOR(@"#000000");
        _lightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _lightLabel;
}

- (UILabel *)voiceLabel {
    if (!_voiceLabel) {
        _voiceLabel = [[UILabel alloc] init];
        _voiceLabel.text = @"dt_audio3d_voice_title".dt_lan;
        _voiceLabel.font = UIFONT_BOLD(12);
        _voiceLabel.textColor = HEX_COLOR(@"#000000");
        _voiceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _voiceLabel;
}

- (DTPaddingLabel *)rotateStateLabel {
    if (!_rotateStateLabel) {
        _rotateStateLabel = [[DTPaddingLabel alloc] init];
        _rotateStateLabel.font = UIFONT_BOLD(10);
        _rotateStateLabel.textColor = HEX_COLOR(@"#ffffff");
        _rotateStateLabel.textAlignment = NSTextAlignmentCenter;
        _rotateStateLabel.paddingX = 6;
        [_rotateStateLabel dt_cornerRadius:6];
    }
    return _rotateStateLabel;
}

- (DTPaddingLabel *)lightStateLabel {
    if (!_lightStateLabel) {
        _lightStateLabel = [[DTPaddingLabel alloc] init];
        _lightStateLabel.font = UIFONT_BOLD(10);
        _lightStateLabel.textColor = HEX_COLOR(@"#ffffff");
        _lightStateLabel.textAlignment = NSTextAlignmentCenter;
        _lightStateLabel.paddingX = 6;
        [_lightStateLabel dt_cornerRadius:6];
    }
    return _lightStateLabel;
}

- (DTPaddingLabel *)voiceStateLabel {
    if (!_voiceStateLabel) {
        _voiceStateLabel = [[DTPaddingLabel alloc] init];
        _voiceStateLabel.font = UIFONT_BOLD(10);
        _voiceStateLabel.textColor = HEX_COLOR(@"#ffffff");
        _voiceStateLabel.textAlignment = NSTextAlignmentCenter;
        _voiceStateLabel.paddingX = 6;
        [_voiceStateLabel dt_cornerRadius:6];
    }
    return _voiceStateLabel;
}

@end