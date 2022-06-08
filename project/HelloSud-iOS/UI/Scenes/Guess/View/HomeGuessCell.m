//
// Created by kaniel on 2022/6/6.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HomeGuessCell.h"

@interface HomeGuessCell ()
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UIView *awardBackgroundView;
@property(nonatomic, strong) YYLabel *awardLabel;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) YYLabel *infoLabel;
@property(nonatomic, strong) UIButton *enterBtn;
@end

@implementation HomeGuessCell

- (void)dtAddViews {

    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.awardBackgroundView];
    [self.awardBackgroundView addSubview:self.awardLabel];
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
    [self.awardBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@8);
        make.centerY.equalTo(self.iconImageView);
        make.height.equalTo(@40);
        make.width.greaterThanOrEqualTo(@0);
    }];
    [self.awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@10);
        make.trailing.equalTo(@-18);
        make.centerY.equalTo(self.awardBackgroundView);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(0);
        make.height.equalTo(@40);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@10);
        make.trailing.equalTo(@-10);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(0);
    }];
    [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@10);
        make.trailing.equalTo(@(-10));
        make.top.equalTo(self.infoLabel.mas_bottom).offset(12);
        make.height.equalTo(@44);
        make.bottom.equalTo(@-14);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = HEX_COLOR_A(@"#000000", 0.1).CGColor;
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    HSGameItem *m = self.model;
    if (![m isKindOfClass:[HSGameItem class]]) {
        return;
    }
    if (m.homeGamePic) {
        [self.iconImageView sd_setImageWithURL:[[NSURL alloc] initWithString:m.homeGamePic]];
    }
    self.nameLabel.text = m.gameName;
    [self updateInfoLabel];
}

/// 更新文案信息
- (void)updateInfoLabel {

    NSMutableAttributedString *full = [[NSMutableAttributedString alloc] initWithString:@"剩余 "];
    full.yy_lineSpacing = 6;
    full.yy_font = UIFONT_REGULAR(12);
    full.yy_color = HEX_COLOR(@"#666666");
    full.yy_firstLineHeadIndent = 10;
    full.yy_headIndent = 10;

    NSMutableAttributedString *attTime = [[NSMutableAttributedString alloc] initWithString:@"10:23:55"];
    attTime.yy_font = UIFONT_REGULAR(12);
    attTime.yy_color = HEX_COLOR(@"#000000");
    [full appendAttributedString:attTime];

    NSMutableAttributedString *attPersonTitle = [[NSMutableAttributedString alloc] initWithString:@"\n参与人数上限 "];
    attPersonTitle.yy_lineSpacing = 6;
    attPersonTitle.yy_firstLineHeadIndent = 10;
    attPersonTitle.yy_headIndent = 10;
    attPersonTitle.yy_font = UIFONT_REGULAR(12);
    attPersonTitle.yy_color = HEX_COLOR(@"#666666");
    [full appendAttributedString:attPersonTitle];

    NSMutableAttributedString *attPersonValue = [[NSMutableAttributedString alloc] initWithString:@"∞"];
    attPersonValue.yy_font = UIFONT_REGULAR(12);
    attPersonValue.yy_color = HEX_COLOR(@"#000000");
    [full appendAttributedString:attPersonValue];

    NSMutableAttributedString *enterTitle = [[NSMutableAttributedString alloc] initWithString:@"\n入场 "];
    enterTitle.yy_firstLineHeadIndent = 10;
    enterTitle.yy_headIndent = 10;
    enterTitle.yy_font = UIFONT_REGULAR(12);
    enterTitle.yy_color = HEX_COLOR(@"#666666");
    [full appendAttributedString:enterTitle];

    NSMutableAttributedString *enterTitleValue = [[NSMutableAttributedString alloc] initWithString:@"免费"];
    enterTitleValue.yy_font = UIFONT_REGULAR(12);
    enterTitleValue.yy_color = HEX_COLOR(@"#000000");
    [full appendAttributedString:enterTitleValue];

    _infoLabel.attributedText = full;
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

- (YYLabel *)awardLabel {
    if (!_awardLabel) {
        _awardLabel = [[YYLabel alloc] init];

        NSMutableAttributedString *full = [[NSMutableAttributedString alloc] initWithString:@"奖励 "];
        full.yy_font = UIFONT_MEDIUM(14);
        full.yy_color = HEX_COLOR(@"#ffffff");

        UIImage *iconImage = [UIImage imageNamed:@"guess_award_coin"];
        NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(18, 18) alignToFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
        [full appendAttributedString:attrIcon];

        NSMutableAttributedString *attrAwardValue = [[NSMutableAttributedString alloc] initWithString:@" 1000"];
        attrAwardValue.yy_font = UIFONT_MEDIUM(16);
        attrAwardValue.yy_color = HEX_COLOR(@"#FFFF22");
        [full appendAttributedString:attrAwardValue];

        _awardLabel.attributedText = full;
    }
    return _awardLabel;
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

- (YYLabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[YYLabel alloc] init];
        _infoLabel.text = @"剩余：00000\n参与人数上限：xxx\n入场 免费";
        _infoLabel.font = UIFONT_REGULAR(12);
        _infoLabel.textColor = HEX_COLOR(@"#666666");
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
