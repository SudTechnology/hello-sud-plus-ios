//
//  ShowViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/9.
//

#import "ShowViewController.h"

@interface ShowViewController ()
@property(nonatomic, strong) UIImageView *ivShowPlayGame;
@property(nonatomic, strong) MarqueeLabel *playLabel;
@property(nonatomic, strong) UIView *videoView;
@property(nonatomic, strong) BaseView *marqueeBottomView;
@property(nonatomic, strong) MarqueeLabel *giftMsgLabel;
@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (Class)serviceClass {
    return AudioRoomService.class;
}

/// 是否显示添加通用机器人按钮
- (BOOL)isShowAddRobotBtn {
    return NO;
}

/// 是否加载通用机器人
- (BOOL)isLoadCommonRobotList {
    return NO;
}

/// 是否展示游戏麦位区域
- (BOOL)isShowGameMic {
    return NO;
}

/// 是否展示语音试图
- (BOOL)isShowAudioContent {
    return NO;
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.sceneView insertSubview:self.videoView atIndex:0];
    [self.sceneView addSubview:self.marqueeBottomView];
    [self.marqueeBottomView addSubview:self.giftMsgLabel];
    [self.sceneView addSubview:self.ivShowPlayGame];
    [self.sceneView addSubview:self.playLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(@0);
    }];
    CGFloat bottom = kAppSafeBottom + 51;
    [self.ivShowPlayGame mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-18);
        make.width.equalTo(@80);
        make.height.equalTo(@90);
        make.bottom.equalTo(@(-bottom));
    }];
    [self.playLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.ivShowPlayGame);
        make.height.equalTo(@15);
        make.bottom.equalTo(self.ivShowPlayGame).offset(-7);
    }];

    [self.marqueeBottomView dt_cornerRadius:15];
    [self.marqueeBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@14);
        make.trailing.equalTo(@-14);
        make.height.equalTo(@30);
        make.top.equalTo(self.naviView.mas_bottom).offset(10);
    }];
    [self.giftMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@10);
        make.trailing.equalTo(@-10);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.marqueeBottomView);
    }];
    [self.operatorView hiddenVoiceBtn:YES];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPlayView:)];
    [self.ivShowPlayGame addGestureRecognizer:tap];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
}

- (void)onTapPlayView:(id)tap {
    [self showSelectGameView];
}

- (BaseView *)marqueeBottomView {
    if (!_marqueeBottomView) {
        _marqueeBottomView = BaseView.new;
        NSArray *colorArr = @[(id) [UIColor dt_colorWithHexString:@"#FEA755" alpha:1].CGColor, (id) [UIColor dt_colorWithHexString:@"#FF5938" alpha:1].CGColor];
        [_marqueeBottomView dtAddGradientLayer:@[@(0.0f), @(0.0f)] colors:colorArr startPoint:CGPointMake(1, 1) endPoint:CGPointMake(1, 1) cornerRadius:0];
    }
    return _marqueeBottomView;
}

- (MarqueeLabel *)giftMsgLabel {
    if (!_giftMsgLabel) {
        _giftMsgLabel = MarqueeLabel.new;
        _giftMsgLabel.font = UIFONT_MEDIUM(14);
        _giftMsgLabel.textColor = UIColor.whiteColor;
        _giftMsgLabel.textAlignment = NSTextAlignmentCenter;
        _giftMsgLabel.text = @"星之卡比 送出       x1 邀请主播玩【数字炸弹】";
    }
    return _giftMsgLabel;
}

- (UIView *)videoView {
    if (!_videoView) {
        _videoView = UIView.new;
        _videoView.backgroundColor = UIColor.greenColor;
    }
    return _videoView;
}

- (UIImageView *)ivShowPlayGame {
    if (!_ivShowPlayGame) {
        _ivShowPlayGame = UIImageView.new;
        _ivShowPlayGame.image = [UIImage imageNamed:@"show_play_game"];
        _ivShowPlayGame.userInteractionEnabled = YES;
    }
    return _ivShowPlayGame;
}

- (MarqueeLabel *)playLabel {
    if (!_playLabel) {
        _playLabel = MarqueeLabel.new;
        _playLabel.font = UIFONT_SEMI_BOLD(10);
        _playLabel.textColor = UIColor.whiteColor;
        _playLabel.textAlignment = NSTextAlignmentCenter;
        _playLabel.text = @"和主播玩游戏";
    }
    return _playLabel;
}
@end
