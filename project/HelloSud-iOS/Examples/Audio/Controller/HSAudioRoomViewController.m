//
//  HSAudioRoomViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSAudioRoomViewController.h"
#import "HSAudioRoomViewController+IM.h"

/// View
#import "HSRoomNaviView.h"
#import "HSRoomOperatorView.h"
#import "HSRoomMsgBgView.h"
#import "HSRoomMsgTableView.h"
#import "HSAudioMicContentView.h"
#import "HSRoomInputView.h"
#import "HSGameMicContentView.h"
#import "HSAudioMicroView.h"

@interface HSAudioRoomViewController ()
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.roomID = @"123";
    HSAudioRoomManager.shared.currentRoomVC = self;
    MediaUser *user = [MediaUser user:HSAppManager.shared.loginUserInfo.userID nickname:HSAppManager.shared.loginUserInfo.name];
    /// 设置语音引擎事件回调
    [MediaAudioEngineManager.shared.audioEngine setEventHandler:self];
    [MediaAudioEngineManager.shared.audioEngine loginRoom:self.roomID user:user config:nil];
    
//    self.roomType = HSGame;
    self.roomType = HSAudio;
}

- (void)hsAddViews {
    [self.view addSubview:self.bgImageView];
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
            [HSAudioRoomManager.shared reqExitRoom:weakSelf.roomID.longLongValue];
            [AppUtil.currentViewController.navigationController popViewControllerAnimated:true];
        } onCloseCallback:^{
        }];
    };
}

/// 处理麦位点击
/// @param micModel micModel description
- (void)handleMicTap:(HSAudioRoomMicModel *)micModel {
    if (micModel.user == nil) {
        /// 无人，上麦
        [HSAudioRoomManager.shared reqSwitchMic:self.roomID.integerValue micIndex:(int)micModel.micIndex handleType:0];
        return;
    }
}

- (void)handleTapVoice {
    switch (self.operatorView.voiceBtnState) {
        case VoiceBtnStateTypeNormal:{
            // 请求上麦
            NSArray *arr = self.arrMicModel;
            HSAudioRoomMicModel *emptyModel = nil;
            for (HSAudioRoomMicModel *m in arr) {
                if (m.user == nil) {
                    emptyModel = m;
                    break;
                }
            }
            if (emptyModel == nil) {
                [SVProgressHUD showErrorWithStatus:@"没有空麦位"];
                return;
            }
            self.operatorView.voiceBtnState = VoiceBtnStateTypeWaitOpen;
            [self handleMicTap:emptyModel];
        }
            break;
        case VoiceBtnStateTypeWaitOpen:
            // 开启声音
            self.operatorView.voiceBtnState = VoiceBtnStateTypeOnVoice;
            [self startPublish:[NSString stringWithFormat:@"%ld", arc4random()]];

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
    }
}

#pragma mark setter
- (void)setRoomType:(RoomType)roomType {
    _roomType = roomType;
    
    if (self.roomType == HSAudioMic) {
        [self.gameMicContentView setHidden:true];
        [self.audioMicContentView setHidden:false];
        [self.msgBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.audioMicContentView.mas_bottom);
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.operatorView.mas_top).offset(-20);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        [self.arrMicModel removeAllObjects];
        for (HSAudioMicroView *v in self.audioMicContentView.micArr) {
            [self.arrMicModel addObject:v.model];
        }
    } else if (self.roomType == HSGameMic) {
        [self.gameMicContentView setHidden:false];
        [self.audioMicContentView setHidden:true];
        [self.msgBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.operatorView.mas_top);
            make.height.mas_equalTo(106);
        }];
        [self.arrMicModel removeAllObjects];
        for (HSAudioMicroView *v in self.gameMicContentView.micArr) {
            [self.arrMicModel addObject:v.model];
        }
    }
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

- (NSMutableArray *)arrMicModel {
    if (_arrMicModel == nil) {
        _arrMicModel = NSMutableArray.new;
    }
    return _arrMicModel;
}

@end
