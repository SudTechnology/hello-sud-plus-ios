//
//  CrossroomViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/18.
//

#import "CrossRoomViewController.h"
#import "PKStateView.h"
#import "PKSelectRoomView.h"
#import "PKSettingView.h"
#import "DTTextAlertView.h"
#import "PKGameEmptyView.h"
#import "SuspendRoomView.h"

/// pk状态类型
typedef NS_ENUM(NSInteger, PKStateType) {
    PKStateTypeClosed = 0, // pk关闭
    PKStateTypeOpened = 1, // pk开启
    PKStateTypeIng = 2,    // pk进行中
    PKStateTypeEnd = 3,    // pk结束
};

@interface CrossRoomViewController ()
@property(nonatomic, strong) BaseView *pkView;
@property(nonatomic, strong) PKStateView *pkStateView;
@property(nonatomic, strong) BaseView *settingView;
@property(nonatomic, strong) MarqueeLabel *settingLabel;
@property(nonatomic, strong) PKGameEmptyView *gameEmptyView;
/// pk状态
@property(nonatomic, assign) PKStateType pkState;
/// 总PK时长
@property(nonatomic, assign) NSInteger totalDuration;
/// 是否在接受中
@property(nonatomic, assign) BOOL isAccepting;
@property(nonatomic, assign) int64_t pkId;
/// 对方用户信息
@property(nonatomic, strong) AudioUserModel *otherUser;
/// 延迟关闭定时器
@property(nonatomic, strong) DTTimer *delayCloseTimer;
// 延迟关闭倒计时
@property(nonatomic, assign) NSInteger delayCloseCountdown;
@end

@implementation CrossRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    kPKService.currentRoomVC = self;
    // 开始隐藏选择游戏
    [self.naviView hiddenNodeWithRoleType:0];
}

/// 服务类，子类返回对应服务类型，用于构建对应场景服务
- (Class)serviceClass {
    return [PKRoomService class];
}

- (void)setConfigModel:(BaseSceneConfigModel *)configModel {
    [super setConfigModel:configModel];
    self.roomType = HSGame;
    [self updatePKState:PKStateTypeClosed];
    // 非房主不展示PK设置按钮
    if (!self.isRoomOwner) {
        self.settingView.hidden = YES;
    }
    self.gameEmptyView.isRoomOwner = self.isRoomOwner;
    [self handleFirstEnterPKState];
}

/// 处理首次进入房间pk状态
- (void)handleFirstEnterPKState {
    if (self.enterModel.pkResultVO == nil) {
        DDLogDebug(@"enterModel.pkResultVO is empty");
        return;
    }
    PKResultModel *pkResultModel = self.enterModel.pkResultVO;
    if (pkResultModel.pkId > 0) {
        self.pkId = pkResultModel.pkId;
    }
    // 更新pk状态
    PKStateType currentState = [self convertPKState:pkResultModel];
    [self updatePKState:currentState];
    NSInteger srcScore = 0;
    NSInteger destScore = 0;
    AudioUserModel *srcUser = nil;
    AudioUserModel *destUser = nil;
    if (pkResultModel.srcRoomInfo) {
        PKResultRoomInfoModel *m = pkResultModel.srcRoomInfo;
        DDLogDebug(@"srcRoomInfo: name:%@, roomID:%@", m.roomOwnerNickname, @(m.roomId));
        srcUser = [[AudioUserModel alloc] init];
        srcUser.icon = m.roomOwnerHeader;
        srcUser.name = m.roomOwnerNickname;
        srcUser.roomID = [NSString stringWithFormat:@"%@", @(m.roomId)];
        srcScore = m.score;
    }
    if (pkResultModel.destRoomInfo) {
        PKResultRoomInfoModel *m = pkResultModel.destRoomInfo;
        DDLogDebug(@"destRoomInfo: name:%@, roomID:%@", m.roomOwnerNickname, @(m.roomId));
        destUser = [[AudioUserModel alloc] init];
        destUser.icon = m.roomOwnerHeader;
        destUser.name = m.roomOwnerNickname;
        destUser.roomID = [NSString stringWithFormat:@"%@", @(m.roomId)];
        destScore = m.score;
    }

    // 如果pk结束了，更新pk结果
    if (self.pkState == PKStateTypeEnd) {
        // 更新结果
        [self.pkStateView updatePKResult];
    } else if (self.pkState == PKStateTypeIng) {
        // 更新倒计时
        [self.pkStateView startCountdown:pkResultModel.remainSecond];
    }

    if ([srcUser.roomID isEqualToString:self.roomID]) {
        // 发起方为自己房间，红方
        self.otherUser = destUser;
        [self.pkStateView updateLeftUserInfo:srcUser];
        [self.pkStateView updateRightUserInfo:destUser];
        [self.pkStateView changeRedInLeft:YES];
        [self.pkStateView updateLeftScore:srcScore rightScore:destScore];
    } else {
        // 自己房间属于受邀房间，蓝方
        self.otherUser = srcUser;
        self.gameRoomID = srcUser.roomID;
        [self.pkStateView updateLeftUserInfo:destUser];
        [self.pkStateView updateRightUserInfo:srcUser];
        [self.pkStateView changeRedInLeft:NO];
        [self.pkStateView updateLeftScore:destScore rightScore:srcScore];
    }

    [self dtUpdateUI];

}

/// 转换服务端pk转态对应到客户端状态
/// @param pkResultModel pkResultModel
/// @return PKStateType
- (PKStateType)convertPKState:(PKResultModel *)pkResultModel {
    PKStateType state = PKStateTypeClosed;
    /// pk状态（1：待匹配 2：pk已匹配，未开始 3：k已匹配，已开始 4：pk匹配关闭 5：pk已结束）
    switch (pkResultModel.pkStatus) {
        case 5:
            state = PKStateTypeEnd;
            break;
        case 4:
            state = PKStateTypeClosed;
            break;
        case 3:
            state = PKStateTypeIng;
            break;
        case 2:
        case 1:
            state = PKStateTypeOpened;
            break;
        default:
            break;
    }
    return state;
}


- (BOOL)isShowAudioContent {
    return self.pkState == PKStateTypeClosed && self.gameId == 0;
}

/// 是否展示游戏麦位区域
- (BOOL)isShowGameMic {
    return self.pkState != PKStateTypeClosed;
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.naviView addSubview:self.settingView];
    [self.settingView addSubview:self.settingLabel];
    [self.sceneView addSubview:self.pkView];
    [self.pkView addSubview:self.pkStateView];
    [self.pkView addSubview:self.gameEmptyView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.settingLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    CGFloat b = 150 + kAppSafeBottom;
    [self.pkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.sceneView);
        make.top.equalTo(self.gameMicContentView.mas_bottom).offset(20);
        make.bottom.equalTo(@(-b));
    }];
    [self.pkStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.pkView);
        make.top.equalTo(@0);
        make.height.equalTo(@50);
    }];
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.naviView.roomModeView);
        make.height.equalTo(@20);
        make.width.mas_greaterThanOrEqualTo(56);
        make.trailing.equalTo(self.naviView.roomModeView.mas_leading).offset(-10);
        make.leading.greaterThanOrEqualTo(self.naviView.roomInfoView.mas_trailing).offset(10);
    }];
    [self.settingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@8);
        make.trailing.equalTo(@(-8));
        make.centerY.equalTo(self.settingView);
        make.height.mas_greaterThanOrEqualTo(0);
        make.width.mas_lessThanOrEqualTo(@100);
    }];
    [self.gameEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.centerY.equalTo(self.pkView);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSettingPKTap:)];
    [self.settingView addGestureRecognizer:tap];
    self.pkStateView.countdownFinishedBlock = ^{
        [weakSelf updatePKState:PKStateTypeEnd];
    };
    self.pkStateView.blueBtnClickBlock = ^{
        [weakSelf handleBlueClick];
    };
    self.gameEmptyView.onClickBlock = ^{
        [weakSelf showSelectGameView];
    };
    self.pkView.hitTestChangedCallback = ^(UIView *currentView, CGPoint point) {
        if (weakSelf.pkView == currentView) {
            // pk子视图不响应，给到游戏视图
            return (UIView *) weakSelf.gameView;
        }
        return currentView;
    };
}

- (void)dtConfigUI {
    [super dtConfigUI];
    AudioUserModel *user = [[AudioUserModel alloc] init];
    user.name = AppService.shared.login.loginUserInfo.name;
    user.icon = AppService.shared.login.loginUserInfo.icon;
    user.roomID = self.roomID;
    [self.pkStateView updateLeftUserInfo:user];
}

// 处理蓝方按钮逻辑
- (void)handleBlueClick {

    if (!self.pkStateView.rightUserInfo) {
        if (!kPKService.currentRoomVC.isRoomOwner) {
            // 非房主不能邀请
            return;
        }
        // 没人，邀请房间
        PKSelectRoomView *v = [[PKSelectRoomView alloc] init];
        [DTSheetView show:v onCloseCallback:^{

        }];
        return;
    }
    WeakSelf
    if (kPKService.currentRoomVC.isRoomOwner) {
        // 是房主
        [DTAlertView showTextAlert:NSString.dt_room_pk_remove_other_tip sureText:NSString.dt_room_pk_remove_sure cancelText:NSString.dt_common_cancel onSureCallback:^{
            [DTAlertView close];

            // 游戏中
            if (weakSelf.sudFSMMGDecorator.isPlaying) {
                [ToastUtil show:NSString.dt_room_pk_remove_gaming_toast_tip];
                return;
            } else if (weakSelf.pkState == PKStateTypeIng) {
                // PK中
                [ToastUtil show:NSString.dt_room_pk_remove_toast_tip];
                return;
            }

            NSString *destRoomID = weakSelf.otherUser.roomID;
            // 请求接触PK关系
            [kPKService reqReleasePK:destRoomID.longLongValue finished:^{
                [weakSelf removeOtherUser];
                [weakSelf updatePKState:PKStateTypeOpened];
                // 对方房间发送
                [kPKService sendCrossPKRemoveOtherMsg:destRoomID finished:nil];
                // 房间内
                [kPKService sendCrossPKRemoveOtherMsg];
            }];
        }          onCloseCallback:^{

        }];


        return;
    }

    // 普通用户进入他人房间
    [DTAlertView showTextAlert:NSString.dt_room_pk_enter_other_room_tip sureText:NSString.dt_common_forward cancelText:NSString.dt_common_cancel onSureCallback:^{
        [DTAlertView close];
        [weakSelf enterOtherRoom];
    }          onCloseCallback:^{

    }];
}

/// 进入对方房间
- (void)enterOtherRoom {
    NSString *roomID = self.otherUser.roomID;
    if (roomID.length > 0) {
        [self exitRoomFromSuspend:NO finished:^{
            [AudioRoomService reqEnterRoom:roomID.longLongValue isFromCreate:NO success:^{

            }                         fail:nil];
        }];
    }
}

/// 点击PK设置
- (void)onSettingPKTap:(UITapGestureRecognizer *)tap {
    WeakSelf
    if (self.pkState == PKStateTypeClosed) {
        // 打开PK
        [kPKService reqOpenPK:self.roomID.longLongValue open:YES finished:^{
            [weakSelf updatePKState:PKStateTypeOpened];
            [kPKService sendPKOpenedMsg];
        }];
        return;
    }
    if (!self.pkStateView.rightUserInfo) {
        // 没有pk对象 邀请房间
        PKSelectRoomView *v = [[PKSelectRoomView alloc] init];
        [DTSheetView show:v onCloseCallback:^{

        }];
        [ToastUtil show:NSString.dt_room_pk_show_invite_tip];
        return;
    }
    // 展示PK时长设置弹窗
    BOOL isPKStop = self.pkState == PKStateTypeOpened || self.pkState == PKStateTypeEnd;
    PKSettingView *node = [[PKSettingView alloc] initWithPKSettingType:isPKStop ? PKSettingTypePKBefore : PKSettingTypePKAfter];
    [DTSheetView show:node onCloseCallback:nil];
    node.settingNodesEventBlock = ^(PKSettingBtnEventType type, NSNumber *time) {
        [DTSheetView close];
        switch (type) {
            case PKSettingBtnEventTypeStartPK: {
                // 开始PK
                if (weakSelf.otherUser == nil) {
                    DDLogDebug(@"pk other user is empty");
                    return;
                }

                [kPKService reqStartPK:self.roomID.longLongValue duration:time.integerValue isAgain:self.pkState == PKStateTypeEnd finished:^(RespStartPKModel *resp) {
                    weakSelf.totalDuration = time.integerValue;
                    weakSelf.pkId = resp.pkId;
                    [weakSelf updatePKState:PKStateTypeIng];
                    // 跨房用户
                    [kPKService sendCrossPKStartedMsg:weakSelf.otherUser.roomID minuteDuration:time.integerValue pkId:resp.pkId finished:nil];
                    // 本房
                    [kPKService sendPKStartedMsgWithMinuteDuration:time.integerValue pkId:resp.pkId];
                }];
            }
                break;
            case PKSettingBtnEventTypeEditPK: {
                // 编辑PK时长
                NSInteger duration = time.integerValue;
                [kPKService reqSetPKDuration:self.roomID.longLongValue duration:duration finished:^{
                    weakSelf.totalDuration = duration;
                    // 如果已经开始PK了，则重新更新PK时间倒计时
                    if (weakSelf.pkState == PKStateTypeIng) {
                        [weakSelf updatePKState:PKStateTypeIng];
                        // 跨房用户
                        [kPKService sendCrossPKChangeTimeMsg:weakSelf.otherUser.roomID minuteDuration:duration finished:nil];
                        // 本房
                        [kPKService sendPKChangeTimeMsgWithMinuteDuration:duration];
                    }
                }];
            }
                break;
            case PKSettingBtnEventTypeClosePK: {
                // 关闭PK
                if (self.pkState != PKStateTypeClosed) {

                    [DTAlertView showTextAlert:NSString.dt_room_close_pk_advance_tip sureText:NSString.dt_common_close cancelText:NSString.dt_common_cancel onSureCallback:^{
                        // 发送关闭PK
                        [kPKService reqOpenPK:self.roomID.longLongValue open:NO finished:^{
                            // 发送PK结束通知对方房间
                            [kPKService sendCrossPKFinishedMsg:weakSelf.otherUser.roomID finished:nil];
                            // 通知本房间用户
                            [kPKService sendPKClosedMsg];
                            [weakSelf removeOtherUser];
                            [weakSelf updatePKState:PKStateTypeClosed];
                            // 关闭游戏
                            if (weakSelf.gameId > 0) {
                                // 结束游戏
                                [weakSelf endGameIfIamCaptainWithFinished:^{
                                    // 房主需要切换本房间游戏为切为空
                                    if (weakSelf.isRoomOwner) {
                                        [weakSelf reqChangeToGameGameId:0 operatorUser:AppService.shared.loginUserID];
                                        return;
                                    }
                                }];
                            }
                        }];
                    }          onCloseCallback:^{

                    }];
                }
            }
                break;
            default:
                break;
        }
    };
}

/// 如果是队长，结束游戏
- (void)endGameIfIamCaptainWithFinished:(void (^)(void))finished {
    if ([self.sudFSMMGDecorator isInGame]) {
        // 离开游戏
        [self.sudFSTAPPDecorator notifyAppComonSelfPlaying:false reportGameInfoExtras:@""];
        // 结束游戏
        if ([self.sudFSMMGDecorator isPlayerIsCaptain:AppService.shared.login.loginUserInfo.userID]) {
            [self.sudFSTAPPDecorator notifyAppCommonSelfEnd];
        }
        // 延迟关闭以便上面指令执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (100 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            if (finished) finished();
        });
        return;
    }
    if (finished) finished();
}

/// 更新pk状态
/// @param pkState
- (void)updatePKState:(PKStateType)pkState {
    self.pkState = pkState;
    self.pkStateView.hidden = pkState == PKStateTypeClosed;
    self.pkView.hidden = pkState == PKStateTypeClosed;
    [self updateGameEmptyState];
    switch (pkState) {
        case PKStateTypeClosed:
            // PK关闭
            self.settingLabel.text = NSString.dt_room_pk_cross_room;
            [self.pkStateView resetResult];
            [self.pkStateView resetCountdown];
            [self.settingView dtAddGradientLayer:@[@0, @1] colors:@[(id) HEX_COLOR(@"#FF1C7C").CGColor, (id) HEX_COLOR(@"#0AACFF").CGColor] startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) cornerRadius:0];
            [self.naviView hiddenNodeWithRoleType:0];
            break;
        case PKStateTypeOpened:
            // PK开启
            [self.naviView hiddenNodeWithRoleType:kAudioRoomService.roleType];
            self.settingLabel.text = NSString.dt_room_start_pk;
            
            [self.pkStateView resetCountdown];
            [self.pkStateView changeRedInLeft:YES];
            [self.settingView dtAddGradientLayer:@[@0, @1] colors:@[(id) HEX_COLOR(@"#FF1C7C").CGColor, (id) HEX_COLOR(@"#0AACFF").CGColor] startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) cornerRadius:0];
            break;
        case PKStateTypeIng:
            // PK进行中
            [self.naviView hiddenNodeWithRoleType:kAudioRoomService.roleType];
            self.settingLabel.text = NSString.dt_room_pk_settings;
            [self.settingView dtRemoveGradient];
            [self.pkStateView resetResult];
            [self.pkStateView startCountdown:self.totalDuration * 60];
            break;
        case PKStateTypeEnd: {
            // PK结束
            [self.naviView hiddenNodeWithRoleType:kAudioRoomService.roleType];
            self.settingLabel.text = NSString.dt_room_another_pk;
            [self.settingView dtAddGradientLayer:@[@0, @1] colors:@[(id) HEX_COLOR(@"#FF1C7C").CGColor, (id) HEX_COLOR(@"#0AACFF").CGColor] startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) cornerRadius:0];
        }
            break;
    }
    [self dtUpdateUI];
}

- (BaseView *)pkView {
    if (!_pkView) {
        _pkView = [[BaseView alloc] init];
        _pkView.backgroundColor = HEX_COLOR_A(@"#10183A", 0.9);
        _pkView.hidden = YES;
    }
    return _pkView;
}

- (PKStateView *)pkStateView {
    if (!_pkStateView) {
        _pkStateView = [[PKStateView alloc] init];
        _pkStateView.hidden = YES;
    }
    return _pkStateView;
}

- (BaseView *)settingView {
    if (!_settingView) {
        _settingView = [[BaseView alloc] init];
        _settingView.backgroundColor = HEX_COLOR_A(@"#FFFFFF", 0.2);
    }
    return _settingView;
}

- (MarqueeLabel *)settingLabel {
    if (!_settingLabel) {
        _settingLabel = [[MarqueeLabel alloc] init];
        _settingLabel.text = NSString.dt_room_start_pk;
        _settingLabel.textColor = UIColor.whiteColor;
        _settingLabel.font = UIFONT_MEDIUM(12);
        _settingLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _settingLabel;
}

- (PKGameEmptyView *)gameEmptyView {
    if (!_gameEmptyView) {
        _gameEmptyView = [[PKGameEmptyView alloc] init];
        _gameEmptyView.hidden = YES;
    }
    return _gameEmptyView;
}

// 是否处于跨房状态
- (BOOL)isInCrossMode {
    return self.otherUser != nil;
}

/// 发送房间切换消息
/// @param gameId gameId
- (void)sendGameChangedMsg:(int64_t)gameId operatorUser:(NSString *)userID {
    [super sendGameChangedMsg:gameId operatorUser:userID];
    // 我发起的切换游戏，则同时发送跨房PK指令
    if ([AppService.shared.login.loginUserInfo isMeByUserID:userID] && [self isInCrossMode]) {
        [kPKService sendCrossPKChangedGameMsg:self.otherUser.roomID gameID:gameId finished:nil];
    }
    [self updateGameEmptyState];
}

/// 游戏切换
- (void)roomGameDidChanged:(NSInteger)gameID {
    [self updateGameEmptyState];
}

/// 更新提示选择游戏视图
- (void)updateGameEmptyState {
    self.gameEmptyView.hidden = self.pkState == PKStateTypeClosed || self.gameId > 0;
    self.pkView.backgroundColor = self.gameEmptyView.hidden ? nil : HEX_COLOR_A(@"#10183A", 0.9);
    [self dtUpdateUI];
}

/// 处理业务指令
- (void)handleBusyCommand:(NSInteger)cmd command:(NSString *)command {
    WeakSelf
    switch (cmd) {
        case CMD_ROOM_PK_SEND_INVITE: {
            // 发送跨房PK邀请
            // 非房主不处理
            if (!self.isRoomOwner) {
                return;
            }
            if (self.isAccepting) {
                NSLog(@"there is a pk answer now, skip the new one");
                return;
            }
            self.isAccepting = YES;
            RoomBaseCMDModel *model = [RoomBaseCMDModel fromJSON:command];
            NSString *name = model.sendUser.name;
            NSString *msg = [NSString stringWithFormat:NSString.dt_room_pk_invitation_accept, name];
            DTAlertView *alert = [DTAlertView showTextAlert:msg sureText:NSString.dt_room_acceptance cancelText:NSString.dt_room_reject onSureCallback:^{
                weakSelf.isAccepting = NO;
                [weakSelf handleInvite:YES model:model];
            }                               onCloseCallback:^{
                weakSelf.isAccepting = NO;
                [weakSelf handleInvite:NO model:model];
            }];
            // 延迟关闭
            [self openAlertDelayClose:alert];
        }
            break;
        case CMD_ROOM_PK_ANSWER: {
            // 跨房PK邀请应答
            RoomCmdPKAckInviteModel *model = [RoomCmdPKAckInviteModel fromJSON:command];
            if (!model.isAccept) {
                NSLog(@"对方不同意");
                break;
            }

            // 更新对方信息
            if ([model.sendUser.roomID isEqualToString:self.roomID]) {
                // 本房房主通知：本房间为被邀请方
                self.otherUser = model.otherUser;
                // 将房间游戏房间调整为对方房间号
                [self updateGameRoomID:self.otherUser.roomID reloadGame:YES];
                DDLogDebug(@"CMD_ROOM_PK_ANSWER gameRoomID:%@, currentRoomID:%@", self.gameRoomID, self.roomID);
                [self.pkStateView changeRedInLeft:NO];
            } else {
                // 本房间为主动邀请方
                self.otherUser = model.sendUser;
                // 将房间游戏房间调整为自己房间号
                [self updateGameRoomID:self.roomID reloadGame:YES];
                // 对方应答了邀请，如果本方存在游戏，则发送切换游戏指令，让对方切换到当前游戏
                if ([AppService.shared.login.loginUserInfo isMeByUserID:model.otherUser.userID]) {
                    [kPKService sendCrossPKChangedGameMsg:self.otherUser.roomID gameID:self.gameId finished:nil];
                }
                [self.pkStateView changeRedInLeft:YES];
            }

            if (model.pkId.length > 0) {
                self.pkId = model.pkId.longLongValue;
            }

            [self.pkStateView updateRightUserInfo:self.otherUser];
        }
            break;
        case CMD_ROOM_PK_START: {
            // 开始跨房PK
            RoomCmdPKStartedModel *model = [RoomCmdPKStartedModel fromJSON:command];
            weakSelf.totalDuration = model.minuteDuration;
            if (model.pkId.length > 0) {
                weakSelf.pkId = model.pkId.longLongValue;
            }
            // 开始PK
            [weakSelf updatePKState:PKStateTypeIng];
        }
            break;
        case CMD_ROOM_PK_FINISH: {
            // 结束跨房PK
            RoomBaseCMDModel *model = [RoomBaseCMDModel fromJSON:command];
            [weakSelf removeOtherUser];
            if ([weakSelf.roomID isEqualToString:model.sendUser.roomID]) {
                // 本房主关闭，回到待开启状态
                [weakSelf updatePKState:PKStateTypeClosed];
            } else {
                // 对方房间结束,回到匹配中状态
                [weakSelf updatePKState:PKStateTypeOpened];
                [weakSelf showClosePKMsg];
            }
            // 关闭游戏
            if (weakSelf.gameId > 0) {
                // 结束游戏
                [weakSelf endGameIfIamCaptainWithFinished:^{
                    // 房主需要切换本房间游戏为切为空
                    if (weakSelf.isRoomOwner) {
                        [weakSelf reqChangeToGameGameId:0 operatorUser:AppService.shared.loginUserID];
                        return;
                    }
                }];
            } else {
                [weakSelf removeOtherUser];
            }

        }
            break;
        case CMD_ROOM_PK_SETTINGS: {
            // 跨房PK设置
            RoomCmdPKStartedModel *model = [RoomCmdPKStartedModel fromJSON:command];
            weakSelf.totalDuration = model.minuteDuration;
            // 如果开启了，PK，则更新PK时间
            if (weakSelf.pkState == PKStateTypeIng) {
                [weakSelf updatePKState:PKStateTypeIng];
            }
        }
            break;
        case CMD_ROOM_PK_OPEN_MATCH: {
            // 开启匹配跨房PK
            RoomBaseCMDModel *model = [RoomBaseCMDModel fromJSON:command];
            // 房主信息
            AudioUserModel *redUser = [[AudioUserModel alloc] init];
            redUser.name = model.sendUser.name;
            redUser.icon = model.sendUser.icon;
            [weakSelf.pkStateView updateLeftUserInfo:redUser];
            [weakSelf updatePKState:PKStateTypeOpened];
        }
            break;
        case CMD_ROOM_PK_CHANGE_GAME: {
            // 跨房PK，切换游戏
            // 房主收到跨房指令，同时切换游戏
            if (weakSelf.isRoomOwner) {
                RoomCmdChangeGameModel *m = [RoomCmdChangeGameModel fromJSON:command];
                [weakSelf reqChangeToGameGameId:m.gameID operatorUser:m.sendUser.userID];
            }
        }
            break;
        case CMD_ROOM_PK_GAME_SETTLE_NOTIFY: {
            // 跨房pk游戏结算消息
            RoomPKGameResultCMDModel *model = [RoomPKGameResultCMDModel fromJSON:command];
            NSInteger leftScore = 0;
            NSInteger rightScore = 0;
            AudioUserModel *leftUser = weakSelf.pkStateView.leftUserInfo;
            if (leftUser.roomID && leftUser.roomID.longLongValue == model.content.srcPkGameSettleInfo.roomId) {
                leftScore = model.content.srcPkGameSettleInfo.totalScore;
                rightScore = model.content.destPkGameSettleInfo.totalScore;
            } else {
                leftScore = model.content.destPkGameSettleInfo.totalScore;
                rightScore = model.content.srcPkGameSettleInfo.totalScore;
            }
            [weakSelf.pkStateView updateLeftScore:leftScore rightScore:rightScore];
            [weakSelf showScreenMsg:model];
        }
            break;
        case CMD_ROOM_PK_CLOSE_NOTIFY: {
            // 跨房pk对手房间关闭消息
            if (weakSelf.gameId > 0 && ![weakSelf.gameRoomID isEqualToString:self.roomID]) {
                // reload游戏
                [self updateGameRoomID:self.roomID reloadGame:YES];
            }
            [weakSelf removeOtherUser];
            [weakSelf updatePKState:PKStateTypeOpened];
            [weakSelf showClosePKMsg];
        }
            break;
        case CMD_ROOM_PK_REMOVE_RIVAL: {
            // 移除对手
            if (weakSelf.gameId > 0 && ![weakSelf.gameRoomID isEqualToString:self.roomID]) {
                // reload游戏
                [self updateGameRoomID:self.roomID reloadGame:YES];
            }
            [weakSelf removeOtherUser];
            [weakSelf updatePKState:PKStateTypeOpened];
        }
            break;
        default:
            break;
    }
}

/// 移除对手
- (void)removeOtherUser {
    self.otherUser = nil;
    [self updateGameRoomID:self.roomID reloadGame:NO];
}

- (BOOL)isReverseLan {
    NSString *lan = NSBundle.currentLanguage;
    // 倒装句
    if ([lan hasPrefix:@"ar"] || [lan hasPrefix:@"en"] || [lan hasPrefix:@"vi"] || [lan hasPrefix:@"th"] || [lan hasPrefix:@"ms"] || [lan hasPrefix:@"id"]) {
        return YES;
    }
    return NO;
}

- (void)showScreenMsg:(RoomPKGameResultCMDModel *)model {

    NSArray<RoomUserRankInfoModel *> *arrUserResult = model.content.userRankInfoList;
    for (int i = 0; i < arrUserResult.count; ++i) {
        RoomUserRankInfoModel *user = arrUserResult[i];

        NSString *teamName = model.content.srcPkGameSettleInfo.roomId == user.roomId ? NSString.dt_room_pk_red_team : NSString.dt_room_pk_blue_team;
        switch (user.rank) {
            case 1: {
                NSString *text = [NSString stringWithFormat:NSString.dt_win_first_tip, user.nickname, teamName, @(user.winScore)];
                if (self.isReverseLan) {
                    text = [NSString stringWithFormat:NSString.dt_win_first_tip, user.nickname, @(user.winScore), teamName];
                }
                [self addResultContent:text];
            }
                break;
            case 2: {
                NSString *text = [NSString stringWithFormat:NSString.dt_win_second_tip, user.nickname, teamName, @(user.winScore)];
                if (self.isReverseLan) {
                    text = [NSString stringWithFormat:NSString.dt_win_second_tip, user.nickname, @(user.winScore), teamName];
                }
                [self addResultContent:text];
            }
                break;
            case 3: {
                NSString *text = [NSString stringWithFormat:NSString.dt_win_third_tip, user.nickname, teamName, @(user.winScore)];
                if (self.isReverseLan) {
                    text = [NSString stringWithFormat:NSString.dt_win_third_tip, user.nickname, @(user.winScore), teamName];
                }
                [self addResultContent:text];
            }
                break;
        }
    }

}

- (void)addResultContent:(NSString *)content {
    if (content.length == 0) {
        return;
    }
    NSMutableAttributedString *attrMsg = [[NSMutableAttributedString alloc] initWithString:content];
    if (attrMsg.length > 0) {
        attrMsg.yy_lineSpacing = 6;
        attrMsg.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        attrMsg.yy_color = [UIColor dt_colorWithHexString:@"#FFD620" alpha:1];
        AudioMsgSystemModel *msgModel = [AudioMsgSystemModel makeMsgWithAttr:attrMsg];
        /// 公屏添加消息
        [self addMsg:msgModel isShowOnScreen:YES];
    }
}

/// 展示结束PK消息
- (void)showClosePKMsg {
    NSMutableAttributedString *attrMsg = [[NSMutableAttributedString alloc] initWithString:NSString.dt_room_pk_closed_msg];
    if (attrMsg.length > 0) {
        attrMsg.yy_lineSpacing = 6;
        attrMsg.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        attrMsg.yy_color = [UIColor dt_colorWithHexString:@"#ffffff" alpha:1];
        AudioMsgSystemModel *msgModel = [AudioMsgSystemModel makeMsgWithAttr:attrMsg];
        /// 公屏添加消息
        [self addMsg:msgModel isShowOnScreen:YES];
    }
}

/// 处理邀请
/// @param agree agree
/// @param model model
- (void)handleInvite:(BOOL)agree model:(RoomBaseCMDModel *)model {
    WeakSelf
    [self.delayCloseTimer stopTimer];
    self.delayCloseTimer = nil;
    if (agree) {
        if (model.sendUser.roomID.length == 0) {
            [ToastUtil show:NSString.dt_room_opposite_room_id_empty];
            return;
        }
        self.otherUser = model.sendUser;
        // 切换游戏房间ID到对方
        [self updateGameRoomID:model.sendUser.roomID reloadGame:YES];
        DDLogDebug(@"handleInvite gameRoomID:%@, currentRoomID:%@", self.gameRoomID, self.roomID);
        // 同意对方邀请，本房间为被邀请方（蓝方）
        [kPKService reqAgreePK:model.sendUser.roomID.longLongValue destRoomId:self.roomID.longLongValue finished:^(RespStartPKModel *resp) {
            weakSelf.pkId = resp.pkId;
            // 给对方房间用户
            [kPKService sendCrossAgreedPKInviteMsg:model.sendUser.roomID agress:agree pkId:resp.pkId otherUser:model.sendUser finished:nil];
            // 自己对方房间用户
            [kPKService sendAgreedPKInviteMsg:model.sendUser agress:YES pkId:resp.pkId];
            [weakSelf updateAgreePKStateInfo:model.sendUser];
        }];
        // 如果挂起了房间，展示出来
        if ([SuspendRoomView isShowSuspend]) {
            [SuspendRoomView enterSceneVC];
        }
    } else {
        // 拒绝
        [kPKService sendCrossAgreedPKInviteMsg:model.sendUser.roomID agress:agree pkId:0 otherUser:model.sendUser finished:nil];
    }
}

/// 更新接受PK后PK红方、蓝方用户状态信息
/// @param other
- (void)updateAgreePKStateInfo:(AudioUserModel *)other {
    AudioUserModel *my = [[AudioUserModel alloc] init];
    my.name = AppService.shared.login.loginUserInfo.name;
    my.icon = AppService.shared.login.loginUserInfo.icon;
    my.roomID = self.roomID;
    [self.pkStateView updateLeftUserInfo:my];
    [self.pkStateView updateRightUserInfo:other];
    [self.pkStateView changeRedInLeft:NO];
}

/// 开启弹窗延迟消失
- (void)openAlertDelayClose:(DTAlertView *)alert {

    if (self.delayCloseTimer) {
        [self.delayCloseTimer stopTimer];
    }
    WeakSelf
    // 延迟8秒关闭
    self.delayCloseCountdown = 8;

    DTTextAlertView *textAlert = (DTTextAlertView *) alert.customView;
    __weak DTTextAlertView *weakTextAlert = textAlert;
    NSString *cancelText = [NSString stringWithFormat:@"%@(%ld)", NSString.dt_room_reject, weakSelf.delayCloseCountdown];
    [weakTextAlert.cancelBtn setTitle:cancelText forState:UIControlStateNormal];
    self.delayCloseTimer = [DTTimer timerWithTimeInterval:1 repeats:YES block:^(DTTimer *timer) {
        weakSelf.delayCloseCountdown--;
        if (weakSelf.delayCloseCountdown <= 0) {
            weakSelf.isAccepting = NO;
            [weakSelf.delayCloseTimer stopTimer];
            weakSelf.delayCloseTimer = nil;
            [DTAlertView close];
            return;
        }
        NSString *cancelText = [NSString stringWithFormat:@"%@(%ld)", NSString.dt_room_reject, weakSelf.delayCloseCountdown];
        [weakTextAlert.cancelBtn setTitle:cancelText forState:UIControlStateNormal];

    }];

}

/// 获取游戏View信息  【需要实现】
- (void)onGetGameViewInfo:(nonnull id <ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    CGFloat scale = [[UIScreen mainScreen] nativeScale];
    GameViewInfoModel *m = [[GameViewInfoModel alloc] init];
    GameViewSize *viewSize = [[GameViewSize alloc] init];
    viewSize.width = kScreenWidth * scale;
    viewSize.height = kScreenHeight * scale;
    ViewGameRect *viewRect = [[ViewGameRect alloc] init];
    viewRect.top = (kStatusBarHeight + 170) * scale;
    viewRect.left = 0;
    viewRect.bottom = (kAppSafeBottom + 150) * scale;
    viewRect.right = 0;
    m.ret_code = 0;
    m.ret_msg = @"success";
    m.view_size = viewSize;
    m.view_game_rect = viewRect;
    [handle success:m.mj_JSONString];
}

/// 获取游戏Config  【需要实现】
- (NSString *)onGetGameCfg {

    GameCfgModel *m = [GameCfgModel defaultCfgModel];
    m.ui.nft_avatar.hide = NO;
    m.ui.game_opening.hide = NO;
    m.ui.game_mvp.hide = NO;
    m.ui.lobby_players.hide = NO;
    m.ui.start_btn.custom = YES;
    m.ui.lobby_game_setting.hide = YES;

    return [m mj_JSONString];
}

/// 游戏: 开始游戏按钮点击状态   MG_COMMON_SELF_CLICK_START_BTN
- (void)onGameMGCommonSelfClickStartBtn {
    NSDictionary *dic = @{@"pkId": @(self.pkId), @"sceneId": @(self.configModel.enterRoomModel.sceneType)};
    [self.sudFSTAPPDecorator notifyAppComonSelfPlaying:true reportGameInfoExtras:dic.mj_JSONString];
}
@end
