//
//  OneOneViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/9.
//

#import "OneOneVideoViewController.h"
#import "OneOneVideoContentView.h"
#import "SuspendRoomView.h"

@interface OneOneVideoViewController ()
@property(nonatomic, strong) OneOneVideoContentView *videoContentView;

@property(nonatomic, strong) DTTimer *timer;
@property(nonatomic, assign) NSInteger duration;
@end

@implementation OneOneVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self startPublishStream];
    [self setAudioRouteToSpeaker:YES];
    [self.videoContentView changeMicState:OneOneVideoMicTypeOpen];
    [self startPreview:self.videoContentView.myVideoView];
}

- (Class)serviceClass {
    return AudioRoomService.class;
}


- (void)dtAddViews {
    [super dtAddViews];
    [self.sceneView addSubview:self.videoContentView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.videoContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.trailing.equalTo(@0);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.naviView.hidden = YES;
    self.operatorView.hidden = YES;
    self.msgBgView.hidden = YES;
    WeakSelf
    self.timer = [DTTimer timerWithTimeInterval:1 repeats:YES block:^(DTTimer *timer) {
        [weakSelf updateDuration];
    }];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    self.videoContentView.hangupBlock = ^{
        [DTAlertView showTextAlert:@"确定要挂断通话吗？" sureText:@"确定" cancelText:@"取消" onSureCallback:^{
            [DTAlertView close];
            [weakSelf exitRoomFromSuspend:NO finished:nil];
        }          onCloseCallback:nil];
    };
    self.videoContentView.micStateChangedBlock = ^(OneOneVideoMicType stateType) {
        if (stateType == OneOneVideoMicTypeOpen) {
            [weakSelf startPublishStream];
        } else {
            [weakSelf stopPublish];
        }
    };

    self.videoContentView.selecteGameBlock = ^{
        [weakSelf showSelectGameView];
    };
    self.videoContentView.addRobotBlock = ^{
        [weakSelf handleAddRobot];
    };
    self.videoContentView.suspendBlock = ^{
        [SuspendRoomView show:weakSelf];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

- (UIView *)getSuspendVideoView {
    return self.videoContentView.myVideoView;
}

- (void)resetVideoView {
    [self.videoContentView resetVideoView];
}

- (void)handleAddRobot {
    WeakSelf
    // 查找一个未在麦位机器人
    [self findOneNotInMicRobot:^(RobotInfoModel *robotInfoModel) {
        /// 将机器人上麦
        [weakSelf joinCommonRobotToMic:robotInfoModel showNoMic:YES];
    }];

}

- (void)onHandleEnteredRoom {
    [super onHandleEnteredRoom];

}

/// 是否显示添加通用机器人按钮
- (BOOL)isShowAddRobotBtn {
    return NO;
}

/// 是否加载通用机器人
- (BOOL)isLoadCommonRobotList {
    return NO;
}

/// 游戏区域配置
- (NSString *)onGameViewInfo {
    CGFloat scale = [[UIScreen mainScreen] nativeScale];
    GameViewInfoModel *m = [[GameViewInfoModel alloc] init];
    m.view_size.width = kScreenWidth * scale;
    m.view_size.height = kScreenHeight * scale;
    m.view_game_rect.top = (kStatusBarHeight + 150) * scale;
    m.view_game_rect.left = 0;
    m.view_game_rect.bottom = (kAppSafeBottom + 100) * scale;
    m.view_game_rect.right = 0;

    m.ret_code = 0;
    m.ret_msg = @"success";
    return m.mj_JSONString;
}

- (void)handleBusyCommand:(NSInteger)cmd command:(NSString *)command {
    switch (cmd) {
        case CMD_ONEONE_INFO_RESP: {
            RoomCmdOneOneInfoModel *m = [RoomCmdOneOneInfoModel fromJSON:command];
            DDLogDebug(@"recv duration:%ld", m.duration);
            self.duration = m.duration;
        }
            break;
        default:
            break;
    }
}

/// 处理麦位变化
/// @param model model description
- (void)handleMicChanged:(RoomCmdUpMicModel *)model {
    [super handleMicChanged:model];
    BOOL isMe = [AppService.shared.login.loginUserInfo isMeByUserID:model.sendUser.userID];
    if (model.cmd == CMD_DOWN_MIC_NOTIFY && !isMe) {
        [ToastUtil show:@"对方已结束通话"];
    }
}

/// 收到用户进入房间通知
/// @param msgModel
- (void)onUserEnterRoom:(AudioMsgSystemModel *)msgModel {
    [super onUserEnterRoom:msgModel];

    // 发送同步时长指令
    [self sendOneOneDuration];
}

- (void)sendOneOneDuration {
    RoomCmdOneOneInfoModel *m = [RoomCmdOneOneInfoModel makeModelWithDuration:self.duration];
    [self sendMsg:m isAddToShow:NO finished:nil];
}

/// 游戏已经发生切换
- (void)roomGameDidChanged:(NSInteger)gameID {
    [super roomGameDidChanged:gameID];
    [self.videoContentView changeUIState:gameID > 0];
}

/// 流更新
/// @param updateType 更新类型
/// @param stream 流信息
- (void)onStreamUpdated:(HSAudioEngineUpdateType)updateType stream:(AudioStream *)stream {
    [super onStreamUpdated:updateType stream:stream];
    if (HSAudioEngineUpdateTypeAdd == updateType) {
        [self startToPullVideo:self.videoContentView.otherVideoView streamID:stream.streamID];
        [self.videoContentView changeOtherVideoState:YES];
    } else {
        [self.videoContentView changeOtherVideoState:NO];
    }
}

- (void)updateDuration {
    self.duration++;
    [self.videoContentView updateDuration:self.duration];
}

- (OneOneVideoContentView *)videoContentView {
    if (!_videoContentView) {
        _videoContentView = OneOneVideoContentView.new;
    }
    return _videoContentView;
}

@end
