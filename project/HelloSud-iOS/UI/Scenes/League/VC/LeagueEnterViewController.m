//
// Created by kaniel on 2022/9/27.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "LeagueEnterViewController.h"
#import "LeagueDetailViewController.h"

@interface LeagueEnterViewController ()
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *backBtn;
@property(nonatomic, strong) UIButton *rightBtn;
@property(nonatomic, strong) UILabel *tipLabel;
@property(nonatomic, strong) UIImageView *awardImageView;
@property(nonatomic, strong) DTPaddingLabel *awardLabel;
@property(nonatomic, strong) UIView *giftContentView;
@property(nonatomic, strong) UIButton *enterBtn;
@property(nonatomic, strong) UILabel *ruleTitleLabel;
@property(nonatomic, strong) UILabel *ruleOneLeftLabel;
@property(nonatomic, strong) UILabel *ruleOneRightLabel;
@property(nonatomic, strong) UILabel *ruleTwoLeftLabel;
@property(nonatomic, strong) UILabel *ruleTwoRightLabel;
@property(nonatomic, strong) UIView *coverView;
/// 继续比赛奖杯
@property(nonatomic, strong) UIImageView *awardIconImageView;
/// 继续比赛提示
@property(nonatomic, strong) DTPaddingLabel *awardTipLabel;

@property(nonatomic, assign) int64_t roomId;
@end

@implementation LeagueEnterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self reqData];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)dtIsHiddenNavigationBar {
    return YES;
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.rightBtn];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.awardImageView];
    [self.view addSubview:self.awardLabel];
    [self.view addSubview:self.giftContentView];
    [self.view addSubview:self.awardTipLabel];
    [self.view addSubview:self.awardIconImageView];
    [self.view addSubview:self.enterBtn];
    [self.view addSubview:self.ruleTitleLabel];
    [self.view addSubview:self.ruleOneLeftLabel];
    [self.view addSubview:self.ruleOneRightLabel];
    [self.view addSubview:self.ruleTwoLeftLabel];
    [self.view addSubview:self.ruleTwoRightLabel];
    [self.view addSubview:self.coverView];

    NSArray *imageList = @[@"league_gift_1", @"league_gift_2", @"league_gift_3", @"league_gift_4"];
    NSMutableArray *imageViewList = NSMutableArray.new;
    for (int i = 0; i < imageList.count; ++i) {
        UIImageView *iv = UIImageView.new;
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.image = [UIImage imageNamed:imageList[i]];
        UILabel *lab = UILabel.new;
        lab.text = @"特有礼物";
        lab.textColor = HEX_COLOR(@"#EADCBC");
        lab.font = UIFONT_REGULAR(12);
        lab.textAlignment = NSTextAlignmentCenter;
        [iv addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@17);
        }];
        [imageViewList addObject:iv];
        [self.giftContentView addSubview:iv];
    }
    [imageViewList dt_mas_distributeSudokuViewsWithFixedLineSpacing:0 fixedInteritemSpacing:10 warpCount:4 topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kAppSafeTop);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.equalTo(@(kScaleByW_375(44)));
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.leading.mas_equalTo(6);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn);
        make.trailing.mas_equalTo(-28);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(9);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@(kScaleByW_375(65)));
    }];
    [self.awardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.tipLabel.mas_bottom).offset(0);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.equalTo(@(kScaleByW_375(131)));
    }];

    [self.awardLabel dt_cornerRadius:9];
    [self.awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.awardImageView).offset(27);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@18);
    }];
    [self.giftContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.awardImageView.mas_bottom).offset(kScaleByW_375(10));
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.equalTo(@(kScaleByW_375(65)));
    }];
    [self.awardIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.awardTipLabel);
        make.trailing.equalTo(self.awardTipLabel.mas_leading).offset(10);
        make.width.equalTo(@24);
        make.height.equalTo(@23);
    }];

    [self.awardTipLabel dt_cornerRadius:10];
    [self.awardTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(10);
        make.top.equalTo(self.giftContentView.mas_bottom).offset(10);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@20);
    }];
    [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.giftContentView.mas_bottom).offset(kScaleByW_375(22));
        make.width.equalTo(@(kScaleByW_375(192)));
        make.height.equalTo(@(kScaleByW_375(78)));
    }];
    [self.ruleTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.enterBtn.mas_bottom).offset(32);
        make.leading.trailing.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];

    [self.ruleOneLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ruleTitleLabel.mas_bottom).offset(15);
        make.leading.equalTo(@(kScaleByW_375(51)));
        make.height.greaterThanOrEqualTo(@0);
        make.width.greaterThanOrEqualTo(@0);
    }];

    [self.ruleOneRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ruleOneLeftLabel);
        make.leading.equalTo(self.ruleOneLeftLabel.mas_trailing).offset(kScaleByW_375(28));
        make.height.greaterThanOrEqualTo(@0);
    }];

    [self.ruleTwoLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ruleOneRightLabel.mas_bottom).offset(20);
        make.leading.equalTo(self.ruleOneLeftLabel);
        make.height.greaterThanOrEqualTo(@0);
        make.width.greaterThanOrEqualTo(@0);
    }];

    [self.ruleTwoRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ruleTwoLeftLabel);
        make.leading.equalTo(self.ruleTwoLeftLabel.mas_trailing).offset(kScaleByW_375(28));
        make.height.greaterThanOrEqualTo(@0);
    }];

    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.top.equalTo(self.ruleTitleLabel.mas_bottom).offset(-10);
        make.bottom.equalTo(self.ruleTwoRightLabel.mas_bottom).offset(23);
    }];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [_backBtn addTarget:self action:@selector(backEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.enterBtn addTarget:self action:@selector(onEnterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn addTarget:self action:@selector(onRightBtnCick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backEvent {
    [self dtNavigationBackClick];
}

- (void)onRightBtnCick:(id)sender {

    LeagueDetailViewController *vc = LeagueDetailViewController.new;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onEnterBtnClick:(id)sender {
    if (self.roomId > 0) {
        DDLogDebug(@"enter room:%@", @(self.roomId));
        [AudioRoomService reqEnterRoom:self.roomId isFromCreate:false subSceneType:0 success:nil fail:nil];
    } else {
        DDLogDebug(@"enter match room");
        [AudioRoomService reqMatchRoom:self.gameId sceneType:self.sceneId gameLevel:-1 subSceneType:0];
    }
}


- (void)dtConfigUI {
    [super dtConfigUI];
    self.titleLabel.text = self.gameName;
    [self.rightBtn setTitle:@"示例" forState:UIControlStateNormal];
    self.tipLabel.text = @"勇敢去赢";
    self.awardLabel.text = @"大赛奖金池，达一百万金币";
    [self.enterBtn setTitle:@"立即参赛" forState:UIControlStateNormal];

    NSMutableAttributedString *fullAttr = [[NSMutableAttributedString alloc] initWithString:@" 比赛赛程 "];
    fullAttr.yy_font = UIFONT_SEMI_BOLD(20);
    fullAttr.yy_color = HEX_COLOR(@"#97A1ED");
    NSAttributedString *left = [NSAttributedString dt_attrWithImage:[UIImage imageNamed:@"league_thr_line"] size:CGSizeMake(16, 11) offsetY:0];
    NSAttributedString *right = [NSAttributedString dt_attrWithImage:[UIImage imageNamed:@"league_thr_line"] size:CGSizeMake(16, 11) offsetY:0];
    [fullAttr insertAttributedString:left atIndex:0];
    [fullAttr appendAttributedString:right];
    self.ruleTitleLabel.attributedText = fullAttr;

    self.ruleOneLeftLabel.attributedText = [self genLeftAttr:@" 第一局"];
    self.ruleTwoLeftLabel.attributedText = [self genLeftAttr:@" 第二局"];
    self.ruleOneRightLabel.attributedText = [self genRightAttr:@"淘汰赛 生死逃杀进前三" detail:@"用户进行比赛， \n排名前三进入前三名"];
    self.ruleTwoRightLabel.attributedText = [self genRightAttr:@"总决赛 勇夺第一名" detail:@"三强用户进行比赛， \n决出第一名"];

    self.awardTipLabel.text = @"你已进入三强";

}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (self.roomId > 0) {
        [self.enterBtn setTitle:@"继续比赛" forState:UIControlStateNormal];
        self.awardIconImageView.hidden = false;
        self.awardTipLabel.hidden = false;
    } else {
        self.awardIconImageView.hidden = true;
        self.awardTipLabel.hidden = true;
    }
}

- (NSMutableAttributedString *)genLeftAttr:(NSString *)title {
    NSMutableAttributedString *fullAttr = [[NSMutableAttributedString alloc] initWithString:title];
    fullAttr.yy_font = UIFONT_SEMI_BOLD(16);
    fullAttr.yy_color = HEX_COLOR(@"#97A1ED");
    NSAttributedString *left = [NSAttributedString dt_attrWithImage:[UIImage imageNamed:@"league_one_line"] size:CGSizeMake(7, 10) offsetY:0];
    [fullAttr insertAttributedString:left atIndex:0];
    return fullAttr;
}

- (NSMutableAttributedString *)genRightAttr:(NSString *)title detail:(NSString *)detail {
    NSMutableAttributedString *fullAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", title]];
    fullAttr.yy_font = UIFONT_SEMI_BOLD(16);
    fullAttr.yy_color = HEX_COLOR(@"#97A1ED");
    fullAttr.yy_lineSpacing = 8;
    NSMutableAttributedString *detailAttr = [[NSMutableAttributedString alloc] initWithString:detail];
    detailAttr.yy_font = UIFONT_SEMI_BOLD(12);
    detailAttr.yy_color = HEX_COLOR(@"#97A1ED");
    [fullAttr appendAttributedString:detailAttr];
    return fullAttr;
}

- (void)reqData {
    [LeagueRoomService reqUserPlayingRoom:self.gameId finished:^(RespLeaguePlayingModel *model) {
        self.roomId = model.roomId;
        [self dtUpdateUI];
    }];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"league_enter_bg"]];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.font = UIFONT_MEDIUM(18);
    }
    return _titleLabel;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = UIButton.new;
        [_backBtn setImage:[UIImage imageNamed:@"tickets_navi_back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = UIButton.new;
        [_rightBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = UIFONT_REGULAR(14);
    }
    return _rightBtn;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = UILabel.new;
        _tipLabel.textColor = UIColor.whiteColor;
        _tipLabel.font = UIFONT_SEMI_BOLD(46);
        _tipLabel.shadowColor = HEX_COLOR(@"#D3023F");
        _tipLabel.shadowOffset = CGSizeMake(1, 2);
    }
    return _tipLabel;
}

- (UIImageView *)awardImageView {
    if (!_awardImageView) {
        _awardImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"award_bg"]];
        _awardImageView.contentMode = UIViewContentModeScaleAspectFill;
        _awardImageView.clipsToBounds = YES;
    }
    return _awardImageView;
}

- (DTPaddingLabel *)awardLabel {
    if (!_awardLabel) {
        _awardLabel = DTPaddingLabel.new;
        _awardLabel.textColor = HEX_COLOR(@"#E6C593");
        _awardLabel.backgroundColor = HEX_COLOR_A(@"#000000", 0.3);
        _awardLabel.font = UIFONT_REGULAR(12);
        _awardLabel.paddingX = 13;
        _awardLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _awardLabel;
}

- (UIImageView *)awardIconImageView {
    if (!_awardIconImageView) {
        _awardIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"league_award"]];
        _awardIconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _awardIconImageView.clipsToBounds = YES;
    }
    return _awardIconImageView;
}

- (DTPaddingLabel *)awardTipLabel {
    if (!_awardTipLabel) {
        _awardTipLabel = DTPaddingLabel.new;
        _awardTipLabel.textColor = HEX_COLOR(@"#ffffff");
        _awardTipLabel.backgroundColor = HEX_COLOR_A(@"#000000", 0.3);
        _awardTipLabel.font = UIFONT_REGULAR(14);
        _awardTipLabel.paddingX = 10;
        _awardTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _awardTipLabel;
}

- (UIView *)giftContentView {
    if (!_giftContentView) {
        _giftContentView = UIView.new;
    }
    return _giftContentView;
}

- (UIButton *)enterBtn {
    if (!_enterBtn) {
        _enterBtn = UIButton.new;
        [_enterBtn setBackgroundImage:[UIImage imageNamed:@"enter_league"] forState:UIControlStateNormal];
        _enterBtn.titleLabel.font = UIFONT_SEMI_BOLD(kScaleByW_375(28));
        [_enterBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    return _enterBtn;
}


- (UILabel *)ruleTitleLabel {
    if (!_ruleTitleLabel) {
        _ruleTitleLabel = UILabel.new;
        _ruleTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _ruleTitleLabel;
}

- (UILabel *)ruleOneLeftLabel {
    if (!_ruleOneLeftLabel) {
        _ruleOneLeftLabel = UILabel.new;
    }
    return _ruleOneLeftLabel;
}

- (UILabel *)ruleOneRightLabel {
    if (!_ruleOneRightLabel) {
        _ruleOneRightLabel = UILabel.new;
        _ruleOneRightLabel.numberOfLines = 0;
    }
    return _ruleOneRightLabel;
}

- (UILabel *)ruleTwoLeftLabel {
    if (!_ruleTwoLeftLabel) {
        _ruleTwoLeftLabel = UILabel.new;
    }
    return _ruleTwoLeftLabel;
}

- (UILabel *)ruleTwoRightLabel {
    if (!_ruleTwoRightLabel) {
        _ruleTwoRightLabel = UILabel.new;
        _ruleTwoRightLabel.numberOfLines = 0;
    }
    return _ruleTwoRightLabel;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = UIView.new;
        _coverView.backgroundColor = HEX_COLOR_A(@"#000000", 0.1);
        [_coverView dt_cornerRadius:10];
    }
    return _coverView;
}

@end
