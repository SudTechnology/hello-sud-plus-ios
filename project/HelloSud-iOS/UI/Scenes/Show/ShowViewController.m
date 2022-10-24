//
//  ShowViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/9.
//

#import "ShowViewController.h"
#import "ShowSendGiftView.h"

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

/// 请求切换房间
- (void)reqChangeToGameGameId:(int64_t)gameId operatorUser:(NSString *)userID {
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
    NSString *gameName = @"数字炸弹";
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
        make.height.equalTo(@30);
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
        [_marqueeBottomView dtAddGradientLayer:@[@(0.0f), @(1.0f)] colors:colorArr startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1) cornerRadius:0];
    }
    return _marqueeBottomView;
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
