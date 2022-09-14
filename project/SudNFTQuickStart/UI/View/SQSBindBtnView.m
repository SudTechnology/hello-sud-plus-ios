//
// Created by kaniel on 2022/8/6.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SQSBindBtnView.h"

@interface SQSBindBtnView()
@property(nonatomic, strong) UIButton *clickBtn;
@end

@implementation SQSBindBtnView
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
        [self.iconImageView sd_setImageWithURL:[[NSURL alloc] initWithString:model.icon]];
    }
    CGFloat maxWidth = kScreenWidth - 40 - 32;
    CGRect rect = [model.name boundingRectWithSize:CGSizeMake(maxWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.nameLabel.font} context:nil];
    CGFloat labelW = ceil(rect.size.width);
    CGFloat left = (maxWidth - labelW - 28 - 16) / 2;
//    [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(@(left));
//    }];
//    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(labelW));
//    }];
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
        _clickBtn = [[UIButton alloc]init];
    }
    return _clickBtn;
}

@end
