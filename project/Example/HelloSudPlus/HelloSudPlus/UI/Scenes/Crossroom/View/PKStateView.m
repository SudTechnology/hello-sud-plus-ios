//
// Created by kaniel on 2022/4/20.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "PKStateView.h"
#import "PKSelectRoomView.h"
#import "PKRuleView.h"

@interface PKStateView ()
@property(nonatomic, strong) UIImageView *bgImageView;
/// 左方视图
@property(nonatomic, strong) UIImageView *leftHeaderImageView;
@property(nonatomic, strong) UIImageView *leftResultImageView;
@property(nonatomic, strong) UILabel *leftNameLabel;
@property(nonatomic, strong) UILabel *leftScoreLabel;
/// 右方视图
@property(nonatomic, strong) UIImageView *rightHeaderImageView;
@property(nonatomic, strong) UIImageView *rightResultImageView;
@property(nonatomic, strong) UILabel *rightNameLabel;
@property(nonatomic, strong) UILabel *rightScoreLabel;
/// 进度条
@property(nonatomic, strong) UIView *progressView;
@property(nonatomic, strong) UIView *leftProgressView;
@property(nonatomic, strong) UIView *rightProgressView;
/// 中间PK状态图片
@property(nonatomic, strong) UIImageView *pkCenterImageView;
@property(nonatomic, strong) DTSVGAPlayerView *pkAnimateView;
@property(nonatomic, strong) UIImageView *pkDrawImageView;
/// 中间状态视图
@property(nonatomic, strong) UIView *centerStateView;
@property(nonatomic, strong) UILabel *centerStateLabel;
@property(nonatomic, strong) UIButton *centerRuleBtn;
/// 倒计时
@property(nonatomic, assign) NSInteger countdown;
/// 倒计时定时器
@property(nonatomic, strong) DTTimer *timer;
@property (nonatomic, strong)AudioUserModel *leftUserInfo;
@property (nonatomic, strong)AudioUserModel *rightUserInfo;
@property (nonatomic, assign)NSInteger leftScore;
@property (nonatomic, assign)NSInteger rightScore;

@property(nonatomic, assign) NSTimeInterval enterBackgroundTimeStamp;
@property(nonatomic, assign) NSInteger pauseCountdown;
@end

@implementation PKStateView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/// 更新红蓝分数
/// @param leftScore leftScore
/// @param rightScore rightScore
- (void)updateLeftScore:(NSInteger)leftScore rightScore:(NSInteger)rightScore {

    NSLog(@"leftScore:%@, rightScore:%@", @(leftScore), @(rightScore));
    self.leftScore = leftScore;
    self.rightScore = rightScore;
    self.leftScoreLabel.text = [NSString stringWithFormat:@"%ld", (NSInteger)leftScore];
    self.rightScoreLabel.text = [NSString stringWithFormat:@"%ld", (NSInteger)rightScore];
    CGFloat total = leftScore + rightScore;
    CGFloat scale = total > 0 ? leftScore / total : 0.5;
    CGFloat baseX = 80;// 预留基准值
    CGFloat redWidth = baseX + (kScreenWidth - 2 * baseX) * scale;

    [UIView animateWithDuration:0.25 animations:^{
        [self.leftProgressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(redWidth);
        }];
        [self layoutIfNeeded];
    }];
}

/// 更新红方资料
/// @param user
- (void)updateLeftUserInfo:(AudioUserModel *)user {
    if (!user) {
        self.leftHeaderImageView.image = nil;
        self.leftNameLabel.text = nil;
        return;
    }
    if (user.icon) {
        NSURL *url = [[NSURL alloc] initWithString:user.icon];
        [self.leftHeaderImageView sd_setImageWithURL:url];
    }
    self.leftUserInfo = user;
    self.leftNameLabel.text = user.name;
}

/// 更新蓝方资料
/// @param user
- (void)updateRightUserInfo:(AudioUserModel *)user {
    if (!user) {
        self.rightHeaderImageView.image = [UIImage imageNamed:@"pk_add"];;
        self.rightNameLabel.text = NSString.dt_room_empty_seat;
        self.rightUserInfo = nil;
        return;
    }
    if (user.icon) {
        NSURL *url = [[NSURL alloc] initWithString:user.icon];
        [self.rightHeaderImageView sd_setImageWithURL:url];
    }
    self.rightUserInfo = user;
    self.rightNameLabel.text = user.name;
}

/// 更新红蓝方
/// @param isRedInLeft 是否红方在左侧
- (void)changeRedInLeft:(BOOL)isRedInLeft {
    if (isRedInLeft) {
        self.leftProgressView.backgroundColor = HEX_COLOR(@"#FF2959");
        self.leftHeaderImageView.layer.borderColor = HEX_COLOR(@"#FF2959").CGColor;

        self.rightProgressView.backgroundColor = HEX_COLOR(@"#39BDFF");
        self.rightHeaderImageView.layer.borderColor = HEX_COLOR(@"#39BDFF").CGColor;
    } else {
        self.leftProgressView.backgroundColor = HEX_COLOR(@"#39BDFF");
        self.leftHeaderImageView.layer.borderColor = HEX_COLOR(@"#39BDFF").CGColor;

        self.rightProgressView.backgroundColor = HEX_COLOR(@"#FF2959");
        self.rightHeaderImageView.layer.borderColor = HEX_COLOR(@"#FF2959").CGColor;
    }
}

/// 开启倒计时
/// @param second second
- (void)startCountdown:(NSTimeInterval)second {
    [self startTimer:second];
    if (self.pkAnimateView.playState != HSSVGAPlayerStateTypePlaying) {
        [self.pkAnimateView play:100000000 didFinished:nil];
    }
    self.pkAnimateView.hidden = NO;
    self.pkCenterImageView.hidden = YES;
}

/// 重置倒计时，清空蓝方
- (void)resetCountdown {
    [self stopTimer];
    self.centerStateLabel.text = NSString.dt_room_to_be_started;
    self.pkCenterImageView.hidden = NO;
    self.pkAnimateView.hidden = YES;
    [self resetResult];
    [self updateRightUserInfo:nil];
    [self updateLeftScore:0 rightScore:0];
}

/// 重置结果
- (void)resetResult {
    self.leftScoreLabel.text = @"0";
    self.rightScoreLabel.text = @"0";
    self.leftResultImageView.image = nil;
    self.rightResultImageView.image = nil;
    self.pkDrawImageView.hidden = YES;
    self.leftScore = 0;
    self.rightScore = 0;
    [self updateLeftScore:0 rightScore:0];
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer stopTimer];
        self.timer = nil;
    }
}

- (void)startTimer:(NSTimeInterval)second {
    WeakSelf
    [self stopTimer];
    self.countdown = second;
    [self showCountdown:self.countdown];
    self.timer = [DTTimer timerWithTimeInterval:1 repeats:YES block:^(DTTimer *timer) {
        [weakSelf updateCountdown];
    }];
}

/// 更新倒计时
- (void)updateCountdown {
    self.countdown--;
    if (self.countdown <= 0) {
        [self stopTimer];
        [self updatePKResult];
        if (self.countdownFinishedBlock) {
            self.countdownFinishedBlock();
        }
        return;
    }
    [self showCountdown:self.countdown];
}

- (void)showCountdown:(NSInteger)countdown {
    NSInteger minutes = countdown / 60;
    NSInteger seconds = countdown - minutes * 60;
    self.centerStateLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, seconds];
}

/// 更新pk结果
- (void)updatePKResult {
    self.centerStateLabel.text = NSString.dt_room_closed;
    if (self.leftScore > self.rightScore) {
        self.leftResultImageView.image = [UIImage imageNamed:@"pk_win"];
        self.rightResultImageView.image = [UIImage imageNamed:@"pk_lose"];
        self.pkDrawImageView.hidden = YES;
        self.leftResultImageView.hidden = NO;
        self.rightResultImageView.hidden = NO;
    } else if (self.leftScore < self.rightScore) {
        self.leftResultImageView.image = [UIImage imageNamed:@"pk_lose"];
        self.rightResultImageView.image = [UIImage imageNamed:@"pk_win"];
        self.pkDrawImageView.hidden = YES;
        self.leftResultImageView.hidden = NO;
        self.rightResultImageView.hidden = NO;
    } else {
        self.pkDrawImageView.hidden = NO;
        self.leftResultImageView.hidden = YES;
        self.rightResultImageView.hidden = YES;
    }
}

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.bgImageView];
    [self addSubview:self.progressView];

    [self.progressView addSubview:self.leftProgressView];
    [self.progressView addSubview:self.rightProgressView];

    [self addSubview:self.pkCenterImageView];
    [self addSubview:self.pkAnimateView];
    [self addSubview:self.pkDrawImageView];
    [self addSubview:self.leftHeaderImageView];
    [self addSubview:self.leftNameLabel];
    [self addSubview:self.leftScoreLabel];
    [self addSubview:self.leftResultImageView];

    [self addSubview:self.rightHeaderImageView];
    [self addSubview:self.rightNameLabel];
    [self addSubview:self.rightScoreLabel];
    [self addSubview:self.rightResultImageView];

    [self addSubview:self.centerStateView];
    [self.centerStateView addSubview:self.centerStateLabel];
    [self.centerStateView addSubview:self.centerRuleBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    [self.leftProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.height.equalTo(self.progressView);
        make.width.mas_equalTo(kScreenWidth / 2);
    }];
    [self.rightProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.progressView);
        make.leading.equalTo(self.leftProgressView.mas_trailing);
        make.trailing.mas_equalTo(0);
    }];
    [self.pkCenterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(54);
        make.height.mas_equalTo(27);
        make.centerX.equalTo(self.progressView);
        make.bottom.equalTo(self.progressView);
    }];
    [self.pkAnimateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
        make.centerX.equalTo(self.leftProgressView.mas_right);
        make.centerY.equalTo(self.progressView);
    }];
    [self.pkDrawImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(76);
        make.height.mas_equalTo(24);
        make.centerX.equalTo(self.progressView);
        make.bottom.equalTo(self.progressView);
    }];
    [self.leftHeaderImageView dt_cornerRadius:18];
    [self.leftHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(6);
        make.width.height.mas_equalTo(36);
    }];
    [self.leftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leftHeaderImageView.mas_trailing).offset(6);
        make.top.equalTo(self.leftHeaderImageView).offset(2);
        make.width.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.leftScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leftNameLabel);
        make.centerY.equalTo(self.progressView);
        make.width.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.leftResultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@68);
        make.height.equalTo(@22);
        make.leading.equalTo(@(-6));
        make.bottom.equalTo(@0);
    }];

    [self.rightHeaderImageView dt_cornerRadius:18];
    [self.rightHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.top.equalTo(self.leftHeaderImageView);
        make.width.height.equalTo(self.leftHeaderImageView);
    }];
    [self.rightNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.rightHeaderImageView.mas_leading).offset(-6);
        make.top.equalTo(self.rightHeaderImageView).offset(2);
        make.width.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.rightScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.rightNameLabel);
        make.centerY.equalTo(self.progressView);;
        make.width.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.rightResultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.width.equalTo(@68);
       make.height.equalTo(@22);
       make.trailing.equalTo(@6);
       make.bottom.equalTo(@0);
    }];

    [self.centerStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.progressView);
        make.top.mas_equalTo(0);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_equalTo(26);
    }];
    [self.centerStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.width.mas_lessThanOrEqualTo(80);
        make.height.mas_greaterThanOrEqualTo(0);
        make.centerY.equalTo(self.centerStateView);
        make.trailing.equalTo(self.centerRuleBtn.mas_leading).offset(0);
    }];
    [self.centerRuleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.width.height.mas_equalTo(26);
        make.trailing.mas_equalTo(-5);
    }];

}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.centerRuleBtn addTarget:self action:@selector(onRuleBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer *tapAdd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAdd:)];
    [self.rightHeaderImageView addGestureRecognizer:tapAdd];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

/// PK规则点击按钮
- (void)onRuleBtnClick:(UIButton *)sender {
    PKRuleView *v = [[PKRuleView alloc] init];
    [DTSheetView show:v onCloseCallback:^{

    }];
}

/// 点击PK邀请
- (void)onTapAdd:(UITapGestureRecognizer *)tap {
    if (self.blueBtnClickBlock) {
        self.blueBtnClickBlock();
    }
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"pk_bg"];
    }
    return _bgImageView;
}

- (UIImageView *)pkCenterImageView {
    if (!_pkCenterImageView) {
        _pkCenterImageView = [[UIImageView alloc] init];
        _pkCenterImageView.image = [UIImage imageNamed:@"pk_icon"];
    }
    return _pkCenterImageView;
}

- (UIImageView *)pkDrawImageView {
    if (!_pkDrawImageView) {
        _pkDrawImageView = [[UIImageView alloc] init];
        _pkDrawImageView.image = [UIImage imageNamed:@"pk_draw"];
        _pkDrawImageView.hidden = YES;
    }
    return _pkDrawImageView;
}

- (DTSVGAPlayerView *)pkAnimateView {
    if (!_pkAnimateView) {
        _pkAnimateView = [[DTSVGAPlayerView alloc] init];
        NSString *path = [NSBundle.mainBundle pathForResource:@"pk_animate" ofType:@"svga" inDirectory:@"Res"];
        if (path) {
            [_pkAnimateView setURL:[NSURL fileURLWithPath:path]];
        }
    }
    return _pkAnimateView;
}

- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [[UIView alloc] init];
    }
    return _progressView;
}

- (UIView *)leftProgressView {
    if (!_leftProgressView) {
        _leftProgressView = [[UIView alloc] init];
        _leftProgressView.backgroundColor = HEX_COLOR(@"#FF2959");
    }
    return _leftProgressView;
}

- (UIView *)rightProgressView {
    if (!_rightProgressView) {
        _rightProgressView = [[UIView alloc] init];
        _rightProgressView.backgroundColor = HEX_COLOR(@"#39BDFF");
    }
    return _rightProgressView;
}

- (UIImageView *)leftHeaderImageView {
    if (!_leftHeaderImageView) {
        _leftHeaderImageView = [[UIImageView alloc] init];
        _leftHeaderImageView.layer.borderWidth = 0.5;
    }
    return _leftHeaderImageView;
}

- (UIImageView *)leftResultImageView {
    if (!_leftResultImageView) {
        _leftResultImageView = [[UIImageView alloc] init];
    }
    return _leftResultImageView;
}

- (UILabel *)leftNameLabel {
    if (!_leftNameLabel) {
        _leftNameLabel = [[UILabel alloc] init];
        _leftNameLabel.font = UIFONT_MEDIUM(10);
        _leftNameLabel.textColor = UIColor.whiteColor;
        _leftNameLabel.text = NSString.dt_room_empty_seat;
    }
    return _leftNameLabel;
}

- (UILabel *)leftScoreLabel {
    if (!_leftScoreLabel) {
        _leftScoreLabel = [[UILabel alloc] init];
        _leftScoreLabel.font = UIFONT_MEDIUM(12);
        _leftScoreLabel.textColor = UIColor.whiteColor;
        _leftScoreLabel.text = @"0";
    }
    return _leftScoreLabel;
}

- (UIImageView *)rightHeaderImageView {
    if (!_rightHeaderImageView) {
        _rightHeaderImageView = [[UIImageView alloc] init];
        _rightHeaderImageView.image = [UIImage imageNamed:@"pk_add"];
        _rightHeaderImageView.userInteractionEnabled = YES;
        _rightHeaderImageView.layer.borderWidth = 0.5;
    }
    return _rightHeaderImageView;
}

- (UIImageView *)rightResultImageView {
    if (!_rightResultImageView) {
        _rightResultImageView = [[UIImageView alloc] init];
    }
    return _rightResultImageView;
}

- (UILabel *)rightNameLabel {
    if (!_rightNameLabel) {
        _rightNameLabel = [[UILabel alloc] init];
        _rightNameLabel.font = UIFONT_MEDIUM(10);
        _rightNameLabel.textColor = UIColor.whiteColor;
        _rightNameLabel.text = NSString.dt_room_empty_seat;
    }
    return _rightNameLabel;
}

- (UILabel *)rightScoreLabel {
    if (!_rightScoreLabel) {
        _rightScoreLabel = [[UILabel alloc] init];
        _rightScoreLabel.font = UIFONT_MEDIUM(12);
        _rightScoreLabel.textColor = UIColor.whiteColor;
        _rightScoreLabel.text = @"0";
    }
    return _rightScoreLabel;
}

- (UIView *)centerStateView {
    if (!_centerStateView) {
        _centerStateView = [[UIView alloc] init];
        _centerStateView.backgroundColor = HEX_COLOR_A(@"#000000", 0.5);
    }
    return _centerStateView;
}

- (UILabel *)centerStateLabel {
    if (!_centerStateLabel) {
        _centerStateLabel = [[UILabel alloc] init];
        _centerStateLabel.font = UIFONT_MEDIUM(16);
        _centerStateLabel.textColor = UIColor.whiteColor;
        _centerStateLabel.text = NSString.dt_room_to_be_started;
    }
    return _centerStateLabel;
}

- (UIButton *)centerRuleBtn {
    if (!_centerRuleBtn) {
        _centerRuleBtn = [[UIButton alloc] init];
        [_centerRuleBtn setImage:[UIImage imageNamed:@"pk_rule"] forState:UIControlStateNormal];
    }
    return _centerRuleBtn;
}

/// 进入前台
- (void)onAppEnterForeground:(id)ntf {

    if (!self.timer) {
        DDLogDebug(@"timer not start, don't calculate this countdown");
        return;
    }
    NSTimeInterval pass = [[NSDate date] timeIntervalSince1970] - self.enterBackgroundTimeStamp;
    self.countdown = (self.pauseCountdown - (NSInteger)pass);
    [self updateCountdown];
}

/// 进入后台
- (void)onAppEnterBackground:(id)ntf {
    self.enterBackgroundTimeStamp = [[NSDate date] timeIntervalSince1970];
    self.pauseCountdown = self.countdown;
}
@end
