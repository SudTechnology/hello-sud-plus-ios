//
//  AudioRoomViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "AudioRoomViewController.h"


@interface AudioRoomViewController ()
@property (nonatomic, strong) AudioMicContentView *audioMicContentView;
@end

@implementation AudioRoomViewController

- (void)dtAddViews {
    [super dtAddViews];
    [self.sceneView addSubview:self.audioMicContentView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.audioMicContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(20);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    self.audioMicContentView.onTapCallback = ^(AudioRoomMicModel * _Nonnull micModel) {
        /// 麦位点击回调
        [weakSelf handleMicTap:micModel];
    };
}

- (AudioMicContentView *)audioMicContentView {
    if (!_audioMicContentView) {
        _audioMicContentView = [[AudioMicContentView alloc] init];
    }
    return _audioMicContentView;
}

- (void)setRoomType:(RoomType)roomType {
    _roomType = roomType;
    if (self.roomType == HSAudioMic) {
        /// 销毁游戏
        [self logoutGame];
        [self.gameMicContentView setHidden:true];
        [self.audioMicContentView setHidden:false];
        self.gameView.hidden = YES;
        self.gameNumLabel.hidden = YES;
        [self.msgBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.audioMicContentView.mas_bottom);
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.operatorView.mas_top).offset(-20);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        [self.dicMicModel removeAllObjects];
        for (AudioMicroView *v in self.audioMicContentView.micArr) {
            NSString *key = [NSString stringWithFormat:@"%ld", v.model.micIndex];
            self.dicMicModel[key] = v.model;
            v.micType = HSAudioMic;
        }
        [self.sudFSMMGDecorator clearAllStates];
        GameService.shared.gameId = 0;
    } else if (self.roomType == HSGameMic) {
        self.gameView.hidden = NO;
        self.gameNumLabel.hidden = NO;
        [self.gameMicContentView setHidden:false];
        [self.audioMicContentView setHidden:true];
        CGFloat h = [UIDevice dt_isiPhoneXSeries] ? 106 : 50;
        [self.msgBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.operatorView.mas_top);
            make.height.mas_equalTo(h);
        }];
        [self.dicMicModel removeAllObjects];
        for (AudioMicroView *v in self.gameMicContentView.micArr) {
            NSString *key = [NSString stringWithFormat:@"%ld", v.model.micIndex];
            self.dicMicModel[key] = v.model;
            v.micType = HSGameMic;
        }
    }
    [self reqMicList];
    [self.naviView hiddenNodeWithRoleType: AudioRoomService.shared.roleType];
    [self dtUpdateUI];
}

- (void)roomGameDidChanged:(NSInteger)gameID {
    [super roomGameDidChanged:gameID];
    if (gameID == 0) {
        self.roomType = HSAudio;
    }else {
        self.roomType = HSGame;
    }
}

- (void)notifyGameToJoin {
    if (self.roomType == HSGame) {
        [super notifyGameToJoin];
    }
}

- (void)notifyGameToExit {
    if (self.roomType == HSGame) {
        [super notifyGameToExit];
    }
}

- (void)handleGameKeywordHitting:(NSString *)content {
    if (self.roomType == HSGame) {
        [super handleGameKeywordHitting:content];
    }
}

- (BOOL)isSupportGame {
    return self.roomType == HSGame;
}

@end
