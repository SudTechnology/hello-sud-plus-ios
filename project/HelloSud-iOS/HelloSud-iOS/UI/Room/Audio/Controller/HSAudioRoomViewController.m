//
//  HSAudioRoomViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSAudioRoomViewController.h"
#import "HSAudioRoomViewController+IM.h"
#import "HSAudioRoomViewController+Game.h"

/// View
#import "HSRoomNaviView.h"
#import "HSRoomOperatorView.h"
#import "HSRoomMsgBgView.h"
#import "HSRoomMsgTableView.h"
#import "HSAudioMicContentView.h"
#import "HSRoomInputView.h"
#import "HSGameMicContentView.h"
#import "HSAudioMicroView.h"
#import "HSMicOperateView.h"
#import "HSRoomGiftPannelView.h"

@interface HSAudioRoomViewController () <BDAlphaPlayerMetalViewDelegate>
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) HSRoomNaviView *naviView;
@property (nonatomic, strong) HSRoomOperatorView *operatorView;
@property (nonatomic, strong) HSRoomMsgBgView *msgBgView;
@property (nonatomic, strong) HSRoomMsgTableView *msgTableView;
@property (nonatomic, strong) HSAudioMicContentView *audioMicContentView;
@property (nonatomic, strong) HSGameMicContentView *gameMicContentView;
@property (nonatomic, strong) HSRoomInputView *inputView;
/// 主播视图列表
@property (nonatomic, strong) NSArray <HSAudioMicroView *> *arrAnchorView;

@end

@implementation HSAudioRoomViewController

- (BOOL)hsIsHidenNavigationBar {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HSAudioRoomManager.shared.currentRoomVC = self;
    [self loginRoom];
//    [self sendEnterRoomMsg];
    if (self.gameId > 0) {
        self.gameInfoModel.currentPlayerUserId = HSAppManager.shared.loginUserInfo.userID;
        [self loginGame];
    }
    [self hsUpdateUI];
}

- (void)hsAddViews {
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.gameView];
    [self.view addSubview:self.naviView];
    [self.view addSubview:self.operatorView];
    [self.view addSubview:self.audioMicContentView];
    [self.view addSubview:self.gameMicContentView];
    [self.view addSubview:self.msgBgView];
    [self.msgBgView addSubview:self.msgTableView];
    [self.view addSubview:self.inputView];
}

- (void)hsLayoutViews {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
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
    [self.audioMicContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(20);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.gameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.gameMicContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(20);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(55);
    }];
    [self.msgBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.audioMicContentView.mas_bottom);
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

- (void)hsConfigEvents {
    WeakSelf
    self.operatorView.giftTapBlock = ^(UIButton *sender) {
        [HSSheetView show:[[HSRoomGiftPannelView alloc] init] rootView:AppUtil.currentWindow onCloseCallback:^{
            [weakSelf.operatorView resetAllSelectedUser];
        }];
    };
    self.operatorView.inputTapBlock = ^(UITapGestureRecognizer *gesture) {
        [weakSelf.inputView hsBecomeFirstResponder];
    };
    self.operatorView.voiceTapBlock = ^(UIButton *sender) {
        // 上麦点击
        [weakSelf handleTapVoice];
    };
    self.inputView.inputMsgBlock = ^(NSString * _Nonnull msg) {
        // 发送公屏消息
        HSAudioMsgTextModel *m = [HSAudioMsgTextModel makeMsg:msg];
        [weakSelf sendMsg:m isAddToShow:YES];
    };
    if (self.roomType == HSAudioMic) {
        self.audioMicContentView.updateMicArrCallBack = ^(NSArray<HSAudioMicroView *> * _Nonnull micArr) {
            weakSelf.arrAnchorView = micArr;
        };
    } else if (self.roomType == HSGameMic) {
        self.gameMicContentView.updateMicArrCallBack = ^(NSArray<HSAudioMicroView *> * _Nonnull micArr) {
            weakSelf.arrAnchorView = micArr;
        };
    }
    self.audioMicContentView.onTapCallback = ^(HSAudioRoomMicModel * _Nonnull micModel) {
        /// 麦位点击回调
        [weakSelf handleMicTap:micModel];
    };
    self.gameMicContentView.onTapCallback = ^(HSAudioRoomMicModel * _Nonnull micModel) {
        /// 麦位点击回调
        [weakSelf handleMicTap:micModel];
    };
    self.naviView.closeTapBlock = ^(UIButton *sender) {
        [HSAlertView showTextAlert:@"确认关闭/离开当前房间吗" sureText:@"确定" cancelText:@"取消" onSureCallback:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                // 需要在主线程执行的代码
                [HSAudioRoomManager.shared reqExitRoom:weakSelf.roomID.longLongValue];
                [weakSelf logoutRoom];
                [AppUtil.currentViewController.navigationController popViewControllerAnimated:true];
            });
        } onCloseCallback:^{
        }];
    };
    self.naviView.onTapGameCallBack = ^(HSGameList * _Nonnull m) {
        [weakSelf handleChangeRoomMode:m];
    };
}

- (void)hsUpdateUI {
    [self.naviView hsUpdateUI];
}

/// 处理切换房间
/// @param m m description
- (void)handleChangeRoomMode:(HSGameList *)m {
    WeakSelf
    [HSAudioRoomManager.shared reqSwitchGame:self.roomID.integerValue gameId:self.gameId success:^{
        
        ExChangeGameMsgModel *msg = nil;
        if (m.isAudioRoom) {
            weakSelf.roomType = HSAudio;
            msg = [ExChangeGameMsgModel makeMsg:0];
        } else if(m.gameId > 0) {
            msg = [ExChangeGameMsgModel makeMsg:m.gameId];
            [weakSelf handleGameChange:m.gameId];
        }
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
- (void)handleMicTap:(HSAudioRoomMicModel *)micModel {
    if (micModel.user == nil) {
        /// 无人，上麦
        [HSAudioRoomManager.shared reqSwitchMic:self.roomID.integerValue micIndex:(int)micModel.micIndex handleType:0];
        return;
    } else if ([HSAppManager.shared.loginUserInfo isMeByUserID:micModel.user.userID] || micModel.user.roleType == 1) {
        // 是自己或者房主
        HSMicOperateView *v = HSMicOperateView.new;
        v.downMicCallback = ^(UIButton *sender) {
            // 下麦
            [HSAudioRoomManager.shared reqSwitchMic:self.roomID.integerValue micIndex:(int)micModel.micIndex handleType:1];
            [HSSheetView close];
        };
        v.cancelCallback = ^(UIButton *sender) {
            [HSSheetView close];
        };
        [HSSheetView show:v rootView:self.view onCloseCallback:^{
                    
        }];
    }
}

- (void)handleTapVoice {
    switch (self.operatorView.voiceBtnState) {
        case VoiceBtnStateTypeNormal:{
            // 请求上麦
            NSArray *arr = self.dicMicModel.allValues;
            HSAudioRoomMicModel *emptyModel = nil;
            for (HSAudioRoomMicModel *m in arr) {
                if (m.user == nil) {
                    emptyModel = m;
                    break;
                }
            }
            if (emptyModel == nil) {
                [ToastUtil show:@"没有空麦位"];
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
                    [HSAlertView showTextAlert:@"无法访问麦克风，请到“设置-隐私“中开启麦克风访问权限" sureText:@"去开启" cancelText:@"暂时不用" onSureCallback:^{
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

/// 展示公屏消息
/// @param msg 消息体
- (void)addMsg:(HSAudioMsgBaseModel *)msg {
    [self.msgTableView addMsg:msg];
    if ([msg isKindOfClass:HSAudioMsgMicModel.class]) {
        [self handleMicChanged:(HSAudioMsgMicModel *)msg];
    } else if ([msg isKindOfClass:HSAudioMsgGiftModel.class]) {
        [self handleGiftEffect:(HSAudioMsgGiftModel *)msg];
    }
}

/// 处理麦位变化
/// @param model model description
- (void)handleMicChanged:(HSAudioMsgMicModel *)model {
    // 通知麦位变化
    [[NSNotificationCenter defaultCenter]postNotificationName:NTF_MIC_CHANGED object:nil userInfo:@{@"msgModel": model}];
}

/// 处理礼物动效
/// @param model model description
- (void)handleGiftEffect:(HSAudioMsgGiftModel *)model {
    HSGiftModel *giftModel = [HSGiftManager.shared giftByID:model.giftID];
    if (!giftModel) {
        NSLog(@"No exist the gift info:%ld", model.giftID);
        return;
    }
    if ([giftModel.animateType isEqualToString:@"svga"]) {
        HSSVGAPlayerView *v = HSSVGAPlayerView.new;
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
            make.width.equalTo(self.view);
            make.height.equalTo(self.view.mas_width);
            make.center.equalTo(self.view);
        }];
        __weak UIView *weakV = v;
        [v playWithCompletion:^(BOOL animationFinished) {
            [weakV removeFromSuperview];
        }];
    } else if ([giftModel.animateType isEqualToString:@"webp"]) {
//        [[SDWebImageDownloader sharedDownloader] setValue:@"image/webp,image/*,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
//        SDImageWebPCoder *webPCoder = [SDImageWebPCoder sharedCoder];
//        [[SDImageCodersManager sharedManager] addCoder:webPCoder];
        
        NSData *webpData = [NSData dataWithContentsOfFile:giftModel.animateURL];
        UIImage *wimage = [[SDImageWebPCoder sharedCoder] decodedImageWithData:webpData options:nil];
        
        UIImageView *v = [[UIImageView alloc] initWithImage:wimage];
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
    } else if ([giftModel.animateType isEqualToString:@"mp4"]) {
        BDAlphaPlayerMetalView *v = [[BDAlphaPlayerMetalView alloc] initWithDelegate: self];
        [self.view addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.view);
            make.height.equalTo(self.view.mas_width);
            make.center.equalTo(self.view);
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
    [HSAudioRoomManager.shared reqMicList:self.roomID.integerValue success:^(NSArray<HSRoomMicList *> * _Nonnull micList) {
        [weakSelf handleMicList:micList];
    } fail:^(NSError *error) {
    }];
}

- (void)handleMicList:(NSArray<HSRoomMicList *> *)micList {
    NSMutableArray<NSNumber *> *arrUserID = NSMutableArray.new;
    for (HSRoomMicList *m in micList) {
        [arrUserID addObject:[NSNumber numberWithInteger:m.userId]];
    }
    // 缓存用户信息
    [HSUserManager.shared asyncCacheUserInfo:arrUserID finished:^{
        for (HSRoomMicList *m in micList) {
            NSString *key = [NSString stringWithFormat:@"%ld",m.micIndex];
            HSAudioRoomMicModel *micModel = self.dicMicModel[key];
            HSUserInfoModel *userInfo = [HSUserManager.shared getCacheUserInfo:m.userId];
            if (micModel) {
                if (!micModel.user) {
                    micModel.user = HSAudioUserModel.new;
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
        [NSNotificationCenter.defaultCenter postNotificationName:NTF_MIC_CHANGED object:nil];
    }];

}

#pragma mark setter
- (void)setRoomType:(RoomType)roomType {
    _roomType = roomType;
    
    if (self.roomType == HSAudioMic) {
        /// 销毁游戏
        [self logoutGame];
        [self.gameMicContentView setHidden:true];
        [self.audioMicContentView setHidden:false];
        self.gameView.hidden = YES;
        [self.msgBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.audioMicContentView.mas_bottom);
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.operatorView.mas_top).offset(-20);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        [self.dicMicModel removeAllObjects];
        for (HSAudioMicroView *v in self.audioMicContentView.micArr) {
            NSString *key = [NSString stringWithFormat:@"%ld", v.model.micIndex];
            self.dicMicModel[key] = v.model;
            v.micType = HSAudioMic;
        }
    } else if (self.roomType == HSGameMic) {
        self.gameView.hidden = NO;
        [self.gameMicContentView setHidden:false];
        [self.audioMicContentView setHidden:true];
        [self.msgBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.operatorView.mas_top);
            make.height.mas_equalTo(106);
        }];
        [self.dicMicModel removeAllObjects];
        for (HSAudioMicroView *v in self.gameMicContentView.micArr) {
            NSString *key = [NSString stringWithFormat:@"%ld", v.model.micIndex];
            self.dicMicModel[key] = v.model;
            v.micType = HSGameMic;
        }
    }
    [self reqMicList];
}

#pragma mark lazy

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"room_bg"];
    }
    return _bgImageView;
}

- (HSRoomNaviView *)naviView {
    if (!_naviView) {
        _naviView = [[HSRoomNaviView alloc] init];
    }
    return _naviView;
}

- (HSRoomOperatorView *)operatorView {
    if (!_operatorView) {
        _operatorView = [[HSRoomOperatorView alloc] init];
    }
    return _operatorView;
}

- (HSRoomMsgBgView *)msgBgView {
    if (!_msgBgView) {
        _msgBgView = [[HSRoomMsgBgView alloc] init];
    }
    return _msgBgView;
}

- (HSRoomMsgTableView *)msgTableView {
    if (!_msgTableView) {
        _msgTableView = [[HSRoomMsgTableView alloc] init];
    }
    return _msgTableView;
}

- (HSAudioMicContentView *)audioMicContentView {
    if (!_audioMicContentView) {
        _audioMicContentView = [[HSAudioMicContentView alloc] init];
    }
    return _audioMicContentView;
}

- (HSRoomInputView *)inputView {
    if (!_inputView) {
        _inputView = [[HSRoomInputView alloc] init];
    }
    return _inputView;
}

- (HSGameMicContentView *)gameMicContentView {
    if (!_gameMicContentView) {
        _gameMicContentView = [[HSGameMicContentView alloc] init];
    }
    return _gameMicContentView;
}

- (UIView *)gameView {
    if (_gameView == nil) {
        _gameView = UIView.new;
    }
    return _gameView;
}

- (NSMutableDictionary *)dicMicModel {
    if (_dicMicModel == nil) {
        _dicMicModel = NSMutableDictionary.new;
    }
    return _dicMicModel;
}

- (HSRoomGameInfoModel *)gameInfoModel {
    if (_gameInfoModel == nil) {
        _gameInfoModel = HSRoomGameInfoModel.new;
        _gameInfoModel.language = @"zh-CN";
    }
    return _gameInfoModel;
}

- (void)setIsEnteredRoom:(BOOL)isEnteredRoom {
    [self.fsm2MGManager sendComonSelfIn:_isEnteredRoom seatIndex:-1 isSeatRandom:true teamId:1];
}

- (void)setRoomName:(NSString *)roomName {
    _roomName = roomName;
    self.naviView.roomNameLabel.text = roomName;
}

- (void)dealloc {
    [self logoutGame];
}

#pragma mark - BDAlphaPlayerMetalViewDelegate
- (void)metalView:(nonnull BDAlphaPlayerMetalView *)metalView didFinishPlayingWithError:(nonnull NSError *)error {
    [metalView removeFromSuperview];
}

@end
