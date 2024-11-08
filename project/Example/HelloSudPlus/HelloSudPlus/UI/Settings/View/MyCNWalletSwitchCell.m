//
//  GuessResultTableViewCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "MyCNWalletSwitchCell.h"
#import "MyCNWalletSwitchCellModel.h"

@interface MyCNWalletSwitchCell ()
@property(nonatomic, strong) UIView *topLineView;
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UIImageView *markImageView;
@property(nonatomic, strong) UILabel *titleLabel;

@end

@implementation MyCNWalletSwitchCell

- (void)dtAddViews {
    [super dtAddViews];
    [self.contentView addSubview:self.topLineView];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.markImageView];
    [self.contentView addSubview:self.titleLabel];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@20);
        make.width.height.equalTo(@24);
        make.centerY.equalTo(self.contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(10);
        make.width.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.contentView);
    }];
    [self.markImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-14);
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.contentView);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = UIColor.clearColor;
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (![self.model isKindOfClass:MyCNWalletSwitchCellModel.class]) {
        return;
    }
    MyCNWalletSwitchCellModel *m = (MyCNWalletSwitchCellModel *) self.model;
    self.markImageView.hidden = m.isSelected ? NO : YES;
    self.titleLabel.text = m.walletInfoModel.name;
    if (m.walletInfoModel.icon) {
        [self.iconImageView sd_setImageWithURL:[[NSURL alloc] initWithString:m.walletInfoModel.icon]];
    }
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = UIView.new;
        _topLineView.backgroundColor = HEX_COLOR(@"#D1D1D1");
    }
    return _topLineView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}

- (UIImageView *)markImageView {
    if (!_markImageView) {
        _markImageView = [[UIImageView alloc] init];
        _markImageView.contentMode = UIViewContentModeScaleAspectFill;
        _markImageView.clipsToBounds = YES;
        _markImageView.image = [UIImage imageNamed:@"my_ethereum_chains_selected"];
    }
    return _markImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = UIFONT_REGULAR(14);
        _titleLabel.textColor = HEX_COLOR(@"#1A1A1A");
    }
    return _titleLabel;
}
@end
