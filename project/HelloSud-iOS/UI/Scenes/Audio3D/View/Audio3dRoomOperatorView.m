//
//  RoomOperatorView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "Audio3dRoomOperatorView.h"
#import "RoomGiftPannelView.h"

@interface Audio3dRoomOperatorView ()
@property(nonatomic, strong) UIButton *audio3dGiftBtn;
@property(nonatomic, strong) UIButton *audio3dFaceBtn;
@property(nonatomic, strong) UIButton *audio3dMoreBtn;
@property (nonatomic, assign)BOOL isAudio3dStyle;
@end

@implementation Audio3dRoomOperatorView


- (void)dtAddViews {
    [super dtAddViews];

    [self addSubview:self.audio3dGiftBtn];
    [self addSubview:self.audio3dFaceBtn];
    [self addSubview:self.audio3dMoreBtn];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    self.giftBtn.hidden = YES;
    [self.inputLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.voiceUpBtn.mas_trailing).offset(12);
        make.trailing.mas_equalTo(self.audio3dFaceBtn.mas_leading).offset(-12);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(32);
    }];

    [self.audio3dFaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.audio3dGiftBtn.mas_leading).offset(-4);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.audio3dGiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.audio3dMoreBtn.mas_leading).offset(-4);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.audio3dMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-13);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
}

- (void)dtConfigUI {
    [super dtUpdateUI];
    self.isAudio3dStyle = YES;
}

- (void)dtUpdateUI {
    [super dtUpdateUI];

}


- (UIButton *)audio3dGiftBtn {
    if (!_audio3dGiftBtn) {
        _audio3dGiftBtn = [[UIButton alloc] init];
        [_audio3dGiftBtn setImage:[UIImage imageNamed:@"room_ope_gift"] forState:UIControlStateNormal];
        [_audio3dGiftBtn setImage:[UIImage imageNamed:@"audio3d_gift"] forState:UIControlStateSelected];
        [_audio3dGiftBtn addTarget:self action:@selector(onAudio3dGiftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _audio3dGiftBtn;
}

- (UIButton *)audio3dMoreBtn {
    if (!_audio3dMoreBtn) {
        _audio3dMoreBtn = [[UIButton alloc] init];
        [_audio3dMoreBtn setImage:[UIImage imageNamed:@"audio3d_more_default"] forState:UIControlStateNormal];
        [_audio3dMoreBtn setImage:[UIImage imageNamed:@"audio3d_more"] forState:UIControlStateSelected];

        [_audio3dMoreBtn addTarget:self action:@selector(onAudio3dMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _audio3dMoreBtn;
}

- (UIButton *)audio3dFaceBtn {
    if (!_audio3dFaceBtn) {
        _audio3dFaceBtn = [[UIButton alloc] init];
        [_audio3dFaceBtn setImage:[UIImage imageNamed:@"audio3d_face_default"] forState:UIControlStateNormal];
        [_audio3dFaceBtn setImage:[UIImage imageNamed:@"audio3d_face"] forState:UIControlStateSelected];
        [_audio3dFaceBtn addTarget:self action:@selector(onAudio3dFaceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _audio3dFaceBtn;
}


- (void)onAudio3dGiftBtnClick:(UIButton *)sender {
    if (self.audio3dGiftTapBlock) self.audio3dGiftTapBlock(sender);
}

- (void)onAudio3dMoreBtnClick:(UIButton *)sender {
    if (self.audio3dGMoreTapBlock) self.audio3dGMoreTapBlock(sender);
}

- (void)onAudio3dFaceBtnClick:(UIButton *)sender {
    if (self.audio3dGFaceTapBlock) self.audio3dGFaceTapBlock(sender);
}

- (void)showTipSate:(BOOL)bShow {
    if (bShow) {
        self.audio3dFaceBtn.hidden = YES;
        self.audio3dMoreBtn.hidden = YES;
        self.audio3dGiftBtn.hidden = YES;
    } else {
        if (self.isAudio3dStyle) {
            self.audio3dFaceBtn.hidden = NO;
            self.audio3dMoreBtn.hidden = NO;
            self.audio3dGiftBtn.hidden = NO;
        }
    }
}

/// 是否展示3d样式,非游戏时恢复默认语聊房场景样式
- (void)showAudio3dStyle:(BOOL)bShow {
    self.isAudio3dStyle = bShow;
    if (bShow) {
        // 3d样式
        self.giftBtn.hidden = YES;
        self.audio3dFaceBtn.hidden = NO;
        self.audio3dMoreBtn.hidden = NO;
        self.audio3dGiftBtn.hidden = NO;
        [self.inputLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.voiceUpBtn.mas_trailing).offset(12);
            make.trailing.mas_equalTo(self.audio3dFaceBtn.mas_leading).offset(-12);
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(32);
        }];
    } else {
        // 普通语聊房样式
        self.giftBtn.hidden = NO;
        self.audio3dFaceBtn.hidden = YES;
        self.audio3dMoreBtn.hidden = YES;
        self.audio3dGiftBtn.hidden = YES;
        [self.inputLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.voiceUpBtn.mas_trailing).offset(12);
            make.trailing.mas_equalTo(self.giftBtn.mas_leading).offset(-12);
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(32);
            make.width.mas_greaterThanOrEqualTo(0);
        }];
    }
}
@end
