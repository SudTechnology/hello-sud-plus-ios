//
// Created by kaniel on 2022/6/6.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HomeGuessCell.h"

@interface HomeGuessCell ()
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) YYLabel *awardLabel;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *infoLabel;
@property(nonatomic, strong) UIButton *enterBtn;
@end

@implementation HomeGuessCell

- (void)dtAddViews {

    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.enterBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(@0);
        make.height.equalTo(@100);
    }];
    [self.awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@0);
        make.centerY.equalTo(self.iconImageView);
        make.height.equalTo(@40);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.leading.trailing.equalTo(@0);
       make.top.equalTo(self.iconImageView.mas_bottom).offset(0);
       make.height.equalTo(@40);
    }];
    [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@10);
        make.trailing.equalTo(@(-10));
        make.top.equalTo(self.iconImageView.mas_bottom).offset(0);
        make.height.equalTo(@44);
    }];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (YYLabel *)awardLabel {
    if (!_awardLabel) {
        _awardLabel = [[YYLabel alloc] init];
        _awardLabel.text = @"奖励10000";
        _awardLabel.font = UIFONT_REGULAR(16);
        _awardLabel.textColor = HEX_COLOR(@"#FFFF22");
        _awardLabel.backgroundColor = HEX_COLOR(@"#FF711A");
    }
    return _awardLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"UMO";
        _nameLabel.font = UIFONT_MEDIUM(14);
        _nameLabel.textColor = HEX_COLOR(@"#FFFF22");
    }
    return _nameLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.text = @"剩余：00000\n参与人数上限：xxx\n入场 免费";
        _infoLabel.font = UIFONT_REGULAR(12);
        _infoLabel.textColor = HEX_COLOR(@"#FFFF22");
        _infoLabel.numberOfLines = 0;
        _infoLabel.backgroundColor = HEX_COLOR(@"#F8F8F8");
    }
    return _infoLabel;
}

- (UIButton *)enterBtn {
    if (!_enterBtn) {
        _enterBtn = [[UIButton alloc] init];
        [_enterBtn setTitle:@"立即加入" forState:UIControlStateNormal];
        [_enterBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _enterBtn.titleLabel.font = UIFONT_REGULAR(16);
        _enterBtn.backgroundColor = UIColor.blackColor;
    }
    return _enterBtn;
}
@end