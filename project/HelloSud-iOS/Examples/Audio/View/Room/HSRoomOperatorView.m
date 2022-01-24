//
//  HSRoomOperatorView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSRoomOperatorView.h"

@interface HSRoomOperatorView ()
@property (nonatomic, strong) UIButton *voiceUpBtn;
@property (nonatomic, strong) UIButton *giftBtn;
@property (nonatomic, strong) UILabel *inputLabel;

@end

@implementation HSRoomOperatorView

- (void)hsAddViews {
    [self addSubview:self.voiceUpBtn];
    [self addSubview:self.giftBtn];
    [self addSubview:self.inputLabel];
    [self.voiceUpBtn hs_setGradientBackgroundWithColors:@[[UIColor colorWithHexString:@"#FFC243" alpha:1], [UIColor colorWithHexString:@"#F38D2E" alpha:1]] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
}

- (void)hsLayoutViews {
    [self.voiceUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(56, 30));
    }];
    [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    [self.inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.voiceUpBtn.mas_right).offset(12);
        make.right.mas_equalTo(self.giftBtn.mas_left).offset(-12);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(32);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
}

- (UIButton *)voiceUpBtn {
    if (!_voiceUpBtn) {
        _voiceUpBtn = [[UIButton alloc] init];
        [_voiceUpBtn setImage:[UIImage imageNamed:@"room_ope_voice"] forState:UIControlStateNormal];
        [_voiceUpBtn setTitle:@"上麦" forState:UIControlStateNormal];
        [_voiceUpBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] forState:UIControlStateNormal];
        _voiceUpBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _voiceUpBtn.backgroundColor = UIColor.darkGrayColor;
        _voiceUpBtn.layer.cornerRadius = 30/2;
        [_voiceUpBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    }
    return _voiceUpBtn;
}

- (UILabel *)inputLabel {
    if (!_inputLabel) {
        _inputLabel = [[UILabel alloc] init];
        _inputLabel.text = @"    聊一聊~";
        _inputLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.5];
        _inputLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _inputLabel.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.4];
        _inputLabel.layer.cornerRadius = 32/2;
        _inputLabel.layer.masksToBounds = true;
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

@end
