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

- (void)dtAddViews {
    [super dtAddViews];
    [self.sceneView addSubview:self.ivShowPlayGame];
    [self.sceneView addSubview:self.playLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
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
