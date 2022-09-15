//
//  GuessResultTableViewCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "CNWalletSelectCell.h"

@interface CNWalletSelectCell ()
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subTitleLabel;
@property(nonatomic, strong) UIButton *bindBtn;
@end

@implementation CNWalletSelectCell

- (void)dtAddViews {
    [super dtAddViews];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.bindBtn];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.iconImageView dt_cornerRadius:7];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@12);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(10);
        make.top.equalTo(self.iconImageView).offset(2);
        make.height.mas_greaterThanOrEqualTo(CGSizeZero);
        make.trailing.equalTo(self.bindBtn.mas_leading);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
        make.height.mas_greaterThanOrEqualTo(CGSizeZero);
        make.trailing.equalTo(self.bindBtn.mas_leading);
    }];
    [self.bindBtn setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-16);
        make.height.equalTo(@24);
        make.width.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.contentView);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.contentView.backgroundColor = UIColor.whiteColor;
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (![self.model isKindOfClass:SudNFTWalletInfoModel.class]) {
        return;
    }
    SudNFTWalletInfoModel *m = (SudNFTWalletInfoModel *) self.model;
    self.titleLabel.text = m.name;
    if (m.icon) {
        [self.iconImageView sd_setImageWithURL:[[NSURL alloc] initWithString:m.icon]];
    }
    BOOL isBind = [HsNFTPreferences.shared getBindUserTokenByWalletType:m.type].length > 0;
    NSString *phone = [HsNFTPreferences.shared getBindUserPhoneByWalletType:m.type];
    if (isBind) {
        self.bindBtn.selected = YES;
        self.bindBtn.layer.borderColor = UIColor.blackColor.CGColor;
        self.bindBtn.layer.borderWidth = 1;
        self.subTitleLabel.text = [NSString stringWithFormat:@"已绑定：%@", phone];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImageView.mas_trailing).offset(10);
            make.top.equalTo(self.iconImageView).offset(2);
            make.height.mas_greaterThanOrEqualTo(CGSizeZero);
            make.trailing.equalTo(self.bindBtn.mas_leading);
        }];
    } else {
        self.bindBtn.selected = NO;
        self.bindBtn.layer.borderColor = nil;
        self.bindBtn.layer.borderWidth = 0;
        self.subTitleLabel.text = nil;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImageView.mas_trailing).offset(10);
            make.centerY.equalTo(self.contentView);
            make.height.mas_greaterThanOrEqualTo(CGSizeZero);
            make.trailing.equalTo(self.bindBtn.mas_leading);
        }];
    }
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.bindBtn addTarget:self action:@selector(onBindBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onBindBtnClick:(id)sender {
    if (self.selectedWalletBlock) {
        self.selectedWalletBlock(self.model);
    }
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = UIFONT_MEDIUM(16);
        _titleLabel.textColor = HEX_COLOR(@"#1A1A1A");
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.font = UIFONT_REGULAR(12);
        _subTitleLabel.textColor = HEX_COLOR(@"#666666");
    }
    return _subTitleLabel;
}

- (UIButton *)bindBtn {
    if (!_bindBtn) {
        _bindBtn = UIButton.new;
        _bindBtn.titleLabel.font = UIFONT_MEDIUM(12);
        [_bindBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        [_bindBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
        [_bindBtn setBackgroundImage:UIColor.blackColor.dt_toImage forState:UIControlStateNormal];

        [_bindBtn setTitleColor:UIColor.blackColor forState:UIControlStateSelected];
        [_bindBtn setTitle:@"解绑" forState:UIControlStateSelected];
        [_bindBtn setBackgroundImage:UIColor.whiteColor.dt_toImage forState:UIControlStateSelected];
    }
    return _bindBtn;
}

@end
