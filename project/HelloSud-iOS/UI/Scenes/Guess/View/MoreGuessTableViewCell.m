//
// Created by kaniel on 2022/6/6.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "MoreGuessTableViewCell.h"

#define DAY_SEC (24 * 3600)
#define HOUR_SEC 3600
#define MINUTE_SEC 60

@interface MoreGuessTableViewCell ()
@property(nonatomic, strong) UIView *customView;
@property(nonatomic, strong) BaseView *awardBackgroundView;
@property(nonatomic, strong) YYLabel *awardLabel;
@property(nonatomic, strong) BaseView *timeBackgroundView;
@property(nonatomic, strong) YYLabel *timeLabel;
@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *coinLabel;
@property(nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong)DTTimer *timer;
@property (nonatomic, assign)NSInteger countdown;
@end

@implementation MoreGuessTableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.timer stopTimer];
    self.timer = nil;
    self.countdown = 0;
    self.headImageView.image = nil;
}

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
        make.leading.equalTo(@0);
        make.height.equalTo(@30);
        make.top.equalTo(@11);
    }];
    [self.awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@6);
        make.trailing.equalTo(@-7);
        make.centerY.equalTo(self.awardBackgroundView);
        make.height.equalTo(@30);
        make.width.greaterThanOrEqualTo(@0);
    }];
    [self.timeBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@12);
        make.top.equalTo(@14);
        make.width.equalTo(@114);
        make.height.equalTo(@24);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@6);
        make.trailing.equalTo(@-17);
        make.top.equalTo(self.timeBackgroundView);
        make.height.equalTo(self.timeBackgroundView);
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

- (void)dtUpdateUI {
    if (![self.model isKindOfClass:[MoreGuessGameModel class]]) {
        return;
    }
    WeakSelf
    MoreGuessGameModel *m = (MoreGuessGameModel *)self.model;
    if (m.gamePic) {
        [self.headImageView sd_setImageWithURL:[[NSURL alloc] initWithString:m.gamePic]];
    }
    self.nameLabel.text = m.gameName;
    self.coinLabel.text = [NSString stringWithFormat:@"入场 %@金币", @(m.ticketCoin)];
    [self updateAward:m.winCoin];
    [self beginCountdown];
    [self updateCountdown];
}

- (void)beginCountdown {
    WeakSelf
    MoreGuessGameModel *m = (MoreGuessGameModel *)self.model;
    if (m.gameCountDownCycle <= 0) {
        return;
    }
    // 经历过时间戳
    NSInteger countdown = 0;
    if (m.beginTimestamp > 0) {
        NSInteger passTime = [[NSDate date] timeIntervalSince1970] - m.beginTimestamp;
        countdown = m.gameCountDownCycle - passTime % m.gameCountDownCycle;
    }
    if (countdown <= 0) {
        countdown = m.gameCountDownCycle;
    }
    if (!self.timer) {
        self.countdown = countdown;
        // 记录倒计时开始时间
        if (m.beginTimestamp <= 0) {
            m.beginTimestamp = [[NSDate date] timeIntervalSince1970];
        }
        self.timer = [DTTimer timerWithTimeInterval:1 repeats:YES block:^(DTTimer *timer) {
            [weakSelf updateCountdown];
        }];
    }
}

- (void)updateCountdown {
    self.countdown--;
    if (self.countdown < 0) {
        // 重复倒计时
        MoreGuessGameModel *m = (MoreGuessGameModel *)self.model;
        self.countdown = m.gameCountDownCycle;
    }

    NSMutableAttributedString *full = [[NSMutableAttributedString alloc] init];
    UIImage *iconImage = [UIImage imageNamed:@"guess_time_icon"];
    NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(12, 12) alignToFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
    [full appendAttributedString:attrIcon];

    NSInteger day = self.countdown / DAY_SEC;
    NSInteger hour = (self.countdown - day * DAY_SEC) / HOUR_SEC;
    NSInteger min = (self.countdown - day * DAY_SEC - hour * HOUR_SEC) / MINUTE_SEC;
    NSInteger sec = self.countdown - day * DAY_SEC - hour * HOUR_SEC - min * MINUTE_SEC;

    NSString *timeStr = [NSString stringWithFormat:@" %02ld:%02ld:%02ld:%02ld", day, hour, min, sec];
    NSMutableAttributedString *attrAwardValue = [[NSMutableAttributedString alloc] initWithString:timeStr];
    attrAwardValue.yy_font = UIFONT_MEDIUM(12);
    attrAwardValue.yy_color = HEX_COLOR(@"#6C3800");
    [full appendAttributedString:attrAwardValue];

    _timeLabel.attributedText = full;
}

- (void)updateAward:(NSInteger)award {
    NSMutableAttributedString *full = [[NSMutableAttributedString alloc] initWithString:@"奖励 "];
    full.yy_font = UIFONT_MEDIUM(14);
    full.yy_color = HEX_COLOR(@"#ffffff");

    UIImage *iconImage = [UIImage imageNamed:@"guess_award_coin"];
    NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(18, 18) alignToFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
    [full appendAttributedString:attrIcon];

    NSMutableAttributedString *attrAwardValue = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", @(award)]];
    attrAwardValue.yy_font = UIFONT_MEDIUM(16);
    attrAwardValue.yy_color = HEX_COLOR(@"#FFFF22");
    [full appendAttributedString:attrAwardValue];

    _awardLabel.attributedText = full;
}

- (UIView *)customView {
    if (!_customView) {
        _customView = [[UIView alloc] init];
        _customView.backgroundColor = HEX_COLOR(@"#FFFAEB");
        [_customView dt_cornerRadius:8];
    }
    return _customView;
}

- (BaseView *)awardBackgroundView {
    if (!_awardBackgroundView) {
        _awardBackgroundView = [[BaseView alloc] init];
        _awardBackgroundView.backgroundColor = HEX_COLOR(@"#FF711A");
        [_awardBackgroundView setPartRoundCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadius:8];
    }
    return _awardBackgroundView;
}

- (YYLabel *)awardLabel {
    if (!_awardLabel) {
        _awardLabel = [[YYLabel alloc] init];
    }
    return _awardLabel;
}

- (BaseView *)timeBackgroundView {
    if (!_timeBackgroundView) {
        _timeBackgroundView = [[BaseView alloc] init];
        _timeBackgroundView.backgroundColor = HEX_COLOR(@"#FFFAEB");
        _timeBackgroundView.layer.borderWidth = 1;
        _timeBackgroundView.layer.borderColor = HEX_COLOR(@"#FFBF3A").CGColor;
        [_timeBackgroundView dt_cornerRadius:12];
    }
    return _timeBackgroundView;
}

- (YYLabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[YYLabel alloc] init];


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
