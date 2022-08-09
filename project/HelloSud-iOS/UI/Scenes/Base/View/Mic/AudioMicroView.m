//
//  AudioMicroView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "AudioMicroView.h"
#import <MJExtension/MJExtension.h>

@interface AudioMicroView ()
@property(nonatomic, strong) UIImageView *headerView;
@property(nonatomic, strong) YYLabel *nameLabel;
@property(nonatomic, strong) UIImageView *giftImageView;

/// game
@property(nonatomic, strong) UIImageView *gameCaptainView;
@property(nonatomic, strong) UILabel *gameStateLabel;
@property(nonatomic, strong) DTPaddingLabel *gameBadgeLabel;
@property(nonatomic, strong) UIImageView *gamingImageView;
@property(nonatomic, strong) DTPaddingLabel *gameimgLabel;

/// 水波纹
@property(nonatomic, strong) DTRippleAnimationView *rippleView;

/// 声音值
@property(nonatomic, assign) CGFloat volume;

@end

@implementation AudioMicroView

- (void)setMicType:(MicType)micType {
    _micType = micType;
    [self switchContentWithType];
}

- (void)setVolume:(CGFloat)volume {
    _volume = volume;
    if (volume > 1.5) {
        [self.rippleView startAnimate:NO];
    } else {
        [self.rippleView stopAnimate:NO];
    }
}

- (void)switchContentWithType {
    DDLogDebug(@"switchContentWithType");
    [self.gameCaptainView setHidden:true];
    [self.gameStateLabel setHidden:true];
    [self.gameBadgeLabel setHidden:true];
    [self.gamingImageView setHidden:true];
    if (self.micType == HSGameMic) {
        [self.giftImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-4);
            make.trailing.mas_equalTo(4);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
    }
    self.headerView.layer.cornerRadius = self.headWidth / 2;
    [self updateGameUI];
}

/// 切换缩放比例
/// @param isSmall isSmall
- (void)changeScale:(BOOL)isSmall {

    if (isSmall) {
        // 缩小版
        self.nameLabel.alpha = 0;
        self.gameCaptainView.alpha = 0;
        self.gameStateLabel.alpha = 0;
        self.gameBadgeLabel.alpha = 0;
        self.gameimgLabel.alpha = 0;
        self.gamingImageView.alpha = 0;
        [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(self.headWidth);
            make.height.mas_equalTo(self.headWidth);
        }];
    } else {
        self.nameLabel.alpha = 1;
        self.gameCaptainView.alpha = 1;
        self.gameStateLabel.alpha = 1;
        self.gameBadgeLabel.alpha = 1;
        self.gameimgLabel.alpha = 1;
        self.gamingImageView.alpha = 1;
        [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(self.mas_width);
        }];
    }
    self.headerView.layer.cornerRadius = self.headWidth / 2;
}

- (void)dtAddViews {
    [self addSubview:self.rippleView];
    [self addSubview:self.headerView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.giftImageView];

    [self addSubview:self.gameCaptainView];
    [self addSubview:self.gameStateLabel];
    [self addSubview:self.gameBadgeLabel];
    [self addSubview:self.gamingImageView];
    [self addSubview:self.gameimgLabel];
}

- (void)hiddenGameStateViews:(BOOL)hiddenCaptain {
    if (hiddenCaptain) {
        [self.gameCaptainView setHidden:true];
    }
    DDLogDebug(@"hiddenGameStateViews");
    [self.gameStateLabel setHidden:true];
    [self.gameBadgeLabel setHidden:true];
    [self.gamingImageView setHidden:true];
}

- (void)dtLayoutViews {

    [self.rippleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headerView);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(self.mas_width);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(8);
        make.centerX.equalTo(self);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-14);
        make.trailing.mas_equalTo(14);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    [self.gameCaptainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.headerView.mas_leading).offset(-4);
        make.top.mas_equalTo(self.headerView.mas_top).offset(-4);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    [self.gamingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headerView);
        make.top.mas_equalTo(self.headerView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    [self.gameStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(32, 12));
    }];
    [self.gameimgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headerView.mas_bottom);
        make.centerX.mas_equalTo(self.headerView);
        make.height.mas_equalTo(16);
        make.width.mas_lessThanOrEqualTo(55);
    }];
}

- (void)dtConfigEvents {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapHead:)];
    [self.headerView addGestureRecognizer:tap];
    WeakSelf
    [[NSNotificationCenter defaultCenter] addObserverForName:NTF_MIC_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *_Nonnull note) {
        RoomCmdUpMicModel *msgModel = note.userInfo[@"msgModel"];
        if ([msgModel isKindOfClass:RoomCmdUpMicModel.class]) {
            
            BOOL isSameMicUser = weakSelf.model.user != nil && [msgModel.sendUser.userID isEqualToString:weakSelf.model.user.userID];
            // 操作麦位与当前符合
            if (msgModel.micIndex == weakSelf.model.micIndex) {
                DDLogDebug(@"NTF_MIC_CHANGED msg info:%@", [msgModel mj_JSONString]);
                if (msgModel.cmd == CMD_DOWN_MIC_NOTIFY) {
                    // 下麦,清空用户信息
                    if (isSameMicUser) {
                        weakSelf.model.user = nil;
                        weakSelf.giftImageView.hidden = true;
                        [weakSelf hiddenGameStateViews:true];
                    }
                } else {
                    weakSelf.model.user = msgModel.sendUser;
                    weakSelf.model.user.roleType = msgModel.roleType;
                    weakSelf.model.streamID = msgModel.streamID;
                }
            } else if (isSameMicUser) {
                DDLogDebug(@"NTF_MIC_CHANGED msg info:%@", [msgModel mj_JSONString]);
                // 当前用户ID与切换用户ID一致，则清除掉
                weakSelf.model.user = nil;
                weakSelf.giftImageView.hidden = true;
            }
            [weakSelf dtUpdateUI];
        } else {
            [weakSelf dtUpdateUI];
        }
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:NTF_SEND_GIFT_USER_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *_Nonnull note) {
        AudioRoomMicModel *micModel = note.userInfo[@"micModel"];
        if ([micModel isKindOfClass:AudioRoomMicModel.class]) {
            // 操作麦位与当前符合
            if (micModel.micIndex == weakSelf.model.micIndex) {
                weakSelf.giftImageView.hidden = micModel.isSelected && weakSelf.micType == HSAudioMic ? NO : YES;
            }
        } else {
            [weakSelf dtUpdateUI];
        }
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:NTF_LOCAL_VOICE_VOLUME_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *_Nonnull note) {
        NSNumber *soundLevel = note.userInfo[@"volume"];
        if ([soundLevel isKindOfClass:NSNumber.class]) {
            NSString *myUserID = AppService.shared.login.loginUserInfo.userID;
            // 操作麦位与当前符合
            if (weakSelf.model.user != nil &&
                    [weakSelf.model.user.userID isEqualToString:myUserID]) {
                weakSelf.volume = soundLevel.floatValue;
            }
        }
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:NTF_REMOTE_VOICE_VOLUME_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *_Nonnull note) {
        NSDictionary<NSString *, NSNumber *> *dicSoundLevel = note.userInfo[@"dicVolume"];
        if ([dicSoundLevel isKindOfClass:NSDictionary.class]) {
            NSString *userID = weakSelf.model.user.userID;
            NSNumber *currentSoundLevel = userID.length > 0 ? dicSoundLevel[userID] : nil;
            // 操作麦位与当前符合
            if (weakSelf.model.user != nil &&
                    currentSoundLevel != nil) {
                weakSelf.volume = currentSoundLevel.floatValue;
            }
        }
    }];
    // 同步采集到的流ID到麦位
    [[NSNotificationCenter defaultCenter] addObserverForName:NTF_STREAM_INFO_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *_Nonnull note) {
        AudioStream *streamInfo = note.userInfo[kNTFStreamInfoKey];
        if ([streamInfo isKindOfClass:AudioStream.class]) {
            if (weakSelf.model.user && [weakSelf.model.user.userID isEqualToString:streamInfo.userID]) {
                weakSelf.model.streamID = streamInfo.streamID;
            }
        }
    }];
    /// 游戏玩家状态变化
    [[NSNotificationCenter defaultCenter] addObserverForName:NTF_PLAYER_STATE_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *_Nonnull note) {
        if (weakSelf.skipGameState) {
            return;
        }
        [weakSelf updateGameUI];
        [weakSelf updateOrderUI];
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    /// 默认游戏
    self.micType = HSGameMic;
}

- (void)dtUpdateUI {
    [self.gameimgLabel setHidden:true];
    if (self.model.user == nil) {
        self.headerView.image = [UIImage imageNamed:@"room_mic_up"];
        if (self.micType == HSAudioMic) {
            [self showUserName:NSString.dt_room_click_mic showOwner:false];
        } else {
            [self showUserName:@"" showOwner:false];
        }
        [self.rippleView stopAnimate:YES];
        [self hiddenGameStateViews:true];
        [self updateGameUI];
        return;
    }
    if (self.model.user.icon) {
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:self.model.user.icon]];
    }
    self.giftImageView.hidden = self.model.isSelected && self.micType == HSAudioMic && kAudioRoomService.sceneType != SceneTypeOrder ? NO : YES;
    [self showUserName:self.model.user.name showOwner:self.model.user.roleType == 1 && self.micType == HSAudioMic];

    [self updateOrderUI];
    [self updateGameUI];
}

- (void)updateOrderUI {
    [self.gameimgLabel setHidden:true];
    if (self.model.user == nil) {
        return;
    }
    if (kAudioRoomService.sceneType == SceneTypeOrder && self.micType == HSAudioMic) {
        if ([self.iSudFSMMG isPlayerInGame:self.model.user.userID]) {
            /// 点单场景下的 游戏中
            DDLogDebug(@"is game playing:%@, user id:%@", @(self.iSudFSMMG.isPlaying), self.model.user.userID);
            [self.gameimgLabel setHidden:false];
        }
    }
}

- (void)updateGameUI {
    if (self.skipGameState) {
        return;
    }
    if (self.micType == HSGameMic) {
        if (self.model.user == nil) {
            self.headerView.image = [UIImage imageNamed:@"room_mic_up"];
            [self showUserName:@"" showOwner:false];
            [self.rippleView stopAnimate:YES];
            [self hiddenGameStateViews:true];
            return;
        }
        /// 设置队长状态 - （队长有且只有一个）
        [self.gameCaptainView setHidden:true];
        BOOL isCaptain = [self.iSudFSMMG isPlayerIsCaptain:self.model.user.userID];
        if (isCaptain) {
            [self.gameCaptainView setHidden:false];
        }
        /// 设置玩家游戏状态
        [self.gamingImageView setHidden:true];
        DDLogDebug(@"updateGameUI");
        [self.gameStateLabel setHidden:true];

        /// 是否还在游戏中
        if (![self.iSudFSMMG isPlayerInGame:self.model.user.userID]) {
            // 不在游戏中
            [self hiddenGameStateViews:false];
        } else {
            // 在游戏大厅中
            if ([self.iSudFSMMG isPlayerIsPlaying:self.model.user.userID]) {
                // 正在玩游戏
                [self hiddenGameStateViews:false];
                [self.gamingImageView setHidden:false];
            } else if ([self.iSudFSMMG isPlayerIsReady:self.model.user.userID]) {
                // 准备
                [self.gameStateLabel setHidden:false];
                self.gameStateLabel.text = NSString.dt_room_is_ready;
                self.gameStateLabel.textColor = [UIColor whiteColor];
                self.gameStateLabel.backgroundColor = [UIColor dt_colorWithHexString:@"#13AD21" alpha:1];
                self.gameStateLabel.layer.borderColor = UIColor.whiteColor.CGColor;
            } else {
                // 未准备
                [self.gameStateLabel setHidden:false];
                self.gameStateLabel.text = NSString.dt_room_not_ready;
                self.gameStateLabel.textColor = [UIColor whiteColor];
                self.gameStateLabel.backgroundColor = [UIColor dt_colorWithHexString:@"#FF6E65" alpha:1];
                self.gameStateLabel.layer.borderColor = UIColor.whiteColor.CGColor;
            }
        }

    } else {
        [self hiddenGameStateViews:false];
    }
}

- (void)showUserName:(NSString *)name showOwner:(BOOL)isShowTag {
    if (name == nil) {
        return;
    }
    UIImage *tagImage = [UIImage imageNamed:@"room_mic_owner_name"];
    NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:tagImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(24, 12) alignToFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];

    NSMutableAttributedString *attrName = [[NSMutableAttributedString alloc] initWithString:name];
    attrName.yy_lineSpacing = 6;
    attrName.yy_font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
    attrName.yy_color = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];

    if (isShowTag) {
        [attrName insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:0];
        [attrIcon appendAttributedString:attrName];
        self.nameLabel.attributedText = attrIcon;
    } else {
        self.nameLabel.attributedText = attrName;
    }
}

- (void)setModel:(AudioRoomMicModel *)model {
    _model = model;
    [self dtUpdateUI];
}

- (void)onTapHead:(UITapGestureRecognizer *)tap {
    if (self.onTapCallback) self.onTapCallback(self.model);
}

#pragma mark - lazy

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.image = [UIImage imageNamed:@"room_mic_up"];
        _headerView.userInteractionEnabled = YES;
        _headerView.clipsToBounds = YES;
    }
    return _headerView;
}

- (UIImageView *)giftImageView {
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc] init];
        _giftImageView.image = [UIImage imageNamed:@"room_mic_gift_tag"];
        _giftImageView.hidden = YES;
    }
    return _giftImageView;
}

- (YYLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[YYLabel alloc] init];
        _nameLabel.numberOfLines = 2;
        _nameLabel.preferredMaxLayoutWidth = 70;
        _nameLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _nameLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:0.4];
        _nameLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
    }
    return _nameLabel;
}

- (UIImageView *)gameCaptainView {
    if (!_gameCaptainView) {
        _gameCaptainView = [[UIImageView alloc] init];
        _gameCaptainView.image = [UIImage imageNamed:@"room_game_captain"];
        [_gameCaptainView setHidden:true];
    }
    return _gameCaptainView;
}

- (UILabel *)gameStateLabel {
    if (!_gameStateLabel) {
        _gameStateLabel = [[UILabel alloc] init];
        _gameStateLabel.text = NSString.dt_room_not_ready;
        _gameStateLabel.font = [UIFont systemFontOfSize:9 weight:UIFontWeightRegular];
        _gameStateLabel.textAlignment = NSTextAlignmentCenter;
        _gameStateLabel.textColor = UIColor.whiteColor;
        _gameStateLabel.backgroundColor = [UIColor dt_colorWithHexString:@"#F7782F" alpha:1];
        _gameStateLabel.layer.cornerRadius = 1;
        _gameStateLabel.layer.borderWidth = 0.5;
        _gameStateLabel.layer.borderColor = UIColor.whiteColor.CGColor;
        _gameStateLabel.layer.masksToBounds = true;
        [_gameStateLabel setHidden:true];
    }
    return _gameStateLabel;
}

- (DTPaddingLabel *)gameBadgeLabel {
    if (!_gameBadgeLabel) {
        _gameBadgeLabel = [[DTPaddingLabel alloc] init];
        _gameBadgeLabel.backgroundColor = [UIColor dt_colorWithHexString:@"#FF4DA6" alpha:1];
        _gameBadgeLabel.layer.cornerRadius = 14 / 2;
        _gameBadgeLabel.layer.masksToBounds = true;
        _gameBadgeLabel.numberOfLines = 1;
        _gameBadgeLabel.textAlignment = NSTextAlignmentCenter;
        _gameBadgeLabel.text = @"99";
        _gameBadgeLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
        _gameBadgeLabel.textColor = [UIColor whiteColor];
        _gameBadgeLabel.paddingX = 4;
        [_gameBadgeLabel setHidden:true];
    }
    return _gameBadgeLabel;
}

- (DTRippleAnimationView *)rippleView {
    if (_rippleView == nil) {
        _rippleView = DTRippleAnimationView.new;
        _rippleView.animateColors = @[(id) HEX_COLOR_A(@"#FFFFFF", 1).CGColor,
                (id) HEX_COLOR_A(@"#FFFFFF", 0.15).CGColor,
                (id) HEX_COLOR_A(@"#FFFFFF", 0.05).CGColor,
                (id) HEX_COLOR_A(@"#FFFFFF", 0).CGColor];
        _rippleView.animateBackgroundColor = UIColor.clearColor;
    }
    return _rippleView;
}

- (UIImageView *)gamingImageView {
    if (!_gamingImageView) {
        _gamingImageView = [[UIImageView alloc] init];
        _gamingImageView.image = [UIImage imageNamed:@"room_game_mic_ing"];
        [_gamingImageView setHidden:true];
    }
    return _gamingImageView;
}

- (DTPaddingLabel *)gameimgLabel {
    if (!_gameimgLabel) {
        _gameimgLabel = [[DTPaddingLabel alloc] init];
        _gameimgLabel.backgroundColor = [UIColor dt_colorWithHexString:@"#79BC2F" alpha:1];
        _gameimgLabel.layer.cornerRadius = 16 / 2;
        _gameimgLabel.layer.masksToBounds = true;
        _gameimgLabel.numberOfLines = 1;
        _gameimgLabel.textAlignment = NSTextAlignmentCenter;
        _gameimgLabel.text = NSString.dt_room_mic_game_ing;
        _gameimgLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
        _gameimgLabel.textColor = [UIColor whiteColor];
        _gameimgLabel.paddingX = 6;
        [_gameimgLabel setHidden:true];
    }
    return _gameimgLabel;
}

@end
