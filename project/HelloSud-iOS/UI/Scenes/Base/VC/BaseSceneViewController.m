//
//  AudioRoomViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import <SudMGP/SudMGP-umbrella.h>
#import "RoomMoreView.h"
#import "SuspendRoomView.h"

#define I_GUESS_YOU_SAID      1468434504892882946L // 你说我猜
#define DIGITAL_BOMB          1468091457989509190L // 数字炸弹
#define YOU_DRAW_AND_I_GUESS  1461228410184400899L // 你画我猜

@interface BaseSceneViewController () <BDAlphaPlayerMetalViewDelegate>

@property(nonatomic, strong) SceneContentView *contentView;

/// 背景视图
@property(nonatomic, strong) UIImageView *bgImageView;

/// 游戏加载主view
@property(nonatomic, strong) BaseView *gameView;

/// 场景视图，所有子类场景
@property(nonatomic, strong) BaseView *sceneView;
/// 添加机器人按钮
@property(nonatomic, strong) BaseView *robotView;
/// 场景服务
@property(nonatomic, strong) BaseSceneService *service;

@property(nonatomic, strong) UIButton *btnTip;
@property(nonatomic, strong) MarqueeLabel *asrTipLabel;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, weak) id stateNTF;
@property(nonatomic, weak) id asrStateNTF;
/// 是否加载机器人完毕
@property(nonatomic, assign) BOOL isLoadedRobotListCompleted;
// 缓存机器人列表
@property(nonatomic, strong) NSArray<RobotInfoModel *> *cacheRobotList;

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
    if (self.gameId > 0 && self.isNeedToLoadGame) {
        [self loginGame];
        [self roomGameDidChanged:self.gameId];
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
    [self.sceneView addSubview:self.robotView];
    [self.sceneView addSubview:self.asrTipLabel];
}

- (void)dtLayoutViews {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.top.bottom.equalTo(@0);
    }];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.sceneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.top.bottom.equalTo(@0);
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
    [self.asrTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.height.mas_greaterThanOrEqualTo(0);
        make.width.mas_equalTo(230);
        make.bottom.equalTo(self.gameNumLabel);
    }];
    [self.robotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.width.height.mas_greaterThanOrEqualTo(0);
        make.bottom.equalTo(self.operatorView.mas_top).offset(-6);
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
        RoomGiftPannelView *pannelView = [[RoomGiftPannelView alloc] init];
        if (weakSelf.isNeedToLoadSceneGiftList) {
            [pannelView loadSceneGift:weakSelf.gameId sceneId:weakSelf.enterModel.sceneType isAppend:weakSelf.isAppendSceneGiftList];
        }
        [DTSheetView show:pannelView rootView:AppUtil.currentWindow hiddenBackCover:YES onCloseCallback:^{
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
        [weakSelf sendContentMsg:msg];
    };

    self.gameMicContentView.updateMicArrCallBack = ^(NSArray<AudioMicroView *> *_Nonnull micArr) {
        weakSelf.arrAnchorView = micArr;
    };

    self.gameMicContentView.onTapCallback = ^(AudioRoomMicModel *_Nonnull micModel) {
        /// 麦位点击回调
        [weakSelf handleMicTap:micModel];
    };
    self.naviView.closeTapBlock = ^(UIButton *sender) {
        [weakSelf showMoreView];
    };
    self.naviView.changeRoomTapBlock = ^(UITapGestureRecognizer *gesture) {
        [weakSelf showSelectGameView];
    };

    // 切换大小模式
    self.gameMicContentView.changeScaleBlock = ^(BOOL isSmall) {
        [weakSelf changeScaleSmallMic:isSmall];
    };
    /// asr状态变化
    self.asrStateNTF = [[NSNotificationCenter defaultCenter] addObserverForName:NTF_ASR_STATE_CHANGED object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *_Nonnull note) {
        [weakSelf handlePlayerStateChanged];
    }];
    UITapGestureRecognizer *robotViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRobotViewTap:)];
    [self.robotView addGestureRecognizer:robotViewTap];
}

- (void)onRobotViewTap:(id)tap {
    WeakSelf
    NSArray *arr = [self getAllRobotMic];
    if (arr.count > 8) {
        [ToastUtil show:@"最多只能加8个机器人"];
        return;
    }
    // 查找一个未在麦位机器人
    [self findOneNotInMicRobot:^(RobotInfoModel *robotInfoModel) {
        /// 将机器人上麦
        [weakSelf joinCommonRobotToMic:robotInfoModel showNoMic:YES];
    }];

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
        }                completion:^(BOOL finished) {
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
        }                completion:^(BOOL finished) {
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
            [weakSelf.sudFSTAPPDecorator notifyAppCommonSelfEnd];
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
                [weakSelf.sudFSTAPPDecorator notifyAppCommonSelfEnd];
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
    self.robotView.hidden = self.isShowAddRobotBtn ? NO : YES;
}

/// 退出房间
- (void)exitRoomFromSuspend:(BOOL)isSuspend finished:(void (^)(void))finished {
    // 如果在麦位上，则下麦
    WeakSelf
    if (kAudioRoomService.micIndex < 0) {
        [self handleExitRoomIsFromSuspend:isSuspend finished:finished];
        return;
    }
    [kAudioRoomService reqSwitchMic:weakSelf.roomID.integerValue micIndex:(int) kAudioRoomService.micIndex handleType:1 proxyUser:nil success:^{
        [weakSelf handleExitRoomIsFromSuspend:isSuspend finished:finished];
    }                          fail:^(NSError *error) {
        [weakSelf handleExitRoomIsFromSuspend:isSuspend finished:finished];
    }];
}

/// 退出房间
- (void)handleExitRoomIsFromSuspend:(BOOL)isSuspend finished:(void (^)(void))finished {

    // 根据游戏状态执行相应指令退出游戏
    [self handleExitGame];
    // 延迟关闭以便上面指令执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (500 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{

        [self logoutRoom];
        [self logoutGame];
        if (!isSuspend) {
            [AppUtil.currentViewController.navigationController popViewControllerAnimated:true];
        }
        if (finished) finished();
        [DTSheetView close];
        [DTAlertView close];
    });
}

/// 根据所处状态，退出游戏
- (void)handleExitGame {
    NSString *myUserId = AppService.shared.loginUserID;
    if ([self.sudFSMMGDecorator isPlayerInGame:myUserId]) {
        if ([self.sudFSMMGDecorator isPlayerIsPlaying:myUserId]) {
            // 用户正在游戏中，先退出本局游戏，再退出游戏
            [self.sudFSTAPPDecorator notifyAppComonSelfPlaying:false reportGameInfoExtras:@""];
        } else if ([self.sudFSMMGDecorator isPlayerIsReady:myUserId]) {
            // 准备时，先退出准备
            [self.sudFSTAPPDecorator notifyAppCommonSelfReady:false];
        }
        [self.sudFSTAPPDecorator notifyAppComonSelfIn:false seatIndex:-1 isSeatRandom:true teamId:1];
    }
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

/// 将要发送消息
/// @param msg msg
- (void)onWillSendMsg:(RoomBaseCMDModel *)msg shouldSend:(void (^)(BOOL shouldSend))shouldSend {
    if ([msg isKindOfClass:RoomCmdSendGiftModel.class]) {
        RoomCmdSendGiftModel *m = (RoomCmdSendGiftModel *) msg;
        GiftModel *giftModel = [m getGiftModel];
        // 发送礼物
        [DanmakuRoomService reqSendGift:self.roomID giftId:[NSString stringWithFormat:@"%@", @(m.giftID)] amount:m.giftCount price:giftModel.price type:m.type == 1 ? 2 : 1 finished:^{
            DDLogDebug(@"发送礼物成功");
            if (shouldSend) shouldSend(YES);
        }                       failure:^(NSError *error) {
            if (shouldSend) shouldSend(NO);

        }];
    } else {
        if (shouldSend) shouldSend(YES);
    }
    DDLogDebug(@"onWillSendMsg");
}

/// 已经发送消息
/// @param msg msg
- (void)onDidSendMsg:(RoomBaseCMDModel *)msg {
    DDLogDebug(@"onDidSendMsg");
}

/// 是否需要加载游戏，子类根据场景要求是否加载游戏，默认YES,加载
- (BOOL)isNeedToLoadGame {
    return YES;
}

/// 发送公屏文本消息
/// @param content content
- (void)sendContentMsg:(NSString *)content {
    RoomCmdChatTextModel *m = [RoomCmdChatTextModel makeMsg:content];
    [self sendMsg:m isAddToShow:YES finished:nil];
}

/// 展示更多视图
- (void)showMoreView {
    WeakSelf
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
}

/// 是否需要展示礼物动效
- (BOOL)isNeedToShowGiftEffect {
    return YES;
}

/// 是否需要加载场景礼物
- (BOOL)isNeedToLoadSceneGiftList {
    return NO;
}

/// 是否是追加方式
- (BOOL)isAppendSceneGiftList {
    return NO;
}

/// 是否需要自动上麦
- (BOOL)isNeedAutoUpMic {
    // 默认自动上麦
    return YES;
}

/// 发送房间切换消息
/// @param gameId
- (void)sendGameChangedMsg:(int64_t)gameId operatorUser:(NSString *)userID {
    // 发送游戏切换给其它用户
    RoomCmdChangeGameModel *msg = [RoomCmdChangeGameModel makeMsg:gameId];
    if (msg) {
        [self sendMsg:msg isAddToShow:false finished:nil];
    }
}

/// 处理麦位点击
/// @param micModel micModel description
- (void)handleMicTap:(AudioRoomMicModel *)micModel {
    if (micModel.user == nil) {
        /// 无人，上麦
        [kAudioRoomService reqSwitchMic:self.roomID.integerValue micIndex:(int) micModel.micIndex handleType:0 proxyUser:nil success:nil fail:nil];
        return;
    } else {
        BOOL isPlaying = self.sudFSMMGDecorator.isPlaying;
        // 是否是队长
        BOOL isCaptain = [self.sudFSMMGDecorator isPlayerIsCaptain:AppService.shared.login.loginUserInfo.userID];
        NSString *micUserID = micModel.user.userID;
        BOOL isMicUserInGame = [self.sudFSMMGDecorator isPlayerInGame:micUserID];
        NSString *transCaptainStr = NSString.dt_room_transfer_leader;
        NSString *kickOutStr = NSString.dt_room_kick_game;
        NSString *kickOutRoomStr = NSString.dt_room_kick_out_room;
        BOOL isMe = [AppService.shared.login.loginUserInfo isMeByUserID:micUserID];
        NSMutableArray *arrOperate = [[NSMutableArray alloc] init];
        if (isMe) {
            [arrOperate addObject:NSString.dt_down_mic];
        } else {
            if (isCaptain && isMicUserInGame) {
                [arrOperate addObject:transCaptainStr];
                // 加载游戏中或者游戏中不能再踢人
                if (self.sudFSMMGDecorator.gameStateType != GameStateTypeLoading &&
                        self.sudFSMMGDecorator.gameStateType != GameStateTypePlaying) {
                    [arrOperate addObject:kickOutStr];
                }
            }
            if (self.enterModel.roleType == 1) {
                // 房主
                [arrOperate addObject:kickOutRoomStr];
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
            } else if ([str isEqualToString:kickOutRoomStr]) {
                // 踢出房间
                // 是队长，把该人踢出游戏
//                if ([weakSelf.sudFSMMGDecorator isPlayerIsCaptain:AppService.shared.loginUserID]) {
//                    [weakSelf.sudFSTAPPDecorator notifyAppComonKickStateWithUserId:micUserID];
//                }
                [kAudioRoomService reqSwitchMic:self.roomID.integerValue micIndex:(int) micModel.micIndex handleType:1 proxyUser:micModel.user success:^{
                    // 发送踢出房间
                    RoomCmdKickoutRoomModel *msg = [RoomCmdKickoutRoomModel makeKickoutRoomMsg:micUserID];
                    [weakSelf sendMsg:msg isAddToShow:NO finished:nil];
                }                          fail:nil];
                [DTSheetView close];
            } else {

                // 自己下麦
                if (isPlaying) {
                    [DTSheetView close];
                    [DTAlertView showTextAlert:NSString.dt_room_flight_tile sureText:NSString.dt_room_confirm_flight cancelText:NSString.dt_common_cancel onSureCallback:^{
                        // 下麦
                        [kAudioRoomService reqSwitchMic:self.roomID.integerValue micIndex:(int) micModel.micIndex handleType:1 proxyUser:nil success:nil fail:nil];

                        [weakSelf.sudFSTAPPDecorator notifyAppComonSelfPlaying:false reportGameInfoExtras:@""];
                    }          onCloseCallback:^{

                    }];
                } else {

                    // 下麦
                    [kAudioRoomService reqSwitchMic:self.roomID.integerValue micIndex:(int) micModel.micIndex handleType:1 proxyUser:nil success:nil fail:nil];

                    if ([self.sudFSMMGDecorator isPlayerIsPlaying:AppService.shared.login.loginUserInfo.userID]) {
                        /// 先退出结束游戏，再退出当前游戏
                        [weakSelf.sudFSTAPPDecorator notifyAppComonSelfPlaying:false reportGameInfoExtras:@""];
                        [weakSelf.sudFSTAPPDecorator notifyAppComonSelfIn:NO seatIndex:-1 isSeatRandom:true teamId:1];
                    } else if ([self.sudFSMMGDecorator isPlayerIsReady:AppService.shared.login.loginUserInfo.userID]) {
                        /// 先取消准备游戏，再退出当前游戏
                        [weakSelf.sudFSTAPPDecorator notifyAppCommonSelfReady:false];
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
- (nullable AudioRoomMicModel *)getOneEmptyMic:(NSInteger)beginMic {
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
    for (int i = 0; i < arr.count; ++i) {
        if (i < beginMic) {
            continue;
        }
        AudioRoomMicModel *m = arr[i];
        if (m.user == nil) {
            emptyModel = m;
            break;
        }
    }
    return emptyModel;
}

/// 获取所有机器人麦位用户
- (NSArray <AudioUserModel *> *)getAllRobotMic {
    NSMutableArray *robotList = [[NSMutableArray alloc] init];
    NSArray *arr = self.dicMicModel.allValues;
    for (AudioRoomMicModel *m in arr) {
        if (m.user && m.user.isAi) {
            [robotList addObject:m.user];
        }
    }
    return robotList;
}

/// 检测是否有机器人在麦位上
- (BOOL)hasRobotInMic {
    NSArray *arr = self.dicMicModel.allValues;
    for (AudioRoomMicModel *m in arr) {
        if (m.user && m.user.isAi) {
            return YES;
        }
    }
    return NO;
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
            AudioRoomMicModel *emptyModel = [self getOneEmptyMic:0];
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
    if (!self.isNeedAutoUpMic) {
        return;
    }
    AudioRoomMicModel *micModel = [self getOneEmptyMic:0];
    if (micModel == nil) {
        [ToastUtil show:NSString.dt_room_there_no_mic];
        return;
    }
    if (micModel.user == nil) {
        /// 无人，上麦
        [kAudioRoomService reqSwitchMic:self.roomID.integerValue micIndex:(int) micModel.micIndex handleType:0 proxyUser:nil success:nil fail:nil];
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
    } else if ([msg isKindOfClass:RoomCmdKickoutRoomModel.class]) {
        // 踢出房间
        RoomCmdKickoutRoomModel *m = (RoomCmdKickoutRoomModel *) msg;
        if ([AppService.shared.login.loginUserInfo isMeByUserID:m.userID]) {
            // 自己被踢出去
            if (SuspendRoomView.isShowSuspend) {
                [SuspendRoomView exitRoom:nil];
            } else {
                [self handleExitRoomIsFromSuspend:NO finished:nil];
            }
        } else {
            // 是队长，把该人踢出游戏
            if ([self.sudFSMMGDecorator isPlayerIsCaptain:AppService.shared.loginUserID]) {
                [self.sudFSTAPPDecorator notifyAppComonKickStateWithUserId:m.userID];
            }
        }
    }
}

/// 处理麦位变化
/// @param model model description
- (void)handleMicChanged:(RoomCmdUpMicModel *)model {
    // 通知麦位变化
    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_MIC_CHANGED object:nil userInfo:@{@"msgModel": model}];
    if (model.cmd == CMD_UP_MIC_NOTIFY &&
            [self.sudFSMMGDecorator isPlayerIsCaptain:AppService.shared.loginUserID] &&
            model.sendUser.isAi) {
        // 自己是队长，将机器人加入游戏中
        [self addRobotFromMicUserModels:@[model.sendUser]];
    }
}

- (GiftModel *)getGiftModelFromMsg:(RoomCmdSendGiftModel *)msgModel {
    GiftModel *giftModel = nil;
    if (msgModel.type == 1) {
        // 后台礼物
        giftModel = [[GiftModel alloc] init];
        if (msgModel.animationUrl) {
            NSURL *url = msgModel.animationUrl.dt_toURL;
            giftModel.animateType = url.pathExtension;
        }
        giftModel.animateURL = msgModel.animationUrl;
        giftModel.giftID = msgModel.giftID;
        giftModel.giftName = msgModel.giftName;
        giftModel.giftURL = msgModel.giftUrl;
        giftModel.smallGiftURL = msgModel.giftUrl;
    } else {
        // 内置
        giftModel = [GiftService.shared giftByID:msgModel.giftID];;
    }
    return giftModel;
}

/// 处理礼物动效
/// @param model model description
- (void)handleGiftEffect:(RoomCmdSendGiftModel *)model {
    if (!self.isNeedToShowGiftEffect) {
        return;
    }
    GiftModel *giftModel = [self getGiftModelFromMsg:model];
    if (!giftModel) {
        NSLog(@"No exist the gift info:%ld", model.giftID);
        return;
    }
    if ([giftModel.animateType isEqualToString:@"svga"]) {
        DTSVGAPlayerView *v = DTSVGAPlayerView.new;
        NSURL *url = [giftModel.animateURL hasPrefix:@"http"] ? [[NSURL alloc] initWithString:giftModel.animateURL] : [NSURL fileURLWithPath:giftModel.animateURL];
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
        NSURL *url = [giftModel.animateURL hasPrefix:@"http"] ? [[NSURL alloc] initWithString:giftModel.animateURL] : [NSURL fileURLWithPath:giftModel.animateURL];

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
    BOOL showTip = self.gameId == DIGITAL_BOMB || self.gameId == YOU_DRAW_AND_I_GUESS || self.gameId == I_GUESS_YOU_SAID;
    [self.asrTipLabel setHidden:showTip ? NO : YES];
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
                    micModel.user.isAi = userInfo.ai;
                }
            }
        }

        [weakSelf handleAutoUpMic];
        [NSNotificationCenter.defaultCenter postNotificationName:NTF_MIC_CHANGED object:nil];
    }];

}

/// 进入房间 自动上麦
- (void)handleAutoUpMic {
    if (!self.isNeedAutoUpMic) {
        DDLogDebug(@"isNeedAutoUpMic false, not auto up mic");
        return;
    }
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

/// 处理游戏状态变化
- (void)handlePlayerStateChanged {

    if (!self.sudFSMMGDecorator.keyWordASRing) {
        return;
    }
    if (self.operatorView.voiceBtnState != VoiceBtnStateTypeWaitOpen) {
        return;
    }
    if (self.gameId == DIGITAL_BOMB || self.gameId == YOU_DRAW_AND_I_GUESS || self.gameId == I_GUESS_YOU_SAID) {
        [self showVoiceTip];
    }
}

- (void)showVoiceTip {

    if (!self.btnTip) {
        self.btnTip = [[UIButton alloc] init];
        UIImage *bgImage = [[[UIImage imageNamed:@"voice_tip"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 50, 19, 49) resizingMode:UIImageResizingModeStretch] imageFlippedForRightToLeftLayoutDirection];
        [self.btnTip setBackgroundImage:bgImage forState:UIControlStateNormal];
        NSString *tip = @"";
        if (self.gameId == DIGITAL_BOMB) {
            tip = NSString.dt_asr_open_mic_num_tip;
        } else {
            tip = NSString.dt_asr_open_mic_tip;
        }
        [self.btnTip setTitle:tip forState:UIControlStateNormal];
        [self.btnTip setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        self.btnTip.titleLabel.font = UIFONT_REGULAR(16);
        [self.btnTip setContentEdgeInsets:UIEdgeInsetsMake(0, 12, 12, 6)];
        [self.sceneView addSubview:self.btnTip];
        [self.btnTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_lessThanOrEqualTo(kScreenWidth - 32);
            make.height.mas_greaterThanOrEqualTo(0);
            make.bottom.equalTo(self.operatorView.mas_top).offset(0);
            make.leading.mas_equalTo(16);
        }];
        if (self.timer) {
            [self.timer invalidate];
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
    }
}

- (void)onTimer:(NSTimer *)timer {
    [self closeTip];
}

- (void)closeTip {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.btnTip removeFromSuperview];
    self.btnTip = nil;
}

#pragma mark lazy

- (MarqueeLabel *)asrTipLabel {
    if (!_asrTipLabel) {
        _asrTipLabel = [[MarqueeLabel alloc] init];
        _asrTipLabel.fadeLength = 10;
        _asrTipLabel.trailingBuffer = 20;
        _asrTipLabel.font = UIFONT_MEDIUM(11);
        _asrTipLabel.textColor = UIColor.whiteColor;
        _asrTipLabel.text = NSString.dt_asr_tip;
        _asrTipLabel.hidden = YES;
    }
    return _asrTipLabel;
}

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

- (BaseView *)robotView {
    if (!_robotView) {
        _robotView = BaseView.new;

        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"添加机器人";
        lab.font = UIFONT_MEDIUM(12);
        lab.textColor = UIColor.whiteColor;
        [_robotView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@6);
            make.trailing.equalTo(@-6);
            make.top.equalTo(@3);
            make.bottom.equalTo(@-3);
        }];
        NSArray *colorArr = @[(id) [UIColor dt_colorWithHexString:@"#33FF8B" alpha:1].CGColor, (id) [UIColor dt_colorWithHexString:@"#13C47C" alpha:1].CGColor];
        [_robotView dtAddGradientLayer:@[@(0.0f), @(1.0f)] colors:colorArr startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 0.28) cornerRadius:4];
    }
    return _robotView;
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

    if (self.asrStateNTF) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.asrStateNTF];
    }
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

- (BOOL)isLoadCommonRobotList {
    return YES;
}

/// 是否显示添加通用机器人按钮
- (BOOL)isShowAddRobotBtn {
    return YES;
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

/// 处理机器人上麦逻辑
- (void)loadCommonRobotList {

    if (self.enterModel.roleType != 1) {
        DDLogDebug(@"you not the room owner, don't need load robot");
        return;
    }
    if (self.isLoadedRobotListCompleted) {
        DDLogDebug(@"had loaded robot list");
        return;
    }
    WeakSelf
    [AudioRoomService reqRobotListWithFinished:^(NSArray<RobotInfoModel *> *robotList) {
        weakSelf.isLoadedRobotListCompleted = YES;
        weakSelf.cacheRobotList = robotList;
        [weakSelf onLoadCommonRobotCompleted:robotList];

    }                                  failure:^(NSError *_Nonnull error) {
        weakSelf.isLoadedRobotListCompleted = NO;
        DDLogError(@"load robot list err:%@", error.dt_errMsg);
    }];
}

/// 是否用户在麦位上
/// @param userId
/// @return
- (BOOL)isUserInMic:(NSString *)userId {
    NSArray *arr = self.dicMicModel.allValues;
    for (AudioRoomMicModel *m in arr) {
        if (m.user && [m.user.userID isEqualToString:userId]) {
            return YES;
        }
    }
    return NO;
}

/// 查找一个没有在麦位的机器人
/// @param completed
- (void)findOneNotInMicRobot:(void (^)(RobotInfoModel *robotInfoModel))completed {
    if (self.cacheRobotList.count == 0) {
        WeakSelf
        [AudioRoomService reqRobotListWithFinished:^(NSArray<RobotInfoModel *> *robotList) {
            weakSelf.cacheRobotList = robotList;
            [weakSelf findOneNotInMicRobotFromCacheList:completed];
        }                                  failure:^(NSError *_Nonnull error) {
            if (completed) {
                completed(nil);
            }
            DDLogError(@"load robot list err:%@", error.dt_errMsg);
        }];
    } else {
        [self findOneNotInMicRobotFromCacheList:completed];
    }
}

/// 从缓存机器人中找出一个未在麦位的
/// @param completed
- (void)findOneNotInMicRobotFromCacheList:(void (^)(RobotInfoModel *robotInfoModel))completed {
    for (RobotInfoModel *robotInfoModel in self.cacheRobotList) {
        if (![self isUserInMic:[NSString stringWithFormat:@"%@", @(robotInfoModel.userId)]]) {
            if (completed) {
                completed(robotInfoModel);
            }
            return;
        }
    }
    if (completed) {
        completed(nil);
    }
}


/// 加载通用机器人完毕
/// @param robotList
- (void)onLoadCommonRobotCompleted:(NSArray<RobotInfoModel *> *)robotList {

    if (self.hasRobotInMic) {
        DDLogDebug(@"has robot in mic, don't up the robot to mic list");
        return;
    }
    // 默认处理机器人上麦
    NSMutableArray *aiPlayers = [[NSMutableArray alloc] init];
    NSMutableArray *robotAnchorList = [[NSMutableArray alloc] init];
    for (int i = 0; i < robotList.count; ++i) {
        RobotInfoModel *robotModel = robotList[i];
        /// 前3位机器人自动上麦
        if (i >= 3) {
            break;
        }
        [robotAnchorList addObject:robotModel];
        AIPlayerInfoModel *aiPlayerInfoModel = [AIPlayerInfoModel alloc];
        aiPlayerInfoModel.userId = [NSString stringWithFormat:@"%@", @(robotModel.userId)];
        aiPlayerInfoModel.name = robotModel.name;
        aiPlayerInfoModel.avatar = robotModel.avatar;
        aiPlayerInfoModel.gender = robotModel.gender;
        [aiPlayers addObject:aiPlayerInfoModel];

    }
    AppCommonGameAddAIPlayersModel *appCommonGameAddAiPlayersModel = [[AppCommonGameAddAIPlayersModel alloc] init];
    appCommonGameAddAiPlayersModel.aiPlayers = aiPlayers;
    appCommonGameAddAiPlayersModel.isReady = YES;
    [self.sudFSTAPPDecorator notifyAppCommonGameAddAIPlayers:appCommonGameAddAiPlayersModel];

    // 机器人加入主播位
    [HSThreadUtils dispatchMainAfter:1 callback:^{
        for (RobotInfoModel *m in robotAnchorList) {
            [self joinCommonRobotToMic:m showNoMic:NO];
        }
    }];
}

- (void)joinCommonRobotToMic:(RobotInfoModel *)robotModel showNoMic:(BOOL)showNoMic {

    // 从麦位号1开始，0留给自己
    AudioRoomMicModel *micModel = [self getOneEmptyMic:1];
    if (micModel == nil) {
        if (showNoMic) {
            [ToastUtil show:NSString.dt_room_there_no_mic];
        }
        return;
    }
    if (micModel.user == nil) {
        /// 无人，上麦
        AudioUserModel *proxyUser = AudioUserModel.new;
        proxyUser.userID = [NSString stringWithFormat:@"%@", @(robotModel.userId)];
        proxyUser.name = robotModel.name;
        proxyUser.icon = robotModel.avatar;
        proxyUser.sex = [robotModel.gender isEqualToString:@"male"] ? 1 : 2;
        proxyUser.isRobot = YES;
        proxyUser.isAi = YES;
        micModel.user = proxyUser;
        [kAudioRoomService reqSwitchMic:self.roomID.integerValue micIndex:(int) micModel.micIndex handleType:0 proxyUser:proxyUser success:nil fail:nil];
        return;
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

/// 处理游戏开始
- (void)handleGameStared {
    /// 如果当前用户在麦上，自动加入游戏
    if ([self isInMic] && [self isAutoJoinGame]) {
        [self notifyGameToJoin];
    }
}

- (void)onGameMGCommonSelfClickReadyBtn {
}

- (void)onGameMGCommonSelfClickStartBtn {
}

/// 已经进入房间，消息通道已经建立
- (void)onHandleEnteredRoom {
    if (self.isLoadCommonRobotList) {
        // 加载机器人
        [self loadCommonRobotList];
    }
}

/// 自己成为了队长事件处理
- (void)onHandleIsGameCaptain {
    DDLogDebug(@"我成为了队长");

    NSArray *robotMicUserList = [self getAllRobotMic];
    [self addRobotFromMicUserModels:robotMicUserList];
}

- (void)addRobotFromMicUserModels:(NSArray<AudioUserModel *> *)robotMicUserList {
    NSMutableArray *aiPlayers = [[NSMutableArray alloc] init];
    if (robotMicUserList.count == 0) {
        return;
    }
    for (AudioUserModel *micUser in robotMicUserList) {
        AIPlayerInfoModel *aiPlayerInfoModel = [AIPlayerInfoModel alloc];
        aiPlayerInfoModel.userId = micUser.userID;
        aiPlayerInfoModel.name = micUser.name;
        aiPlayerInfoModel.avatar = micUser.icon;
        aiPlayerInfoModel.gender = micUser.sex == 1 ? @"male" : @"female";
        [aiPlayers addObject:aiPlayerInfoModel];

    }
    // 如果麦位有机器人，自动加入游戏中
    AppCommonGameAddAIPlayersModel *appCommonGameAddAiPlayersModel = [[AppCommonGameAddAIPlayersModel alloc] init];
    appCommonGameAddAiPlayersModel.aiPlayers = aiPlayers;
    appCommonGameAddAiPlayersModel.isReady = YES;
    [self.sudFSTAPPDecorator notifyAppCommonGameAddAIPlayers:appCommonGameAddAiPlayersModel];
}

/// 加入状态处理发生变更
- (void)playerIsInGameStateChanged:(NSString *)userId {

}

@end
