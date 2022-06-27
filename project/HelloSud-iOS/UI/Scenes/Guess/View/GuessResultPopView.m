//
//  GuessResultPopView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GuessResultPopView.h"
#import "GuessResultTableViewCell.h"

@interface GuessResultPopView () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) BaseView *bgView;
@property(nonatomic, strong) BaseView *contentView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) YYLabel *coinLabel;
@property(nonatomic, strong) MarqueeLabel *tipLabel;
@property(nonatomic, strong) UILabel *listTipLabel;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *againBtn;
@property(nonatomic, strong) UIButton *closeBtn;
@property(nonatomic, strong) UIImageView *joinImageView;
@property(nonatomic, strong) MarqueeLabel *joinTipLabel;
@property(nonatomic, assign) NSInteger betCoin;

@property(nonatomic, assign) NSInteger countdown;
@property(nonatomic, strong) DTTimer *timer;
@end

@implementation GuessResultPopView

- (void)dealloc {
    [self closeCountdown];
}


- (void)dtAddViews {

    [self addSubview:self.bgView];
    [self addSubview:self.bgImageView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.coinLabel];
    [self.contentView addSubview:self.tipLabel];
    [self.contentView addSubview:self.joinImageView];
    [self.contentView addSubview:self.joinTipLabel];
    [self.contentView addSubview:self.listTipLabel];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.againBtn];
    [self.contentView addSubview:self.closeBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@260);
    }];
    [self.bgView dt_cornerRadius:12];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView).offset(103);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@417);
        make.bottom.equalTo(@0);
    }];
    [self.contentView dt_cornerRadius:12];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView).offset(103);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@417);
        make.bottom.equalTo(@0);
    }];


    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@30);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.greaterThanOrEqualTo(@37);
    }];
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
        make.height.greaterThanOrEqualTo(@0);
        make.width.greaterThanOrEqualTo(@0);
        make.centerX.equalTo(self.titleLabel);

    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(42);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.joinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@46);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(35);
        make.height.equalTo(@24);
        make.width.equalTo(@114);
    }];

    [self.joinTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.joinImageView.mas_trailing).offset(4);
        make.centerY.equalTo(self.joinImageView);
        make.height.greaterThanOrEqualTo(@0);
        make.width.lessThanOrEqualTo(@100);
    }];
    [self.listTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@134);
        make.leading.equalTo(@16);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listTipLabel.mas_bottom).offset(6);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@176);
    }];


}

- (void)dtConfigUI {
    [super dtConfigUI];
    [self updateCoin:0];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    [self handleStateResult];
}

/// 处理状态结果
- (void)handleStateResult {

    // 是否在游戏
    BOOL isInGame = kGuessService.currentRoomVC.sudFSMMGDecorator.isInGame;

    if (isInGame) {
        self.closeBtn.hidden = NO;
        [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@14);
            make.height.equalTo(@36);
            make.bottom.equalTo(@(-24));
        }];
        [self.againBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.closeBtn.mas_trailing).offset(16);
            make.height.equalTo(@36);
            make.bottom.equalTo(@(-24));
            make.trailing.equalTo(@-16);
            make.width.equalTo(self.closeBtn);
        }];

    } else {
        self.againBtn.hidden = YES;
        [self.closeBtn setBackgroundImage:HEX_COLOR(@"#FFE373").dt_toImage forState:UIControlStateNormal];
        self.closeBtn.layer.borderColor = HEX_COLOR(@"#FFBF3A").CGColor;
        [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@47);
            make.trailing.equalTo(@-47);
            make.height.equalTo(@36);
            make.bottom.equalTo(@(-24));
        }];
    }

    switch (self.resultStateType) {
        case GuessResultPopViewTypeWin: {
            /// 猜中
            self.titleLabel.text = isInGame ? @"恭喜获胜" : @"猜中了";
            [self updateCoin:self.winCoin];
            self.tipLabel.text = isInGame ? @"超过了94.8%的人" : @"料事如神，乘胜追击~";
            [self beginCountdown];
        }
            break;
        case GuessResultPopViewTypeLose: {
            /// 未猜中
            self.titleLabel.text = @"下次加油";
            self.tipLabel.text = @"不必气馁，下把翻盘！";
            self.joinImageView.hidden = NO;
            self.joinTipLabel.hidden = NO;
            self.coinLabel.hidden = YES;
            [self.tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
            }];
            [self beginCountdown];
        }
            break;
        case GuessResultPopViewTypeNotBet: {
            /// 未参与
            self.titleLabel.text = @"未竞猜";
            self.tipLabel.text = isInGame ? @"投自己赢，获胜讲赢得5倍奖励！" : @"猜中将获得5倍奖励！下轮一起来吧~";
            self.joinImageView.hidden = NO;
            self.joinTipLabel.hidden = NO;
            self.coinLabel.hidden = YES;
            [self.tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
            }];
            [self beginCountdown];
        }
            break;
        default:
            break;

    }
}

- (void)beginCountdown {
    WeakSelf
    if (!self.timer) {
        self.countdown = 10;
        [self updateCountdown];
        self.timer = [DTTimer timerWithTimeInterval:1 repeats:YES block:^(DTTimer *timer) {
            weakSelf.countdown--;
            [weakSelf updateCountdown];
        }];
    }
}

- (void)updateCountdown {

    if (self.countdown <= 0) {
        [DTAlertView close];
        [self.timer stopTimer];
        self.timer = nil;
        return;
    }
    NSString *closeStr = [NSString stringWithFormat:@"关闭(%@s)", @(self.countdown)];
    [self.closeBtn setTitle:closeStr forState:UIControlStateNormal];
}

- (void)closeCountdown {
    if (self.timer) {
        [self.timer stopTimer];
        self.timer = nil;
    }
}

- (void)updateCoin:(NSInteger)coin {
    NSMutableAttributedString *full = [[NSMutableAttributedString alloc] init];
    full.yy_alignment = NSTextAlignmentCenter;


    UIImage *iconImage = [UIImage imageNamed:@"guess_result_coin"];
    NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(24, 24) alignToFont:[UIFont systemFontOfSize:20 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
    attrIcon.yy_firstLineHeadIndent = 8;
    [full appendAttributedString:attrIcon];

    NSMutableAttributedString *attrAwardValue = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" +%@", @(coin)]];
    attrAwardValue.yy_font = UIFONT_MEDIUM(20);
    attrAwardValue.yy_color = HEX_COLOR(@"#FF7B14");
    [full appendAttributedString:attrAwardValue];

    self.coinLabel.attributedText = full;
}

- (void)dtConfigEvents {
    [super dtConfigEvents];

    [self.closeBtn addTarget:self action:@selector(onCloseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.againBtn addTarget:self action:@selector(onAgainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onCloseBtnClick:(id)sender {
    [self closeCountdown];
    [DTAlertView close];
}

- (void)onAgainBtnClick:(id)sender {
    [self closeCountdown];
    [DTAlertView close];
}

#pragma mark - UITableViewDelegate || UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GuessResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuessResultTableViewCell"];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor dt_colorWithHexString:@"#FFFCED" alpha:1];
        [_tableView registerClass:[GuessResultTableViewCell class] forCellReuseIdentifier:@"GuessResultTableViewCell"];
    }
    return _tableView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
        _bgImageView.image = [UIImage imageNamed:@"guess_result_bg"];
        _bgImageView.backgroundColor = UIColor.clearColor;
    }
    return _bgImageView;
}

- (BaseView *)bgView {
    if (!_bgView) {
        _bgView = [[BaseView alloc] init];
        _bgView.backgroundColor = HEX_COLOR(@"#FCF4D2");
    }
    return _bgView;
}

- (BaseView *)contentView {
    if (!_contentView) {
        _contentView = [[BaseView alloc] init];
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFONT_BOLD(26);
        _titleLabel.textColor = HEX_COLOR(@"#000000");
        _titleLabel.shadowColor = HEX_COLOR(@"#FFDE00");
        _titleLabel.shadowOffset = CGSizeMake(1, 2);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (MarqueeLabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[MarqueeLabel alloc] init];
        _tipLabel.font = UIFONT_REGULAR(12);
        _tipLabel.textColor = HEX_COLOR(@"#FF0E00");
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (UILabel *)listTipLabel {
    if (!_listTipLabel) {
        _listTipLabel = [[UILabel alloc] init];
        _listTipLabel.font = UIFONT_REGULAR(12);
        _listTipLabel.textColor = HEX_COLOR(@"#000000");
        _listTipLabel.textAlignment = NSTextAlignmentCenter;
        _listTipLabel.text = @"游戏战况";
    }
    return _listTipLabel;
}

- (YYLabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[YYLabel alloc] init];
        _coinLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _coinLabel;
}

- (UIButton *)againBtn {
    if (!_againBtn) {
        _againBtn = [[UIButton alloc] init];
        [_againBtn setTitle:@"再来一局" forState:UIControlStateNormal];
        [_againBtn setTitleColor:HEX_COLOR(@"#6C3800") forState:UIControlStateNormal];
        [_againBtn setBackgroundImage:HEX_COLOR(@"#FFE373").dt_toImage forState:UIControlStateNormal];
        _againBtn.layer.borderWidth = 1;
        _againBtn.layer.borderColor = HEX_COLOR(@"#FFBF3A").CGColor;
        _againBtn.titleLabel.font = UIFONT_MEDIUM(14);
    }
    return _againBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:HEX_COLOR(@"#6C3800") forState:UIControlStateNormal];
        [_closeBtn setBackgroundImage:HEX_COLOR(@"#FFFFFF").dt_toImage forState:UIControlStateNormal];
        _closeBtn.layer.borderWidth = 1;
        _closeBtn.layer.borderColor = HEX_COLOR(@"#EEE8D0").CGColor;
        _closeBtn.titleLabel.font = UIFONT_MEDIUM(14);
    }
    return _closeBtn;
}

- (UIImageView *)joinImageView {
    if (!_joinImageView) {
        _joinImageView = [[UIImageView alloc] init];
        _joinImageView.contentMode = UIViewContentModeScaleAspectFill;
        _joinImageView.clipsToBounds = YES;
        _joinImageView.image = [UIImage imageNamed:@"guess_join_avatar"];
        _joinImageView.hidden = YES;
    }
    return _joinImageView;
}

- (MarqueeLabel *)joinTipLabel {
    if (!_joinTipLabel) {
        _joinTipLabel = [[MarqueeLabel alloc] init];
        _joinTipLabel.text = @"他们已参与竞猜";
        _joinTipLabel.font = UIFONT_REGULAR(12);
        _joinTipLabel.textColor = HEX_COLOR_A(@"#000000", 0.7);
        _joinTipLabel.hidden = YES;
    }
    return _joinTipLabel;
}

@end
