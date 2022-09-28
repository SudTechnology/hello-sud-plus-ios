//
// Created by kaniel on 2022/8/6.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BindBtnView.h"

@interface BindBtnView ()
@property(nonatomic, strong) UIButton *clickBtn;
@end

@implementation BindBtnView
- (void)dtAddViews {
    [self addSubview:self.iconImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.clickBtn];
}

- (void)dtLayoutViews {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@102);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(8);
        make.centerY.equalTo(self);
        make.height.mas_greaterThanOrEqualTo(CGSizeZero);
        make.trailing.equalTo(@-16);
    }];
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}


- (void)update:(SudNFTWalletInfoModel *)model {
    self.model = model;
    self.nameLabel.text = model.name;
    if (model.icon) {
        self.iconImageView.hidden = NO;
        [self.iconImageView sd_setImageWithURL:[[NSURL alloc] initWithString:model.icon]];
        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@102);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImageView.mas_trailing).offset(8);
            make.centerY.equalTo(self);
            make.height.mas_greaterThanOrEqualTo(CGSizeZero);
            make.trailing.equalTo(@-16);
        }];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        self.iconImageView.hidden = YES;
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@16);
            make.centerY.equalTo(self);
            make.height.mas_greaterThanOrEqualTo(CGSizeZero);
            make.trailing.equalTo(@-16);
        }];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
    }

}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.clickBtn addTarget:self action:@selector(onTap:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTap:(id)tap {
    if (self.clickWalletBlock) {
        self.clickWalletBlock(self.model);
    }
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.clipsToBounds = true;
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.numberOfLines = 1;
        _nameLabel.textColor = HEX_COLOR(@"#ffffff");
        _nameLabel.font = UIFONT_MEDIUM(14);
    }
    return _nameLabel;
}

- (UIButton *)clickBtn {
    if (!_clickBtn) {
        _clickBtn = [[UIButton alloc] init];
    }
    return _clickBtn;
}

@end
