//
// Created by kaniel on 2022/6/8.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "MoreGuessCoinPopView.h"
#import "MoreGuessCoinItemView.h"

@interface MoreGuessCoinPopView ()
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIView *awardBackgroundView;
@property(nonatomic, strong) YYLabel *awardLabel;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subtitleLabel;
@property(nonatomic, strong) UIButton *supportBtn;
@property(nonatomic, strong) UIView *coinContentView;
@property(nonatomic, strong) NSArray<MoreGuessCoinItemView *> *arrCoinItemView;
@property(nonatomic, assign) NSInteger selectedCoin;
@end

@implementation MoreGuessCoinPopView

- (void)dtAddViews {
    [super dtAddViews];

    [self addSubview:self.bgImageView];
    [self addSubview:self.awardBackgroundView];
    [self.awardBackgroundView addSubview:self.awardLabel];

    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.coinContentView];
    [self addSubview:self.supportBtn];
    MoreGuessCoinItemView *v1 = [[MoreGuessCoinItemView alloc] init];
    v1.isSelected = NO;
    v1.coin = 10;
    WeakSelf
    v1.onStateChangedBlock = ^(MoreGuessCoinItemView *view, BOOL isSelected) {
        [weakSelf updateSelectState:view];
    };

    MoreGuessCoinItemView *v2 = [[MoreGuessCoinItemView alloc] init];
    v2.isSelected = YES;
    v2.coin = 100;
    v2.onStateChangedBlock = ^(MoreGuessCoinItemView *view, BOOL isSelected) {
        [weakSelf updateSelectState:view];
    };

    self.selectedCoin = v2.coin;
    MoreGuessCoinItemView *v3 = [[MoreGuessCoinItemView alloc] init];
    v3.isSelected = NO;
    v3.coin = 500;
    v3.onStateChangedBlock = ^(MoreGuessCoinItemView *view, BOOL isSelected) {
        [weakSelf updateSelectState:view];
    };

    [self.coinContentView addSubview:v1];
    [self.coinContentView addSubview:v2];
    [self.coinContentView addSubview:v3];
    self.arrCoinItemView = @[v1, v2, v3];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.awardBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@10);
        make.height.equalTo(@20);
        make.top.equalTo(@8);
    }];
    [self.awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@5);
        make.trailing.equalTo(@-12);
        make.centerY.equalTo(self.awardBackgroundView);
        make.height.equalTo(self.awardBackgroundView);
        make.width.greaterThanOrEqualTo(@0);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.awardBackgroundView.mas_bottom).offset(8);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.greaterThanOrEqualTo(@0);
    }];

    [self.coinContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.trailing.equalTo(@-15);
        make.top.equalTo(self.subtitleLabel.mas_bottom).offset(12);
        make.height.equalTo(@80);
    }];

    [self.arrCoinItemView dt_mas_distributeSudokuViewsWithFixedLineSpacing:10 fixedInteritemSpacing:10 warpCount:3 topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];

    CGFloat bottom = kAppSafeBottom + 12;
    [self.supportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coinContentView.mas_bottom).offset(12);
        make.height.equalTo(@44);
        make.width.equalTo(@236);
        make.centerX.equalTo(self);
        make.bottom.equalTo(@(-bottom));
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    WeakSelf
    [UserService.shared reqUserCoinDetail:^(int64_t i) {
        [weakSelf updateCoin:i];
    }                                fail:^(NSString *errStr) {
        [ToastUtil show:errStr];
    }];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.supportBtn addTarget:self action:@selector(onSupportBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    self.titleLabel.text = [NSString stringWithFormat:@"你要投入多少支持%@", self.name];
}

- (void)onSupportBtnCLick:(id)sender {

    [GuessRoomService reqBet:1 coin:self.selectedCoin userList:nil finished:^{
        if (self.onSupportCoinBlock) {
            self.onSupportCoinBlock(self.selectedCoin);
        }
    }                failure:^(NSError *error) {
        [ToastUtil show:error.dt_errMsg];
    }];
}

- (void)updateSelectState:(MoreGuessCoinItemView *)selectedView {

    self.selectedCoin = selectedView.coin;
    for (int i = 0; i < self.arrCoinItemView.count; ++i) {
        if (selectedView != self.arrCoinItemView[i]) {
            self.arrCoinItemView[i].isSelected = NO;
        }
    }
}

- (void)updateCoin:(int64_t)coin {
    NSMutableAttributedString *full = [[NSMutableAttributedString alloc] init];
    UIImage *iconImage = [UIImage imageNamed:@"guess_award_coin"];
    NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(14, 14) alignToFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
    [full appendAttributedString:attrIcon];
    NSNumber *number = @(coin);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    formatter.positiveFormat = @"###,###";
    NSString *amountString = [formatter stringFromNumber:number];
    NSMutableAttributedString *attrAwardValue = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", amountString]];
    attrAwardValue.yy_font = UIFONT_MEDIUM(14);
    attrAwardValue.yy_color = HEX_COLOR(@"#F6A209");
    [full appendAttributedString:attrAwardValue];

    _awardLabel.attributedText = full;
}

- (UIView *)awardBackgroundView {
    if (!_awardBackgroundView) {
        _awardBackgroundView = [[UIView alloc] init];
        _awardBackgroundView.backgroundColor = HEX_COLOR(@"#ffffff");
        [_awardBackgroundView dt_cornerRadius:10];
    }
    return _awardBackgroundView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more_guess_pop_bg"]];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (YYLabel *)awardLabel {
    if (!_awardLabel) {
        _awardLabel = [[YYLabel alloc] init];
    }
    return _awardLabel;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFONT_MEDIUM(16);
        _titleLabel.textColor = HEX_COLOR(@"#000000");
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = UIFONT_REGULAR(16);
        _subtitleLabel.textColor = HEX_COLOR(@"#4C4A46");
        _subtitleLabel.text = @"投的多分的多";
        _subtitleLabel.numberOfLines = 0;
    }
    return _subtitleLabel;
}

- (UIButton *)supportBtn {
    if (!_supportBtn) {
        _supportBtn = [[UIButton alloc] init];
        [_supportBtn setTitle:@"立即支持" forState:UIControlStateNormal];
        [_supportBtn setTitleColor:HEX_COLOR(@"#6C3800") forState:UIControlStateNormal];
        [_supportBtn setBackgroundImage:HEX_COLOR(@"#FFE373").dt_toImage forState:UIControlStateNormal];
        _supportBtn.layer.borderColor = HEX_COLOR(@"#FFBF3A").CGColor;
        _supportBtn.layer.borderWidth = 1;
        [_supportBtn dt_cornerRadius:2];
    }
    return _supportBtn;
}

- (UIView *)coinContentView {
    if (!_coinContentView) {
        _coinContentView = [[UIView alloc] init];
    }
    return _coinContentView;
}
@end
