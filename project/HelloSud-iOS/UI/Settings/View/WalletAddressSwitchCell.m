//
//  GuessResultTableViewCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "WalletAddressSwitchCell.h"
#import "WalletAddressSwitchCellModel.h"

@interface WalletAddressSwitchCell ()
@property(nonatomic, strong) UILabel *typeLabel;
@property(nonatomic, strong) UIImageView *markImageView;
@property(nonatomic, strong) UILabel *titleLabel;

@end

@implementation WalletAddressSwitchCell

- (void)dtAddViews {
    [super dtAddViews];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.markImageView];
    [self.contentView addSubview:self.titleLabel];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@19);
        make.top.equalTo(@8);
        make.width.equalTo(@156);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.width.height.greaterThanOrEqualTo(@0);
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
    if (![self.model isKindOfClass:WalletAddressSwitchCellModel.class]) {
        return;
    }
    WalletAddressSwitchCellModel *m = (WalletAddressSwitchCellModel *) self.model;
    self.markImageView.hidden = m.isSelected ? NO : YES;
    self.titleLabel.text = m.walletAddress;
    self.typeLabel.text = m.walletModel.name;

}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textAlignment = NSTextAlignmentLeft;

        _typeLabel.font = UIFONT_REGULAR(14);
        _typeLabel.textColor = HEX_COLOR(@"#8A8A8E");
    }
    return _typeLabel;
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
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _titleLabel;
}
@end
