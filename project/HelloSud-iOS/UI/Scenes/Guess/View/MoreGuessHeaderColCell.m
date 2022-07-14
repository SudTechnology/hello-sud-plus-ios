//
// Created by kaniel on 2022/6/6.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "MoreGuessHeaderColCell.h"
#import "MoreGuessHeaderCellModel.h"
#import "MoreGuessCoinPopView.h"

#define DAY_SEC (24 * 3600)
#define HOUR_SEC 3600
#define MINUTE_SEC 60

@interface MoreGuessHeaderColCell ()
@property(nonatomic, strong) UIImageView *vsImageView;
@property(nonatomic, strong) BaseView *stateContentView;
@property(nonatomic, strong) UILabel *stateLabel;

@property(nonatomic, strong) UILabel *leftNameLabel;
@property(nonatomic, strong) UILabel *leftIDLabel;
@property(nonatomic, strong) UILabel *leftSupportLabel;
@property(nonatomic, strong) UIImageView *leftImageView;
@property(nonatomic, strong) UIImageView *leftSupportImageView;
@property(nonatomic, strong) UIButton *leftSupportBtn;

@property(nonatomic, strong) UILabel *rightNameLabel;
@property(nonatomic, strong) UILabel *rightIDLabel;
@property(nonatomic, strong) UILabel *rightSupportLabel;
@property(nonatomic, strong) UIImageView *rightImageView;
@property(nonatomic, strong) UIImageView *rightSupportImageView;
@property(nonatomic, strong) UIButton *rightSupportBtn;

@property(nonatomic, strong) UIImageView *joinImageView;
@property(nonatomic, strong) MarqueeLabel *joinTipLabel;

@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UILabel *coinTipLabel;
@property(nonatomic, strong) YYLabel *coinLabel;

@property(nonatomic, strong) UIImageView *leftResultImageView;
@property(nonatomic, strong) UIImageView *rightResultImageView;

@property (nonatomic, strong)DTTimer *timer;
@property (nonatomic, assign)NSInteger countdown;
@end

@implementation MoreGuessHeaderColCell

- (void)dtAddViews {

    [self.contentView addSubview:self.vsImageView];

    [self.contentView addSubview:self.stateContentView];
    [self.stateContentView addSubview:self.stateLabel];

    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.leftNameLabel];
    [self.contentView addSubview:self.leftIDLabel];
    [self.contentView addSubview:self.leftSupportLabel];
    [self.contentView addSubview:self.leftSupportImageView];
    [self.contentView addSubview:self.leftSupportBtn];

    [self.contentView addSubview:self.rightImageView];
    [self.contentView addSubview:self.rightNameLabel];
    [self.contentView addSubview:self.rightIDLabel];
    [self.contentView addSubview:self.rightSupportLabel];
    [self.contentView addSubview:self.rightSupportImageView];
    [self.contentView addSubview:self.rightSupportBtn];

    [self.contentView addSubview:self.joinImageView];
    [self.contentView addSubview:self.joinTipLabel];

    [self.contentView addSubview:self.bottomView];

    [self.bottomView addSubview:self.coinTipLabel];
    [self.bottomView addSubview:self.coinLabel];

    [self.contentView addSubview:self.leftResultImageView];
    [self.contentView addSubview:self.rightResultImageView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.stateContentView dt_cornerRadius:4];
    [self.stateContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@-4);
        make.height.equalTo(@34);
        make.centerX.equalTo(self.contentView);
        make.width.greaterThanOrEqualTo(@0);
    }];

    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@10);
        make.trailing.equalTo(@-10);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@20);
        make.bottom.equalTo(@-5);
    }];

    [self.vsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateContentView.mas_bottom).offset(24);
        make.leading.equalTo(@10);
        make.trailing.equalTo(@-10);
        make.height.equalTo(@80);
    }];

    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vsImageView).offset(-12);
        make.leading.equalTo(self.vsImageView).offset(10);
        make.width.height.equalTo(@48);
    }];

    [self.leftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leftImageView);
        make.top.equalTo(self.leftImageView.mas_bottom).offset(2);
        make.height.greaterThanOrEqualTo(@0);
        make.trailing.equalTo(self.vsImageView.mas_centerX);
    }];
    [self.leftSupportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leftImageView.mas_trailing).offset(6);
        make.top.equalTo(self.vsImageView).offset(6);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.leftIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leftImageView);
        make.top.equalTo(self.leftNameLabel.mas_bottom).offset(0);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.leftSupportImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.leftImageView).offset(3);
        make.bottom.equalTo(self.leftImageView).offset(3);
        make.width.height.equalTo(@20);
    }];
    [self.leftSupportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.vsImageView);
        make.trailing.equalTo(self.vsImageView.mas_centerX).offset(-5);
        make.top.equalTo(self.vsImageView.mas_bottom).offset(12);
        make.height.equalTo(@40);
    }];

    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vsImageView).offset(-12);
        make.trailing.equalTo(self.vsImageView).offset(-10);
        make.width.height.equalTo(@48);
    }];

    [self.rightNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.rightImageView);
        make.top.equalTo(self.rightImageView.mas_bottom).offset(2);
        make.height.greaterThanOrEqualTo(@0);
        make.leading.equalTo(self.vsImageView.mas_centerX);
    }];
    [self.rightSupportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.rightImageView.mas_leading).offset(-6);
        make.top.equalTo(self.vsImageView).offset(6);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.rightIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.rightImageView);
        make.top.equalTo(self.rightNameLabel.mas_bottom).offset(0);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.rightSupportImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.rightImageView).offset(-3);
        make.bottom.equalTo(self.rightImageView).offset(3);
        make.width.height.equalTo(@20);
    }];
    [self.rightSupportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leftSupportBtn.mas_trailing).offset(10);
        make.trailing.equalTo(self.vsImageView);
        make.top.equalTo(self.leftSupportBtn);
        make.height.equalTo(self.leftSupportBtn);
    }];

    [self.joinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.leftSupportBtn).offset(16);
        make.top.equalTo(self.leftSupportBtn.mas_bottom).offset(16);
        make.height.equalTo(@24);
        make.width.equalTo(@114);
    }];

    [self.joinTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.joinImageView.mas_trailing).offset(4);
        make.centerY.equalTo(self.joinImageView);
        make.height.greaterThanOrEqualTo(@0);
        make.width.lessThanOrEqualTo(@100);
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@60);
    }];

    [self.coinTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
        make.bottom.equalTo(self.coinLabel.mas_top).offset(-3);
    }];

    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView);
        make.bottom.equalTo(@-8);
        make.width.height.greaterThanOrEqualTo(@0);
    }];

    [self.leftResultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView.mas_centerX).offset(-30);
        make.top.equalTo(self.vsImageView.mas_bottom).offset(-5);
        make.width.equalTo(@88);
        make.height.equalTo(@57);
    }];

    [self.rightResultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leftResultImageView.mas_trailing).offset(60);
        make.top.equalTo(self.vsImageView.mas_bottom).offset(-5);
        make.width.equalTo(@88);
        make.height.equalTo(@57);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = HEX_COLOR(@"#FFFAEB");
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = HEX_COLOR_A(@"#000000", 0.1).CGColor;
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.leftSupportBtn addTarget:self action:@selector(onLeftSupportClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightSupportBtn addTarget:self action:@selector(onRightSupportClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (![self.model isKindOfClass:[MoreGuessHeaderCellModel class]]) {
        return;
    }
    MoreGuessHeaderCellModel *m = (MoreGuessHeaderCellModel *)self.model;
    if (m.duration > 0) {
        if (m.leftSupportCoin > 0) {
            self.leftSupportImageView.hidden = NO;
            self.leftSupportLabel.text = [NSString stringWithFormat:NSString.dt_room_guess_support_fmt, @(m.leftSupportCoin)];
            self.rightSupportBtn.enabled = NO;
            self.leftSupportBtn.selected = YES;
        } else {
            self.leftSupportLabel.text = nil;
            self.leftSupportImageView.hidden = YES;
        }
        if (m.rightSupportCoin > 0) {
            self.rightSupportImageView.hidden = NO;
            self.rightSupportLabel.hidden = NO;
            self.rightSupportLabel.text = [NSString stringWithFormat:NSString.dt_room_guess_support_fmt, @(m.rightSupportCoin)];
            self.leftSupportBtn.enabled = NO;
            self.rightSupportBtn.selected = YES;
        } else {
            self.rightSupportLabel.text = nil;
            self.rightSupportImageView.hidden = YES;
        }
        self.leftResultImageView.hidden = YES;
        self.rightResultImageView.hidden = YES;
        self.leftSupportBtn.hidden = NO;
        self.rightSupportBtn.hidden = NO;
        self.leftImageView.image = [UIImage imageNamed:@"ic_avatar_7"];
        self.rightImageView.image = [UIImage imageNamed:@"ic_avatar_8"];
        self.leftNameLabel.text = @"趣味辩论";

        self.leftIDLabel.text = @"ID 8721";
        self.rightNameLabel.text = @"念念不忘团";
        self.rightIDLabel.text = @"ID 8719";
        self.coinTipLabel.text = NSString.dt_room_guess_win_pool;
        self.vsImageView.alpha = 1;
        [self updateCoin:50000];
        [self beginCountdown];
        m.leftRoomName = self.leftNameLabel.text;
        m.rightRoomName = self.rightNameLabel.text;
    } else {
        self.stateLabel.text = @"已结束";
        self.coinTipLabel.text = NSString.dt_room_guess_thirdthhen_pool;
        self.leftResultImageView.hidden = NO;
        self.rightResultImageView.hidden = NO;
        self.leftSupportLabel.hidden = NO;
        self.leftSupportImageView.hidden = NO;
        self.leftSupportBtn.hidden = YES;
        self.rightSupportBtn.hidden = YES;
        self.rightSupportLabel.hidden = YES;
        self.rightSupportImageView.hidden = YES;
        self.leftImageView.image = [UIImage imageNamed:@"ic_avatar_9"];
        self.rightImageView.image = [UIImage imageNamed:@"ic_avatar_10"];
        self.leftNameLabel.text = @"梦语女友";
        self.leftIDLabel.text = @"ID 8526";
        self.rightNameLabel.text = @"彼岸花开";
        self.rightIDLabel.text = @"ID 8329";
        self.vsImageView.alpha = 0.7;
        [self updateCoin:30000];
    }
}

- (void)beginCountdown {
    WeakSelf
    MoreGuessHeaderCellModel *m = (MoreGuessHeaderCellModel *)self.model;
    if (!self.timer) {
        self.countdown = m.duration - (int64_t)[NSDate date].timeIntervalSince1970 % m.duration;
        [weakSelf updateCountdown];
        self.timer = [DTTimer timerWithTimeInterval:1 repeats:YES block:^(DTTimer *timer) {
            weakSelf.countdown--;
            [weakSelf updateCountdown];
        }];
    }
}

- (void)updateCountdown {

    if (self.countdown < 0) {
        MoreGuessHeaderCellModel *m = (MoreGuessHeaderCellModel *)self.model;
        self.countdown = m.duration;
    }
    NSInteger day = self.countdown / DAY_SEC;
    NSInteger hour = (self.countdown - day * DAY_SEC) / HOUR_SEC;
    NSInteger min = (self.countdown - day * DAY_SEC - hour * HOUR_SEC) / MINUTE_SEC;
    NSInteger sec = self.countdown - day * DAY_SEC - hour * HOUR_SEC - min * MINUTE_SEC;
    _stateLabel.text = [NSString stringWithFormat:NSString.dt_room_guess_distance_time_fmt, day, hour, min, sec];
}

- (void)onLeftSupportClick:(id)sender {
    WeakSelf
    MoreGuessHeaderCellModel *m = (MoreGuessHeaderCellModel *)self.model;
    if (![m isKindOfClass:[MoreGuessHeaderCellModel class]]) {
        return;
    }
    MoreGuessCoinPopView *v = [[MoreGuessCoinPopView alloc]init];
    v.name = m.leftRoomName;
    [v dtUpdateUI];
    v.onSupportCoinBlock = ^(NSInteger coin) {


        m.leftSupportCoin += coin;
        [weakSelf dtUpdateUI];
        [DTSheetView close];
    };
    [DTSheetView show:v onCloseCallback:nil];
}

- (void)onRightSupportClick:(id)sender {
    WeakSelf
    MoreGuessHeaderCellModel *m = (MoreGuessHeaderCellModel *)self.model;
    if (![m isKindOfClass:[MoreGuessHeaderCellModel class]]) {
        return;
    }
    MoreGuessCoinPopView *v = [[MoreGuessCoinPopView alloc]init];
    v.name = m.rightRoomName;
    [v dtUpdateUI];
    v.onSupportCoinBlock = ^(NSInteger coin) {
        MoreGuessHeaderCellModel *m = weakSelf.model;
        if (![m isKindOfClass:[MoreGuessHeaderCellModel class]]) {
            return;
        }
        m.rightSupportCoin += coin;
        [weakSelf dtUpdateUI];
        [DTSheetView close];
    };
    [DTSheetView show:v onCloseCallback:nil];
}

- (void)updateCoin:(NSInteger)coin {
    NSMutableAttributedString *full = [[NSMutableAttributedString alloc] init];
    full.yy_alignment = NSTextAlignmentCenter;

    UIImage *iconImage = [UIImage imageNamed:@"guess_award_coin"];
    NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(18, 18) alignToFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
    [full appendAttributedString:attrIcon];


    NSNumber *number = @(coin);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    formatter.positiveFormat = @"###,###";
    NSString *amountString = [formatter stringFromNumber:number];
    NSMutableAttributedString *attrAwardValue = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", amountString]];

    attrAwardValue.yy_font = UIFONT_MEDIUM(16);
    attrAwardValue.yy_color = HEX_COLOR(@"#FFFF22");
    [full appendAttributedString:attrAwardValue];

    _coinLabel.attributedText = full;
}

- (UIImageView *)vsImageView {
    if (!_vsImageView) {
        _vsImageView = [[UIImageView alloc] init];
        _vsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _vsImageView.image = [UIImage imageNamed:@"more_guess_vs"];
        [_vsImageView dt_cornerRadius:8];
        _vsImageView.clipsToBounds = YES;
    }
    return _vsImageView;
}

- (BaseView *)stateContentView {
    if (!_stateContentView) {
        _stateContentView = [[BaseView alloc] init];
        _stateContentView.layer.borderWidth = 1;
        _stateContentView.layer.borderColor = HEX_COLOR(@"#FFBF3A").CGColor;
    }
    return _stateContentView;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textColor = HEX_COLOR(@"#6C3800");
        _stateLabel.font = UIFONT_MEDIUM(14);
        _stateLabel.text = @"";
    }
    return _stateLabel;
}

- (UILabel *)leftNameLabel {
    if (!_leftNameLabel) {
        _leftNameLabel = [[UILabel alloc] init];
        _leftNameLabel.text = @"趣味辩论";
        _leftNameLabel.font = UIFONT_REGULAR(16);
        _leftNameLabel.textColor = HEX_COLOR(@"#ffffff");
    }
    return _leftNameLabel;
}

- (YYLabel *)leftSupportLabel {
    if (!_leftSupportLabel) {
        _leftSupportLabel = [[UILabel alloc] init];
        _leftSupportLabel.text = [NSString stringWithFormat:NSString.dt_room_guess_support_fmt, @(100)];
        _leftSupportLabel.font = UIFONT_MEDIUM(10);
        _leftSupportLabel.textColor = HEX_COLOR(@"#FFFF22");
    }
    return _leftSupportLabel;
}

- (UILabel *)leftIDLabel {
    if (!_leftIDLabel) {
        _leftIDLabel = [[UILabel alloc] init];
        _leftIDLabel.text = @"ID 8721";
        _leftIDLabel.font = UIFONT_MEDIUM(14);
        _leftIDLabel.textColor = HEX_COLOR_A(@"#ffffff", 0.7);
        _leftIDLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftIDLabel;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImageView.clipsToBounds = YES;
        _leftImageView.image = [UIImage imageNamed:@"ic_avatar_7"];
        [_leftImageView dt_cornerRadius:6];
        _leftImageView.clipsToBounds = YES;
        _leftImageView.layer.borderColor = HEX_COLOR(@"#ffffff").CGColor;
        _leftImageView.layer.borderWidth = 0.75;
    }
    return _leftImageView;
}

- (UIImageView *)leftSupportImageView {
    if (!_leftSupportImageView) {
        _leftSupportImageView = [[UIImageView alloc] init];
        _leftSupportImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftSupportImageView.clipsToBounds = YES;
        _leftSupportImageView.image = [UIImage imageNamed:@"more_guess_like"];
    }
    return _leftSupportImageView;
}

- (UIButton *)leftSupportBtn {
    if (!_leftSupportBtn) {
        _leftSupportBtn = [[UIButton alloc] init];
        [_leftSupportBtn setTitle:NSString.dt_room_guess_ta_win forState:UIControlStateNormal];
        [_leftSupportBtn setTitle:NSString.dt_room_guess_add forState:UIControlStateSelected];

        [_leftSupportBtn setTitleColor:HEX_COLOR(@"#6C3800") forState:UIControlStateNormal];
        [_leftSupportBtn setTitleColor:HEX_COLOR_A(@"#6C3800", 0.3) forState:UIControlStateDisabled];

        [_leftSupportBtn setBackgroundImage:HEX_COLOR(@"#FFE373").dt_toImage forState:UIControlStateNormal];
        [_leftSupportBtn setBackgroundImage:HEX_COLOR(@"#FBF2D0").dt_toImage forState:UIControlStateDisabled];

        _leftSupportBtn.layer.borderWidth = 1;
        _leftSupportBtn.layer.borderColor = HEX_COLOR(@"#FFBF3A").CGColor;

        _leftSupportBtn.titleLabel.font = UIFONT_BOLD(16);
    }
    return _leftSupportBtn;
}

- (UILabel *)rightNameLabel {
    if (!_rightNameLabel) {
        _rightNameLabel = [[UILabel alloc] init];
        _rightNameLabel.text = @"趣味辩论";
        _rightNameLabel.font = UIFONT_REGULAR(16);
        _rightNameLabel.textColor = HEX_COLOR(@"#ffffff");
        _rightNameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightNameLabel;
}

- (YYLabel *)rightSupportLabel {
    if (!_rightSupportLabel) {
        _rightSupportLabel = [[UILabel alloc] init];
        _rightSupportLabel.text = [NSString stringWithFormat:NSString.dt_room_guess_support_fmt, @(100)];
        _rightSupportLabel.font = UIFONT_MEDIUM(10);
        _rightSupportLabel.textColor = HEX_COLOR(@"#FFFF22");
    }
    return _rightSupportLabel;
}

- (UILabel *)rightIDLabel {
    if (!_rightIDLabel) {
        _rightIDLabel = [[UILabel alloc] init];
        _rightIDLabel.text = @"ID 8721";
        _rightIDLabel.font = UIFONT_MEDIUM(14);
        _rightIDLabel.textColor = HEX_COLOR_A(@"#ffffff", 0.7);
        _rightIDLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rightIDLabel;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rightImageView.clipsToBounds = YES;
        _rightImageView.image = [UIImage imageNamed:@"ic_avatar_7"];
        [_rightImageView dt_cornerRadius:6];
        _rightImageView.clipsToBounds = YES;
        _rightImageView.layer.borderColor = HEX_COLOR(@"#ffffff").CGColor;
        _rightImageView.layer.borderWidth = 0.75;
    }
    return _rightImageView;
}

- (UIImageView *)rightSupportImageView {
    if (!_rightSupportImageView) {
        _rightSupportImageView = [[UIImageView alloc] init];
        _rightSupportImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rightSupportImageView.clipsToBounds = YES;
        _rightSupportImageView.image = [UIImage imageNamed:@"more_guess_like"];
    }
    return _rightSupportImageView;
}

- (UIButton *)rightSupportBtn {
    if (!_rightSupportBtn) {
        _rightSupportBtn = [[UIButton alloc] init];
        [_rightSupportBtn setTitle:NSString.dt_room_guess_ta_win forState:UIControlStateNormal];
        [_rightSupportBtn setTitle:NSString.dt_room_guess_add forState:UIControlStateSelected];

        [_rightSupportBtn setTitleColor:HEX_COLOR(@"#6C3800") forState:UIControlStateNormal];
        [_rightSupportBtn setTitleColor:HEX_COLOR_A(@"#6C3800", 0.3) forState:UIControlStateDisabled];

        [_rightSupportBtn setBackgroundImage:HEX_COLOR(@"#FFE373").dt_toImage forState:UIControlStateNormal];
        [_rightSupportBtn setBackgroundImage:HEX_COLOR(@"#FBF2D0").dt_toImage forState:UIControlStateDisabled];

        _rightSupportBtn.layer.borderWidth = 1;
        _rightSupportBtn.layer.borderColor = HEX_COLOR(@"#FFBF3A").CGColor;

        _rightSupportBtn.titleLabel.font = UIFONT_BOLD(16);
    }
    return _rightSupportBtn;
}

- (UIImageView *)joinImageView {
    if (!_joinImageView) {
        _joinImageView = [[UIImageView alloc] init];
        _joinImageView.contentMode = UIViewContentModeScaleAspectFill;
        _joinImageView.clipsToBounds = YES;
        _joinImageView.image = [UIImage imageNamed:@"guess_join_avatar"];
    }
    return _joinImageView;
}

- (MarqueeLabel *)joinTipLabel {
    if (!_joinTipLabel) {
        _joinTipLabel = [[MarqueeLabel alloc] init];
        _joinTipLabel.text = @"30人已参与竞猜";
        _joinTipLabel.font = UIFONT_REGULAR(12);
        _joinTipLabel.textColor = HEX_COLOR_A(@"#000000", 0.7);
    }
    return _joinTipLabel;
}

- (YYLabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[YYLabel alloc] init];
    }
    return _coinLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = HEX_COLOR(@"#FF5B2C");
    }
    return _bottomView;
}

- (UILabel *)coinTipLabel {
    if (!_coinTipLabel) {
        _coinTipLabel = [[UILabel alloc] init];
        _coinTipLabel.text = NSString.dt_room_guess_win_pool;
        _coinTipLabel.numberOfLines = 0;
        _coinTipLabel.font = UIFONT_MEDIUM(14);
        _coinTipLabel.textColor = HEX_COLOR(@"#ffffff");
        _coinTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _coinTipLabel;
}

- (UIImageView *)leftResultImageView {
    if (!_leftResultImageView) {
        _leftResultImageView = [[UIImageView alloc] init];
        _leftResultImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftResultImageView.clipsToBounds = YES;
        _leftResultImageView.image = [UIImage imageNamed:@"more_guess_win"];
    }
    return _leftResultImageView;
}

- (UIImageView *)rightResultImageView {
    if (!_rightResultImageView) {
        _rightResultImageView = [[UIImageView alloc] init];
        _rightResultImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rightResultImageView.clipsToBounds = YES;
        _rightResultImageView.image = [UIImage imageNamed:@"more_guess_lose"];
    }
    return _rightResultImageView;
}
@end
