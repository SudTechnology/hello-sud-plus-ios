//
//  AudioRoomViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

@interface BaseSceneViewController () <BDAlphaPlayerMetalViewDelegate>
/// 背景视图
@property (nonatomic, strong) UIImageView *bgImageView;

/// 游戏加载主view
@property (nonatomic, strong) UIView *gameView;

/// 场景视图，所有子类场景
@property (nonatomic, strong) BaseView *sceneView;


@end

@implementation BaseSceneViewController

- (BOOL)dtIsHiddenNavigationBar {
    return YES;
}

- (void)setConfigModel:(BaseSceneConfigModel *)configModel {
    self.gameId = configModel.gameId;
    self.roomID = configModel.roomID;
    self.roomName = configModel.roomName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.language = @"zh-CN";
    [self initSudFSMMG];
    AudioRoomService.shared.currentRoomVC = self;
    [self loginRoom];
    if (self.gameId > 0) {
        [self loginGame];
    }
    [self dtUpdateUI];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO;
}

- (void)dtAddViews {
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.gameView];
    [self.view addSubview:self.sceneView];

    [self.sceneView addSubview:self.naviView];
    [self.sceneView addSubview:self.operatorView];
    [self.sceneView addSubview:self.gameMicContentView];
    [self.sceneView addSubview:self.gameNumLabel];
    [self.sceneView addSubview:self.msgBgView];
    [self.msgBgView addSubview:self.msgTableView];
    [self.sceneView addSubview:self.inputView];
}

- (void)dtLayoutViews {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.sceneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(kStatusBarHeight);
        make.height.mas_equalTo(44);
    }];
    [self.operatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-kAppSafeBottom);
        make.height.mas_equalTo(44);
    }];

    [self.gameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.gameMicContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(0);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(55);
    }];
    [self.gameNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(self.gameMicContentView.mas_bottom).offset(3);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.msgBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(106);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.operatorView.mas_top).offset(0);
    }];
    [self.msgTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.msgBgView);
    }];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(80);
    }];
}

- (void)dtConfigEvents {
    WeakSelf
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
            [ToastUtil show:@"当前不能发言"];
            return;
        }
        [weakSelf handleTapVoice];
    };
    self.inputView.inputMsgBlock = ^(NSString * _Nonnull msg) {
        // 发送公屏消息
        RoomCmdChatTextModel *m = [RoomCmdChatTextModel makeMsg:msg];
        [weakSelf sendMsg:m isAddToShow:YES];
    };

    self.gameMicContentView.updateMicArrCallBack = ^(NSArray<AudioMicroView *> * _Nonnull micArr) {
        weakSelf.arrAnchorView = micArr;
    };

    self.gameMicContentView.onTapCallback = ^(AudioRoomMicModel * _Nonnull micModel) {
        /// 麦位点击回调
        [weakSelf handleMicTap:micModel];
    };
    self.naviView.closeTapBlock = ^(UIButton *sender) {
        [DTAlertView showTextAlert:@"确认离开当前房间吗" sureText:@"确定" cancelText:@"取消" onSureCallback:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                // 如果在麦位上，则下麦
                if (AudioRoomService.shared.micIndex >= 0) {
                    [AudioRoomService.shared reqSwitchMic:weakSelf.roomID.integerValue micIndex:(int)AudioRoomService.shared.micIndex handleType:1 success:^{
                        [weakSelf handleExitRoom];
                    } fail:^(NSError *error) {
                        [weakSelf handleExitRoom];
                    }];
                } else {
                    [weakSelf handleExitRoom];
                }
            });
        } onCloseCallback:^{
        }];
    };
    self.naviView.changeRoomTapBlock = ^(UITapGestureRecognizer *gesture) {
        SwitchRoomModeView *modeView = [[SwitchRoomModeView alloc] init];
        BOOL isGame = weakSelf.isSupportGame;
        [modeView reloadData:!isGame];
        [DTSheetView show:modeView rootView:AppUtil.currentWindow hiddenBackCover:NO onCloseCallback:^{
        }];
        modeView.onTapGameCallBack = ^(HSGameItem * _Nonnull m) {
            [DTSheetView close];
            if (weakSelf.sudFSMMGDecorator.gameStateType == GameStateTypePlaying) {
                [ToastUtil show:@"正在游戏中, 无法切换游戏"];
                return;
            }
            [weakSelf handleChangeRoomMode:m];
        };
    };
    self.naviView.endGameBlock = ^(UIButton *sender) {
        [DTAlertView showTextAlert:@"确定结束游戏吗" sureText:@"确定" cancelText:@"取消" onSureCallback:^{
            [weakSelf.sudFSTAPPDecorator notifyAppComonSetEnd];
        } onCloseCallback:^{
        }];
    };
}

- (void)dtUpdateUI {
    [self.naviView dtUpdateUI];
    if (self.gameId > 0) {
        self.totalGameUserCount = [AppService.shared getTotalGameCountWithGameID:self.gameId];
    }
}

/// 退出房间
- (void)handleExitRoom {
    [AudioRoomService.shared reqExitRoom:self.roomID.longLongValue];
    [self logoutRoom];
    [AppUtil.currentViewController.navigationController popViewControllerAnimated:true];
}

/// 处理切换房间
/// @param m m description
- (void)handleChangeRoomMode:(HSGameItem *)m {
    WeakSelf
    [AudioRoomService.shared reqSwitchGame:self.roomID.integerValue gameId:m.gameId success:^{
        
        RoomCmdChangeGameModel *msg = nil;
        if (m.isAudioRoom) {
            msg = [RoomCmdChangeGameModel makeMsg:0];
        } else if(m.gameId > 0) {
            msg = [RoomCmdChangeGameModel makeMsg:m.gameId];
        }
        [weakSelf handleGameChange:m.gameId];
        // 发送游戏切换给其它用户
        if (msg) {
            [weakSelf sendMsg:msg isAddToShow:false];
        }
    } fail:^(NSError *error) {
        NSLog(@"reqSwitchGame error:%@", error.debugDescription);
    }];
    
}

/// 处理麦位点击
/// @param micModel micModel description
- (void)handleMicTap:(AudioRoomMicModel *)micModel {
    if (micModel.user == nil) {
        /// 无人，上麦
        [AudioRoomService.shared reqSwitchMic:self.roomID.integerValue micIndex:(int)micModel.micIndex handleType:0 success:nil fail:nil];
        return;
    } else if ([AppService.shared.login.loginUserInfo isMeByUserID:micModel.user.userID]) {
        BOOL isGameing = self.sudFSMMGDecorator.isPlaying;
        // 是自己或者房主
        MicOperateView *v = [[MicOperateView alloc]initWithOperateList: @[@"下麦"]];
        WeakSelf
        v.operateCallback = ^(NSString *str) {
            if (isGameing) {
                [DTSheetView close];
                [DTAlertView showTextAlert:@"当前正在游戏中，是否逃跑？" sureText:@"确认逃跑" cancelText:@"返回游戏" onSureCallback:^{
                    // 下麦
                    [AudioRoomService.shared reqSwitchMic:self.roomID.integerValue micIndex:(int)micModel.micIndex handleType:1 success:nil fail:nil];
                    
                    [weakSelf.sudFSTAPPDecorator notifyAppComonSelfPlaying:false reportGameInfoExtras:@""];
                } onCloseCallback:^{
                    
                }];
            } else {
                
                // 下麦
                [AudioRoomService.shared reqSwitchMic:self.roomID.integerValue micIndex:(int)micModel.micIndex handleType:1 success:nil fail:nil];
                
                if ([self.sudFSMMGDecorator isPlayerIsPlaying:AppService.shared.login.loginUserInfo.userID]) {
                    /// 先退出结束游戏，再退出当前游戏
                    [weakSelf.sudFSTAPPDecorator notifyAppComonSelfPlaying:false reportGameInfoExtras:@""];
                    [weakSelf.sudFSTAPPDecorator notifyAppComonSelfIn:NO seatIndex:-1 isSeatRandom:true teamId:1];
                } else if ([self.sudFSMMGDecorator isPlayerIsReady:AppService.shared.login.loginUserInfo.userID]) {
                    /// 先取消准备游戏，再退出当前游戏
                    [weakSelf.sudFSTAPPDecorator notifyAppComonSetReady:false];
                    [weakSelf.sudFSTAPPDecorator notifyAppComonSelfIn:NO seatIndex:-1 isSeatRandom:true teamId:1];
                }  else if ([self.sudFSMMGDecorator isPlayerIn:AppService.shared.login.loginUserInfo.userID]) {
                    /// 退出当前游戏
                    [weakSelf.sudFSTAPPDecorator notifyAppComonSelfIn:NO seatIndex:-1 isSeatRandom:true teamId:1];
                }
                [DTSheetView close];
            }
        };
        v.cancelCallback = ^(UIButton *sender) {
            [DTSheetView close];
        };
        [DTSheetView show:v rootView:self.view hiddenBackCover:NO onCloseCallback:^{

        }];
    }
}

- (BOOL)isSupportGame {
    return YES;
}

/// 获取空麦位
- (nullable AudioRoomMicModel *)getOneEmptyMic {
    // 请求上麦
    NSArray *o_arr = self.dicMicModel.allValues;
    /// 重新排序
    NSArray *arr = [o_arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        AudioRoomMicModel *model1 = obj1;
        AudioRoomMicModel *model2 = obj2;
        if (model1.micIndex > model2.micIndex){
            return NSOrderedDescending;
        } else if (model1.micIndex < model2.micIndex){
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


/// 处理点击上麦按钮
- (void)handleTapVoice {
    switch (self.operatorView.voiceBtnState) {
        case VoiceBtnStateTypeNormal:{
            // 请求上麦
            AudioRoomMicModel *emptyModel = [self getOneEmptyMic];
            if (emptyModel == nil) {
                [ToastUtil show:@"没有空位啦"];
                return;
            }
            self.operatorView.voiceBtnState = VoiceBtnStateTypeWaitOpen;
            [self handleMicTap:emptyModel];
        }
            break;
        case VoiceBtnStateTypeWaitOpen:{
            
            // 开启声音
            [DeviceUtil checkMicAuth:^(BOOL isAuth) {
                if (isAuth) {
                    self.operatorView.voiceBtnState = VoiceBtnStateTypeOnVoice;
                    [self startPublish:[NSString stringWithFormat:@"%u", arc4random()]];
                } else {
                    // 提示开启权限
                    [DTAlertView showTextAlert:@"无法访问麦克风，请到“设置-隐私“中开启麦克风访问权限" sureText:@"去开启" cancelText:@"暂时不用" onSureCallback:^{
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if (url && [[UIApplication sharedApplication]canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    } onCloseCallback:nil];
                }
            }];
        }
            break;
        case VoiceBtnStateTypeOnVoice:
            // 关闭声音
            self.operatorView.voiceBtnState = VoiceBtnStateTypeWaitOpen;
            [self stopPublish];
            break;
            
        default:
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
        if (self.operatorView.voiceBtnState != VoiceBtnStateTypeOnVoice) {
            if (self.operatorView.voiceBtnState != VoiceBtnStateTypeWaitOpen) {
                self.operatorView.voiceBtnState = VoiceBtnStateTypeWaitOpen;
            }
            [self handleTapVoice];
        }
    } else {
        if (isPlaying) {
            // 正在游戏中，而且游戏关闭麦克风，此时标记游戏禁止发言
            self.isGameForbiddenVoice = YES;
        }
        // 游戏要禁言，如果开启了声音，禁止掉推流
        if (self.operatorView.voiceBtnState == VoiceBtnStateTypeOnVoice){
            [self handleTapVoice];
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
        [ToastUtil show:@"没有空位啦"];
        return;
    }
    if (micModel.user == nil) {
        /// 无人，上麦
        [AudioRoomService.shared reqSwitchMic:self.roomID.integerValue micIndex:(int)micModel.micIndex handleType:0 success:nil fail:nil];
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
        [self handleMicChanged:(RoomCmdUpMicModel *)msg];
    } else if ([msg isKindOfClass:RoomCmdSendGiftModel.class]) {
        [self handleGiftEffect:(RoomCmdSendGiftModel *)msg];
    }
}

/// 处理麦位变化
/// @param model model description
- (void)handleMicChanged:(RoomCmdUpMicModel *)model {
    // 通知麦位变化
    [[NSNotificationCenter defaultCenter]postNotificationName:NTF_MIC_CHANGED object:nil userInfo:@{@"msgModel": model}];
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
        NSURL *url = [NSURL fileURLWithPath: giftModel.animateURL];
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
        NSURL *url = [NSURL fileURLWithPath: giftModel.animateURL];
        
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

        [giftModel loadWebp:^(UIImage * _Nonnull image) {
            UIImageView *v = [[UIImageView alloc] init];
            v.image = image;
            [self.view addSubview:v];
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self.view);
                make.height.equalTo(self.view.mas_width);
                make.center.equalTo(self.view);
            }];
            __weak UIView *weakV = v;
            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
            dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                [weakV removeFromSuperview];
            });
        }];
    } else if ([giftModel.animateType isEqualToString:@"mp4"]) {
        BDAlphaPlayerMetalView *v = [[BDAlphaPlayerMetalView alloc] initWithDelegate: self];
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
    [AudioRoomService.shared reqMicList:self.roomID.integerValue success:^(NSArray<HSRoomMicList *> * _Nonnull micList) {
        [weakSelf handleMicList:micList];
    } fail:^(NSError *error) {
    }];
}

- (void)roomGameDidChanged:(NSInteger)gameID {

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
            NSString *key = [NSString stringWithFormat:@"%ld",m.micIndex];
            AudioRoomMicModel *micModel = self.dicMicModel[key];
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
        [self handleTapVoice];
    }
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

#pragma mark lazy

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"room_bg"];
    }
    return _bgImageView;
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
    }
    return _dicMicModel;
}

- (UILabel *)gameNumLabel {
    if (!_gameNumLabel) {
        _gameNumLabel = UILabel.new;
        _gameNumLabel.text = @"游戏人数：0/0";
        _gameNumLabel.font = UIFONT_REGULAR(12);
        _gameNumLabel.textColor = UIColor.whiteColor;
    }
    return _gameNumLabel;
}

- (void)setIsEnteredRoom:(BOOL)isEnteredRoom {
    [self.sudFSTAPPDecorator notifyAppComonSelfIn:_isEnteredRoom seatIndex:-1 isSeatRandom:true teamId:1];
}

- (void)setRoomName:(NSString *)roomName {
    _roomName = roomName;
    self.naviView.roomNameLabel.text = roomName;
}

- (void)setGameId:(NSInteger)gameId {
    _gameId = gameId;
    GameService.shared.gameId = gameId;
}

- (void)setIsShowEndGame:(BOOL)isShowEndGame {
    _isShowEndGame = isShowEndGame;
    
    [self.naviView isHiddenEndGameBtn:!isShowEndGame];
}

- (void)dealloc {
    [self logoutGame];
}

#pragma mark - BDAlphaPlayerMetalViewDelegate
- (void)metalView:(nonnull BDAlphaPlayerMetalView *)metalView didFinishPlayingWithError:(nonnull NSError *)error {
    [metalView removeFromSuperview];
}

@end