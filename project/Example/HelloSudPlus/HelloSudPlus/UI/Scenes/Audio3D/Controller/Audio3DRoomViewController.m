//
//  AudioRoomViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "Audio3DRoomViewController.h"
#import "EnterRoomModel.h"
#import "Audio3dRoomOperatorView.h"
#import "Audio3dMoreSettingPopView.h"
#import "Audio3dConfigStateModel.h"
#import "Audio3dRoomInputView.h"
#import "Audio3dFaceView.h"
#import "RoomCmd3dMicChangedModel.h"
#import "AnchorDetailView.h"
#import "InviteAnchorPopView.h"
#import "RoomCmdAudio3dSendFaceModel.h"
#import "Audio3dGiftSideView.h"
#import "Audio3dRoomSceneGameEventHandler.h"


@interface Audio3DRoomViewController () {
    Audio3dRoomOperatorView *_audio3dRoomOperatorView;
    Audio3dRoomInputView *_audio3dRoomInputView;
}
@property(nonatomic, strong) UIView *bottomTipView;
/// 房间配置状态
@property(nonatomic, strong) Audio3dConfigStateModel *configStateModel;
@property(nonatomic, strong) Audio3dFaceView *faceView;
@property(nonatomic, assign) CGFloat faceExpectedHeight;
@property(nonatomic, strong) AppCustomCrSetSeatsModel *seatsModel;
@property(nonatomic, strong) AppCustomCrSetRoomConfigModel *roomConfigModel;
@property(nonatomic, strong) NSMutableDictionary<NSString *, AppCustomCrSeatItemModel *> *seatDic;
@property(nonatomic, assign) BOOL isHadShowBottomTip;
@property(nonatomic, strong) UIView *loadingView;
@property(nonatomic, strong) UIView *progressView;
@property(nonatomic, strong) UILabel *progressTipLabel;
@property(nonatomic, strong) UIButton *retryBtn;
@end

@implementation Audio3DRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

/// 服务类，子类返回对应服务类型，用于构建对应场景服务
- (Class)serviceClass {
    return [Audio3dRoomService class];
}

- (void)setConfigModel:(BaseSceneConfigModel *)configModel {
    [super setConfigModel:configModel];
    if ([configModel isKindOfClass:[AudioSceneConfigModel class]]) {
        AudioSceneConfigModel *m = (AudioSceneConfigModel *) configModel;
    }
}

- (void)dtAddViews {
    [super dtAddViews];

    [self.sceneView addSubview:self.faceView];
    [self.sceneView insertSubview:self.loadingView atIndex:0];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    self.faceExpectedHeight = [self.faceView expectedHeight];
    [self.faceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@(self.faceExpectedHeight));
        make.bottom.equalTo(@0);
    }];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.sceneView);
    }];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    _audio3dRoomOperatorView.audio3dGMoreTapBlock = ^(UIButton *sender) {
        [weakSelf showSettingPopView];
    };
    _audio3dRoomOperatorView.audio3dGiftTapBlock = ^(UIButton *sender) {
        [weakSelf showGiftPannelView:NULL];
    };
    _audio3dRoomOperatorView.audio3dGFaceTapBlock = ^(UIButton *sender) {
        [weakSelf handleBottomFaceClick];
    };

    _audio3dRoomInputView.faceClickBlock = ^(UIButton *sender) {
        if (![weakSelf isMeOnMainAnchorSeat]) {
            [ToastUtil show:@"dt_up_mic_tip".dt_lan];
            return;
        }
        sender.selected = !sender.selected;
        [weakSelf showFaceView:sender.selected];
    };
    _audio3dRoomInputView.onKeyboardHiddenBlock = ^{
        [weakSelf resetRotate];
    };
    
    _audio3dRoomInputView.onKeyboardShowBlock = ^{
        [weakSelf resetRotate];
        weakSelf.faceView.hidden = YES;
    };

    self.faceView.faceItemClickBlock = ^(Audio3dFaceItemModel *faceItemModel) {
        AppCustomCrSeatItemModel *seatItemModel = weakSelf.seatDic[APP_SERVICE.loginUserID];
        NSInteger seatIndex = 0;
        if (seatItemModel) {
            seatIndex = seatItemModel.seatIndex;
        }
        if (faceItemModel.type == Audio3dFaceItemModelLight) {
            AppCustomCrSetLightFlashModel *flashModel = AppCustomCrSetLightFlashModel.new;
            flashModel.seatIndex = seatIndex;
            [weakSelf.gameEventHandler.sudFSTAPPDecorator notifyAppCustomCrSetLightFlash:flashModel];
        } else if (faceItemModel.type == Audio3dFaceItemModelFace) {
            // 选择动效
            AppCustomCrPlayAnimModel *playAnimModel = AppCustomCrPlayAnimModel.new;
            playAnimModel.animId = faceItemModel.faceId;
            playAnimModel.seatIndex = seatIndex;
            [weakSelf.gameEventHandler.sudFSTAPPDecorator notifyAppCustomCrPlayAnim:playAnimModel];


        }

        // 发消息
        RoomCmdAudio3dSendFaceModel *sendFaceModel = [RoomCmdAudio3dSendFaceModel makeUpMicMsgWithFaceId:faceItemModel.faceId seatIndex:seatIndex type:faceItemModel.type];
        [weakSelf sendMsg:sendFaceModel isAddToShow:NO finished:nil];
        [weakSelf showMicEffect:sendFaceModel];
//        // 关闭表情
//        [weakSelf closeFaceViewIfNeed];
    };

    [[NSNotificationCenter defaultCenter] addObserverForName:NTF_REMOTE_VOICE_VOLUME_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *_Nonnull note) {
        NSDictionary<NSString *, NSNumber *> *dicSoundLevel = note.userInfo[@"dicVolume"];
        if ([dicSoundLevel isKindOfClass:NSDictionary.class]) {
            NSArray *userIdList = [dicSoundLevel allKeys];
            for (NSString *userId in userIdList) {
                CGFloat value = dicSoundLevel[userId].floatValue;
                AppCustomCrSeatItemModel *m = weakSelf.seatDic[userId];
                if (!m) {
                    continue;
                }
                AppCustomCrMicphoneValueSeatModel *valueSeatModel = AppCustomCrMicphoneValueSeatModel.new;
                valueSeatModel.value = (NSInteger) (value);
                valueSeatModel.seatIndex = m.seatIndex;
                [weakSelf.gameEventHandler.sudFSTAPPDecorator notifyAppCustomCrMicphoneValueSeat:valueSeatModel];
            }
        }
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:NTF_LOCAL_VOICE_VOLUME_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *_Nonnull note) {
        NSNumber *soundLevel = note.userInfo[@"volume"];
        if ([soundLevel isKindOfClass:NSNumber.class]) {
            NSString *myUserID = AppService.shared.login.loginUserInfo.userID;
            AppCustomCrSeatItemModel *m = weakSelf.seatDic[myUserID];
            if (!m) {
                return;
            }
            CGFloat value = soundLevel.floatValue;
            AppCustomCrMicphoneValueSeatModel *valueSeatModel = AppCustomCrMicphoneValueSeatModel.new;
            valueSeatModel.value = (NSInteger) (value);
            valueSeatModel.seatIndex = m.seatIndex;
            [weakSelf.gameEventHandler.sudFSTAPPDecorator notifyAppCustomCrMicphoneValueSeat:valueSeatModel];
        }
    }];

    [self.bottomTipView dt_onTap:^(UITapGestureRecognizer *tap) {
        [weakSelf onBottomTipBtnClick:nil];
    }];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
}

/// 自己是否在主播位
- (BOOL)isMeOnMainAnchorSeat {
    AppCustomCrSeatItemModel *seatItemModel = self.seatDic[APP_SERVICE.loginUserID];
    if (seatItemModel && seatItemModel.seatIndex > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isShowAddRobotBtn {
    return YES;
}

/// 是否自定义游戏进度条
/// @return YES显示，NO隐藏
- (BOOL)showCustomLoadingView {
    return YES;
}

- (BOOL)isNeedToShowGiftEffect {
    return NO;
}

/// 创建游戏事件处理模块
- (BaseSceneGameEventHandler *)createGameEventHandler {
    return Audio3dRoomSceneGameEventHandler.new;
}

- (void)handleBottomFaceClick {

    if (![self isMeOnMainAnchorSeat]) {
        [ToastUtil show:@"dt_up_mic_tip".dt_lan];
        return;
    }
    [_audio3dRoomInputView selectFace:YES];
}

- (void)setSeatsModel:(AppCustomCrSetSeatsModel *)seatsModel {
    _seatsModel = seatsModel;
    if (!self.seatDic) {
        self.seatDic = NSMutableDictionary.new;
    }
    [self.seatDic removeAllObjects];
    for (AppCustomCrSeatItemModel *item in self.seatsModel.seats) {
        if (item.microState == AppCustomCrSeatItemModelTypeHasUser) {
            self.seatDic[item.userId] = item;
        }
    }
}

- (void)showFaceView:(BOOL)bShow {
    if (bShow) {
        [self stopRotate];
        [self.inputView hsResignFirstResponder];
        self.faceView.transform = CGAffineTransformMakeTranslation(0, self.faceExpectedHeight);
        self.faceView.hidden = NO;
        [UIView animateWithDuration:0.25 delay:0 options:0 animations:^{
            self.faceView.transform = CGAffineTransformIdentity;
            [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@(-self.faceExpectedHeight));
            }];
            [self.inputView.superview layoutIfNeeded];
        }                completion:^(BOOL finished) {
        }];
        return;
    }
    [self resetRotate];
    [self.inputView hsBecomeFirstResponder];
    self.faceView.hidden = YES;
}

- (void)showSettingPopView {
    WeakSelf
    Audio3dMoreSettingPopView *v = Audio3dMoreSettingPopView.new;
    [self update3dRoomConfigState];
    [v updateConfig:self.configStateModel];
    __weak typeof(v) weakV = v;
    v.voiceChangedBlock = ^(BOOL isSelected) {
        weakSelf.configStateModel.isVoiceStateOpen = isSelected;
        [weakV updateConfig:weakSelf.configStateModel];
        [weakSelf reqUpdateConfig];
        [ToastUtil show:isSelected ? @"dt_room_open_voice_tip".dt_lan : @"dt_room_close_voice_tip".dt_lan];
    };
    v.lightChangedBlock = ^(BOOL isSelected) {
        weakSelf.configStateModel.isLightStateOpen = isSelected;
        [weakV updateConfig:weakSelf.configStateModel];
        [weakSelf reqUpdateConfig];
        [ToastUtil show:isSelected ? @"dt_room_open_light_tip".dt_lan : @"dt_room_close_light_tip".dt_lan];
    };
    v.rotateChangedBlock = ^(BOOL isSelected) {
        weakSelf.configStateModel.isRotateStateOpen = isSelected;
        [weakV updateConfig:weakSelf.configStateModel];
        [weakSelf reqUpdateConfig];
        [ToastUtil show:isSelected ? @"dt_room_open_rotate_tip".dt_lan : @"dt_room_close_rotate_tip".dt_lan];
    };
    [DTSheetView show:v rootView:nil hiddenBackCover:NO cornerRadius:0 onCloseCallback:nil];
}

- (void)update3dRoomConfigState {
    self.configStateModel.isRotateStateOpen = (BOOL) self.roomConfigModel.platformRotate;
    self.configStateModel.isLightStateOpen = (BOOL) self.roomConfigModel.flashVFX;
    self.configStateModel.isVoiceStateOpen = (BOOL) self.roomConfigModel.micphoneWave;
}

- (void)reqUpdateConfig {

    self.roomConfigModel.platformRotate = self.configStateModel.isRotateStateOpen;
    self.roomConfigModel.flashVFX = self.configStateModel.isLightStateOpen;
    self.roomConfigModel.micphoneWave = self.configStateModel.isVoiceStateOpen;
    [self.gameEventHandler.sudFSTAPPDecorator notifyAppCustomCrSetRoomConfig:self.roomConfigModel];
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


- (void)roomGameDidChanged:(NSInteger)gameID {
    [super roomGameDidChanged:gameID];
    if (gameID == HSAudio) {
        self.loadingView.hidden = YES;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onDelayShowBottomTip) object:nil];
        [_audio3dRoomOperatorView showAudio3dStyle:NO];
        [_audio3dRoomInputView showAudio3dStyle:NO];
    } else {
        [_audio3dRoomOperatorView showAudio3dStyle:YES];
        [_audio3dRoomInputView showAudio3dStyle:YES];
    }
}

- (void)handleRoomChange:(RoomType)roomType {
    [super handleRoomChange:roomType];
}

/// 场景视图被点击了
- (void)onSceneViewClick {
    [super onSceneViewClick];
    [self closeFaceViewIfNeed];
}

- (void)closeFaceViewIfNeed {
    if (!self.faceView.hidden) {
        self.faceView.hidden = YES;
        [_audio3dRoomInputView selectFace:NO];
    }
}

- (AppCustomCrSetRoomConfigModel *)roomConfigModel {
    if (!_roomConfigModel) {
        _roomConfigModel = AppCustomCrSetRoomConfigModel.new;
    }
    return _roomConfigModel;
}

- (RoomOperatorView *)operatorView {
    if (!_audio3dRoomOperatorView) {
        _audio3dRoomOperatorView = [[Audio3dRoomOperatorView alloc] init];
    }
    return _audio3dRoomOperatorView;
}

- (RoomInputView *)inputView {
    if (!_audio3dRoomInputView) {
        _audio3dRoomInputView = [[Audio3dRoomInputView alloc] init];
    }
    return _audio3dRoomInputView;
}

- (Audio3dFaceView *)faceView {
    if (!_faceView) {
        _faceView = Audio3dFaceView.new;
        _faceView.backgroundColor = HEX_COLOR(@"#F5F6FB");
        _faceView.hidden = YES;
    }
    return _faceView;
}

- (UIView *)bottomTipView {
    if (!_bottomTipView) {
        _bottomTipView = UIView.new;
        _bottomTipView.backgroundColor = HEX_COLOR_A(@"#000000", 0.4);

        UIView *contentView = UIView.new;

        UILabel *labTile = UILabel.new;
        labTile.text = @"dt_audio3d_tip".dt_lan;
        labTile.textColor = HEX_COLOR(@"#FFFFFF");
        labTile.font = UIFONT_BOLD(14);

        UIImageView *bgImageView = UIImageView.new;
        bgImageView.image = [UIImage imageNamed:@"audio3d_more_tip"];

        UIButton *closeBtn = UIButton.new;
        [closeBtn setTitle:@"dt_audio3d_tip_close".dt_lan forState:UIControlStateNormal];
        [closeBtn setTitleColor:HEX_COLOR(@"#417CE8") forState:UIControlStateNormal];
        closeBtn.titleLabel.font = UIFONT_BOLD(12);
        closeBtn.backgroundColor = UIColor.whiteColor;
        [closeBtn addTarget:self action:@selector(onBottomTipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn dt_cornerRadius:10];

        UIButton *audio3dGiftBtn = [[UIButton alloc] init];
        [audio3dGiftBtn setImage:[UIImage imageNamed:@"audio3d_gift"] forState:UIControlStateNormal];
        audio3dGiftBtn.userInteractionEnabled = NO;

        UIButton *audio3dFaceBtn = [[UIButton alloc] init];
        [audio3dFaceBtn setImage:[UIImage imageNamed:@"audio3d_more"] forState:UIControlStateNormal];
        audio3dFaceBtn.userInteractionEnabled = NO;

        UIButton *audio3dMoreBtn = [[UIButton alloc] init];
        [audio3dMoreBtn setImage:[UIImage imageNamed:@"audio3d_face"] forState:UIControlStateNormal];
        audio3dMoreBtn.userInteractionEnabled = NO;

        UIImageView *starImageView = UIImageView.new;
        starImageView.image = [UIImage imageNamed:@"audio3d_star"];


        [_bottomTipView addSubview:contentView];
        [contentView addSubview:bgImageView];
        [contentView addSubview:labTile];
        [contentView addSubview:closeBtn];

        [_bottomTipView addSubview:audio3dGiftBtn];
        [_bottomTipView addSubview:audio3dFaceBtn];
        [_bottomTipView addSubview:audio3dMoreBtn];
        [_bottomTipView addSubview:starImageView];

        [starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(audio3dFaceBtn.mas_leading).offset(3);
            make.centerY.equalTo(audio3dFaceBtn.mas_top);
            make.size.mas_equalTo(CGSizeMake(11, 17));
        }];

        [audio3dFaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(audio3dGiftBtn.mas_leading).offset(-4);
            make.centerY.mas_equalTo(audio3dMoreBtn);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [audio3dGiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(audio3dMoreBtn.mas_leading).offset(-4);
            make.centerY.mas_equalTo(audio3dMoreBtn);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        CGFloat b = kAppSafeBottom;
        [audio3dMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-13);
            make.centerY.mas_equalTo(audio3dMoreBtn);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.bottom.equalTo(@(-b));
        }];


        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.bottom.equalTo(@0);
        }];
        [labTile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@11);
            make.leading.equalTo(@16);
            make.height.greaterThanOrEqualTo(@0);
            make.trailing.equalTo(closeBtn.mas_leading).offset(-8);
        }];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@-15);
            make.height.equalTo(@20);
            make.width.greaterThanOrEqualTo(@0);
            make.centerY.equalTo(labTile);
        }];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@-13);
            make.width.equalTo(@202);
            make.height.equalTo(@104);
            make.bottom.equalTo(audio3dMoreBtn.mas_top).offset(-2);
        }];


    }
    return _bottomTipView;
}

- (UIView *)loadingView {
    if (!_loadingView) {
        _loadingView = UIView.new;

        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"audio3d_loading"]];

        UIView *contentView = UIView.new;

        UIImageView *iconImageView = UIImageView.new;
        NSString *iconUrl = [NSBundle.mainBundle pathForResource:@"audio3d_cube" ofType:@"png" inDirectory:@"Res"];
        [iconImageView sd_setImageWithURL:iconUrl.dt_toURL];

        UILabel *tipLabel = UILabel.new;
        tipLabel.textColor = HEX_COLOR(@"#ffffff");
        tipLabel.font = UIFONT_MEDIUM(10);

        UIView *bgTraceView = UIView.new;
        bgTraceView.backgroundColor = HEX_COLOR(@"#000000");

        UIView *progressView = UIView.new;
        [progressView dt_setGradientBackgroundWithColors:@[HEX_COLOR(@"#76FFF4"), HEX_COLOR(@"#FFFFFF")] locations:@[@(0.0), @(1)] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1)];

        UIImageView *thumbView = UIImageView.new;
        thumbView.image = [UIImage imageNamed:@"audio3d_thumb"];

        

        UIButton *retryBtn = UIButton.new;
        retryBtn.layer.borderWidth = 1;
        retryBtn.layer.borderColor = UIColor.whiteColor.CGColor;
        [retryBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        retryBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
        [retryBtn setTitle:@"dt_room_retry_load".dt_lan forState:UIControlStateNormal];
        retryBtn.hidden = YES;
        WeakSelf
        [retryBtn dt_onClick:^(UIButton *sender) {
            [weakSelf.gameEventHandler.sudFSTAPPDecorator reLoadMG];
        }];

        self.progressTipLabel = tipLabel;
        self.progressView = progressView;
        self.retryBtn = retryBtn;

        [_loadingView addSubview:bgImageView];
        [_loadingView addSubview:iconImageView];

        [_loadingView addSubview:contentView];

        [contentView addSubview:tipLabel];
        [contentView addSubview:bgTraceView];
        [contentView addSubview:progressView];
        [contentView addSubview:retryBtn];
        [contentView addSubview:thumbView];

        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];

        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@210);
            make.height.equalTo(@147);
            make.centerX.equalTo(_loadingView);
            make.top.equalTo(@(kAppSafeTop + 156));
        }];

        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.height.greaterThanOrEqualTo(@0);
            make.top.equalTo(iconImageView.mas_bottom).offset(80);
        }];

        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
            make.width.greaterThanOrEqualTo(@0);
            make.centerX.equalTo(contentView);
            make.top.equalTo(@0);
        }];
        [bgTraceView dt_cornerRadius:1.5];
        [bgTraceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@70);
            make.trailing.equalTo(@-70);
            make.height.equalTo(@3);
            make.top.equalTo(tipLabel.mas_bottom).offset(5);
        }];
        [progressView dt_cornerRadius:1.5];
        [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(bgTraceView);
            make.height.equalTo(bgTraceView);
            make.centerY.equalTo(bgTraceView);
            make.width.equalTo(@10);
        }];
        [thumbView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@10);
            make.centerX.equalTo(progressView.mas_trailing);
            make.centerY.equalTo(progressView);
        }];
        [retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(104, 36));
            make.top.equalTo(bgTraceView.mas_bottom).offset(60);
            make.centerX.equalTo(bgTraceView);
            make.bottom.equalTo(@0);
        }];

    }
    return _loadingView;
}

- (Audio3dConfigStateModel *)configStateModel {
    if (!_configStateModel) {
        _configStateModel = Audio3dConfigStateModel.new;
    }
    return _configStateModel;
}


- (void)onBottomTipBtnClick:(UIButton *)sender {
    [self.bottomTipView removeFromSuperview];
    self.bottomTipView.hidden = YES;
    [_audio3dRoomOperatorView showTipSate:NO];
}

/// 声音状态变化
- (void)onVoiceStateChanged:(VoiceBtnStateType)state {
    [super onVoiceStateChanged:state];
    [self handleGameMicState:state];
}

/// 处理游戏麦状态
- (void)handleGameMicState:(VoiceBtnStateType)state {
    AppCustomCrSeatItemModel *seatItemModel = self.seatDic[AppService.shared.loginUserID];
    if (!seatItemModel) {
        return;
    }
    switch (state) {
        case VoiceBtnStateTypeOnVoice: {
            if (seatItemModel.micphoneState == Audio3dMicStateTypeOpen) {
                break;
            }
            ReqAudio3dUpdateMicModel *micModel = ReqAudio3dUpdateMicModel.new;
            micModel.roomId = self.roomID;
            micModel.userId = AppService.shared.loginUserID;
            micModel.micphoneState = Audio3dMicStateTypeOpen;
            [kAudio3dRoomService req3dRoomUpdateMicState:micModel finished:^{

            }];
        }
            break;
        default: {
            if (seatItemModel.micphoneState == Audio3dMicStateTypeClose) {
                break;
            }
            ReqAudio3dUpdateMicModel *micModel = ReqAudio3dUpdateMicModel.new;
            micModel.roomId = self.roomID;
            micModel.userId = AppService.shared.loginUserID;
            micModel.micphoneState = Audio3dMicStateTypeClose;
            [kAudio3dRoomService req3dRoomUpdateMicState:micModel finished:^{

            }];
        }
            break;
    }
}

- (AppCustomCrSeatItemModel *)getMicInfoBySeatIndex:(NSInteger)seatIndex {
    for (AppCustomCrSeatItemModel *item in self.seatsModel.seats) {
        if (item.seatIndex == seatIndex) {
            return item;
        }
    }
    return nil;
}


- (void)stopRotate {
    
    AppCustomCrPauseRotateModel *model = AppCustomCrPauseRotateModel.new;
    model.pause = 1;
    [self.gameEventHandler.sudFSTAPPDecorator notifyAppCustomCrPauseRotate:model];
}

- (void)resetRotate {

    AppCustomCrPauseRotateModel *model = AppCustomCrPauseRotateModel.new;
    model.pause = 0;
    [self.gameEventHandler.sudFSTAPPDecorator notifyAppCustomCrPauseRotate:model];
}


/// 请求房间数据 MG_CUSTOM_CR_ROOM_INIT_DATA
- (void)onGameMGCustomCrRoomInitData:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomCrRoomInitData *)model {
    DDLogDebug(@"onGameMGCustomCrRoomInitData");
    WeakSelf
    // 获取房间配置
    [kAudio3dRoomService reqGet3dRoomConfig:self.roomID finished:^(AppCustomCrSetRoomConfigModel *resp) {
        // 设置房间配置给游戏
        self.roomConfigModel = resp;
        [weakSelf.gameEventHandler.sudFSTAPPDecorator notifyAppCustomCrSetRoomConfig:resp];
    }];
    // 获取麦位列表
    ReqAudio3dMicSeatsModel *seatsModel = ReqAudio3dMicSeatsModel.new;
    seatsModel.roomId = self.roomID;
    [kAudio3dRoomService req3dRoomMicSeatsList:seatsModel finished:^(AppCustomCrSetSeatsModel *seatsModel) {
        // 设置麦位列表给游戏
        weakSelf.seatsModel = seatsModel;
        [weakSelf.gameEventHandler.sudFSTAPPDecorator notifyAppCustomCrSetSeats:seatsModel];
    }];
}

/// 点击主播位或老板位通知 MG_CUSTOM_CR_CLICK_SEAT
- (void)onGameMGCustomCrClickSeat:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomCrClickSeat *)model {

    BOOL isBossSeat = model.seatIndex == 0;
    NSMutableArray *arrOperate = [[NSMutableArray alloc] init];
    AppCustomCrSeatItemModel *seatItemModel = [self getMicInfoBySeatIndex:model.seatIndex];
    if (!seatItemModel) {
        DDLogError(@"麦位数据为空");
        [ToastUtil show:@"dt_room_no_mic_tip".dt_lan];
        return;
    }
    switch (seatItemModel.microState) {
        case AppCustomCrSeatItemModelTypeHasUser:
            // 有人
            if ([seatItemModel.userId isEqualToString:APP_SERVICE.loginUserID]) {
                // 自己
                // 下麦
                [arrOperate addObject:@"dt_down_mic".dt_lan];
            } else {
                // 查看资料

                if (self.isRoomOwner) {
                    [arrOperate addObject:@"dt_room_look_user_detail".dt_lan];
                    // 抱下麦
                    [arrOperate addObject:@"dt_room_kick_out_mic".dt_lan];
                    // 锁麦
                    [arrOperate addObject:@"dt_room_lock_mic".dt_lan];
                    // 踢出房间
                    [arrOperate addObject:@"dt_room_mic_kick_out_room".dt_lan];
                } else {
                    // 直接查看资料
                    [self showUserDetailView:seatItemModel.userId];
                    return;
                }
            }
            break;
        case AppCustomCrSeatItemModelTypeEmpty:
            // 没人
            // 上麦
            if (isBossSeat || !self.isRoomOwner) {
                // 上麦
                [arrOperate addObject:@"dt_room_up_mic".dt_lan];
            } else {
                // 自己上麦
                [arrOperate addObject:@"dt_room_self_up_mic".dt_lan];
            }
            if (self.isRoomOwner) {
                // 房主
                if (!isBossSeat) {
                    [arrOperate addObject:@"dt_room_invite_up_mic".dt_lan];
                }
                // 锁麦
                [arrOperate addObject:@"dt_room_lock_mic".dt_lan];
            }

            break;
        case AppCustomCrSeatItemModelTypeLocked:
            // 锁麦
            if (self.isRoomOwner) {
                // 解锁
                [arrOperate addObject:@"dt_room_unlock_mic".dt_lan];
            } else {
                // tip 提示
                [ToastUtil show:@"dt_room_mic_lock_tip".dt_lan];
                return;
            }
            break;
        default:
            break;
    }


    MicOperateView *v = [[MicOperateView alloc] initWithOperateList:arrOperate];
    WeakSelf
    v.operateCallback = ^(NSString *str) {
        [DTSheetView close];
        [weakSelf resetRotate];
        [weakSelf handleMicOperate:str seatItemModel:seatItemModel];
    };
    v.cancelCallback = ^(UIButton *sender) {
        [weakSelf resetRotate];
        [DTSheetView close];
    };
    [self stopRotate];
    [DTSheetView show:v rootView:self.view hiddenBackCover:NO onCloseCallback:^{
        [weakSelf resetRotate];
    }];
}

- (void)handleMicOperate:(NSString *)operateStr seatItemModel:(AppCustomCrSeatItemModel *)seatItemModel {
    WeakSelf
    if ([operateStr isEqualToString:@"dt_down_mic".dt_lan]) {
        // 下麦
        ReqAudio3dUpMicModel *upMicModel = ReqAudio3dUpMicModel.new;
        upMicModel.roomId = self.roomID;
        upMicModel.userId = seatItemModel.userId;
        upMicModel.micIndex = seatItemModel.seatIndex;
        upMicModel.handleType = Audio3dMicHandleTypeDown;
        [kAudio3dRoomService req3dRoomUpMic:upMicModel finished:^{

        }];
    } else if ([operateStr isEqualToString:@"dt_room_up_mic".dt_lan] || [operateStr isEqualToString:@"dt_room_self_up_mic".dt_lan]) {
        // 上麦
        ReqAudio3dUpMicModel *upMicModel = ReqAudio3dUpMicModel.new;
        upMicModel.roomId = self.roomID;
        upMicModel.userId = APP_SERVICE.loginUserID;
        upMicModel.micIndex = seatItemModel.seatIndex;
        upMicModel.handleType = Audio3dMicHandleTypeUp;
        [kAudio3dRoomService req3dRoomUpMic:upMicModel finished:^{

        }];
    } else if ([operateStr isEqualToString:@"dt_room_look_user_detail".dt_lan]) {
        // 查看资料卡
        [self showUserDetailView:seatItemModel.userId];

    } else if ([operateStr isEqualToString:@"dt_room_kick_out_mic".dt_lan]) {
        // 抱下麦
        ReqAudio3dUpMicModel *upMicModel = ReqAudio3dUpMicModel.new;
        upMicModel.roomId = self.roomID;
        upMicModel.userId = seatItemModel.userId;
        upMicModel.micIndex = seatItemModel.seatIndex;
        upMicModel.handleType = Audio3dMicHandleTypeDown;
        [kAudio3dRoomService req3dRoomUpMic:upMicModel finished:^{

        }];
    } else if ([operateStr isEqualToString:@"dt_room_lock_mic".dt_lan]) {
        // 锁麦

        if (seatItemModel.microState == AppCustomCrSeatItemModelTypeHasUser) {
            // 抱下麦
            ReqAudio3dUpMicModel *upMicModel = ReqAudio3dUpMicModel.new;
            upMicModel.roomId = self.roomID;
            upMicModel.userId = seatItemModel.userId;
            upMicModel.micIndex = seatItemModel.seatIndex;
            upMicModel.handleType = Audio3dMicHandleTypeDown;
            [kAudio3dRoomService req3dRoomUpMic:upMicModel finished:^{
                // 锁麦
                ReqAudio3dLockMicModel *lockMicModel = ReqAudio3dLockMicModel.new;
                lockMicModel.roomId = weakSelf.roomID;
                lockMicModel.micIndex = seatItemModel.seatIndex;
                lockMicModel.handleType = Audio3dMicLockHandleTypeLock;
                [kAudio3dRoomService req3dRoomLocakMic:lockMicModel finished:^{

                }];
            }];
        } else {
            // 锁麦
            ReqAudio3dLockMicModel *lockMicModel = ReqAudio3dLockMicModel.new;
            lockMicModel.roomId = weakSelf.roomID;
            lockMicModel.micIndex = seatItemModel.seatIndex;
            lockMicModel.handleType = Audio3dMicLockHandleTypeLock;
            [kAudio3dRoomService req3dRoomLocakMic:lockMicModel finished:^{

            }];
        };


    } else if ([operateStr isEqualToString:@"dt_room_unlock_mic".dt_lan]) {
        // 解锁
        ReqAudio3dLockMicModel *lockMicModel = ReqAudio3dLockMicModel.new;
        lockMicModel.roomId = self.roomID;
        lockMicModel.micIndex = seatItemModel.seatIndex;
        lockMicModel.handleType = Audio3dMicLockHandleTypeUnlock;
        [kAudio3dRoomService req3dRoomLocakMic:lockMicModel finished:^{

        }];
    } else if ([operateStr isEqualToString:@"dt_room_mic_kick_out_room".dt_lan]) {
        // 踢出房间

        // 抱下麦
        ReqAudio3dUpMicModel *upMicModel = ReqAudio3dUpMicModel.new;
        upMicModel.roomId = self.roomID;
        upMicModel.userId = seatItemModel.userId;
        upMicModel.micIndex = seatItemModel.seatIndex;
        upMicModel.handleType = Audio3dMicHandleTypeDown;
        [kAudio3dRoomService req3dRoomUpMic:upMicModel finished:^{

        }];
        // 发送踢出房间
        RoomCmdKickoutRoomModel *msg = [RoomCmdKickoutRoomModel makeKickoutRoomMsg:seatItemModel.userId];
        [self sendMsg:msg isAddToShow:NO finished:nil];
    } else if ([operateStr isEqualToString:@"dt_room_invite_up_mic".dt_lan]) {

        NSMutableArray *anchorList = NSMutableArray.new;
        NSArray <AudioUserModel *> *micUserList = self.getAllMic;
        NSMutableDictionary *dicTemp = NSMutableDictionary.new;
        for (AppCustomCrSeatItemModel *itemModel in self.seatsModel.seats) {
            if (itemModel.microState == AppCustomCrSeatItemModelTypeHasUser) {
                dicTemp[itemModel.userId] = itemModel;
            }
        }
        for (AudioUserModel *userModel in micUserList) {
            Audio3dInviteAnchorModel *anchorModel = Audio3dInviteAnchorModel.new;
            anchorModel.name = userModel.name;
            anchorModel.avatar = userModel.icon;
            anchorModel.isInvited = dicTemp[userModel.userID] != nil;
            anchorModel.userId = userModel.userID;
            [anchorList addObject:anchorModel];
        }
        WeakSelf
        [self stopRotate];
        InviteAnchorPopView *v = InviteAnchorPopView.new;
        v.inviteClickBlock = ^(Audio3dInviteAnchorModel *anchorModel) {
            [DTSheetView close];
            [weakSelf resetRotate];
            ReqAudio3dUpMicModel *upMicModel = ReqAudio3dUpMicModel.new;
            upMicModel.roomId = weakSelf.roomID;
            upMicModel.userId = anchorModel.userId;
            upMicModel.micIndex = seatItemModel.seatIndex;
            upMicModel.handleType = Audio3dMicHandleTypeUp;
            [kAudio3dRoomService req3dRoomUpMic:upMicModel finished:^{

            }];
        };
        [v showList:anchorList];
        [DTSheetView show:v rootView:nil hiddenBackCover:NO cornerRadius:0 onCloseCallback:nil];
    }

}

- (void)handleBusyCommand:(NSInteger)cmd command:(NSString *)command {
    [super handleBusyCommand:cmd command:command];
    switch (cmd) {
        case CMD_ROOM_3D_MIC_STATE_CHANGE_NOTIFY: {
            // 麦位变更通知
            RoomCmd3dMicChangedModel *m = [RoomCmd3dMicChangedModel fromServerJSON:command];
            AppCustomCrSetSeatsModel *seatsModel = AppCustomCrSetSeatsModel.new;
            seatsModel.seats = m.seats;
            self.seatsModel = seatsModel;
            [self.gameEventHandler.sudFSTAPPDecorator notifyAppCustomCrSetSeats:seatsModel];
            // 更新自己开闭状态
            [self handleGameMicState:self.operatorView.voiceBtnState];
        }
            break;
        case CMD_ROOM_3D_CONFIG_CHANGE_NOTIFY: {
            // 房间配置变更
            // 设置房间配置给游戏
            AppCustomCrSetRoomConfigModel *configModel = [RoomBaseCMDModel parseInstance:AppCustomCrSetRoomConfigModel.class fromServerJSON:command];
            self.roomConfigModel = configModel;
            [self.gameEventHandler.sudFSTAPPDecorator notifyAppCustomCrSetRoomConfig:configModel];

        }
            break;
        case CMD_ROOM_GIFT_VALUES_CHANGE_NOTIFY_V2:
            break;
        case CMD_ROOM_3D_SEND_FACE_NOTIFY: {
            RoomCmdAudio3dSendFaceModel *m = [RoomCmdAudio3dSendFaceModel fromJSON:command];
            if (m.type == Audio3dFaceItemModelLight) {
                AppCustomCrSetLightFlashModel *flashModel = AppCustomCrSetLightFlashModel.new;
                flashModel.seatIndex = m.seatIndex;
                [self.gameEventHandler.sudFSTAPPDecorator notifyAppCustomCrSetLightFlash:flashModel];
                [self showMicEffect:m];
            } else if (m.type == Audio3dFaceItemModelFace) {
                // 选择动效
                AppCustomCrPlayAnimModel *playAnimModel = AppCustomCrPlayAnimModel.new;
                playAnimModel.animId = m.faceId;
                playAnimModel.seatIndex = m.seatIndex;
                [self.gameEventHandler.sudFSTAPPDecorator notifyAppCustomCrPlayAnim:playAnimModel];
            }
        }
            break;
        default:
            break;
    }
}

/// 展示麦位爆灯
- (void)showMicEffect:(RoomCmdAudio3dSendFaceModel *)model {
    if (model.type != Audio3dFaceItemModelLight) {
        return;
    }
    NSArray <AudioMicroView *> *micList = self.gameMicContentView.micArr;
    for (AudioMicroView *microView in micList) {
        if (microView.model.user && [microView.model.user.userID isEqualToString:model.sendUser.userID]) {
            UIImageView *iconImageView = UIImageView.new;
            NSString *iconUrl = [NSBundle.mainBundle pathForResource:@"audio3d_baodeng" ofType:@"png" inDirectory:@"Res"];
            [iconImageView sd_setImageWithURL:iconUrl.dt_toURL];

            [microView addSubview:iconImageView];
            [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@60);
                make.centerX.equalTo(microView.headerView).offset(2);
                make.centerY.equalTo(microView.headerView);
            }];
            [HSThreadUtils dispatchMainAfter:2 callback:^{
                [iconImageView removeFromSuperview];
            }];
        }
    }

}

/// 处理礼物动效
/// @param model model description
- (void)handleGiftEffect:(RoomCmdSendGiftModel *)model {
    [super handleGiftEffect:model];

    [Audio3dGiftSideView showOnView:self.sceneView effectModel:model];
    // 处理送出礼物，执行相应游戏指令
    AppCustomCrPlayGiftEffectModel *effectModel = AppCustomCrPlayGiftEffectModel.new;
    effectModel.giverUserId = model.sendUser.userID;
    effectModel.isAllSeat = model.isAllSeat;
    NSMutableArray *giftList = NSMutableArray.new;

    BOOL isUserInGameMic = NO;
    for (AudioUserModel *audioUserModel in model.toUserList) {
        AppCustomCrPlayGiftItemModel *giftItemModel = AppCustomCrPlayGiftItemModel.new;
        giftItemModel.count = model.giftCount;
        AppCustomCrSeatItemModel *seatItemModel = self.seatDic[audioUserModel.userID];
        giftItemModel.seatIndex = seatItemModel.seatIndex;
        giftItemModel.level = [self getGiftRandLevel:model];
        if (self.seatDic[audioUserModel.userID]) {
            isUserInGameMic = YES;
            [giftList addObject:giftItemModel];
        }
    }
    if (!isUserInGameMic) {
        // 没有人在游戏麦位，不强制全麦
        effectModel.isAllSeat = NO;
    }
    effectModel.giftList = giftList;
    [self.gameEventHandler.sudFSTAPPDecorator notifyAppCustomCrPlayGiftEffect:effectModel];
}

/// 随机获取级别
- (NSInteger)getGiftRandLevel:(RoomCmdSendGiftModel *)sendGiftModel {
    GiftModel *giftModel = sendGiftModel.getGiftModel;
    NSInteger fromLevel = 0;
    NSInteger toLevel = 0;
    if (giftModel.price >= 1 && giftModel.price <= 10) {
        fromLevel = 1;
        toLevel = 10;
    } else if (giftModel.price == 50) {
        fromLevel = 11;
        toLevel = 20;
    } else {
        fromLevel = 21;
        toLevel = 30;
    }
    return arc4random() % (toLevel - fromLevel) + fromLevel;
}

/// 游戏加载进度(loadMG)
/// @param stage start=1,loading=2,end=3
/// @param retCode 错误码，0成功
/// @param progress [0, 100]
/// 最低版本：v1.1.30.xx
- (void)onGameLoadingProgress:(int)stage retCode:(int)retCode progress:(int)progress {

    if (retCode != 0) {
        self.retryBtn.hidden = NO;
        self.progressTipLabel.text = [NSString stringWithFormat:@"%@(%@)", @"dt_room_game_loading".dt_lan, @(retCode)];
    } else {
        CGFloat width = kScreenWidth - 150;
        self.progressTipLabel.text = [NSString stringWithFormat:@"%@%@%%", @"dt_room_game_loading".dt_lan, @(progress)];
        [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@((width + 10) * progress / 100.0));
        }];
        self.retryBtn.hidden = YES;
        self.loadingView.hidden = NO;
        if (progress == 100) {
            self.loadingView.hidden = YES;
        }
    }


    if (progress < 100 && !self.isHadShowBottomTip) {
        return;
    }

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onDelayShowBottomTip) object:nil];
    [self performSelector:@selector(onDelayShowBottomTip) withObject:nil afterDelay:10];
}

- (void)onDelayShowBottomTip {
    if (self.isHadShowBottomTip) {
        return;
    }
    self.isHadShowBottomTip = YES;
    [_audio3dRoomOperatorView showTipSate:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.sceneView addSubview:self.bottomTipView];
        [self.bottomTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.sceneView);
        }];
    });
}

- (void)onWillSendMsg:(RoomBaseCMDModel *)msg shouldSend:(void (^)(BOOL shouldSend))shouldSend {
    if ([msg isKindOfClass:RoomCmdSendGiftModel.class]) {
        RoomCmdSendGiftModel *m = (RoomCmdSendGiftModel *) msg;
        GiftModel *giftModel = [m getGiftModel];
        NSMutableArray *userIdList = NSMutableArray.new;
        for (AudioUserModel *audioUserModel in m.toUserList) {
            [userIdList addObject:audioUserModel.userID];
        }
        // 发送礼物
        [DanmakuRoomService reqSendGift:self.roomID giftId:[NSString stringWithFormat:@"%@", @(m.giftID)] amount:m.giftCount price:giftModel.price type:m.type == 1 ? 2 : 1 receiverList:userIdList finished:^{
            DDLogDebug(@"发送礼物成功");
            if (shouldSend) shouldSend(YES);
        }                       failure:^(NSError *error) {
            if (shouldSend) shouldSend(NO);

        }];
    } else {
        if (shouldSend) shouldSend(YES);
    }
}

/// 退出房间
- (void)handleExitRoomIsFromSuspend:(BOOL)isSuspend finished:(void (^)(void))finished {
    // 下麦
    AppCustomCrSeatItemModel *seatItemModel = self.seatDic[APP_SERVICE.loginUserID];
    ReqAudio3dUpMicModel *upMicModel = ReqAudio3dUpMicModel.new;
    upMicModel.roomId = self.roomID;
    upMicModel.userId = seatItemModel.userId;
    upMicModel.micIndex = seatItemModel.seatIndex;
    upMicModel.handleType = Audio3dMicHandleTypeDown;
    [kAudio3dRoomService req3dRoomUpMic:upMicModel finished:^{

    }];
    [super handleExitRoomIsFromSuspend:isSuspend finished:finished];
}

/// 展示用户资料卡
- (void)showUserDetailView:(NSString *)userId {
    // 查看资料卡
    AnchorDetailView *v = AnchorDetailView.new;
    v.userId = userId;
    [self stopRotate];
    WeakSelf
    v.clickSendGiftBlock = ^{
        [weakSelf resetRotate];
        [weakSelf showGiftPannelView:userId];
    };

    [DTSheetView show:v rootView:nil hiddenBackCover:NO onCloseCallback:^{
        [weakSelf resetRotate];
    }];
}


@end
