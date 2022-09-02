//
// Created by kaniel on 2022/7/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SudNFTQsSelectEtherChainsView.h"
#import "SudNFTQsNFTListViewController.h"
#import "UIImageView+AFNetworking.h"

@interface SudNFTQsSelectEtherChainsView ()
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UIButton *clickBtn;
@end

@implementation SudNFTQsSelectEtherChainsView

- (void)dtConfigUI {
}

- (void)dtAddViews {
    [self addSubview:self.nameLabel];
    [self addSubview:self.iconImageView];
    [self addSubview:self.clickBtn];
}

- (void)dtLayoutViews {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@12);
        make.centerY.equalTo(self);
        make.leading.equalTo(@20);

    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(4);
        make.top.equalTo(@6);
        make.width.equalTo(@135);
        make.height.equalTo(@17);
        make.bottom.equalTo(@-7);
    }];

    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)dtUpdateUI {

}


- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.clickBtn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickBtn:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)update:(SudNFTChainInfoModel *)model {
    self.nameLabel.text = model.name;
    if (model.icon) {
        [self.iconImageView sd_setImageWithURL:[[NSURL alloc] initWithString:model.icon]];
    }
    CGRect rect = [model.name boundingRectWithSize:CGSizeMake(190 - 16, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.nameLabel.font} context:nil];
    CGFloat labelW = ceil(rect.size.width);
    CGFloat left = (190 - labelW - 16) / 2;
    [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@(left));
    }];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(labelW));
    }];
}

/// 通过钱包更新
- (void)updateWithWalletInfoModel:(SudNFTWalletInfoModel *)model {
    self.nameLabel.text = model.name;
    if (model.icon) {
        [self.iconImageView sd_setImageWithURL:[[NSURL alloc] initWithString:model.icon]];
    }
    CGRect rect = [model.name boundingRectWithSize:CGSizeMake(190 - 16, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.nameLabel.font} context:nil];
    CGFloat labelW = ceil(rect.size.width);
    CGFloat left = (190 - labelW - 16) / 2;
    [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@16);
        make.leading.equalTo(@(left));
    }];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(labelW));
    }];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textColor = HEX_COLOR(@"#ffffff");
        _nameLabel.font = UIFONT_REGULAR(12);
    }
    return _nameLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UIButton *)clickBtn {
    if (!_clickBtn) {
        _clickBtn = [[UIButton alloc] init];
    }
    return _clickBtn;
}
@end
