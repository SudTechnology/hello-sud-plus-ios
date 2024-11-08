//
// Created by kaniel on 2022/6/6.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HomeGuessCell.h"

#define DAY_SEC (24 * 3600)
#define HOUR_SEC 3600
#define MINUTE_SEC 60

@interface HomeGuessCell ()
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIView *awardBackgroundView;
@property(nonatomic, strong) UILabel *awardLabel;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) YYLabel *infoLabel;
@property(nonatomic, strong) UIButton *enterBtn;

@property (nonatomic, strong)DTTimer *timer;
@property (nonatomic, assign)NSInteger countdown;
@end

@implementation HomeGuessCell

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.timer stopTimer];
    self.timer = nil;
    self.countdown = 0;
}

- (void)dtAddViews {

    [super dtAddViews];
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.awardBackgroundView];
    [self.awardBackgroundView addSubview:self.awardLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.enterBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(@0);
        make.height.equalTo(@100);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bgImageView).offset(18);
        make.width.height.equalTo(@64);
        make.centerY.equalTo(self.bgImageView);
    }];
    [self.awardBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@8);
        make.centerY.equalTo(self.bgImageView);
        make.height.equalTo(@40);
        make.width.greaterThanOrEqualTo(@0);
    }];
    [self.awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@10);
        make.trailing.equalTo(@-18);
        make.top.bottom.equalTo(@0);
        make.width.greaterThanOrEqualTo(@0);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.top.equalTo(self.bgImageView.mas_bottom).offset(0);
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
    if (![self.model isKindOfClass:[MoreGuessGameModel class]]) {
        return;
    }
    MoreGuessGameModel *m = (MoreGuessGameModel *)self.model;
    if (m.homeGamePic) {
        [self.bgImageView sd_setImageWithURL:[[NSURL alloc] initWithString:m.homeGamePic]];
    }
    if (m.gamePic) {
        [self.iconImageView sd_setImageWithURL:[[NSURL alloc] initWithString:m.gamePic]];
    }
    self.nameLabel.text = m.gameName;
    [self updateInfoLabel:@"00:00:00"];
    [self updateAward:m.winCoin];
    [self beginCountdown];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.enterBtn addTarget:self action:@selector(onEnterBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)onEnterBtnClick:(id)sender {
    if (![self.model isKindOfClass:[MoreGuessGameModel class]]) {
        return;
    }
    MoreGuessGameModel *m = (MoreGuessGameModel *)self.model;
    if (self.onEnterRoomBlock) {
        self.onEnterRoomBlock(m);
    }
}

/// 更新文案信息
- (void)updateInfoLabel:(NSString *)timeStr {

    MoreGuessGameModel *m = (MoreGuessGameModel *)self.model;
    NSString *fmt = [NSString stringWithFormat:@"%@ ", NSString.dt_room_guess_remain];
    NSMutableAttributedString *full = [[NSMutableAttributedString alloc] initWithString:fmt];
    full.yy_lineSpacing = 6;
    full.yy_font = UIFONT_REGULAR(12);
    full.yy_color = HEX_COLOR(@"#666666");
    full.yy_firstLineHeadIndent = 10;
    full.yy_headIndent = 10;

    NSMutableAttributedString *attTime = [[NSMutableAttributedString alloc] initWithString:timeStr];
    attTime.yy_font = UIFONT_BOLD(12);
    attTime.yy_color = HEX_COLOR(@"#000000");
    [full appendAttributedString:attTime];

    NSMutableAttributedString *attPersonTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@ ", NSString.dt_room_guess_people_limit]];
    attPersonTitle.yy_lineSpacing = 6;
    attPersonTitle.yy_firstLineHeadIndent = 10;
    attPersonTitle.yy_headIndent = 10;
    attPersonTitle.yy_font = UIFONT_REGULAR(12);
    attPersonTitle.yy_color = HEX_COLOR(@"#666666");
    [full appendAttributedString:attPersonTitle];

    NSMutableAttributedString *attPersonValue = [[NSMutableAttributedString alloc] initWithString:@"∞"];
    attPersonValue.yy_font = UIFONT_BOLD(12);
    attPersonValue.yy_color = HEX_COLOR(@"#000000");
    [full appendAttributedString:attPersonValue];

    NSMutableAttributedString *enterTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",[NSString stringWithFormat:NSString.dt_room_guess_enter_fmt, @""]]];
    enterTitle.yy_firstLineHeadIndent = 10;
    enterTitle.yy_headIndent = 10;
    enterTitle.yy_font = UIFONT_REGULAR(12);
    enterTitle.yy_color = HEX_COLOR(@"#666666");
    [full appendAttributedString:enterTitle];

    NSString *feeStr =  m.ticketCoin > 0 ? [NSString stringWithFormat:NSString.dt_room_guess_coin_fmt, @(m.ticketCoin)] : NSString.dt_room_guess_fee;
    NSMutableAttributedString *enterTitleValue = [[NSMutableAttributedString alloc] initWithString:feeStr];
    enterTitleValue.yy_font = UIFONT_BOLD(12);
    enterTitleValue.yy_color = HEX_COLOR(@"#000000");
    [full appendAttributedString:enterTitleValue];

    _infoLabel.attributedText = full;
}

- (void)beginCountdown {
    WeakSelf
    MoreGuessGameModel *m = (MoreGuessGameModel *)self.model;
    if (m.gameCountDownCycle <= 0) {
        return;
    }
    // 经历过时间戳
    NSInteger countdown = m.gameCountDownCycle - (int64_t)[NSDate date].timeIntervalSince1970 % m.gameCountDownCycle;
    if (!self.timer) {
        self.countdown = countdown;
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
    [self updateInfoLabel:timeStr];
}

- (void)updateAward:(NSInteger)award {
    NSMutableAttributedString *full = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", NSString.dt_room_guess_aword]];
    full.yy_font = UIFONT_MEDIUM(14);
    full.yy_color = HEX_COLOR(@"#ffffff");

    UIImage *iconImage = [UIImage imageNamed:@"guess_award_coin"];
//    NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(18, 18) alignToFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
    //[full appendAttributedString:attrIcon];
    
    NSAttributedString *iconAttr = [NSAttributedString dt_attrWithImage:iconImage size:CGSizeMake(18, 18) offsetY: -4];
    [full appendAttributedString:iconAttr];

    NSMutableAttributedString *attrAwardValue = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", @(award)]];
    attrAwardValue.yy_font = UIFONT_MEDIUM(16);
    attrAwardValue.yy_color = HEX_COLOR(@"#FFFF22");
    [full appendAttributedString:attrAwardValue];
    _awardLabel.attributedText = full;
    
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
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

- (UILabel *)awardLabel {
    if (!_awardLabel) {
        _awardLabel = [[UILabel alloc] init];
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
        _infoLabel.text = @"";
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
        [_enterBtn setTitle:NSString.dt_room_guess_join_now forState:UIControlStateNormal];
        [_enterBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _enterBtn.titleLabel.font = UIFONT_REGULAR(16);
        _enterBtn.backgroundColor = UIColor.blackColor;
    }
    return _enterBtn;
}
@end
