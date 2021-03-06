//
//  AudioRoomViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import <SudMGP/SudMGP-umbrella.h>
#import "RoomMoreView.h"
#import "SuspendRoomView.h"

@interface BaseSceneViewController () <BDAlphaPlayerMetalViewDelegate>

@property(nonatomic, strong) SceneContentView *contentView;

/// 背景视图
@property(nonatomic, strong) UIImageView *bgImageView;

/// 游戏加载主view
@property(nonatomic, strong) BaseView *gameView;

/// 场景视图，所有子类场景
@property(nonatomic, strong) BaseView *sceneView;
/// 场景服务
@property(nonatomic, strong) BaseSceneService *service;

@end

@implementation BaseSceneViewController

- (BOOL)dtIsHiddenNavigationBar {
    return YES;
}

- (void)setConfigModel:(BaseSceneConfigModel *)configModel {
    _configModel = configModel;
    self.gameId = configModel.gameId;
    self.roomID = configModel.roomID;
    self.roomNumber = configModel.roomNumber;
    self.roomName = configModel.roomName;
    self.enterModel = configModel.enterRoomModel;
    // 默认游戏房间ID=当前房间ID
    self.gameRoomID = self.roomID;
    DDLogDebug(@"enter roomID:%@, roleType:%@", self.roomID, @(configModel.roleType));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SuspendRoomView close];
    // Do any additional setup after loading the view.
    self.language = [SettingsService getCurLanguageLocale];
    [self initSudFSMMG];
    [self loginRoom];
    if (self.gameId > 0) {
        [self loginGame];
    }
    [self dtUpdateUI];
    [self.naviView hiddenNodeWithRoleType:kAudioRoomService.roleType];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO;
}

- (void)dtAddViews {
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.gameView];
    [self.contentView addSubview:self.sceneView];

    [self.sceneView addSubview:self.gameTopShadeNode];
    [self.sceneView addSubview:self.naviView];
    [self.sceneView addSubview:self.operatorView];
    [self.sceneView addSubview:self.gameMicContentView];
    [self.sceneView addSubview:self.gameNumLabel];
    [self.sceneView addSubview:self.msgBgView];
    [self.msgBgView addSubview:self.msgTableView];
    [self.contentView addSubview:self.inputView];
}

- (void)dtLayoutViews {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.sceneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.gameTopShadeNode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.sceneView);
        make.height.mas_equalTo(145);
    }];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.top.mas_equalTo(kStatusBarHeight);
        make.height.mas_equalTo(44);
    }];
    [self.operatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.bottom.mas_equalTo(-kAppSafeBottom);
        make.height.mas_equalTo(44);
    }];

    [self.gameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.gameMicContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(0);
        make.leading.mas_equalTo(self.contentView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(55);
    }];
    [self.gameNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(14);
        make.top.mas_equalTo(self.gameMicContentView.mas_bottom).offset(3);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_equalTo(16);
    }];
    [self.msgBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(106);
        make.leading.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.operatorView.mas_top).offset(0);
    }];
    [self.msgTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.msgBgView);
    }];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(80);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
}

- (void)dtConfigEvents {
    WeakSelf
    self.contentView.hitTestChangedCallback = ^(UIView *currentView) {
        // 如果场景视图没有响应事件，将该事件穿透到游戏中去
        if (weakSelf.sceneView == currentView) {
            return weakSelf.gameView;
        }
        return currentView;
    };
    self.operatorView.giftTapBlock = ^(UIButton *sender) {
        [DTSheetView show:[[RoomGiftPannelView alloc] init] rootView:AppUtil.currentWindow hiddenBackCover:YES onCloseCallback:^{
            [weakSelf.operatorView resetAllSelectedUser];
        }];
    };
    self.operatorView.inputTapBlock = ^(UITapGestureRecognizer *gesture) {
        [weakSelf.inputView hsBecomeFirstResponder];
    };
    self.operatorView.voiceTapBlock = ^(UIButton *sender) {
        // 上麦点击
        if (weakSelf.isGameForbiddenVoice) {
            [ToastUtil show:NSString.dt_room_unable_speak_present];
            return;
        }
        switch (weakSelf.operatorView.voiceBtnState) {
            case VoiceBtnStateTypeNormal:
                [weakSelf changeTapVoiceState:VoiceBtnStateTypeUpMic];
                break;
            case VoiceBtnStateTypeUpMic:
                [weakSelf changeTapVoiceState:VoiceBtnStateTypeOnVoice];
                break;
            case VoiceBtnStateTypeWaitOpen:
                [weakSelf changeTapVoiceState:VoiceBtnStateTypeOnVoice];
                break;
            case VoiceBtnStateTypeOnVoice:
                [weakSelf changeTapVoiceState:VoiceBtnStateTypeWaitOpen];
                break;
            default:
                break;
        }
    };
    self.inputView.inputMsgBlock = ^(NSString *_Nonnull msg) {
        // 发送公屏消息
        RoomCmdChatTextModel *m = [RoomCmdChatTextModel makeMsg:msg];
        [weakSelf sendMsg:m isAddToShow:YES];
    };

    self.gameMicContentView.updateMicArrCallBack = ^(NSArray<AudioMicroView *> *_Nonnull micArr) {
        weakSelf.arrAnchorView = micArr;
    };

    self.gameMicContentView.onTapCallback = ^(AudioRoomMicModel *_Nonnull micModel) {
        /// 麦位点击回调
        [weakSelf handleMicTap:micModel];
    };
    self.naviView.closeTapBlock = ^(UIButton *sender) {

        RoomMoreView *v = [[RoomMoreView alloc] init];
        v.suspendCallback = ^{
            [DTSheetView close];
            [SuspendRoomView show:weakSelf];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        v.exitCallback = ^{
            [DTSheetView close];
            [DTAlertView showTextAlert:NSString.dt_room_sure_leave_cur_room sureText:NSString.dt_common_sure cancelText:NSString.dt_common_cancel onSureCallback:^{
                [DTSheetView close];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf exitRoomFromSuspend:NO finished:nil];
                });
            }          onCloseCallback:^{
            }];
        };
        [DTSheetView showTop:v cornerRadius:0 onCloseCallback:^{

        }];
    };
    self.naviView.changeRoomTapBlock = ^(UITapGestureRecognizer *gesture) {
        [weakSelf showSelectGameView];
    };

    // 切换大小模式
    self.gameMicContentView.changeScaleBlock = ^(BOOL isSmall) {
        [weakSelf changeScaleSmallMic:isSmall];
    };
}

/// 调整麦位是否缩放
/// @param bSmall 是否缩放
- (void)changeScaleSmallMic:(BOOL)bSmall {
    if (bSmall) {
        [UIView animateWithDuration:0.35 animations:^{
            [self.gameMicContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.naviView.mas_bottom).offset(31);
                make.trailing.mas_equalTo(self.contentView);
                make.width.mas_equalTo(115);
                make.height.mas_equalTo(24);
            }];
            
            [self.gameMicContentView scaleToSmallView];
            [self.gameMicContentView.superview layoutIfNeeded];
        } completion: ^(BOOL finished){
            [self.gameMicContentView showSmallState];
        }];

    } else {
        [UIView animateWithDuration:0.35 animations:^{
            [self.gameMicContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.naviView.mas_bottom).offset(0);
                make.trailing.mas_equalTo(self.contentView);
                make.width.mas_equalTo(kScreenWidth);
                make.height.mas_equalTo(55);
            }];
            [self.gameMicContentView scaleToBigView];
            [self.gameMicContentView.superview layoutIfNeeded];
        } completion: ^(BOOL finished){
            [self.gameMicContentView showBigState];
        }];
    }
}

/// 展示选择切换游戏视图
- (void)showSelectGameView {
    WeakSelf
    /// 非房主 结束游戏
    if (kAudioRoomService.roleType != 1) {
        [DTAlertView showTextAlert:NSString.dt_room_sure_end_game sureText:NSString.dt_common_sure cancelText:NSString.dt_common_cancel onSureCallback:^{
            [weakSelf.sudFSTAPPDecorator notifyAppComonSetEnd];
        }          onCloseCallback:^{
        }];
        return;
    }
    SwitchRoomModeView *modeView = [[SwitchRoomModeView alloc] init];
    [modeView reloadData:weakSelf.enterModel.sceneType gameID:weakSelf.gameId isShowCloseGame:weakSelf.isShowEndGame];
    [DTSheetView show:modeView rootView:AppUtil.currentWindow hiddenBackCover:NO onCloseCallback:^{
    }];
    modeView.onTapGameCallBack = ^(HSGameItem *_Nonnull m) {
        [DTSheetView close];
        if (m.itemType == 2) {
            [DTAlertView showTextAlert:NSString.dt_room_sure_end_game sureText:NSString.dt_common_sure cancelText:NSString.dt_common_cancel onSureCallback:^{
                [weakSelf.sudFSTAPPDecorator notifyAppComonSetEnd];
            }          onCloseCallback:^{
            }];
            return;
        } else if (m.itemType == 1) {
            if (weakSelf.sudFSMMGDecorator.gameStateType == GameStateTypePlaying) {
                [ToastUtil show:NSString.dt_room_need_end_game_can_switch];
                return;
            }
        }
        if (weakSelf.sudFSMMGDecorator.gameStateType == GameStateTypePlaying) {
            [ToastUtil show:NSString.dt_room_unable_switch_game];
            return;
        }
        [weakSelf reqChangeToGameGameId:m.gameId operatorUser:AppService.shared.login.loginUserInfo.userID];

    };
}

- (void)dtUpdateUI {
    [self.naviView dtUpdateUI];
    if (self.gameId > 0) {
        self.totalGameUserCount = [AppService.shared getTotalGameCountWithGameID:self.gameId];
    }
    [self setupGameRoomContent];
}

/// 退出房间
- (void)exitRoomFromSuspend:(BOOL)isSuspend finished:(void (^)(void))finished {
    // 如果在麦位上，则下麦
    WeakSelf
    if (kAudioRoomService.micIndex < 0) {
        [self handleExitRoomIsFromSuspend:isSuspend finished:finished];
        return;
    }
    [kAudioRoomService reqSwitchMic:weakSelf.roomID.integerValue micIndex:(int) kAudioRoomService.micIndex handleType:1 success:^{
        [weakSelf handleExitRoomIsFromSuspend:isSuspend finished:finished];
    }                          fail:^(NSError *error) {
        [weakSelf handleExitRoomIsFromSuspend:isSuspend finished:finished];
    }];
}

/// 退出房间
- (void)handleExitRoomIsFromSuspend:(BOOL)isSuspend finished:(void (^)(void))finished {

    if ([self.sudFSMMGDecorator isInGame]) {
        [self.sudFSTAPPDecorator notifyAppComonSelfPlaying:false reportGameInfoExtras:@""];
    }
    // 延迟关闭以便上面指令执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (500 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{

        [self logoutRoom];
        [self logoutGame];
        if (!isSuspend) {
            [AppUtil.currentViewController.navigationController popViewControllerAnimated:true];
        }
        if (finished) finished();
    });
}

/// 更新游戏房间ID
- (void)updateGameRoomID:(NSString *)gameRoomID reloadGame:(BOOL)reloadGame {
    self.gameRoomID = gameRoomID;
    if (reloadGame && self.gameId > 0) {
        DDLogDebug(@"reload room game");
        [self handleChangeToGame:self.gameId];
    }
    DDLogDebug(@"new gameRoomID:%@, current roomID:%@", self.gameRoomID, self.roomID);
}

/// 请求切换房间
- (void)reqChangeToGameGameId:(int64_t)gameId operatorUser:(NSString *)userID {
    WeakSelf
    [kAudioRoomService reqSwitchGame:self.roomID.longLongValue gameId:gameId success:^{
        [weakSelf handleChangeToGame:gameId];
        [weakSelf sendGameChangedMsg:gameId operatorUser:userID];
    }                           fail:^(NSError *error) {
        NSLog(@"reqSwitchGame error:%@", error.debugDescription);
    }];

}

/// 发送房间切换消息
/// @param gameId
- (void)sendGameChangedMsg:(int64_t)gameId operatorUser:(NSString *)userID {
    // 发送游戏切换给其它用户
    RoomCmdChangeGameModel *msg = [RoomCmdChangeGameModel makeMsg:gameId];
    if (msg) {
        [self sendMsg:msg isAddToShow:false];
    }
}

/// 处理麦位点击
/// @param micModel micModel description
- (void)handleMicTap:(AudioRoomMicModel *)micModel {
    if (micModel.user == nil) {
        /// 无人，上麦
        [kAudioRoomService reqSwitchMic:self.roomID.integerValue micIndex:(int) micModel.micIndex handleType:0 success:nil fail:nil];
        return;
    } else {
        BOOL isPlaying = self.sudFSMMGDecorator.isPlaying;
        // 是否是队长
        BOOL isCaptain = [self.sudFSMMGDecorator isPlayerIsCaptain:AppService.shared.login.loginUserInfo.userID];
        NSString *micUserID = micModel.user.userID;
        BOOL isMicUserInGame = [self.sudFSMMGDecorator isPlayerInGame:micUserID];
        NSString *transCaptainStr = NSString.dt_room_transfer_leader;
        NSString *kickOutStr = NSString.dt_room_kick_game;
        NSMutableArray *arrOperate = [[NSMutableArray alloc] init];
        if ([AppService.shared.login.loginUserInfo isMeByUserID:micUserID]) {
            [arrOperate addObject:NSString.dt_down_mic];
        } else if (isCaptain && isMicUserInGame) {
            [arrOperate addObject:transCaptainStr];
            // 加载游戏中或者游戏中不能再踢人
            if (self.sudFSMMGDecorator.gameStateType != GameStateTypeLoading &&
                    self.sudFSMMGDecorator.gameStateType != GameStateTypePlaying) {
                [arrOperate addObject:kickOutStr];
            }
        }

        if (arrOperate.count == 0) {
            return;
        }

        // 是自己或者房主
        MicOperateView *v = [[MicOperateView alloc] initWithOperateList:arrOperate];
        WeakSelf
        v.operateCallback = ^(NSString *str) {

            if ([str isEqualToString:transCaptainStr]) {
                // 转让队长
                [weakSelf.sudFSTAPPDecorator notifyAppComonSetCaptainStateWithUserId:micUserID];
                [DTSheetView close];
            } else if ([str isEqualToString:kickOutStr]) {
                // 踢人
                [weakSelf.sudFSTAPPDecorator notifyAppComonKickStateWithUserId:micUserID];
                [DTSheetView close];
            } else {

                if (isPlaying) {
                    [DTSheetView close];
                    [DTAlertView showTextAlert:NSString.dt_room_flight_tile sureText:NSString.dt_room_confirm_flight cancelText:NSString.dt_common_cancel onSureCallback:^{
                        // 下麦
                        [kAudioRoomService reqSwitchMic:self.roomID.integerValue micIndex:(int) micModel.micIndex handleType:1 success:nil fail:nil];

                        [weakSelf.sudFSTAPPDecorator notifyAppComonSelfPlaying:false reportGameInfoExtras:@""];
                    }          onCloseCallback:^{

                    }];
                } else {

                    // 下麦
                    [kAudioRoomService reqSwitchMic:self.roomID.integerValue micIndex:(int) micModel.micIndex handleType:1 success:nil fail:nil];

                    if ([self.sudFSMMGDecorator isPlayerIsPlaying:AppService.shared.login.loginUserInfo.userID]) {
                        /// 先退出结束游戏，再退出当前游戏
                        [weakSelf.sudFSTAPPDecorator notifyAppComonSelfPlaying:false reportGameInfoExtras:@""];
                        [weakSelf.sudFSTAPPDecorator notifyAppComonSelfIn:NO seatIndex:-1 isSeatRandom:true teamId:1];
                    } else if ([self.sudFSMMGDecorator isPlayerIsReady:AppService.shared.login.loginUserInfo.userID]) {
                        /// 先取消准备游戏，再退出当前游戏
                        [weakSelf.sudFSTAPPDecorator notifyAppComonSetReady:false];
                        [weakSelf.sudFSTAPPDecorator notifyAppComonSelfIn:NO seatIndex:-1 isSeatRandom:true teamId:1];
                    } else if ([self.sudFSMMGDecorator isPlayerIn:AppService.shared.login.loginUserInfo.userID]) {
                        /// 退出当前游戏
                        [weakSelf.sudFSTAPPDecorator notifyAppComonSelfIn:NO seatIndex:-1 isSeatRandom:true teamId:1];
                    }
                    [DTSheetView close];
                }
            }

        };
        v.cancelCallback = ^(UIButton *sender) {
            [DTSheetView close];
        };
        [DTSheetView show:v rootView:self.view hiddenBackCover:NO onCloseCallback:^{

        }];
    }
}

/// 获取空麦位
- (nullable AudioRoomMicModel *)getOneEmptyMic {
    // 请求上麦
    NSArray *o_arr = self.dicMicModel.allValues;
    /// 重新排序
    NSArray *arr = [o_arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        AudioRoomMicModel *model1 = obj1;
        AudioRoomMicModel *model2 = obj2;
        if (model1.micIndex > model2.micIndex) {
            return NSOrderedDescending;
        } else if (model1.micIndex < model2.micIndex) {
            return NSOrderedAscending;
        } else {
            return NSOrderedAscending;
        }
    }];

    AudioRoomMicModel *emptyModel = nil;
    for (AudioRoomMicModel *m in arr) {
        if (m.user == nil) {
            emptyModel = m;
            break;
        }
    }
    return emptyModel;
}

/// 改变语音按钮状态
- (void)changeTapVoiceState:(VoiceBtnStateType)state {
    VoiceBtnStateType currentState = self.operatorView.voiceBtnState;
    if (currentState == state) {
        return;
    }
    switch (state) {
        case VoiceBtnStateTypeNormal:
            break;
        case VoiceBtnStateTypeUpMic: {
            // 请求上麦
            AudioRoomMicModel *emptyModel = [self getOneEmptyMic];
            if (emptyModel == nil) {
                [ToastUtil show:NSString.dt_room_there_no_mic];
                return;
            }
            self.operatorView.voiceBtnState = VoiceBtnStateTypeUpMic;
            [self handleMicTap:emptyModel];
        }
            break;
        case VoiceBtnStateTypeWaitOpen: {
            // 关闭声音
            self.operatorView.voiceBtnState = VoiceBtnStateTypeWaitOpen;
            [self stopPublish];
        }
            break;
        case VoiceBtnStateTypeOnVoice:
            // 开启声音
            [DeviceUtil checkMicAuth:^(BOOL isAuth) {
                if (isAuth) {
                    self.operatorView.voiceBtnState = VoiceBtnStateTypeOnVoice;
                    [self startPublishStream];
                } else {
                    // 提示开启权限
                    [DTAlertView showTextAlert:NSString.dt_unable_microphone_tip sureText:NSString.dt_unable_microphone_open cancelText:NSString.dt_unable_microphone_not_have onSureCallback:^{
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }          onCloseCallback:nil];
                }
            }];
            break;
    }

}

/// 游戏开关麦
- (void)handleGameTapVoice:(BOOL)isOn {
    BOOL isPlaying = [self.sudFSMMGDecorator isPlayerIsPlaying:AppService.shared.login.loginUserInfo.userID];
    NSLog(@"handleGameTapVoice, isPlaying:%@, isOn:%@, btn state:%@", @(isPlaying), @(isOn), @(self.operatorView.voiceBtnState));
    if (isOn) {
        self.isGameForbiddenVoice = NO;
        // 游戏同步推流，如果没有推流，同步推流
        [self changeTapVoiceState:VoiceBtnStateTypeOnVoice];
    } else {
        if (isPlaying) {
            // 正在游戏中，而且游戏关闭麦克风，此时标记游戏禁止发言
            self.isGameForbiddenVoice = YES;
        }
        // 游戏要禁言，如果开启了声音，禁止掉推流
        if (self.operatorView.voiceBtnState == VoiceBtnStateTypeOnVoice) {
            [self changeTapVoiceState:VoiceBtnStateTypeWaitOpen];
        }
    }

}


/// 游戏触发上麦
- (void)handleGameUpMic {
    NSLog(@"handleGameUpMic");
    if ([self isInMic]) {
        return;
    }
    AudioRoomMicModel *micModel = [self getOneEmptyMic];
    if (micModel == nil) {
        [ToastUtil show:NSString.dt_room_there_no_mic];
        return;
    }
    if (micModel.user == nil) {
        /// 无人，上麦
        [kAudioRoomService reqSwitchMic:self.roomID.integerValue micIndex:(int) micModel.micIndex handleType:0 success:nil fail:nil];
        return;
    }
}

//- (void)resetGameInfoModel {
//    _gameInfoModel = nil;
//}

/// 展示公屏消息
/// @param msg 消息体
/// @param isShowOnScreen 是否展示公屏
- (void)addMsg:(RoomBaseCMDModel *)msg isShowOnScreen:(BOOL)isShowOnScreen {
    if (isShowOnScreen) {
        [self.msgTableView addMsg:msg];
    }
    if ([msg isKindOfClass:RoomCmdUpMicModel.class]) {
        [self handleMicChanged:(RoomCmdUpMicModel *) msg];
    } else if ([msg isKindOfClass:RoomCmdSendGiftModel.class]) {
        [self handleGiftEffect:(RoomCmdSendGiftModel *) msg];
    }
}

/// 处理麦位变化
/// @param model model description
- (void)handleMicChanged:(RoomCmdUpMicModel *)model {
    // 通知麦位变化
    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_MIC_CHANGED object:nil userInfo:@{@"msgModel": model}];
}

/// 处理礼物动效
/// @param model model description
- (void)handleGiftEffect:(RoomCmdSendGiftModel *)model {
    GiftModel *giftModel = [GiftService.shared giftByID:model.giftID];
    if (!giftModel) {
        NSLog(@"No exist the gift info:%ld", model.giftID);
        return;
    }
    if ([giftModel.animateType isEqualToString:@"svga"]) {
        DTSVGAPlayerView *v = DTSVGAPlayerView.new;
        NSURL *url = [NSURL fileURLWithPath:giftModel.animateURL];
        [v setURL:url];
        [self.view addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.view);
            make.height.equalTo(self.view.mas_width);
            make.center.equalTo(self.view);
        }];
        __weak UIView *weakV = v;
        [v play:1 didFinished:^{
            [weakV removeFromSuperview];
        }];
    } else if ([giftModel.animateType isEqualToString:@"lottie"]) {
        NSURL *url = [NSURL fileURLWithPath:giftModel.animateURL];

        LOTAnimationView *v = [[LOTAnimationView alloc] initWithContentsOfURL:url];
        [self.view addSubview:v];

        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        __weak UIView *weakV = v;
        [v playWithCompletion:^(BOOL animationFinished) {
            [weakV removeFromSuperview];
        }];
    } else if ([giftModel.animateType isEqualToString:@"webp"]) {

        [giftModel loadWebp:^(UIImage *_Nonnull image) {
            UIImageView *v = [[UIImageView alloc] init];
            v.image = image;
            [self.view addSubview:v];
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self.view);
                make.height.equalTo(self.view.mas_width);
                make.center.equalTo(self.view);
            }];
            __weak UIView *weakV = v;
            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC);
            dispatch_after(timer, dispatch_get_main_queue(), ^(void) {
                [weakV removeFromSuperview];
            });
        }];
    } else if ([giftModel.animateType isEqualToString:@"mp4"]) {
        BDAlphaPlayerMetalView *v = [[BDAlphaPlayerMetalView alloc] initWithDelegate:self];
        [self.view addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        BDAlphaPlayerMetalConfiguration *configuration = [BDAlphaPlayerMetalConfiguration defaultConfiguration];
        configuration.directory = giftModel.animateURL;
        configuration.renderSuperViewFrame = self.view.frame;
        configuration.orientation = BDAlphaPlayerOrientationPortrait;

        [v playWithMetalConfiguration:configuration];
    }
}

/// 同步麦位列表
- (void)reqMicList {
    WeakSelf
    [kAudioRoomService reqMicList:self.roomID.integerValue success:^(NSArray<HSRoomMicList *> *_Nonnull micList) {
        [weakSelf handleMicList:micList];
    }                        fail:^(NSError *error) {
    }];
}

/// 处理房间切换
- (void)roomGameDidChanged:(NSInteger)gameID {
    if (gameID == HSAudio) {
        if (self.enterModel.sceneType != SceneTypeAudio) {
            [self logoutGame];
        }
    }
}

- (void)handleMicList:(NSArray<HSRoomMicList *> *)micList {
    NSMutableArray<NSNumber *> *arrUserID = NSMutableArray.new;
    for (HSRoomMicList *m in micList) {
        [arrUserID addObject:[NSNumber numberWithInteger:m.userId]];
    }
    // 缓存用户信息
    WeakSelf
    [UserService.shared asyncCacheUserInfo:arrUserID finished:^{
        for (HSRoomMicList *m in micList) {
            NSString *key = [NSString stringWithFormat:@"%ld", m.micIndex];
            AudioRoomMicModel *micModel = weakSelf.dicMicModel[key];
            HSUserInfoModel *userInfo = [UserService.shared getCacheUserInfo:m.userId];
            if (micModel) {
                if (!micModel.user) {
                    micModel.user = AudioUserModel.new;
                }
                micModel.user.roleType = m.roleType;
                micModel.user.userID = [NSString stringWithFormat:@"%ld", m.userId];
                if (userInfo) {
                    micModel.user.name = userInfo.nickname;
                    micModel.user.icon = userInfo.avatar;
                    micModel.user.sex = [userInfo.gender isEqualToString:@"male"] ? 1 : 2;
                }
            }
        }

        [weakSelf handleAutoUpMic];
        [NSNotificationCenter.defaultCenter postNotificationName:NTF_MIC_CHANGED object:nil];
    }];

}

/// 进入房间 自动上麦
- (void)handleAutoUpMic {
    if (![self isInMic]) {
        [self handleGameUpMic];
    }
}

/// 创建服务
- (void)createService {
    self.service = [[[self serviceClass] alloc] init];
    self.service.currentRoomVC = self;
    AppService.shared.scene = self.service;
}

/// 服务类，子类返回对应服务类型，用于构建对应场景服务
- (Class)serviceClass {
    return [AudioRoomService class];
}

/// 是否展示加载游戏SDK时显示加载背景，子类覆盖改变是否需要展示，默认展示
/// @return YES显示，NO隐藏
- (BOOL)showSudMGPLoadingGameBackground {
    return YES;
}

#pragma mark setter


- (BOOL)isInMic {
    BOOL isInMic = false;
    NSArray *micArr = self.dicMicModel.allValues;
    for (AudioRoomMicModel *m in micArr) {
        if ([m.user.userID isEqualToString:AppService.shared.login.loginUserInfo.userID]) {
            isInMic = true;
        }
    }
    return isInMic;
}

/// isInMic 为YES的情况下是否自动加入游戏，默认 YES,子场景可以根据需要返回
- (BOOL)isAutoJoinGame {
    return YES;
}

#pragma mark lazy

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"room_bg"];
    }
    return _bgImageView;
}

- (UIImageView *)gameTopShadeNode {
    if (!_gameTopShadeNode) {
        _gameTopShadeNode = [[UIImageView alloc] init];
        _gameTopShadeNode.image = [UIImage imageNamed:@"room_game_top_v"];
    }
    return _gameTopShadeNode;
}

- (RoomNaviView *)naviView {
    if (!_naviView) {
        _naviView = [[RoomNaviView alloc] init];
    }
    return _naviView;
}

- (RoomOperatorView *)operatorView {
    if (!_operatorView) {
        _operatorView = [[RoomOperatorView alloc] init];
    }
    return _operatorView;
}

- (RoomMsgBgView *)msgBgView {
    if (!_msgBgView) {
        _msgBgView = [[RoomMsgBgView alloc] init];
    }
    return _msgBgView;
}

- (RoomMsgTableView *)msgTableView {
    if (!_msgTableView) {
        _msgTableView = [[RoomMsgTableView alloc] init];
    }
    return _msgTableView;
}


- (RoomInputView *)inputView {
    if (!_inputView) {
        _inputView = [[RoomInputView alloc] init];
    }
    return _inputView;
}

- (GameMicContentView *)gameMicContentView {
    if (!_gameMicContentView) {
        _gameMicContentView = [[GameMicContentView alloc] init];
    }
    return _gameMicContentView;
}

- (BaseView *)gameView {
    if (_gameView == nil) {
        _gameView = BaseView.new;
    }
    return _gameView;
}

- (BaseView *)sceneView {
    if (_sceneView == nil) {
        _sceneView = BaseView.new;
    }
    return _sceneView;
}

- (NSMutableDictionary *)dicMicModel {
    if (_dicMicModel == nil) {
        _dicMicModel = NSMutableDictionary.new;
        // 初始化构建9麦model
        for (int i = 0; i < 9; i++) {
            AudioRoomMicModel *m = AudioRoomMicModel.new;
            m.micIndex = i;
            NSString *key = [NSString stringWithFormat:@"%@", @(i)];
            _dicMicModel[key] = m;
        }
    }
    return _dicMicModel;
}

- (UILabel *)gameNumLabel {
    if (!_gameNumLabel) {
        _gameNumLabel = UILabel.new;
        _gameNumLabel.text = @"";
        _gameNumLabel.font = UIFONT_REGULAR(12);
        _gameNumLabel.textColor = UIColor.whiteColor;
    }
    return _gameNumLabel;
}

- (SceneContentView *)contentView {
    if (!_contentView) {
        _contentView = [[SceneContentView alloc] init];
    }
    return _contentView;
}

- (void)setRoomName:(NSString *)roomName {
    _roomName = roomName;
    self.naviView.roomNameLabel.text = roomName;
}

- (void)setGameId:(int64_t)gameId {
    _gameId = gameId;
    GameService.shared.gameId = gameId;
}

- (void)setIsShowEndGame:(BOOL)isShowEndGame {
    _isShowEndGame = isShowEndGame;

    if (kAudioRoomService.roleType != 1) {
        [self.naviView hiddenNodeWithEndGame:!isShowEndGame];
    }
}

- (void)dealloc {
    NSLog(@"base scene vc dealloc");
}

- (BOOL)isShowGameMic {
    return self.gameId > 0;
}

- (BOOL)isShowAudioContent {
    return self.gameId == 0;
}

- (BOOL)isRoomOwner {
    return self.configModel.roleType == 1;
}

/// 设置游戏房间内容
- (void)setupGameRoomContent {
    if ([self isShowGameMic]) {
        self.gameNumLabel.hidden = false;
        [self.gameMicContentView setHidden:false];
    } else {
        self.gameNumLabel.hidden = true;
        [self.gameMicContentView setHidden:true];
    }
    self.gameView.hidden = NO;

    CGFloat h = [UIDevice dt_isiPhoneXSeries] ? 106 : 50;
    [self.msgBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.operatorView.mas_top);
        make.height.mas_equalTo(h);
    }];
    for (AudioMicroView *v in self.gameMicContentView.micArr) {
        v.micType = HSGameMic;
    }
}

#pragma mark - BDAlphaPlayerMetalViewDelegate

- (void)metalView:(nonnull BDAlphaPlayerMetalView *)metalView didFinishPlayingWithError:(nonnull NSError *)error {
    [metalView removeFromSuperview];
}

#pragma mark - SudFSMMGListener

- (NSString *)onGetGameCfg {
    GameCfgModel *m = [GameCfgModel defaultCfgModel];
    return [m mj_JSONString];
}

- (void)onGameMGCommonSelfClickReadyBtn {
}

- (void)onGameMGCommonSelfClickStartBtn {
}

@end
