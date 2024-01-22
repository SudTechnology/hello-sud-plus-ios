//
//  SwitchRoomModeView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "GameMatchGroupView.h"
#import "CrossAppSelectGameView.h"
#import "MatchSeatView.h"

@interface GameMatchGroupView ()
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *gameNameLabel;
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UIView *firstRowView;
@property(nonatomic, strong) UIView *secondRowView;
@property(nonatomic, strong) UILabel *numLabel;
@property(nonatomic, strong) UILabel *searchLabel;
@property(nonatomic, strong) UIImageView *rollingImageView;
@property(nonatomic, strong) UIButton *cancelBtn;
@property(nonatomic, strong) UIButton *joinTeamBtn;
@property(nonatomic, strong) UIButton *fastMatchBtn;
@property(nonatomic, strong) NSArray <MatchSeatView *> *seatViewList;
@property(nonatomic, strong) NSMutableDictionary <NSString *, MatchSeatView *> *seatViewMap;
@property(nonatomic, strong) NSArray <UserIndexInfo *> *userList;
@end

@implementation GameMatchGroupView


- (void)dtAddViews {

    NSInteger count = 9;
    NSMutableArray *list = NSMutableArray.new;
    self.seatViewMap = NSMutableDictionary.new;
    WeakSelf
    for (int i = 0; i < count; ++i) {
        MatchSeatView *seatView = [[MatchSeatView alloc] initWithIconWidth:i == 0 ? 72 : 54];
        seatView.hidden = YES;
        seatView.index = i;
        seatView.clickBlock = ^(NSInteger index) {
            [weakSelf handleSeatClick:index];
        };
        [list addObject:seatView];
        NSString *indexKey = [NSString stringWithFormat:@"%@", @(i)];
        self.seatViewMap[indexKey] = seatView;
    }
    self.seatViewList = list;

    [self addSubview:self.bgView];
    [self.bgView addSubview:self.seatViewList[0]];
    [self.bgView addSubview:self.firstRowView];
    [self.bgView addSubview:self.secondRowView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.gameNameLabel];

    [self addSubview:self.cancelBtn];
    [self addSubview:self.fastMatchBtn];
    [self addSubview:self.joinTeamBtn];
}

- (void)dtLayoutViews {

    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bgView).offset(14);
        make.width.height.equalTo(@40);
        make.top.equalTo(@0);
    }];
    [self.gameNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(8);
        make.bottom.equalTo(self.iconImageView);
        make.height.greaterThanOrEqualTo(@0);
        make.trailing.equalTo(self.bgView);
    }];
    [self.bgView dt_cornerRadius:16];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView).offset(10);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.equalTo(@280);
    }];


    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom).offset(24);
        make.leading.equalTo(@16);
        make.height.mas_equalTo(36);
        make.bottom.equalTo(@0);
    }];

    [self.fastMatchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.cancelBtn.mas_trailing).offset(19);
        make.height.mas_equalTo(36);
        make.bottom.mas_equalTo(self.cancelBtn);
        make.width.equalTo(self.cancelBtn);
        make.trailing.equalTo(@-16);
    }];

    [self.joinTeamBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@168);
        make.height.mas_equalTo(36);
        make.bottom.equalTo(@0);
        make.centerX.equalTo(self);
    }];
}

- (void)dtConfigUI {
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (self.gameItem.gameName) {
        NSMutableAttributedString *fullAttr = [[NSMutableAttributedString alloc] initWithString:self.gameItem.gameName];
        fullAttr.yy_font = UIFONT_MEDIUM(16);
        fullAttr.yy_color = HEX_COLOR(@"#FFFFFF");

        NSMutableAttributedString *subtitleAttr = [[NSMutableAttributedString alloc] initWithString:@" 游戏组队"];
        subtitleAttr.yy_font = UIFONT_MEDIUM(16);
        subtitleAttr.yy_color = HEX_COLOR_A(@"#FFFFFF", 0.6);
        [fullAttr appendAttributedString:subtitleAttr];
        self.gameNameLabel.attributedText = fullAttr;
    }
    [self.iconImageView sd_setImageWithURL:self.gameItem.gamePic.dt_toURL];
    if ([AppService.shared.login.loginUserInfo isMeByUserID:DT_STR(self.captainId)]) {
        // 队长
        [_fastMatchBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_fastMatchBtn setTitle:@"一键匹配玩伴" forState:UIControlStateNormal];
        [_fastMatchBtn setImage:[UIImage imageNamed:@"cross_app_fast_match"] forState:UIControlStateNormal];
        _fastMatchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
        _fastMatchBtn.backgroundColor = UIColor.whiteColor;
        _fastMatchBtn.userInteractionEnabled = YES;
    } else {
        // 非队长
        [_fastMatchBtn setTitleColor:HEX_COLOR(@"#CCCCCC") forState:UIControlStateNormal];
        [_fastMatchBtn setTitle:@"等待队长开始匹配" forState:UIControlStateNormal];
        [_fastMatchBtn setImage:nil forState:UIControlStateNormal];
        _fastMatchBtn.titleEdgeInsets = UIEdgeInsetsZero;
        _fastMatchBtn.backgroundColor = HEX_COLOR_A(@"#FFFFFF", 0.4);
        _fastMatchBtn.userInteractionEnabled = NO;
    }
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.cancelBtn addTarget:self action:@selector(onCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.joinTeamBtn addTarget:self action:@selector(onJoinTeamBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.fastMatchBtn addTarget:self action:@selector(onFastMatchBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setGameItem:(HSGameItem *)gameItem {
    _gameItem = gameItem;
    [self dtUpdateUI];
}

- (void)setCaptainId:(NSInteger)captainId {
    _captainId = captainId;
    [self dtUpdateUI];
}

/// 更新用户列表
/// @param userList userList
- (void)updateUser:(NSArray <UserIndexInfo *> *)userList {

    _userList = userList;
    NSMutableArray *userIdList = NSMutableArray.new;
    for (UserIndexInfo *info in userList) {
        [userIdList addObject:@(info.userId)];
    }

    [UserService.shared asyncCacheUserInfo:userIdList forceRefresh:NO finished:^{
        [self updateSeatUserState:userList];
    }];
    [self showJoinState];
}

/// 更新用户内存状态信息
/// @param userList userList
- (void)updateSeatUserState:(NSArray <UserIndexInfo *> *)userList {
    NSMutableDictionary *newSeatIndexMap = NSMutableDictionary.new;
    for (UserIndexInfo *info in userList) {
        newSeatIndexMap[[NSString stringWithFormat:@"%@", @(info.index)]] = info;
    }
    // 重置不存在座位人信息
    for (int i = 0; i < self.seatViewList.count; ++i) {
        MatchSeatView *seatView = self.seatViewList[i];
        UserIndexInfo *info = newSeatIndexMap[[NSString stringWithFormat:@"%@", @(i)]];
        if (!info) {
            [seatView updateUser:nil isCaptain:NO];
        } else {
            HSUserInfoModel *user = [UserService.shared getCacheUserInfo:info.userId];
            [seatView updateUser:user isCaptain:user.userId == self.captainId];
        }
    }
}

- (void)setSeatCount:(NSInteger)seatCount {
    _seatCount = seatCount;
    NSInteger firstRowCount = seatCount / 2 - 1;
    NSInteger secondRowCount = seatCount - 1 - firstRowCount;
    if (seatCount <= 4) {
        firstRowCount = seatCount - 1;
        secondRowCount = 0;
    }
    NSArray *firstList = firstRowCount > 0 ? [self.seatViewList subarrayWithRange:NSMakeRange(1, firstRowCount)] : nil;
    NSArray *secondList = secondRowCount > 0 ? [self.seatViewList subarrayWithRange:NSMakeRange(firstRowCount + 1, secondRowCount)] : nil;

    for (UIView *v in firstList) {
        [self.firstRowView addSubview:v];
    }
    for (UIView *v in secondList) {
        [self.secondRowView addSubview:v];
    }
    CGFloat bigSeatWidth = 72;
    CGFloat defaultSeatWidth = 54;
    CGFloat marginL = (kScreenWidth - defaultSeatWidth * firstRowCount - bigSeatWidth - 28 - 32) / firstRowCount;
    [self.firstRowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(39);
        make.leading.equalTo(self.seatViewList[0].mas_trailing).offset(marginL);
        make.trailing.equalTo(@-14);
        make.height.greaterThanOrEqualTo(@0);
    }];

    [self.secondRowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstRowView.mas_bottom).offset(37);
        make.leading.equalTo(@14);
        make.trailing.equalTo(@-14);
        make.height.greaterThanOrEqualTo(@0);
    }];

    CGFloat firstViewLeft = seatCount == 2 ? 55 : 14;
    [self.seatViewList[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@(firstViewLeft));
        make.top.equalTo(self.iconImageView.mas_bottom).offset(30);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    if (firstList.count == 1) {
        [firstList[0] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@(-firstViewLeft));
            make.top.equalTo(@0);
            make.width.equalTo(@54);
            make.height.equalTo(@78);
        }];
    } else {
        [firstList dt_mas_distributeSudokuViewsWithFixedItemWidth:54 fixedItemHeight:78 warpCount:firstRowCount topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];
    }
    if (secondList.count > 1) {
        [secondList dt_mas_distributeSudokuViewsWithFixedItemWidth:54 fixedItemHeight:78 warpCount:secondRowCount topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];
    }
    for (int i = 0; i < self.seatViewList.count; ++i) {
        self.seatViewList[i].hidden = NO;
        if (i >= seatCount) {
            self.seatViewList[i].hidden = YES;
        }
    }
}

/// 处理座位点击
/// @param index
- (void)handleSeatClick:(NSInteger)index {
    MatchSeatView *view = self.seatViewMap[DT_STR(index)];
    if (self.clickSeatBlock) {
        self.clickSeatBlock(index, view.isExistUser);
    }
}

- (void)onCancelBtn:(id)sender {

    if (self.clickExitBlock) {
        self.clickExitBlock();
    }
    [self showJoinState];
}

- (void)onJoinTeamBtn:(id)sender {
    NSInteger index = -1;
    for (int i = 0; i < self.seatViewList.count; ++i) {
        MatchSeatView *v = self.seatViewList[i];
        if (!v.isExistUser) {
            index = v.index;
            break;
        }
    }
    if (index < 0) {
        [ToastUtil show:@"座位已满"];
        return;
    }
    if (self.clickJoinBlock) {
        self.clickJoinBlock(index);
    }
}

/// 一键匹配
- (void)onFastMatchBtn:(id)sender {
    if (self.clickMatchBlock) {
        self.clickMatchBlock();
    }
}

/// 展示加入状态
- (void)showJoinState {
    if (self.isMeInGroup) {
        self.joinTeamBtn.hidden = YES;
        self.cancelBtn.hidden = NO;
        self.fastMatchBtn.hidden = NO;
    } else {
        self.joinTeamBtn.hidden = NO;
        self.cancelBtn.hidden = YES;
        self.fastMatchBtn.hidden = YES;
    }
}

- (BOOL)isMeInGroup {
    for (UserIndexInfo *indexInfo in self.userList) {
        if ([AppService.shared.loginUserID isEqualToString:DT_STR(indexInfo.userId)]) {
            return YES;
        }
    }
    return NO;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = UIButton.new;
        _cancelBtn.titleLabel.font = UIFONT_MEDIUM(14);
        [_cancelBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"退出组队" forState:UIControlStateNormal];
        _cancelBtn.layer.borderColor = UIColor.whiteColor.CGColor;
        _cancelBtn.layer.borderWidth = 1;
    }
    return _cancelBtn;
}

- (UIButton *)joinTeamBtn {
    if (!_joinTeamBtn) {
        _joinTeamBtn = UIButton.new;
        _joinTeamBtn.titleLabel.font = UIFONT_MEDIUM(14);
        [_joinTeamBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_joinTeamBtn setTitle:@"我要加入" forState:UIControlStateNormal];
        _joinTeamBtn.backgroundColor = UIColor.whiteColor;
        _joinTeamBtn.hidden = true;
    }
    return _joinTeamBtn;
}

- (UIButton *)fastMatchBtn {
    if (!_fastMatchBtn) {
        _fastMatchBtn = UIButton.new;
        _fastMatchBtn.titleLabel.font = UIFONT_MEDIUM(14);
        [_fastMatchBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_fastMatchBtn setTitle:@"一键匹配玩伴" forState:UIControlStateNormal];
        [_fastMatchBtn setImage:[UIImage imageNamed:@"cross_app_fast_match"] forState:UIControlStateNormal];
        _fastMatchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
        _fastMatchBtn.backgroundColor = UIColor.whiteColor;
    }
    return _fastMatchBtn;
}


- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"cross_app_game_icon"];
    }
    return _iconImageView;
}

- (UIImageView *)rollingImageView {
    if (!_rollingImageView) {
        _rollingImageView = [[UIImageView alloc] init];
        _rollingImageView.image = [UIImage imageNamed:@"cross_app_game_rolling"];
    }
    return _rollingImageView;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
        _numLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}

- (UILabel *)searchLabel {
    if (!_searchLabel) {
        _searchLabel = [[UILabel alloc] init];
        _searchLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
        _searchLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _searchLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _searchLabel;
}

- (UILabel *)gameNameLabel {
    if (!_gameNameLabel) {
        _gameNameLabel = [[UILabel alloc] init];
        _gameNameLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
        _gameNameLabel.font = UIFONT_MEDIUM(16);
        _gameNameLabel.numberOfLines = 2;
    }
    return _gameNameLabel;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.backgroundColor = HEX_COLOR_A(@"#FFFFFF", 0.04);
        _bgView.layer.borderColor = HEX_COLOR_A(@"#FFFFFF", 0.06).CGColor;
        _bgView.layer.borderWidth = 1;
    }
    return _bgView;
}

- (UIView *)firstRowView {
    if (!_firstRowView) {
        _firstRowView = UIView.new;
    }
    return _firstRowView;
}

- (UIView *)secondRowView {
    if (!_secondRowView) {
        _secondRowView = UIView.new;
    }
    return _secondRowView;
}
@end
