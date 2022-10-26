//
// Created by kaniel on 2022/10/25.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "UpgradeAlertView.h"

@interface UpgradeAlertView ()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIScrollView *detailScrollView;
@property(nonatomic, strong) UILabel *detailLabel;
@property(nonatomic, strong) UIButton *sureBtn;
@property(nonatomic, strong) UIButton *cancelBtn;
@end

@implementation UpgradeAlertView

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content upgradeType:(NSInteger)upgradeType {
    if (self = [super initWithFrame:CGRectZero]) {
        self.titleLabel.text = title;
        self.detailLabel.text = content;
        [self resetButtonsWithType:upgradeType];
        [self dtUpdateUI];
    }
    return self;
}

- (void)dtAddViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailScrollView];
    [self.detailScrollView addSubview:self.detailLabel];
    [self addSubview:self.sureBtn];
    [self addSubview:self.cancelBtn];
}

- (void)dtLayoutViews {

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@24);
        make.leading.equalTo(@24);
        make.trailing.equalTo(@-24);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.detailScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.leading.trailing.equalTo(self.titleLabel);
        make.height.equalTo(@92);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.top.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
        make.bottom.equalTo(@0);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailScrollView.mas_bottom).offset(25);
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

- (void)resetButtonsWithType:(NSInteger)upgradeType {
    if (upgradeType == 1) {
        // 强制
        [self.sureBtn setTitle:NSString.dt_update_now forState:UIControlStateNormal];
        [self.sureBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cancelBtn);
            make.centerX.equalTo(self);
            make.height.mas_equalTo(36);
            make.width.mas_greaterThanOrEqualTo(140);
        }];
        self.cancelBtn.hidden = YES;
    } else if (upgradeType == 2) {
        [self.sureBtn setTitle:NSString.dt_update_now forState:UIControlStateNormal];
        [self.cancelBtn setTitle:NSString.dt_next_time_again_say forState:UIControlStateNormal];
    }
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.titleLabel.text = @"您的APP版本比较低，请先升级";
    self.detailLabel.text = @"更新内容更新内容更新内容";
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    [self resetDetailScrollView];
}

- (void)resetDetailScrollView {
    CGFloat w = 296 - 48;
    self.detailLabel.preferredMaxLayoutWidth = w;
    CGSize size = [self.detailLabel sizeThatFits:CGSizeMake(w, 10000000)];
    CGFloat h = size.height;
    if (h > 92) {
        h = 92;
    }
    [self.detailScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(h));
    }];
    [self.detailScrollView layoutIfNeeded];
    CGFloat height = self.detailLabel.bounds.size.height;
    self.detailScrollView.contentSize = CGSizeMake(w, height);
}

- (void)onSureBtnCLick:(id)sender {
    if (self.sureBlock) self.sureBlock();
}

- (void)onCancelBtnCLick:(id)sender {
    if (self.cancelBlock) self.cancelBlock();
}

- (UIScrollView *)detailScrollView {
    if (!_detailScrollView) {
        _detailScrollView = UIScrollView.new;
        _detailScrollView.bounces = YES;
    }
    return _detailScrollView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.font = UIFONT_MEDIUM(16);
        _titleLabel.textColor = HEX_COLOR(@"#1A1A1A");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = UILabel.new;
        _detailLabel.font = UIFONT_REGULAR(12);
        _detailLabel.textColor = HEX_COLOR(@"#1A1A1A");
        _detailLabel.numberOfLines = 0;
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
