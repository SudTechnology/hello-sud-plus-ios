//
// Created by kaniel on 2022/11/1.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GiftRocketEnterView.h"

@interface GiftRocketEnterView ()
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIImageView *rocketImageView;
@property(nonatomic, strong) UIView *enterView;
@property(nonatomic, strong) UILabel *enterLabel;
@property(nonatomic, strong) UIImageView *enterImageView;
@end

@implementation GiftRocketEnterView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.bgImageView];
    [self addSubview:self.rocketImageView];
    [self addSubview:self.enterView];
    [self.enterView addSubview:self.enterLabel];
    [self.enterView addSubview:self.enterImageView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.rocketImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.equalTo(@0);
        make.width.height.equalTo(@80);
    }];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(@0);
        make.height.equalTo(@60);
    }];
    [self.enterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-16);
        make.height.equalTo(@34);
        make.centerY.equalTo(self.bgImageView);
    }];
    [self.enterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.enterView);
    }];
    [self.enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-10);
        make.width.height.equalTo(@12);
        make.centerY.equalTo(self.enterView);
        make.leading.equalTo(self.enterLabel.mas_trailing);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.enterLabel.text = @"去定制";
    self.enterImageView.image = [[UIImage imageNamed:@"right_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.enterImageView.tintColor = UIColor.whiteColor;
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    GiftModel *giftModel = [GiftService.shared giftByID:kRocketGiftID];
    if (giftModel.giftURL) {
        [self.rocketImageView sd_setImageWithURL:giftModel.giftURL.dt_toURL];
    }
}

- (UIImageView *)rocketImageView {
    if (!_rocketImageView) {
        _rocketImageView = [[UIImageView alloc] init];
    }
    return _rocketImageView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"gift_rocket_bottom"];
    }
    return _bgImageView;
}

- (UIImageView *)enterImageView {
    if (!_enterImageView) {
        _enterImageView = [[UIImageView alloc] init];
    }
    return _enterImageView;
}

- (UIView *)enterView {
    if (!_enterView) {
        _enterView = [[UIView alloc] init];
        _enterView.layer.borderColor = HEX_COLOR(@"#B8F9FB").CGColor;
        _enterView.layer.borderWidth = 2;
        [_enterView dt_cornerRadius:17];
    }
    return _enterView;
}

- (UILabel *)enterLabel {
    if (!_enterLabel) {
        _enterLabel = [[UILabel alloc] init];
        _enterLabel.text = @"";
        _enterLabel.textColor = UIColor.whiteColor;
        _enterLabel.font = UIFONT_SEMI_BOLD(14);
    }
    return _enterLabel;
}

@end