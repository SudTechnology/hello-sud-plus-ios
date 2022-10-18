//
//  GuessResultPopView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "LeagueResultPopView.h"
#import "LeagueResultTableViewCell.h"
#import "LeagueAwardView.h"
#import "LeagueModel.h"

@interface LeagueResultPopView () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) BaseView *bgView;
@property(nonatomic, strong) BaseView *contentView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) YYLabel *coinLabel;
@property(nonatomic, strong) UILabel *tipLabel;
@property(nonatomic, strong) UILabel *listTipLabel;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *leftBtn;
@property(nonatomic, strong) UIButton *rightBtn;
@property(nonatomic, strong) UIImageView *joinImageView;
@property(nonatomic, strong) MarqueeLabel *joinTipLabel;
@property(nonatomic, strong) LeagueAwardView *awardView;
@property(nonatomic, assign) NSInteger betCoin;

@property(nonatomic, assign) NSInteger countdown;
@property(nonatomic, strong) DTTimer *timer;
@end

@implementation LeagueResultPopView

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
    [self.contentView addSubview:self.awardView];
    [self.contentView addSubview:self.leftBtn];
    [self.contentView addSubview:self.rightBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@198);
    }];
    [self.bgView dt_cornerRadius:12];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView).offset(91);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@418);
        make.bottom.equalTo(@0);
    }];
    [self.contentView dt_cornerRadius:12];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView).offset(91);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(self.bgView);
        make.bottom.equalTo(@0);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@30);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.greaterThanOrEqualTo(@37);
    }];

    [self.listTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@84);
        make.leading.equalTo(@16);
        make.width.height.greaterThanOrEqualTo(@0);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(48);
        make.leading.trailing.equalTo(@0);
    }];

    [self.awardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.top.equalTo(self.tableView.mas_bottom);
        make.height.greaterThanOrEqualTo(@0);
        make.bottom.equalTo(self.rightBtn.mas_top).offset(-20);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    [self updateCoin:0];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
//    self.tipLabel.text = @"比赛战况";
    self.listTipLabel.text = @"比赛战况";
    [self handleStateResult];
}

/// 处理状态结果
- (void)handleStateResult {

    [self closeCountdown];
    // 是否在游戏
    BOOL isInGame = kGuessService.currentRoomVC.sudFSMMGDecorator.isInGame;

    if (self.resultStateType == LeagueResultTypeNotJoinFirstResult) {
        self.leftBtn.hidden = NO;
        [self.leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@14);
            make.height.equalTo(@36);
            make.bottom.equalTo(@(-20));
        }];
        [self.rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.leftBtn.mas_trailing).offset(16);
            make.height.equalTo(@36);
            make.bottom.equalTo(@(-20));
            make.trailing.equalTo(@-16);
            make.width.equalTo(self.leftBtn);
        }];

    } else {
        self.leftBtn.hidden = YES;
        [self.rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@47);
            make.trailing.equalTo(@-47);
            make.height.equalTo(@36);
            make.bottom.equalTo(@(-20));
        }];
    }
    [self.rightBtn setTitle:@"回到首页" forState:UIControlStateNormal];
    self.awardView.hidden = YES;
    [self.awardView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.top.equalTo(self.tableView.mas_bottom);
        make.height.equalTo(@0);
        make.bottom.equalTo(self.rightBtn.mas_top).offset(-20);
    }];
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@418);
    }];
    switch (self.resultStateType) {

        case LeagueResultTypeNotJoinFirstResult: {
            // 初赛未参与
            self.titleLabel.text = @"比赛进入下一局";
            self.bgImageView.image = [UIImage imageNamed:@"league_star"];
            self.coinLabel.hidden = NO;
            self.joinImageView.hidden = YES;
            self.joinTipLabel.hidden = YES;
            [self beginCountdown];
        }
            break;
        case LeagueResultTypeNotJoinEndResult: {
            /// 决赛未参与
            self.titleLabel.text = @"比赛已结束";
            self.bgImageView.image = [UIImage imageNamed:@"league_star"];
            self.joinImageView.hidden = NO;
            self.joinTipLabel.hidden = NO;
            self.coinLabel.hidden = YES;
        }
            break;
        case LeagueResultTypeJoinFirstBeforeThree: {
            /// 初赛进入前三
            self.titleLabel.text = @"恭喜进入前三";
            self.bgImageView.image = [UIImage imageNamed:@"league_win"];
            self.joinImageView.hidden = NO;
            self.joinTipLabel.hidden = NO;
            self.coinLabel.hidden = YES;

            [self beginCountdown];
        }
            break;
        case LeagueResultTypeJoinFirstAfterThree: {
            /// 初赛未进前三
            self.titleLabel.text = @"下次加油，进入总结赛";
            self.bgImageView.image = [UIImage imageNamed:@"league_star"];
            self.joinImageView.hidden = NO;
            self.joinTipLabel.hidden = NO;
            self.coinLabel.hidden = YES;
        }
            break;
        case LeagueResultTypeJoinEndFirst: {
            /// 前三名争第一时第一个名
            self.titleLabel.text = @"恭喜获得第一名";
            self.bgImageView.image = [UIImage imageNamed:@"league_win"];
            self.joinImageView.hidden = NO;
            self.joinTipLabel.hidden = NO;
            self.coinLabel.hidden = YES;
            self.awardView.hidden = NO;
            [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@471);
            }];
            [self.awardView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.equalTo(@0);
                make.top.equalTo(self.tableView.mas_bottom);
                make.height.greaterThanOrEqualTo(@0);
                make.bottom.equalTo(self.rightBtn.mas_top).offset(-20);
            }];
        }
            break;
        case LeagueResultTypeJoinEndLose: {
            /// 前三名争第一时未获得第一
            self.titleLabel.text = @"下次加油，夺得第一";
            self.bgImageView.image = [UIImage imageNamed:@"league_star"];
            self.joinImageView.hidden = NO;
            self.joinTipLabel.hidden = NO;
            self.coinLabel.hidden = YES;
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
        if (self.resultStateType == LeagueResultTypeNotJoinFirstResult || self.resultStateType == LeagueResultTypeJoinFirstBeforeThree) {
            if (self.continueBlock) self.continueBlock();
        }
        return;
    }
    NSString *title = self.resultStateType == LeagueResultTypeNotJoinFirstResult ? @"继续观看(%@s)" : @"继续比赛(%@s)";
    NSString *closeStr = [NSString stringWithFormat:title, @(self.countdown)];
    [self.rightBtn setTitle:closeStr forState:UIControlStateNormal];
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

    [self.rightBtn addTarget:self action:@selector(onRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn addTarget:self action:@selector(onLeftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onLeftBtnClick:(id)sender {
    [self closeCountdown];
    [DTAlertView close];
    if (self.closeBlock) self.closeBlock();
}

- (void)onRightBtnClick:(id)sender {
    [self closeCountdown];
    [DTAlertView close];
    if (self.resultStateType == LeagueResultTypeNotJoinFirstResult || self.resultStateType == LeagueResultTypeJoinFirstBeforeThree) {
        if (self.continueBlock) self.continueBlock();
    } else {
        if (self.closeBlock) self.closeBlock();
    }
}

#pragma mark - UITableViewDelegate || UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeagueResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeagueResultTableViewCell"];
    LeaguePlayerModel *model = self.dataList[indexPath.row];
    cell.model = model;
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
        _tableView.backgroundColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1];
        [_tableView registerClass:[LeagueResultTableViewCell class] forCellReuseIdentifier:@"LeagueResultTableViewCell"];
    }
    return _tableView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
        _bgImageView.backgroundColor = UIColor.clearColor;
    }
    return _bgImageView;
}

- (BaseView *)bgView {
    if (!_bgView) {
        _bgView = [[BaseView alloc] init];
        _bgView.backgroundColor = HEX_COLOR(@"#000000");
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
        _titleLabel.font = UIFONT_SEMI_BOLD(24);
        _titleLabel.textColor = HEX_COLOR(@"#EBD095");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = UIFONT_REGULAR(12);
        _tipLabel.textColor = HEX_COLOR(@"#ffffff");
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (UILabel *)listTipLabel {
    if (!_listTipLabel) {
        _listTipLabel = [[UILabel alloc] init];
        _listTipLabel.font = UIFONT_REGULAR(12);
        _listTipLabel.textColor = HEX_COLOR(@"#ffffff");
        _listTipLabel.textAlignment = NSTextAlignmentCenter;
        _listTipLabel.text = NSString.dt_room_guess_game_round_state;
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

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setTitle:@"退出" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:HEX_COLOR(@"#ffffff") forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = UIFONT_MEDIUM(14);
        _leftBtn.layer.borderWidth = 1;
        _leftBtn.layer.borderColor = HEX_COLOR_A(@"#FFFFFF", 0.52).CGColor;
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitle:NSString.dt_common_close forState:UIControlStateNormal];
        [_rightBtn setTitleColor:HEX_COLOR(@"#ffffff") forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = UIFONT_MEDIUM(14);
        BaseView *gradView = [[BaseView alloc] init];
        gradView.userInteractionEnabled = NO;
        [gradView dtAddGradientLayer:@[@0, @1] colors:@[(id) HEX_COLOR(@"#FFC045").CGColor, (id) HEX_COLOR(@"#FF6C2D").CGColor] startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) cornerRadius:0];
        [_rightBtn insertSubview:gradView atIndex:0];
        [gradView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];

    }
    return _rightBtn;
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
        _joinTipLabel.text = NSString.dt_room_guess_they_guess;
        _joinTipLabel.font = UIFONT_REGULAR(12);
        _joinTipLabel.textColor = HEX_COLOR_A(@"#000000", 0.7);
        _joinTipLabel.hidden = YES;
    }
    return _joinTipLabel;
}

- (LeagueAwardView *)awardView {
    if (!_awardView) {
        _awardView = LeagueAwardView.new;
    }
    return _awardView;
}
@end
