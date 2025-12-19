//
//  SudAdCollectionViewCell.m
//  HelloSudPlus
//
//  Created by kaniel on 9/16/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SudAdCollectionViewCell.h"
#import "SudAdAnimateView.h"


@interface SudAdCollectionViewCell ()
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property(nonatomic, strong)UIView *vGame;
@property(nonatomic, strong)UIView *vGameCover;
@property(nonatomic, strong)UIView *vGameBottom;
@property(nonatomic, strong)UIImageView *ivGameBg;
@property(nonatomic, strong)UIButton *btnPlay;

@property(nonatomic, strong)UIView *vGameFinished;
@property(nonatomic, strong)UIView *vGameCard;
@property(nonatomic, strong)UIImageView *ivGameCard;
@property(nonatomic, strong)UIView *vGameCardDetail;
@property(nonatomic, strong)UIImageView *ivGameCardIcon;
@property(nonatomic, strong)UILabel *labGameName;
@property(nonatomic, strong)UIView *vLine;
@property(nonatomic, strong)UIButton *btnAgain;
@property(nonatomic, strong)UIButton *btnJump;
@property(nonatomic, strong)UIButton *btnClose;

@property(nonatomic, weak)UIView *gameView;
@property(nonatomic, strong)AVPlayerLooper *looper;
@property(nonatomic, strong)SudAdAnimateView *vAnimate;

@property(nonatomic, assign)BOOL isWillShow;// cell 是否即将展示
@end

@implementation SudAdCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)dealloc {
    DDLogDebug(@"SudAdCollectionViewCell dealloc");
    [self pause];
}

- (void)dtAddViews {
    
    // game view
    [self.contentView addSubview:self.vGame];
    [self.vGame mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.contentView addSubview:self.vAnimate];
    [self.vAnimate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    // 背景 Cover
    [self.contentView addSubview:self.vGameCover];
    [self.vGameCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.vGameCover addSubview:self.ivGameBg];
    [self.ivGameBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.vGameCover);
    }];
    
    [self.vGameCover addSubview:self.vGameBottom];
    [self.vGameBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vGameCover.mas_centerY);
        make.leading.trailing.bottom.mas_equalTo(0);
    }];
    
    [self.vGameCover addSubview:self.btnPlay];
    [self.btnPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.vGameCover);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(-(kAppSafeBottom + 126));
        
    }];
    
    // 游戏结束层
    [self.contentView addSubview:self.vGameFinished];
    [self.vGameFinished mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    // 卡片
    [self.vGameFinished addSubview:self.vGameCard];
    [self.vGameCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.vGameFinished);
        make.width.mas_equalTo(255);
        make.height.mas_equalTo(375);
    }];
    
    [self.vGameCard addSubview:self.ivGameCard];
    [self.ivGameCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.vGameCard);
        make.height.mas_equalTo(295);
    }];
    
    [self.vGameCard addSubview:self.ivGameCardIcon];
    [self.ivGameCardIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ivGameCard.mas_bottom).offset(10);
        make.leading.mas_equalTo(10);
        make.width.height.mas_equalTo(60);
    }];
    
    
    [self.vGameCard addSubview:self.labGameName];
    [self.vGameCard addSubview:self.vLine];
    [self.vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ivGameCardIcon).offset(8);
        make.trailing.mas_equalTo(-18);
        make.height.equalTo(@2);
        make.width.equalTo(@16);
        
    }];
    [self.labGameName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ivGameCardIcon);
        make.trailing.mas_equalTo(-18);
        make.height.greaterThanOrEqualTo(@0);
        make.leading.equalTo(self.ivGameCardIcon.mas_trailing).offset(10);
    }];
    
    
    // Jump 按钮
    [self.vGameFinished addSubview:self.btnJump];
    [self.btnJump mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vGameCard.mas_bottom).offset(24);
        make.leading.equalTo(self.vGameCard);
        make.height.mas_equalTo(36);
    }];
    
    // Again 按钮
    [self.vGameFinished addSubview:self.btnAgain];
    [self.btnAgain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnJump);
        make.trailing.equalTo(self.vGameCard);
        make.height.mas_equalTo(36);
        make.leading.equalTo(self.btnJump.mas_trailing).offset(15);
        make.width.equalTo(self.btnJump);
    }];

    // 游戏结束层
    [self.contentView addSubview:self.btnClose];
    [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(48);
        make.trailing.mas_equalTo(-8);
        make.top.mas_equalTo(kAppSafeTop + 8);
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self pause];
    [self.playerLayer removeFromSuperlayer];
    self.player = nil;
    self.looper = nil;
//    if (self.gameView) {
//        [self.gameView removeFromSuperview];
//        self.gameView = nil;
//    }
    [self updateGameState:SudAdGameStateUnknow];
}

- (void)configureWithURL:(NSURL *)url {
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];

    // 使用AVQueuePlayer（AVPlayer的子类，支持队列播放）
    AVQueuePlayer *queuePlayer = [[AVQueuePlayer alloc] init];

    // 创建循环播放器，指定模板项目（要循环的视频）
    AVPlayerLooper *looper = [AVPlayerLooper playerLooperWithPlayer:queuePlayer
                                                      templateItem:playerItem];
    self.looper = looper;
    
    self.player = queuePlayer;//[AVPlayer playerWithURL:url];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playerLayer.frame = self.contentView.bounds;

    
    [self.contentView.layer addSublayer:self.playerLayer];
    self.contentView.clipsToBounds = YES;
}

- (void)play {
    
    SudAdItemModel *model = (SudAdItemModel *)self.model;
    switch (model.adType) {
        case SudAdItemModelAdTypeVideo:
            DDLogDebug(@"player play");
            [self.player play];
            break;
        case SudAdItemModelAdTypeGame:
            break;
        default:
            break;
    }
}

- (void)pause {
    
    SudAdItemModel *model = (SudAdItemModel *)self.model;
    switch (model.adType) {
        case SudAdItemModelAdTypeVideo:
            DDLogDebug(@"player pause");
            [self.player pause];
            break;
        case SudAdItemModelAdTypeGame:
            break;
        default:
            break;
    }
}

- (void)addGameView:(UIView *)gameView {
    SudAdItemModel *model = (SudAdItemModel *)self.model;
    DDLogDebug(@"addGameView:%@", model.tag);
    if (_gameView != gameView) {
        [_gameView removeFromSuperview];
        _gameView = gameView;
        DDLogDebug(@"addGameView insert:%@", model.tag);
        [self.vGame addSubview:gameView];
        [gameView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.vGame);
        }];
    }
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (![self.model isKindOfClass:SudAdItemModel.class]) {
        return;
    }
    WeakSelf;
    SudAdItemModel *model = (SudAdItemModel *)self.model;
    switch (model.adType) {
        case SudAdItemModelAdTypeVideo:
            self.vGameCover.hidden = YES;
            self.vGame.hidden = YES;
            self.btnClose.hidden = YES;
            self.vGameFinished.hidden = YES;
            if (model.videoInfo.url) {
                [self configureWithURL:[NSURL URLWithString:model.videoInfo.url]];
            }
            break;
        case SudAdItemModelAdTypeGame:{
            // 游戏
            self.vGameCover.hidden = NO;
            self.vGame.hidden = NO;
            self.btnClose.hidden = YES;
            self.gameState = SudAdGameStateUnknow;
            //            if (model.gameInfo.cover) {
            //                [self.ivGameBg sd_setImageWithURL:[NSURL URLWithString:model.gameInfo.cover]];
            //            }
            if (model.gameInfo.cover) {
                [self.ivGameCard sd_setImageWithURL:[NSURL URLWithString:model.gameInfo.cover]];
            }
            if (model.gameInfo.icon) {
                [self.ivGameCardIcon sd_setImageWithURL:[NSURL URLWithString:model.gameInfo.icon]];
            }
            self.labGameName.text = model.gameInfo.name;

            if (model.lastState > 0) {
                [self updateGameState:model.lastState];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.btnClose addTarget:self action:@selector(stopGame) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPlay addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    [self.btnAgain addTarget:self action:@selector(playAgain) forControlEvents:UIControlEventTouchUpInside];
    [self.btnJump addTarget:self action:@selector(handleJumpClick) forControlEvents:UIControlEventTouchUpInside];

}

- (void)handleGameStarted {
    [self updateGameState:SudAdGameStatePlaying];
}

- (void)handleGameStopped {
    [self updateGameState:SudAdGameStateUnknow];
    SudAdItemModel *model = (SudAdItemModel *)self.model;
    model.lastState = SudAdGameStateUnknow;
}

- (void)handleGameFinished {
    DDLogDebug(@"处理游戏结束");
    [self updateGameState:SudAdGameStateFinished];
    SudAdItemModel *model = (SudAdItemModel *)self.model;
    model.lastState = SudAdGameStateFinished;
    [model stopGame];
}

- (void)startGame {
    // 通知外界点击开始玩
    [self handleLoadGame:NO];
}

- (void)playAgain {

    [self handleLoadGame:NO];
    
}

- (void)handleLoadGame:(BOOL)isForPrepare {
    
    SudAdItemModel *model = (SudAdItemModel *)self.model;
    WeakSelf

    [model requestShowGameView];
    if (isForPrepare) {
        [model stopGame];
    } else {
        [model playGame];
        [self handleGameStarted];
    }
}

- (void)handleJumpClick {
    SudAdItemModel *model = (SudAdItemModel *)self.model;
    switch (model.adType) {
        case SudAdItemModelAdTypeGame:
//            if (model.gameInfo.link.length > 0) {
//                [UIApplication.sharedApplication openURL:[NSURL URLWithString:model.gameInfo.link] options:@{} completionHandler:^(BOOL completion){
//                                    
//                }];
//            }
            // 调整消消乐
            [AudioRoomService reqMatchRoom:1664525565526667266 sceneType:SceneTypeAudio gameLevel:-1];
            break;
        default:
            break;
    }
}

- (void)stopGame {

    SudAdItemModel *model = (SudAdItemModel *)self.model;
    [model stopGame];
    [self handleGameStopped];

}

- (void)resetGameToFirstState {
    self.isGamePrepared = NO;
    [self updateGameState:SudAdGameStateUnknow];
}

- (void)updateGameState:(SudAdGameState)gameState {
    DDLogDebug(@"updateGameState old:%@,current:%@", @(self.gameState), @(gameState));
    SudAdItemModel *model = (SudAdItemModel *)self.model;
    if (model.adType != SudAdItemModelAdTypeGame) {
        DDLogDebug(@"updateGameState but is not game type");
        return;
    }
    self.gameState = gameState;
    switch (self.gameState) {
        case SudAdGameStateUnknow:
            self.vGameCover.hidden = NO;
            self.vGameFinished.hidden = YES;
            self.btnClose.hidden = YES;
            break;
        case SudAdGameStatePlaying:
            self.vGameCover.hidden = YES;
            self.vGameFinished.hidden = YES;
            self.btnClose.hidden = NO;
            self.btnClose.hidden = NO;
            break;
        case SudAdGameStateFinished:
            self.vGameCover.hidden = YES;
            self.vGameFinished.hidden = NO;
            self.btnClose.hidden = NO;
            break;
            
        default:
            break;
    }
    if (self.onGameStateChangedBlock) {
        self.onGameStateChangedBlock(self.gameState);
    }
}
#pragma mark - Getter



- (UIView *)vGame {
    if (!_vGame) {
        _vGame = [[UIView alloc] init];
        _vGame.backgroundColor = [UIColor blackColor];
    }
    return _vGame;
}



- (UIView *)vGameCover {
    if (!_vGameCover) {
        _vGameCover = [[UIView alloc] init];
        _vGameCover.backgroundColor = [UIColor clearColor];
    }
    return _vGameCover;
}


- (UIView *)vGameBottom {
    if (!_vGameBottom) {
        _vGameBottom = [[UIView alloc] init];
        [_vGameBottom dt_setGradientBackgroundWithColors:@[HEX_COLOR_A(@"#000000", 0), HEX_COLOR_A(@"#000000", 0.6)] locations:@[@(0), @(1.0f)] startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1)];
    }
    return _vGameBottom;
}

- (UIImageView *)ivGameBg {
    if (!_ivGameBg) {
        _ivGameBg = [[UIImageView alloc] init];
        _ivGameBg.contentMode = UIViewContentModeScaleAspectFill;
        _ivGameBg.clipsToBounds = YES;
    }
    return _ivGameBg;
}

- (UIButton *)btnPlay {
    if (!_btnPlay) {
        _btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnPlay setTitle:@"dt_ad_try_play".dt_lan forState:UIControlStateNormal];
        [_btnPlay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_btnPlay dt_cornerRadius:22];
        _btnPlay.titleLabel.font = UIFONT_SEMI_BOLD(20);
        _btnPlay.layer.borderColor = HEX_COLOR_A(@"#FFFFFF", 1).CGColor;
        _btnPlay.layer.borderWidth = 1;
        _btnPlay.backgroundColor = HEX_COLOR_A(@"#FFFFFF", 0.1);
    }
    return _btnPlay;
}

- (UIView *)vGameFinished {
    if (!_vGameFinished) {
        _vGameFinished = [[UIView alloc] init];
        _vGameFinished.backgroundColor = HEX_COLOR_A(@"#000000", 0.6);
        _vGameFinished.hidden = YES;
    }
    return _vGameFinished;
}

- (UIView *)vGameCard {
    if (!_vGameCard) {
        _vGameCard = [[UIView alloc] init];
        _vGameCard.backgroundColor = [UIColor whiteColor];
        _vGameCard.layer.cornerRadius = 8;
        _vGameCard.clipsToBounds = YES;
    }
    return _vGameCard;
}

- (UIImageView *)ivGameCard {
    if (!_ivGameCard) {
        _ivGameCard = [[UIImageView alloc] init];
        _ivGameCard.contentMode = UIViewContentModeScaleAspectFill;
        _ivGameCard.clipsToBounds = YES;
    }
    return _ivGameCard;
}

- (UIView *)vGameCardDetail {
    if (!_vGameCardDetail) {
        _vGameCardDetail = [[UIView alloc] init];
        _vGameCardDetail.backgroundColor = UIColor.whiteColor;
    }
    return _vGameCardDetail;
}



- (UIImageView *)ivGameCardIcon {
    if (!_ivGameCardIcon) {
        _ivGameCardIcon = [[UIImageView alloc] init];
        _ivGameCardIcon.contentMode = UIViewContentModeScaleAspectFill;
        _ivGameCardIcon.layer.cornerRadius = 8;
        _ivGameCardIcon.clipsToBounds = YES;
    }
    return _ivGameCardIcon;
}

- (UILabel *)labGameName {
    if (!_labGameName) {
        _labGameName = [[UILabel alloc] init];
        _labGameName.font = UIFONT_SEMI_BOLD(16);
        _labGameName.textColor = [UIColor blackColor];
        _labGameName.textAlignment = NSTextAlignmentRight;
    }
    return _labGameName;
}

- (UIView *)vLine {
    if (!_vLine) {
        _vLine = [[UIView alloc] init];
        _vLine.backgroundColor = HEX_COLOR(@"#000000");
    }
    return _vLine;
}

- (UIButton *)btnAgain {
    if (!_btnAgain) {
        _btnAgain = [[UIButton alloc]init];
        [_btnAgain setTitle:@"dt_ad_try_again".dt_lan forState:UIControlStateNormal];
        
        [_btnAgain dt_cornerRadius:18];
        _btnAgain.titleLabel.font = UIFONT_SEMI_BOLD(20);
        _btnAgain.layer.borderColor = HEX_COLOR_A(@"#FFFFFF", 1).CGColor;
        _btnAgain.layer.borderWidth = 1;
        _btnAgain.backgroundColor = HEX_COLOR_A(@"#FFFFFF", 0.1);
    }
    return _btnAgain;
}

- (UIButton *)btnJump {
    if (!_btnJump) {
        _btnJump = [[UIButton alloc]init];
        [_btnJump setTitle:@"dt_ad_operate_tip".dt_lan forState:UIControlStateNormal];
        
        [_btnJump dt_cornerRadius:18];
        _btnJump.titleLabel.font = UIFONT_SEMI_BOLD(20);
        _btnJump.layer.borderColor = HEX_COLOR_A(@"#FFFFFF", 1).CGColor;
        _btnJump.layer.borderWidth = 1;
        _btnJump.backgroundColor = HEX_COLOR_A(@"#FFFFFF", 0.1);
    }
    return _btnJump;
}


- (UIButton *)btnClose {
    if (!_btnClose) {
        _btnClose = [[UIButton alloc]init];
        [_btnClose setImage:[UIImage imageNamed:@"circle_close"] forState:UIControlStateNormal];
    }
    return _btnClose;
}

- (SudAdAnimateView *)vAnimate {
    if (!_vAnimate) {
        _vAnimate = SudAdAnimateView.new;
    }
    return _vAnimate;
}

- (void)onGameNotifyFinished {
    [self handleGameFinished];
}


- (void)onShowGameView:(UIView *)gameView {
    [self addGameView:gameView];
    SudAdItemModel *model = (SudAdItemModel *)self.model;
    if (model.isLoaded) {
        [self.vAnimate stopTimer];
        self.vAnimate.hidden = YES;
    }
}

- (void)showCell:(BOOL)isWillShow {
    self.isWillShow = isWillShow;
    SudAdItemModel *model = (SudAdItemModel *)self.model;
    if (!isWillShow) {
        [model stopRunGame];
        return;
    }
    
    [model startRunGame];
    if (!model.isLoaded) {
        [self.vAnimate startTimer];
        self.vAnimate.hidden = NO;
    }
}

@end
