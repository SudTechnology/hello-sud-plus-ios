//
//  HSAudioMicroView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSAudioMicroView.h"



@interface HSAudioMicroView ()
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) UIImageView *giftImageView;

/// game
@property (nonatomic, strong) UIImageView *gameCaptainView;
@property (nonatomic, strong) UILabel *gameStateLabel;
@property (nonatomic, strong) HSPaddingLabel *gameBadgeLabel;
@property (nonatomic, strong) UIImageView * gamingImageView;

/// 水波纹
@property (nonatomic, strong) HSRippleAnimationView *rippleView;

/// 声音值
@property (nonatomic, assign) CGFloat volume;

@end

@implementation HSAudioMicroView

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
    [self.gameCaptainView setHidden:true];
    [self.gameStateLabel setHidden:true];
    [self.gameBadgeLabel setHidden:true];
    [self.gamingImageView setHidden:true];
    if (self.micType == HSAudioMic) {
    } else if (self.micType == HSGameMic) {
        [self.giftImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-4);
            make.right.mas_equalTo(4);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
    }
    self.headerView.layer.cornerRadius = self.headWidth / 2;
}

- (void)hsAddViews {
    [self addSubview:self.rippleView];
    [self addSubview:self.headerView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.giftImageView];
    
    [self addSubview:self.gameCaptainView];
    [self addSubview:self.gameStateLabel];
    [self addSubview:self.gameBadgeLabel];
    [self addSubview:self.gamingImageView];
}

- (void)hsLayoutViews {

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
        make.right.mas_equalTo(14);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    [self.gameCaptainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerView.mas_left).offset(-4);
        make.top.mas_equalTo(self.headerView.mas_top).offset(-4);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    [self.gameStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(32, 12));
    }];
}

- (void)hsConfigEvents {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapHead:)];
    [self.headerView addGestureRecognizer:tap];
    WeakSelf
    [[NSNotificationCenter defaultCenter]addObserverForName:NTF_MIC_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        HSAudioMsgMicModel *msgModel = note.userInfo[@"msgModel"];
        if ([msgModel isKindOfClass:HSAudioMsgMicModel.class] ) {
            // 操作麦位与当前符合
            if (msgModel.micIndex == weakSelf.model.micIndex) {
                if (msgModel.cmd == CMD_DOWN_MIC_NTF) {
                    // 下麦,清空用户信息
                    weakSelf.model.user = nil;
                } else {
                    weakSelf.model.user = msgModel.sendUser;
                    weakSelf.model.streamID = msgModel.streamID;
                }
            } else if (weakSelf.model.user != nil && [msgModel.sendUser.userID isEqualToString:weakSelf.model.user.userID]) {
                // 当前用户ID与切换用户ID一致，则清除掉
                weakSelf.model.user = nil;
            }
            [weakSelf hsUpdateUI];
        } else {
            [weakSelf hsUpdateUI];
        }
    }];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:NTF_SEND_GIFT_USER_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        HSAudioRoomMicModel *micModel = note.userInfo[@"micModel"];
        if ([micModel isKindOfClass:HSAudioRoomMicModel.class] ) {
            // 操作麦位与当前符合
            if (micModel.micIndex == weakSelf.model.micIndex) {
                weakSelf.giftImageView.hidden = micModel.isSelected ? NO : YES;
            }
        } else {
            [weakSelf hsUpdateUI];
        }
    }];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:NTF_LOCAL_VOICE_VOLUME_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        NSNumber *soundLevel = note.userInfo[@"volume"];
        if ([soundLevel isKindOfClass:NSNumber.class] ) {
            NSString *myUserID = HSAppManager.shared.loginUserInfo.userID;
            // 操作麦位与当前符合
            if (weakSelf.model.user != nil &&
                [weakSelf.model.user.userID isEqualToString:myUserID]) {
                weakSelf.volume = soundLevel.floatValue;
            }
        }
    }];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:NTF_REMOTE_VOICE_VOLUME_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        NSDictionary<NSString*, NSNumber*> * dicSoundLevel = note.userInfo[@"dicVolume"];
        if ([dicSoundLevel isKindOfClass:NSDictionary.class] ) {
            NSString *currentStreamID = weakSelf.model.streamID;
            NSNumber * currentSoundLevel = currentStreamID.length > 0 ? dicSoundLevel[currentStreamID] : nil;
            // 操作麦位与当前符合
            if (weakSelf.model.user != nil &&
                currentSoundLevel != nil) {
                weakSelf.volume = currentSoundLevel.floatValue;
            }
        }
    }];
    // 同步采集到的流ID到麦位
    [[NSNotificationCenter defaultCenter]addObserverForName:NTF_STREAM_INFO_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        MediaStream *streamInfo = note.userInfo[kNTFStreamInfoKey];
        if ([streamInfo isKindOfClass:MediaStream.class] ) {
            if (weakSelf.model.user && [weakSelf.model.user.userID isEqualToString:streamInfo.user.userID]) {
                weakSelf.model.streamID = streamInfo.streamID;
            }
        }
    }];
    /// 游戏玩家状态变化
    [[NSNotificationCenter defaultCenter]addObserverForName:NTF_PLAYER_STATE_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        GamePlayerStateModel *m = note.userInfo[@"model"];
        [weakSelf gamePlayerStateNOT:m];
    }];
}

- (void)hsUpdateUI {
    if (self.model.user == nil) {
        self.headerView.image = [UIImage imageNamed:@"room_mic_up"];
        self.nameLabel.text = @"点击上麦";
        [self.rippleView stopAnimate:YES];
        return;
    }
    if (self.model.user.icon) {
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:self.model.user.icon]];
    }
    self.giftImageView.hidden = self.model.isSelected ? NO : YES;
    self.nameLabel.text = self.model.user.name;
}

- (void)setModel:(HSAudioRoomMicModel *)model {
    _model = model;
    [self hsUpdateUI];
}

- (void)onTapHead:(UITapGestureRecognizer *)tap {
    if (self.onTapCallback) self.onTapCallback(self.model);
}

- (void)gamePlayerStateNOT:(GamePlayerStateModel *)m {
    if ([m isKindOfClass:GamePlayerStateModel.class] ) {
        NSString *state = m.state;
        /// 设置队长状态 - （队长有且只有一个）
        if ([state isEqualToString:MG_COMMON_PLAYER_CAPTAIN]) {
            [self.gameCaptainView setHidden:!(m.isCaptain && m.userId == self.model.user.userID)];
        }
        if (m.userId != self.model.user.userID) {
            return;
        }
        /// 设置玩家游戏状态
        [self.gameBadgeLabel setHidden:true];
        if ([state isEqualToString:MG_COMMON_PLAYER_READY]) {
            NSLog(@"玩家: 准备状态");
            [self.gameStateLabel setHidden:!m.isReady];
            self.gameStateLabel.text = m.isReady ? @"已准备" : @"未准备";
            self.gameStateLabel.textColor = [UIColor whiteColor];
            self.gameStateLabel.backgroundColor = [UIColor colorWithHexString:m.isReady ? @"#13AD21" : @"#FF6E65" alpha:1];
            self.gameStateLabel.layer.borderColor = UIColor.whiteColor.CGColor;
        } else if ([state isEqualToString:MG_COMMON_PLAYER_PLAYING]) {
            NSLog(@"玩家: 游戏中状态");
            [self.gamingImageView setHidden:!m.isPlaying];
        } else if ([state isEqualToString:MG_DG_SELECTING] || [state isEqualToString:MG_DG_PAINTING] || [state isEqualToString:MG_DG_SCORE]) {
            NSLog(@"你画我猜 玩家: 选词中 || 作画中 || 错误答");
            [self.gameStateLabel setHidden:false];
            self.gameStateLabel.text = m.msg;
            self.gameStateLabel.textColor = [UIColor colorWithHexString:@"#FF95CA" alpha:1];
            self.gameStateLabel.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.7];
            self.gameStateLabel.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.5].CGColor;
        }  else if ([state isEqualToString:MG_DG_SCORE]) {
            NSLog(@"你画我猜 玩家: 本次积分");
            [self.gameStateLabel setHidden:false];
            self.gameStateLabel.text = m.msg;
            self.gameStateLabel.textColor = [UIColor colorWithHexString:@"#65FF73" alpha:1];
            self.gameStateLabel.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.7];
            self.gameStateLabel.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.5].CGColor;
        } else if ([state isEqualToString:MG_DG_TOTALSCORE]) {
            NSLog(@"你画我猜 玩家: 总积分");
            [self.gameBadgeLabel setHidden:false];
            self.gameBadgeLabel.text = m.msg;
        }
    }
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
        _nameLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.4];
        _nameLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        _nameLabel.text = @"点击上麦";
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
        _gameStateLabel.text = @"未准备";
        _gameStateLabel.font = [UIFont systemFontOfSize:9 weight:UIFontWeightRegular];
        _gameStateLabel.textAlignment = NSTextAlignmentCenter;
        _gameStateLabel.textColor = UIColor.whiteColor;
        _gameStateLabel.backgroundColor = [UIColor colorWithHexString:@"#F7782F" alpha:1];
        _gameStateLabel.layer.cornerRadius = 1;
        _gameStateLabel.layer.borderWidth = 0.5;
        _gameStateLabel.layer.borderColor = UIColor.whiteColor.CGColor;
        _gameStateLabel.layer.masksToBounds = true;
        [_gameStateLabel setHidden:true];
    }
    return _gameStateLabel;
}

- (HSPaddingLabel *)gameBadgeLabel {
    if (!_gameBadgeLabel) {
        _gameBadgeLabel = [[HSPaddingLabel alloc] init];
        _gameBadgeLabel.backgroundColor = [UIColor colorWithHexString:@"#FF4DA6" alpha:1];
        _gameBadgeLabel.layer.cornerRadius = 14/2;
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

- (HSRippleAnimationView *)rippleView {
    if (_rippleView == nil) {
        _rippleView = HSRippleAnimationView.new;
        _rippleView.animateColors = @[(id)HEX_COLOR_A(@"#FF3B2F", 1).CGColor,
                                      (id)HEX_COLOR_A(@"#FF3B2F", 0.59).CGColor,
                                      (id)HEX_COLOR_A(@"#FF3B2F", 0.34).CGColor,
                                      (id)HEX_COLOR_A(@"#FF3B2F", 0).CGColor];
        _rippleView.animateBackgroundColor = UIColor.clearColor;
    }
    return _rippleView;
}

- (UIImageView *)gamingImageView {
    if (!_gamingImageView) {
        _gamingImageView = [[UIImageView alloc]init];
        _gamingImageView.image = [UIImage imageNamed:@"room_game_mic_ing"];
        [_gamingImageView setHidden:true];
    }
    return _gamingImageView;
}

@end