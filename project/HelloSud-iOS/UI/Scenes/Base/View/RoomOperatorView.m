//
//  RoomOperatorView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "RoomOperatorView.h"
#import "RoomGiftPannelView.h"

@interface RoomOperatorView ()


@end

@implementation RoomOperatorView


- (void)dtAddViews {
    [self addSubview:self.voiceUpBtn];
    [self addSubview:self.giftBtn];
    [self addSubview:self.inputLabel];
    self.voiceBtnState = VoiceBtnStateTypeNormal;
}

- (void)dtLayoutViews {
    [self.voiceUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(56, 30));
    }];
    [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    [self.inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.voiceUpBtn.mas_trailing).offset(12);
        make.trailing.mas_equalTo(self.giftBtn.mas_leading).offset(-12);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(32);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)dtConfigEvents {
    WeakSelf
    [[NSNotificationCenter defaultCenter]addObserverForName:NTF_MIC_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        RoomCmdUpMicModel *msgModel = note.userInfo[@"msgModel"];
        if ([msgModel isKindOfClass:RoomCmdUpMicModel.class] ) {
            // 操作麦位与当前符合
            if ([AppService.shared.login.loginUserInfo isMeByUserID: msgModel.sendUser.userID]) {
                if (msgModel.cmd == CMD_DOWN_MIC_NOTIFY) {
                    // 下麦
                    weakSelf.voiceBtnState = VoiceBtnStateTypeNormal;
                } else {
                    if (weakSelf.voiceBtnState == VoiceBtnStateTypeNormal) {
                        weakSelf.voiceBtnState = VoiceBtnStateTypeWaitOpen;
                    }
                }
                NSLog(@"NTF_MIC_CHANGED btn state:%@", @(weakSelf.voiceBtnState));
            }
        } else {
            [weakSelf dtUpdateUI];
        }
    }];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    BOOL isInMic = [kAudioRoomService.currentRoomVC isInMic];
    if (isInMic && self.voiceBtnState == VoiceBtnStateTypeNormal) {
        self.voiceBtnState = VoiceBtnStateTypeWaitOpen;
    }
}

- (void)setVoiceBtnState:(VoiceBtnStateType)voiceBtnState {
    _voiceBtnState = voiceBtnState;
    switch (voiceBtnState) {
        case VoiceBtnStateTypeUpMic:
            /// 与等待开启一致
        case VoiceBtnStateTypeWaitOpen:
            [_voiceUpBtn setImage:[UIImage imageNamed:@"room_voice_close_mic"] forState:UIControlStateNormal];
            [_voiceUpBtn setTitle:nil forState:UIControlStateNormal];
            _voiceUpBtn.backgroundColor = HEX_COLOR_A(@"#000000", 0.4);
            _voiceUpBtn.az_colors = nil;
            break;
        case VoiceBtnStateTypeOnVoice:
            [_voiceUpBtn setImage:[UIImage imageNamed:@"room_voice_open_mic"] forState:UIControlStateNormal];
            [_voiceUpBtn setTitle:nil forState:UIControlStateNormal];
            _voiceUpBtn.backgroundColor = HEX_COLOR_A(@"#000000", 0.4);
            _voiceUpBtn.az_colors = nil;
            break;
        default:
            _voiceUpBtn.backgroundColor = nil;
            [_voiceUpBtn setImage:[UIImage imageNamed:@"room_ope_voice"] forState:UIControlStateNormal];
            [_voiceUpBtn setTitle:NSString.dt_room_up_mic forState:UIControlStateNormal];
            [self.voiceUpBtn dt_setGradientBackgroundWithColors:@[[UIColor dt_colorWithHexString:@"#FFC243" alpha:1], [UIColor dt_colorWithHexString:@"#F38D2E" alpha:1]] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
            break;
    }
}

/// 是否隐藏上麦按钮
/// @param hidden
- (void)hiddenVoiceBtn:(BOOL)hidden {
    if (hidden) {
        self.voiceUpBtn.hidden = hidden;
        [self.inputLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(16);
        }];
    } else {
        self.voiceUpBtn.hidden = hidden;
        [self.inputLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.voiceUpBtn.mas_trailing).offset(12);
        }];
    }
}

- (UIButton *)voiceUpBtn {
    if (!_voiceUpBtn) {
        _voiceUpBtn = [[UIButton alloc] init];
        [_voiceUpBtn setImage:[UIImage imageNamed:@"room_ope_voice"] forState:UIControlStateNormal];
        [_voiceUpBtn setTitle:NSString.dt_room_up_mic forState:UIControlStateNormal];
        [_voiceUpBtn setTitleColor:[UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1] forState:UIControlStateNormal];
        _voiceUpBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _voiceUpBtn.backgroundColor = UIColor.darkGrayColor;
        _voiceUpBtn.layer.cornerRadius = 30/2;
        [_voiceUpBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
        [_voiceUpBtn addTarget:self action:@selector(onBtnVoice:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceUpBtn;
}

- (UILabel *)inputLabel {
    if (!_inputLabel) {
        _inputLabel = [[UILabel alloc] init];
        _inputLabel.text = [NSString stringWithFormat:@"    %@", NSString.dt_room_input_text];
        _inputLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:0.5];
        _inputLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _inputLabel.backgroundColor = [UIColor dt_colorWithHexString:@"#000000" alpha:0.4];
        _inputLabel.layer.cornerRadius = 32/2;
        _inputLabel.layer.masksToBounds = true;
        [_inputLabel setUserInteractionEnabled:true];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInputEvent:)];
        [_inputLabel addGestureRecognizer:tapGesture];
    }
    return _inputLabel;
}

- (UIButton *)giftBtn {
    if (!_giftBtn) {
        _giftBtn = [[UIButton alloc] init];
        [_giftBtn setImage:[UIImage imageNamed:@"room_ope_gift"] forState:UIControlStateNormal];
        [_giftBtn addTarget:self action:@selector(onBtnGift:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _giftBtn;
}

- (void)onBtnGift:(UIButton *)sender {
    if (self.giftTapBlock) self.giftTapBlock(sender);
}

- (void)onBtnVoice:(UIButton *)sender {
    if (self.voiceTapBlock) self.voiceTapBlock(sender);
}


- (void)resetAllSelectedUser {
    NSArray *arr = kAudioRoomService.currentRoomVC.dicMicModel.allValues;
    for (AudioRoomMicModel *m in arr) {
        m.isSelected = NO;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NTF_SEND_GIFT_USER_CHANGED object:nil];
}

- (void)tapInputEvent:(UITapGestureRecognizer *)gesture {
    if (self.inputTapBlock) {
        self.inputTapBlock(gesture);
    }
}
@end
