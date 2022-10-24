//
// Created by kaniel on 2022/10/21.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "ShowSendGiftView.h"

@interface ShowSendGiftView ()
@property(nonatomic, strong) UIImageView *giftImageView;
@property(nonatomic, strong) UILabel *coinLabel;
@property(nonatomic, strong) UILabel *detailLabel;
@property(nonatomic, strong) UIButton *sureBtn;
@property(nonatomic, strong) UIButton *cancelBtn;
@end

@implementation ShowSendGiftView
- (void)dtAddViews {
    [self addSubview:self.giftImageView];
    [self addSubview:self.coinLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.giftImageView];
    [self addSubview:self.sureBtn];
    [self addSubview:self.cancelBtn];
}

- (void)dtLayoutViews {

    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.centerX.equalTo(self);
        make.width.height.equalTo(@60);
    }];
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.giftImageView.mas_bottom);
        make.centerX.equalTo(self);
        make.height.equalTo(@20);
        make.width.greaterThanOrEqualTo(@0);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@10);
        make.trailing.equalTo(@-10);
        make.top.equalTo(self.coinLabel.mas_bottom).offset(8);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).offset(40);
        make.leading.mas_equalTo(24);
        make.height.mas_equalTo(36);
        make.width.mas_greaterThanOrEqualTo(0);
        make.bottom.mas_equalTo(-24);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cancelBtn);
        make.leading.mas_equalTo(self.cancelBtn.mas_trailing).offset(40);
        make.trailing.mas_equalTo(-24);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(self.cancelBtn.mas_width);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.coinLabel.text = @"520金币";
    self.detailLabel.text = @"是否送出邀请主播一起玩游戏？";
    self.giftImageView.image = [UIImage imageNamed:@"gift_heart"];
}

- (void)onSureBtnCLick:(id)sender {
    if (self.sureBlock) self.sureBlock();
}

- (void)onCancelBtnCLick:(id)sender {
    if (self.cancelBlock) self.cancelBlock();
}

- (UIImageView *)giftImageView {
    if (!_giftImageView) {
        _giftImageView = UIImageView.new;
    }
    return _giftImageView;
}

- (UILabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = UILabel.new;
        _coinLabel.font = UIFONT_MEDIUM(14);
        _coinLabel.textColor = HEX_COLOR(@"#F6A209");
        _coinLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _coinLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = UILabel.new;
        _detailLabel.font = UIFONT_MEDIUM(16);
        _detailLabel.textColor = HEX_COLOR(@"#1A1A1A");
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLabel;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:NSString.dt_common_sure forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _sureBtn.backgroundColor = UIColor.blackColor;
        [_sureBtn addTarget:self action:@selector(onSureBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:NSString.dt_common_cancel forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _cancelBtn.backgroundColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
        [_cancelBtn addTarget:self action:@selector(onCancelBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
@end