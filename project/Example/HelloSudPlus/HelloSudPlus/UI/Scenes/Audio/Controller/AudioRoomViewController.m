//
//  AudioRoomViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "AudioRoomViewController.h"
#import "EnterRoomModel.h"

@interface AudioRoomViewController ()
@end

@implementation AudioRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self roomTypeReloadContent];
}

/// 服务类，子类返回对应服务类型，用于构建对应场景服务
- (Class)serviceClass {
    return [AudioRoomService class];
}

- (void)setConfigModel:(BaseSceneConfigModel *)configModel {
    [super setConfigModel:configModel];
    if ([configModel isKindOfClass:[AudioSceneConfigModel class]]) {
        AudioSceneConfigModel *m = (AudioSceneConfigModel *)configModel;
        self.roomType = (RoomType) m.roomType;
    }
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.sceneView addSubview:self.audioMicContentView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.audioMicContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(20);
        make.leading.trailing.mas_equalTo(self.view);
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

- (void)dtUpdateUI {
    [super dtUpdateUI];
    [self roomTypeReloadContent];
}

- (GameCfgModel *)onGetGameCfg {
    if (self.configModel.enterRoomModel.sceneType == SceneTypeAudio) {
        
        GameCfgModel *m = [GameCfgModel defaultCfgModel];
        m.ui.lobby_players.hide = NO;
        m.ui.nft_avatar.hide = NO;
        m.ui.game_opening.hide = NO;
        m.ui.game_mvp.hide = NO;
        m.ui.bullet_screens_btn.hide = NO;
        return m;
    } else {
        return [super onGetGameCfg];
    }
}

- (void)roomTypeReloadContent {
    if ([self isShowAudioContent]) {
        self.gameMicContentView.hidden = YES;
        self.gameView.hidden = YES;
        self.gameNumLabel.hidden = YES;
        [self.gameTopShadeNode setHidden:true];
        self.audioMicContentView.hidden = NO;
        for (AudioMicroView *v in self.audioMicContentView.micArr) {
            NSString *key = [NSString stringWithFormat:@"%ld", v.model.micIndex];
            v.micType = HSAudioMic;
        }
        [self.msgBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.audioMicContentView.mas_bottom);
            make.leading.trailing.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.operatorView.mas_top).offset(-20);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
    } else {
        [self.audioMicContentView setHidden:true];
        [self.gameTopShadeNode setHidden:false];
        [self setupGameRoomContent];
    }
}

- (AudioMicContentView *)audioMicContentView {
    if (!_audioMicContentView) {
        _audioMicContentView = [[AudioMicContentView alloc] init];
    }
    return _audioMicContentView;
}

- (void)roomGameDidChanged:(NSInteger)gameID {
    [super roomGameDidChanged:gameID];
    if (gameID == 0) {
        self.roomType = HSAudio;
    } else {
        self.roomType = HSGame;
    }
    [self roomTypeReloadContent];
    [self handleRoomChange:self.roomType];
}

- (void)handleRoomChange:(RoomType)roomType {
    
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

- (void)hanldeInitSudFSMMG {
    [super hanldeInitSudFSMMG];
    self.audioMicContentView.iSudFSMMG = self.gameEventHandler.sudFSMMGDecorator;
}

@end
