//
//  SwitchRoomModeView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "GameMatchingView.h"
#import "CrossAppSelectGameView.h"

@interface GameMatchingView ()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *numLabel;
@property(nonatomic, strong) UILabel *searchLabel;
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UIImageView *rollingImageView;
@property(nonatomic, strong) UIButton *cancelBtn;
@property(nonatomic, strong) UIButton *switchGameBtn;
@property(nonatomic, strong) UIButton *retryBtn;
@property(nonatomic, strong) UIButton *spectorBtn;
@property(nonatomic, strong) BaseView *spectorView;
@property(nonatomic, strong) DTTimer *timeOutTimer;
@property(nonatomic, assign) NSInteger totalMember;
@property(nonatomic, assign) NSInteger currentMember;
@property(nonatomic, assign) GameMatchingViewShowStateType stateType;
@property(nonatomic, assign) BOOL isAnimating;
@end

@implementation GameMatchingView


- (void)dtAddViews {

    [self addSubview:self.rollingImageView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.searchLabel];
    [self addSubview:self.numLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.switchGameBtn];
    [self addSubview:self.retryBtn];
    [self addSubview:self.spectorView];
    [self.spectorView addSubview:self.spectorBtn];
}

- (void)dtLayoutViews {

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.rollingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numLabel.mas_bottom).offset(33);
        make.width.height.equalTo(@240);
        make.centerX.equalTo(self);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@70);
        make.center.equalTo(self.rollingImageView);
    }];
    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(0);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.rollingImageView.mas_bottom).offset(15);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(168);
        make.bottom.mas_equalTo(0);
    }];
    [self.switchGameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.height.mas_equalTo(36);
        make.bottom.equalTo(self.cancelBtn);
    }];
    [self.retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.switchGameBtn.mas_trailing).offset(19);
        make.height.mas_equalTo(36);
        make.bottom.mas_equalTo(self.cancelBtn);
        make.width.equalTo(self.switchGameBtn);
        make.trailing.equalTo(@-16);
    }];
    [self.spectorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.retryBtn);
        make.width.equalTo(@248);
        make.height.equalTo(@36);
        make.centerX.equalTo(self);
    }];
    [self.spectorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(@0);
    }];

}

- (void)dtConfigUI {
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    [self.switchGameBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.height.mas_equalTo(36);
        make.bottom.equalTo(self.cancelBtn);
    }];
    [self.retryBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.switchGameBtn.mas_trailing).offset(19);
        make.height.mas_equalTo(36);
        make.bottom.mas_equalTo(self.cancelBtn);
        make.width.equalTo(self.switchGameBtn);
        make.trailing.equalTo(@-16);
    }];
    switch (self.stateType) {
        case GameMatchingViewShowStateTypeJoinMatching: {
            self.titleLabel.text = [NSString stringWithFormat:@"正在匹配【%@】的玩伴", self.gameItem.gameName];
            [self updateMatchNum];
            self.searchLabel.text = @"正在寻找玩伴…";
            self.cancelBtn.hidden = NO;
            self.switchGameBtn.hidden = YES;
            self.retryBtn.hidden = YES;
            self.spectorView.hidden = YES;
            [self showLoadingAnimate:YES];
        }
            break;
        case GameMatchingViewShowStateTypeUnJoinMatching: {
            self.titleLabel.text = [NSString stringWithFormat:@"正在匹配【%@】的玩伴", self.gameItem.gameName];
            [self updateMatchNum];
            self.searchLabel.text = @"正在寻找玩伴…";
            self.cancelBtn.hidden = YES;
            self.switchGameBtn.hidden = YES;
            self.retryBtn.hidden = YES;
            self.spectorView.hidden = NO;
            [self showLoadingAnimate:YES];
        }
            break;
        case GameMatchingViewShowStateTypeCaptainFailed: {
            // 队长失败
            self.cancelBtn.hidden = YES;
            self.switchGameBtn.hidden = NO;
            self.retryBtn.hidden = NO;
            self.searchLabel.text = @"啊哦，系统繁忙";
            self.titleLabel.text = @"暂匹配不到\n可重新匹配或者更换游戏";
            self.numLabel.text = @"";
            self.spectorView.hidden = YES;
            [self showLoadingAnimate:NO];
        }
        break;
        case GameMatchingViewShowStateTypeUnCaptainFailed: {
            // 非队长失败
            [self.retryBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self.rollingImageView.mas_bottom).offset(15);
                make.height.mas_equalTo(36);
                make.width.mas_equalTo(168);
                make.bottom.mas_equalTo(0);
            }];
            self.cancelBtn.hidden = YES;
            self.switchGameBtn.hidden = YES;
            self.retryBtn.hidden = NO;
            self.searchLabel.text = @"啊哦，系统繁忙";
            self.titleLabel.text = @"暂匹配不到\n可重新匹配";
            self.numLabel.text = @"";
            self.spectorView.hidden = YES;
            [self showLoadingAnimate:NO];
        }
            break;
        default: {
            self.cancelBtn.hidden = YES;
            self.switchGameBtn.hidden = YES;
            self.retryBtn.hidden = YES;
            self.searchLabel.text = @"啊哦，系统繁忙";
            self.titleLabel.text = @"暂匹配不到\n可重新匹配或者更换游戏";
            self.numLabel.text = @"";
            self.spectorView.hidden = NO;
            [self showLoadingAnimate:NO];
        }
    }
}

/// 更新匹配人数
- (void)updateMatchNum {
    NSMutableAttributedString *fullAttr = [[NSMutableAttributedString alloc] initWithString:DT_STR(self.currentMember)];
    fullAttr.yy_font = UIFONT_MEDIUM(18);
    fullAttr.yy_color = HEX_COLOR(@"#FFFFFF");

    NSMutableAttributedString *subtitleAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" /%@人", @(self.totalMember)]];
    subtitleAttr.yy_font = UIFONT_MEDIUM(14);
    subtitleAttr.yy_color = HEX_COLOR_A(@"#FFFFFF", 0.6);
    [fullAttr appendAttributedString:subtitleAttr];
    self.numLabel.attributedText = fullAttr;
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.cancelBtn addTarget:self action:@selector(onCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.switchGameBtn addTarget:self action:@selector(onSwitchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.retryBtn addTarget:self action:@selector(onRetryBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setGameItem:(HSGameItem *)gameItem {
    _gameItem = gameItem;
    self.totalMember = [AppService.shared getTotalGameCountWithGameID:self.gameItem.gameId];
    [self dtUpdateUI];
}

/// 展示状态
/// @param stateType stateType
- (void)showState:(GameMatchingViewShowStateType)stateType {
    if (_stateType == stateType) {
        return;
    }
    _stateType = stateType;
    [self dtUpdateUI];
}

/// 更新人数
/// @param current current
/// @param total total
- (void)updateMembers:(NSInteger)current total:(NSInteger)total {
    self.currentMember = current;
    self.totalMember = total;
    [self dtUpdateUI];
}

- (void)showLoadingAnimate:(BOOL)show {


    if (!show) {
        [self.rollingImageView.layer removeAllAnimations];
        self.isAnimating = NO;
        return;
    }
    if (self.isAnimating) {
        return;
    }
    self.isAnimating = YES;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = @(0);
    animation.toValue = @(M_PI * 2.0);
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]; // 动画效果慢进慢出
    animation.duration = 2; //动画持续时间
    animation.repeatCount = HUGE_VALF; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    animation.removedOnCompletion = NO; //动画后是否回到最初状态（配合kCAFillModeForwards使用）
    animation.fillMode = kCAFillModeForwards;
    [self.rollingImageView.layer addAnimation:animation forKey:@"rotation"];

}

- (void)beginTimeoutTimer {
    if (self.timeOutTimer) {
        [self.timeOutTimer stopTimer];
        self.timeOutTimer = nil;
    }
    WeakSelf
    self.timeOutTimer = [DTTimer timerWithTimeInterval:5 repeats:NO block:^(DTTimer *timer) {
        [weakSelf showState:GameMatchingViewShowStateTypeFailed];
    }];
}


- (void)onCancelBtn:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)onSwitchBtn:(id)sender {
    // 选择游戏
    if (self.selectGameBlock) {
        self.selectGameBlock();
    }
}

/// 重试
- (void)onRetryBtn:(id)sender {
    if (self.retryBlock) {
        self.retryBlock();
    }
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = UIButton.new;
        _cancelBtn.titleLabel.font = UIFONT_MEDIUM(14);
        [_cancelBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消匹配" forState:UIControlStateNormal];
        _cancelBtn.layer.borderColor = UIColor.whiteColor.CGColor;
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.hidden = true;
    }
    return _cancelBtn;
}

- (UIButton *)switchGameBtn {
    if (!_switchGameBtn) {
        _switchGameBtn = UIButton.new;
        _switchGameBtn.titleLabel.font = UIFONT_REGULAR(16);
        [_switchGameBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_switchGameBtn setTitle:@"更换游戏" forState:UIControlStateNormal];
        _switchGameBtn.layer.borderColor = UIColor.whiteColor.CGColor;
        _switchGameBtn.layer.borderWidth = 1;
        _switchGameBtn.hidden = true;
    }
    return _switchGameBtn;
}

- (UIButton *)retryBtn {
    if (!_retryBtn) {
        _retryBtn = UIButton.new;
        _retryBtn.titleLabel.font = UIFONT_REGULAR(16);
        [_retryBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_retryBtn setTitle:@"重新匹配" forState:UIControlStateNormal];
        _retryBtn.backgroundColor = UIColor.whiteColor;
    }
    return _retryBtn;
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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIButton *)spectorBtn {
    if (!_spectorBtn) {
        _spectorBtn = UIButton.new;
        _spectorBtn.titleLabel.font = UIFONT_REGULAR(14);
        [_spectorBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_spectorBtn setTitle:@"未加入队伍，围观中" forState:UIControlStateNormal];
        [_spectorBtn setImage:[UIImage imageNamed:@"cross_app_spector"] forState:UIControlStateNormal];
        _spectorBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    }
    return _spectorBtn;
}

- (BaseView *)spectorView {

    if (!_spectorView) {
        _spectorView = BaseView.new;
        NSArray *colorArr = @[(id) [UIColor dt_colorWithHexString:@"#000000" alpha:0].CGColor, (id) [UIColor dt_colorWithHexString:@"#000000" alpha:0.2].CGColor, (id) [UIColor dt_colorWithHexString:@"#000000" alpha:0].CGColor];
        [_spectorView dtAddGradientLayer:@[@(0.0f), @(0.5), @(1.0f)] colors:colorArr startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) cornerRadius:0];
    }
    return _spectorView;
}

@end
