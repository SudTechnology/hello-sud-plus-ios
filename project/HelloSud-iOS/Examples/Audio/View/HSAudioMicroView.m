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

@end

@implementation HSAudioMicroView

- (void)setMicType:(MicType)micType {
    _micType = micType;
    [self switchContentWithType];
}

- (void)switchContentWithType {
    if (self.micType == HSAudioMic) {
        [self.gameCaptainView setHidden:true];
        [self.gameStateLabel setHidden:true];
    } else if (self.micType == HSGameMic) {
        [self.gameCaptainView setHidden:false];
        [self.gameStateLabel setHidden:false];
        [self.giftImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-4);
            make.right.mas_equalTo(4);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
    }
    CGFloat w = self.micType == HSGameMic ? 32 : 54;
    self.headerView.layer.cornerRadius = w / 2;
    self.headerView.clipsToBounds = YES;
}

- (void)hsAddViews {
    [self addSubview:self.headerView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.giftImageView];
    
    [self addSubview:self.gameCaptainView];
    [self addSubview:self.gameStateLabel];
    [self.gameCaptainView setHidden:true];
    [self.gameStateLabel setHidden:true];
}

- (void)hsLayoutViews {

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
    
    [[NSNotificationCenter defaultCenter]addObserverForName:NTF_MIC_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        HSAudioMsgMicModel *msgModel = note.userInfo[@"micModel"];
        if ([msgModel isKindOfClass:HSAudioMsgMicModel.class] ) {
            // 操作麦位与当前符合
            if (msgModel.micIndex == self.model.micIndex) {
                if (msgModel.cmd == CMD_DOWN_MIC_NTF) {
                    // 下麦,清空用户信息
                    self.model.user = nil;
                } else {
                    self.model.user = msgModel.sendUser;
                }
            } else if (self.model.user != nil && [msgModel.sendUser.userID isEqualToString:self.model.user.userID]) {
                // 当前用户ID与切换用户ID一致，则清除掉
                self.model.user = nil;
            }
            [self hsUpdateUI];
        }
    }];
}


- (void)hsUpdateUI {
    if (self.model.user == nil) {
        self.headerView.image = [UIImage imageNamed:@"room_mic_up"];
        self.nameLabel.text = @"点击上麦";
        return;
    }
    if (self.model.user.icon) {
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:self.model.user.icon]];
    }
    self.nameLabel.text = self.model.user.name;
}

- (void)setModel:(HSAudioRoomMicModel *)model {
    _model = model;
    [self hsUpdateUI];
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
    }
    return _headerView;
}

- (UIImageView *)giftImageView {
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc] init];
        _giftImageView.image = [UIImage imageNamed:@"room_mic_gift_tag"];
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
    }
    return _gameStateLabel;
}

@end