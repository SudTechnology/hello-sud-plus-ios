//
//  QuickSendColCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/10.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "QuickSendColCell.h"

@interface QuickSendColCell()
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UIView *awardBackgroundView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UIButton *enterBtn;
@end

@implementation QuickSendColCell
- (void)dtAddViews {

    [super dtAddViews];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.awardBackgroundView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.enterBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(@0);
        make.height.equalTo(@100);
    }];
    [self.awardBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@8);
        make.centerY.equalTo(self.iconImageView);
        make.height.equalTo(@40);
        make.width.greaterThanOrEqualTo(@0);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];

}

- (void)dtUpdateUI {
    [super dtUpdateUI];

}

- (void)dtConfigEvents {
    [super dtConfigEvents];

}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}

- (UIView *)awardBackgroundView {
    if (!_awardBackgroundView) {
        _awardBackgroundView = [[UIView alloc] init];
        _awardBackgroundView.backgroundColor = HEX_COLOR(@"#FF711A");
        [_awardBackgroundView dt_cornerRadius:8];
    }
    return _awardBackgroundView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"UMO";
        _nameLabel.font = UIFONT_MEDIUM(14);
        _nameLabel.textColor = HEX_COLOR(@"#000000");
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
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
