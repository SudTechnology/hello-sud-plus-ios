//
//  ASRViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/18.
//

#import "ASRViewController.h"

#define I_GUESS_YOU_SAID      1468434504892882946L // 你说我猜
#define DIGITAL_BOMB          1468091457989509190L // 数字炸弹
#define YOU_DRAW_AND_I_GUESS  1461228410184400899L // 你画我猜

@interface ASRViewController ()
@property(nonatomic, strong) UIButton *btnTip;
@property(nonatomic, strong) UILabel *asrTipLabel;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, weak) id stateNTF;
@property(nonatomic, weak) id asrStateNTF;
@end

@implementation ASRViewController

- (void)dealloc {
    if (self.stateNTF) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.stateNTF];
    }
    if (self.asrStateNTF) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.asrStateNTF];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)dtAddViews {
    [super dtAddViews];
    [self.sceneView addSubview:self.asrTipLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.asrTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.height.mas_greaterThanOrEqualTo(0);
        make.width.mas_equalTo(230);
        make.bottom.equalTo(self.gameNumLabel);
    }];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    /// 游戏玩家状态变化
    self.stateNTF = [[NSNotificationCenter defaultCenter]addObserverForName:NTF_PLAYER_STATE_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf handlePlayerStateChanged];
    }];
    /// asr状态变化
    self.asrStateNTF = [[NSNotificationCenter defaultCenter]addObserverForName:NTF_ASR_STATE_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf handlePlayerStateChanged];
    }];

}

- (void)roomGameDidChanged:(NSInteger)gameID {
    [super roomGameDidChanged:gameID];
    [self.asrTipLabel setHidden:gameID == HSAudio];
}

/// 处理游戏状态变化
- (void)handlePlayerStateChanged {
    if (!self.sudFSMMGDecorator.keyWordASRing) {
        return;
    }
    // 正在游戏中 && 开麦按钮不打开时，提示用户
    if (self.gameId == DIGITAL_BOMB || self.gameId == YOU_DRAW_AND_I_GUESS) {
        if ([self.sudFSMMGDecorator isPlayerIsPlaying:AppService.shared.login.loginUserInfo.userID] && self.operatorView.voiceBtnState == VoiceBtnStateTypeWaitOpen) {
            [self showVoiceTip];
        }
    } else if (self.gameId == I_GUESS_YOU_SAID) {
        // 只要游戏中都提示
        if (self.sudFSMMGDecorator.isPlaying && self.operatorView.voiceBtnState == VoiceBtnStateTypeWaitOpen) {
            [self showVoiceTip];
        }
    }
}

- (void)showVoiceTip {

    if (!self.btnTip) {
        self.btnTip = [[UIButton alloc] init];
        UIImage *bgImage = [[UIImage imageNamed:@"voice_tip"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 50, 19, 49) resizingMode:UIImageResizingModeStretch];
        [self.btnTip setBackgroundImage:bgImage forState:UIControlStateNormal];
        NSString *tip = @"";
        if (self.gameId == DIGITAL_BOMB) {
            tip = NSString.dt_asr_open_mic_num_tip;
        } else {
            tip = NSString.dt_asr_open_mic_tip;
        }
        [self.btnTip setTitle:tip forState:UIControlStateNormal];
        [self.btnTip setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        self.btnTip.titleLabel.font = UIFONT_REGULAR(16);
        [self.btnTip setContentEdgeInsets:UIEdgeInsetsMake(0, 12, 12, 6)];
        [self.sceneView addSubview:self.btnTip];
        [self.btnTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_lessThanOrEqualTo(kScreenWidth - 32);
            make.height.mas_greaterThanOrEqualTo(0);
            make.bottom.equalTo(self.operatorView.mas_top).offset(0);
            make.leading.mas_equalTo(16);
        }];
        WeakSelf
        if (self.timer) {
            [self.timer invalidate];
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
    }
}

- (void)onTimer:(NSTimer *)timer {
    [self closeTip];
}

- (void)closeTip {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.btnTip removeFromSuperview];
    self.btnTip = nil;
}

- (UILabel *)asrTipLabel {
    if (!_asrTipLabel) {
        _asrTipLabel = [[UILabel alloc] init];
        _asrTipLabel.font = UIFONT_MEDIUM(11);
        _asrTipLabel.numberOfLines = 0;
        _asrTipLabel.textColor = UIColor.whiteColor;
        _asrTipLabel.text = NSString.dt_asr_tip;
    }
    return _asrTipLabel;
}
@end
