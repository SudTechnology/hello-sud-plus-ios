//
//  ShowViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/9.
//

#import "ShowViewController.h"
#import "ShowSendGiftView.h"
#import "PanMoveBaseView.h"

@interface ShowViewController ()
@property(nonatomic, strong) UIImageView *ivShowPlayGame;
@property(nonatomic, strong) MarqueeLabel *playLabel;
@property(nonatomic, strong) UIView *videoView;
@property(nonatomic, strong) BaseView *marqueeBottomView;
@property(nonatomic, strong) MarqueeLabel *giftMsgLabel;
@property(nonatomic, strong) PanMoveBaseView *gameStateView;
@property(nonatomic, strong) UIImageView *gameIconImageView;
@property(nonatomic, strong) UILabel *gameStateLabel;
@property(nonatomic, strong) HSGameItem *currentGameItem;
/// 是否适配处于缩放状态
@property(nonatomic, assign) BOOL isVideoInScaleMode;
@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.sceneView insertSubview:self.videoView atIndex:0];
    [self.sceneView addSubview:self.marqueeBottomView];
    [self.marqueeBottomView addSubview:self.giftMsgLabel];
    [self.sceneView addSubview:self.ivShowPlayGame];
    [self.sceneView addSubview:self.playLabel];

    [self.sceneView addSubview:self.gameStateView];
    [self.gameStateView addSubview:self.gameIconImageView];
    [self.gameStateView addSubview:self.gameStateLabel];
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
        make.height.equalTo(@30);
        make.centerY.equalTo(self.marqueeBottomView);
    }];
    [self.operatorView hiddenVoiceBtn:YES];

    [self.gameStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.top.equalTo(@(kAppSafeTop + 64));
        make.width.equalTo(@80);
        make.height.equalTo(@107);
    }];
    [self.gameIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(@10);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];

    [self.gameStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
        make.top.equalTo(self.gameIconImageView.mas_bottom).offset(9);
    }];

}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPlayView:)];
    [self.ivShowPlayGame addGestureRecognizer:tap];
//    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapVideoView:)];
//    [self.videoView addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGameStateView:)];
    [self.gameStateView addGestureRecognizer:tap3];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.gameStateView.backgroundColor = UIColor.blackColor;
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
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

/// 请求切换房间
- (void)reqChangeToGameGameId:(int64_t)gameId operatorUser:(NSString *)userID {
    if (gameId == 0) {
        [super reqChangeToGameGameId:gameId operatorUser:userID];
        return;
    }
    ShowSendGiftView *v = ShowSendGiftView.new;
    v.sureBlock = ^{
        [DTAlertView close];
        // 先切换游戏
        [super reqChangeToGameGameId:gameId operatorUser:userID];
        [HSThreadUtils dispatchMainAfter:1 callback:^{
            // 发送礼物消息
            [self sendGiftMsg];
        }];
    };
    v.cancelBlock = ^{
        [DTAlertView close];
    };
    [DTAlertView show:v rootView:nil clickToClose:NO showDefaultBackground:YES onCloseCallback:nil];
}

/// 游戏已经发生切换
- (void)roomGameDidChanged:(NSInteger)gameID {
    [super roomGameDidChanged:gameID];
    self.currentGameItem = [AppService.shared getGameInfo:self.configModel.enterRoomModel.sceneType gameId:gameID];
    [self changeVideoUIState:gameID > 0];
}

/// 改变视频UI状态
/// @param bScaleVideoView
- (void)changeVideoUIState:(BOOL)bScaleVideoView {
    if (bScaleVideoView) {
        // 缩小
        self.isVideoInScaleMode = YES;
        [self.gameStateView addSubview:self.videoView];
        [self.videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.top.equalTo(@0);
            make.width.equalTo(@80);
            make.height.equalTo(@107);
        }];
        self.gameView.alpha = 1;
    } else {
        // 放大
        self.isVideoInScaleMode = NO;
        self.gameView.alpha = 0;
        [self.sceneView insertSubview:self.videoView atIndex:0];
        [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.equalTo(@0);
        }];
        [self.gameStateView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@16);
            make.top.equalTo(@(kAppSafeTop + 64));
            make.width.equalTo(@80);
            make.height.equalTo(@107);
        }];
    }
    if (self.currentGameItem && self.currentGameItem.gamePic) {
        [self.gameIconImageView sd_setImageWithURL:[[NSURL alloc] initWithString:self.currentGameItem.gamePic]];
    } else {
        self.gameIconImageView.image = nil;
    }
    self.gameStateView.hidden = self.gameId > 0 ? NO : YES;
}

/// 发送礼物
- (void)sendGiftMsg {

    GiftModel *giftModel = [GiftService.shared giftByID:8];
    AudioUserModel *toUser = AudioUserModel.new;
    toUser.userID = @"0";
    toUser.name = @"主播";
    toUser.roomID = self.roomID;
    RoomCmdSendGiftModel *giftMsg = [RoomCmdSendGiftModel makeMsgWithGiftID:giftModel.giftID giftCount:1 toUser:toUser];
    giftMsg.type = giftModel.type;
    giftMsg.giftUrl = giftModel.giftURL;
    giftMsg.animationUrl = giftModel.animateURL;
    giftMsg.giftName = giftModel.giftName;
    [self sendMsg:giftMsg isAddToShow:YES finished:nil];
}

/// 处理礼物动效
/// @param model model description
- (void)handleGiftEffect:(RoomCmdSendGiftModel *)model {
    [super handleGiftEffect:model];
    [self showGiftMarquee:model];
}

- (void)showGiftMarquee:(RoomCmdSendGiftModel *)model {
    NSString *gameName = self.currentGameItem.gameName;
    NSMutableAttributedString *attrFull = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 送出", model.sendUser.name]];
    attrFull.yy_baselineOffset = @(8);
    NSAttributedString *attr = [NSMutableAttributedString dt_attrWithImage:[UIImage imageNamed:@"gift_heart"] size:CGSizeMake(30, 30) offsetY:-2];
    NSMutableAttributedString *attrTail = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"x%@ %@ 玩【%@】", @(model.giftCount), model.toUser.name, gameName]];
    attrTail.yy_baselineOffset = @(8);
    [attrFull appendAttributedString:attr];
    [attrFull appendAttributedString:attrTail];
    NSRange range = [attrFull yy_rangeOfAll];
    [attrFull addAttributes:@{NSFontAttributeName: UIFONT_MEDIUM(14), NSForegroundColorAttributeName: HEX_COLOR(@"#FFFFFF")} range:range];
    self.giftMsgLabel.attributedText = attrFull;
    self.marqueeBottomView.hidden = NO;
    // 3秒消失
    [self performSelector:@selector(handleCloseGiftMarquee) withObject:self afterDelay:3];
}


- (void)handleCloseGiftMarquee {
    [HSThreadUtils runOnUiThread:^{
        self.marqueeBottomView.hidden = YES;
    }];
}


- (void)onTapPlayView:(id)tap {
    [self showSelectGameView];
}

- (void)onTapVideoView:(id)tap {
    [self changeVideoUIState:NO];
}

- (void)onTapGameStateView:(id)tap {
    [self changeVideoUIState:!self.isVideoInScaleMode];
}

- (BaseView *)marqueeBottomView {
    if (!_marqueeBottomView) {
        _marqueeBottomView = BaseView.new;
        _marqueeBottomView.hidden = YES;
        NSArray *colorArr = @[(id) [UIColor dt_colorWithHexString:@"#FEA755" alpha:1].CGColor, (id) [UIColor dt_colorWithHexString:@"#FF5938" alpha:1].CGColor];
        [_marqueeBottomView dtAddGradientLayer:@[@(0.0f), @(1.0f)] colors:colorArr startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1) cornerRadius:0];
    }
    return _marqueeBottomView;
}

- (PanMoveBaseView *)gameStateView {
    if (!_gameStateView) {
        _gameStateView = PanMoveBaseView.new;
        _gameStateView.hidden = YES;
    }
    return _gameStateView;
}

- (UIImageView *)gameIconImageView {
    if (!_gameIconImageView) {
        _gameIconImageView = UIImageView.new;
        _gameIconImageView.userInteractionEnabled = YES;
    }
    return _gameIconImageView;
}

- (UILabel *)gameStateLabel {
    if (!_gameStateLabel) {
        _gameStateLabel = UILabel.new;
        _gameStateLabel.font = UIFONT_MEDIUM(14);
        _gameStateLabel.textColor = UIColor.whiteColor;
        _gameStateLabel.textAlignment = NSTextAlignmentCenter;
        _gameStateLabel.text = @"游戏中...";
    }
    return _gameStateLabel;
}


- (MarqueeLabel *)giftMsgLabel {
    if (!_giftMsgLabel) {
        _giftMsgLabel = MarqueeLabel.new;
        _giftMsgLabel.font = UIFONT_MEDIUM(14);
        _giftMsgLabel.textColor = UIColor.whiteColor;
        _giftMsgLabel.textAlignment = NSTextAlignmentCenter;
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
