//
//  GuessResultTableViewCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SudNFTQsForeignWalletSelectCell.h"
#import "SudNFTQsCnEthereumChainsCellModel.h"

@interface SudNFTQsForeignWalletSelectCell ()
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *titleLabel;

@end

@implementation SudNFTQsForeignWalletSelectCell

- (void)dtAddViews {
    [super dtAddViews];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@114);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(7);
        make.centerY.equalTo(self);
        make.height.mas_greaterThanOrEqualTo(CGSizeZero);
        make.trailing.equalTo(@-16);
    }];


}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self dt_cornerRadius:24];
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
        _titleLabel.font = UIFONT_MEDIUM(14);
        _titleLabel.textColor = HEX_COLOR(@"#000000");
    }
    return _titleLabel;
}
@end
