//
// Created by kaniel on 2022/6/6.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "MoreGuessTableViewCell.h"

@interface MoreGuessTableViewCell ()
@property(nonatomic, strong) UIView *customView;
@property(nonatomic, strong) UIView *awardBackgroundView;
@property(nonatomic, strong) YYLabel *awardLabel;
@property(nonatomic, strong) UIView *timeBackgroundView;
@property(nonatomic, strong) YYLabel *timeLabel;
@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *coinLabel;
@property(nonatomic, strong) UIButton *playBtn;
@end

@implementation MoreGuessTableViewCell

- (void)dtAddViews {
    [super dtAddViews];

    [self.contentView addSubview:self.customView];
    [self.customView addSubview:self.awardBackgroundView];
    [self.awardBackgroundView addSubview:self.awardLabel];

    [self.customView addSubview:self.timeBackgroundView];
    [self.timeBackgroundView addSubview:self.timeLabel];

    [self.customView addSubview:self.headImageView];
    [self.customView addSubview:self.nameLabel];
    [self.customView addSubview:self.coinLabel];
    [self.customView addSubview:self.playBtn];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.top.equalTo(@0);
        make.bottom.equalTo(@-10);
    }];

    [self.awardBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@-8);
        make.height.equalTo(@30);
        make.top.equalTo(@11);
    }];
    [self.awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@14);
        make.trailing.equalTo(@-7);
        make.centerY.equalTo(self.awardBackgroundView);
        make.height.equalTo(@30);
        make.width.greaterThanOrEqualTo(@0);
    }];
    [self.timeBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@8);
        make.height.equalTo(@24);
        make.top.equalTo(@14);
        make.width.greaterThanOrEqualTo(@0);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@6);
        make.trailing.equalTo(@-13);
        make.top.equalTo(self.timeBackgroundView);
        make.height.equalTo(self.timeBackgroundView);
        make.width.greaterThanOrEqualTo(@0);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@10);
        make.top.equalTo(self.awardBackgroundView.mas_bottom).offset(8);
        make.width.height.equalTo(@64);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headImageView.mas_trailing).offset(8);
        make.top.equalTo(self.headImageView).offset(7);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-10);
        make.bottom.equalTo(@-11);
        make.width.greaterThanOrEqualTo(@100);
        make.height.equalTo(@40);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = UIColor.clearColor;
}


- (UIView *)customView {
    if (!_customView) {
        _customView = [[UIView alloc] init];
        _customView.backgroundColor = HEX_COLOR(@"#FFFAEB");
        [_customView dt_cornerRadius:8];
    }
    return _customView;
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

- (UIView *)timeBackgroundView {
    if (!_timeBackgroundView) {
        _timeBackgroundView = [[UIView alloc] init];
        _timeBackgroundView.backgroundColor = HEX_COLOR(@"#FFFAEB");
        [_timeBackgroundView dt_cornerRadius:12];
        _timeBackgroundView.layer.borderWidth = 1;
        _timeBackgroundView.layer.borderColor = HEX_COLOR(@"#FFBF3A").CGColor;

    }
    return _timeBackgroundView;
}

- (YYLabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[YYLabel alloc] init];

        NSMutableAttributedString *full = [[NSMutableAttributedString alloc] init];

        UIImage *iconImage = [UIImage imageNamed:@"guess_time_icon"];
        NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(12, 12) alignToFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
        [full appendAttributedString:attrIcon];

        NSMutableAttributedString *attrAwardValue = [[NSMutableAttributedString alloc] initWithString:@" 02:38:28:23"];
        attrAwardValue.yy_font = UIFONT_MEDIUM(12);
        attrAwardValue.yy_color = HEX_COLOR(@"#6C3800");
        [full appendAttributedString:attrAwardValue];

        _timeLabel.attributedText = full;
    }
    return _timeLabel;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        [_headImageView dt_cornerRadius:8];
    }
    return _headImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = UIFONT_MEDIUM(18);
        _nameLabel.textColor = HEX_COLOR(@"#000000");
        _nameLabel.text = @"狼人杀";
    }
    return _nameLabel;
}

- (UILabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[UILabel alloc] init];
        _coinLabel.font = UIFONT_MEDIUM(14);
        _coinLabel.textColor = HEX_COLOR_A(@"#000000", 0.7);
        _coinLabel.text = @"入场 2金币";
    }
    return _coinLabel;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        [_playBtn setTitle:@"立即玩" forState:UIControlStateNormal];
        [_playBtn setTitleColor:HEX_COLOR(@"#6C3800") forState:UIControlStateNormal];
        [_playBtn setBackgroundImage:HEX_COLOR(@"#FFE373").dt_toImage forState:UIControlStateNormal];
        _playBtn.layer.borderColor = HEX_COLOR(@"#FFBF3A").CGColor;
        _playBtn.layer.borderWidth = 1;
        [_playBtn dt_cornerRadius:2];
    }
    return _playBtn;
}
@end