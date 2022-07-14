//
//  DiscoDancingRoomViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/24.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoRoomViewController.h"
#import "DiscoNaviRankView.h"
#import "DiscoRankPopView.h"
#import "DiscoMenuView.h"
#import "DiscoPopMenuListView.h"
#import "DiscoRankTipView.h"
#import "SudMGPAPPState.h"

static NSString *discoKeyWordsMove = @"移动";
static NSString *discoKeyWordsUp = @"上天";
static NSString *discoKeyWordsSwitchRole = @"换角色";
static NSString *discoKeyWordsJoinWork = @"上班";
static NSString *discoKeyWordsLeaveWork = @"下班";
static NSString *discoKeyWordsFocus = @"聚焦";

@interface DiscoRoomViewController ()
@property(nonatomic, strong) BaseView *settingView;
@property(nonatomic, strong) MarqueeLabel *settingLabel;
@property(nonatomic, strong) MarqueeLabel *tipLabel;
@property(nonatomic, strong) UIView *tipView;
@property(nonatomic, strong) YYLabel *tipOpenLabel;
@property(nonatomic, strong) DiscoNaviRankView *rankView;
@property(nonatomic, strong) DiscoMenuView *menuView;
@property(nonatomic, strong) DiscoRankTipView *rankTipView;
/// 同步蹦迪信息用户ID
@property(nonatomic, strong) NSString *syncDiscoInfoUserID;
@property(nonatomic, assign) BOOL syncEnd;
@property(nonatomic, assign) BOOL isTipOpened;
@property(nonatomic, assign) NSInteger djCountdown;
@property(nonatomic, assign) DTTimer *djRandTimer;
@property(nonatomic, assign) BOOL loadedRobotList;
@end

@implementation DiscoRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.naviView hiddenNodeWithRoleType:0];
    [self updateSettingState:self.gameId > 0];
    // 跳过游戏状态监听
    for (AudioMicroView *v in self.gameMicContentView.micArr) {
        v.skipGameState = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self beginScrollTip];
}

- (Class)serviceClass {
    return DiscoRoomService.class;
}

- (void)setConfigModel:(BaseSceneConfigModel *)configModel {
    [super setConfigModel:configModel];
    // 非房主不展示开关按钮
    if (!self.isRoomOwner) {
        self.settingView.hidden = YES;
    }
}

/// 是否需要自动上麦
- (BOOL)isNeedAutoUpMic {
    return NO;
}

/// 是否需要加载场景礼物
- (BOOL)isNeedToLoadSceneGiftList {
    return YES;
}

/// 是否是追加方式
- (BOOL)isAppendSceneGiftList {
    return YES;
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.naviView addSubview:self.rankView];
    [self.naviView addSubview:self.settingView];
    [self.settingView addSubview:self.settingLabel];
    [self.sceneView addSubview:self.menuView];
    [self.sceneView addSubview:self.tipView];
    [self.tipView addSubview:self.tipLabel];
    [self.tipView addSubview:self.tipOpenLabel];
    [self.sceneView addSubview:self.rankTipView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.rankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.naviView.roomModeView);
        make.centerY.equalTo(self.naviView.roomModeView);
        make.height.greaterThanOrEqualTo(@0);
        make.width.greaterThanOrEqualTo(@0);
    }];
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rankView);
        make.height.equalTo(@20);
        make.width.mas_greaterThanOrEqualTo(56);
        make.trailing.equalTo(self.rankView.mas_leading).offset(-10);
        make.leading.greaterThanOrEqualTo(self.naviView.onlineImageView.mas_trailing).offset(10);
    }];
    [self.settingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@8);
        make.trailing.equalTo(@(-8));
        make.centerY.equalTo(self.settingView);
        make.height.mas_greaterThanOrEqualTo(0);
        make.width.mas_lessThanOrEqualTo(@66);
    }];
    CGFloat b = kAppSafeBottom + 93;
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-9);
        make.bottom.equalTo(@(-b));
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.rankTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.menuView).offset(-7);
        make.bottom.equalTo(self.menuView.mas_top);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gameMicContentView.mas_bottom).offset(15);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.equalTo(@24);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(@0);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@24);
    }];
    [self.tipOpenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@5);
        make.top.trailing.bottom.equalTo(@0);
    }];

}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSettingTap:)];
    [self.settingView addGestureRecognizer:tap];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRankViewTap:)];
    [self.rankView addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMenuViewTap:)];
    [self.menuView addGestureRecognizer:tap3];

    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTipLabelTap:)];
    [self.tipView addGestureRecognizer:tap4];

    [[NSNotificationCenter defaultCenter] addObserverForName:showWaitingForDancingNTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
        weakSelf.rankTipView.hidden = NO;
        [weakSelf.rankTipView show:^{
            weakSelf.rankTipView.hidden = YES;
        }];
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.djCountdown = 60 - (int64_t) [NSDate date].timeIntervalSince1970 % 60;
    [self updateTipLabel];
    [self.tipLabel restartLabel];
    WeakSelf
    self.djRandTimer = [DTTimer timerWithTimeInterval:1 repeats:YES block:^(DTTimer *timer) {
        [weakSelf handleDJTimerCallback];
    }];
    self.gameNumLabel.alpha = 0;
}

- (void)onTipLabelTap:(id)tap {

    self.isTipOpened = !self.isTipOpened;
    if (self.isTipOpened) {
        self.tipOpenLabel.hidden = NO;
        self.tipLabel.hidden = YES;
        [self.tipView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gameMicContentView.mas_bottom).offset(10);
            make.leading.equalTo(@16);
            make.trailing.equalTo(@-16);
            make.height.equalTo(@112);
        }];
    } else {
        self.tipOpenLabel.hidden = YES;
        self.tipLabel.hidden = NO;
        [self.tipView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gameMicContentView.mas_bottom).offset(10);
            make.leading.equalTo(@16);
            make.trailing.equalTo(@-16);
            make.height.equalTo(@24);
        }];
    }

}

/// 点击跳舞菜单
- (void)onMenuViewTap:(UITapGestureRecognizer *)tap {
    DiscoPopMenuListView *v = [[DiscoPopMenuListView alloc] init];
    [DTSheetView show:v onCloseCallback:nil];
}

/// 点击排行榜
- (void)onRankViewTap:(UITapGestureRecognizer *)tap {
    DiscoRankPopView *v = [[DiscoRankPopView alloc] init];
    [DTSheetView show:v onCloseCallback:nil];
}

/// 点击PK设置
- (void)onSettingTap:(UITapGestureRecognizer *)tap {
    if (self.gameId > 0) {
        NSString *tip = @"确定要关闭蹦迪吗？ 关闭后本场蹦迪将清空，包括正在进行中的跳舞、排队中的跳舞、角色特效";
        [DTAlertView showTextAlert:tip sureText:@"关闭" cancelText:@"返回" onSureCallback:^{
            [kDiscoRoomService clearAllDancingMenu];
            [self reqChangeToGameGameId:0 operatorUser:AppService.shared.login.loginUserInfo.userID];
            [self updateSettingState:NO];
        }          onCloseCallback:nil];

    } else {
        [self reqChangeToGameGameId:[self getCurrentGameID] operatorUser:AppService.shared.login.loginUserInfo.userID];
        [self updateSettingState:YES];
    }
}

- (int64_t)getCurrentGameID {
    NSArray <HSGameItem *> *dataArr = AppService.shared.gameList;
    for (HSGameItem *item in dataArr) {
        for (NSNumber *scene in item.suitScene) {
            if ([scene integerValue] == self.configModel.enterRoomModel.sceneType) {
                return item.gameId;
            }
        }
    }
    return 0;
}

- (void)updateSettingState:(BOOL)isGameExist {
    if (isGameExist) {
        self.settingLabel.text = @"关闭蹦迪";
        [self.settingView dtRemoveGradient];
    } else {
        self.settingLabel.text = @"开启蹦迪";
        [self.settingView dtAddGradientLayer:@[@0, @0.25, @0.35, @0.5, @0.7, @0.85, @1]
                                      colors:@[(id) HEX_COLOR(@"#F40ADE").CGColor,
                                              (id) HEX_COLOR(@"#E02020").CGColor,
                                              (id) HEX_COLOR(@"#FA6400").CGColor,
                                              (id) HEX_COLOR(@"#EBAC00").CGColor,
                                              (id) HEX_COLOR(@"#6DD400").CGColor,
                                              (id) HEX_COLOR(@"#0091FF").CGColor,
                                              (id) HEX_COLOR(@"#6236FF").CGColor]
                                  startPoint:CGPointMake(0, 0.5)
                                    endPoint:CGPointMake(1, 0.5)
                                cornerRadius:0];
    }
}

/// 处理礼物动效
/// @param model model description
- (void)handleGiftEffect:(RoomCmdSendGiftModel *)model {
    [super handleGiftEffect:model];
    [kDiscoRoomService handleUserSentGift:model];
}

- (void)roomGameDidChanged:(NSInteger)gameID {
    [super roomGameDidChanged:gameID];
    self.menuView.hidden = gameID == 0;
    self.tipView.hidden = gameID == 0;
}

- (void)beginScrollTip {

    CABasicAnimation *moveLeft = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    // 设置运动形式
    [moveLeft setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    // 设置开始位置
    moveLeft.fromValue = @(self.tipView.bounds.size.width);
    moveLeft.toValue = @(-self.tipLabel.bounds.size.width);
    moveLeft.removedOnCompletion = NO;
    moveLeft.duration = 25;
    moveLeft.repeatCount = 1000000;
    moveLeft.fillMode = kCAFillModeForwards;
    [self.tipLabel.layer addAnimation:moveLeft forKey:@"moveLeft"];
    self.tipView.alpha = 1;
}

/// 处理机器人上麦逻辑
- (void)loadRobotList {

    if (!self.enterModel.isFromCreate) {
        return;
    }
    if (self.enterModel.roleType != 1) {
        DDLogDebug(@"you not the room owner, don't need load robot");
        return;
    }
    if (self.loadedRobotList) {
        DDLogDebug(@"had loaded robot list");
        return;
    }
    WeakSelf
    [DiscoRoomService reqRobotListWithFinished:^(NSArray<RotbotInfoModel *> *robotList) {
        [weakSelf handleRobotUpMic:robotList];

    }                                  failure:^(NSError *_Nonnull error) {
        DDLogError(@"load robot list err:%@", error.dt_errMsg);
    }];
}

/// 处理机器人上麦逻辑
- (void)handleRobotUpMic:(NSArray<RotbotInfoModel *> *)robotList {

    self.loadedRobotList = YES;
    NSMutableArray *aiPlayers = [[NSMutableArray alloc] init];
    for (int i = 0; i < robotList.count; ++i) {
        RotbotInfoModel *robotModel = robotList[i];
        /// 前6位机器人自动上麦
        if (i < 6) {
            [self joinTheRobotToMic:robotModel];
        }
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

}

- (void)joinTheRobotToMic:(RotbotInfoModel *)robotModel {

    AudioRoomMicModel *micModel = [self getOneEmptyMic];
    if (micModel == nil) {
        [ToastUtil show:NSString.dt_room_there_no_mic];
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
        micModel.user = proxyUser;
        [kAudioRoomService reqSwitchMic:self.roomID.integerValue micIndex:(int) micModel.micIndex handleType:0 proxyUser:proxyUser success:nil fail:nil];
        return;
    }
}

#pragma game

/// 处理游戏开始d
- (void)handleGameStared {
    [super handleGameStared];
    // 延迟1秒加入舞池，目前游戏直接加入有问题，待游戏解决
    [HSThreadUtils dispatchMainAfter:1 callback:^{
        [self loadRobotList];
        [kDiscoRoomService joinDancePool:nil];
        // 单对多模式
        [kDiscoRoomService setDanceMode:@"1"];
    }];
}

- (void)handleBusyCommand:(NSInteger)cmd command:(NSString *)command {
    switch (cmd) {
        case CMD_ROOM_DISCO_INFO_REQ:
            // 请求蹦迪信息
            [self handleIfNeedToRespDiscoInfo];
            break;
        case CMD_ROOM_DISCO_INFO_RESP: {
            // 响应蹦迪信息
            RespDiscoInfoModel *model = [RespDiscoInfoModel fromJSON:command];
            [self handleDiscoInfoResp:model];
        }

            break;
        case CMD_ROOM_DISCO_BECOME_DJ: {
            // 上DJ台
            RespDiscoBecomeDJModel *model = [RespDiscoBecomeDJModel fromJSON:command];
            [self handleUpDJ:model];
        }
            break;
        default:
            [super handleBusyCommand:cmd command:command];
            break;
    }
}

/// 检测自己是否是麦位第一位用户
- (BOOL)checkIsFirstMicUser {
    NSArray<AudioMicroView *> *micViewList = self.gameMicContentView.micArr;
    BOOL isExistUser = NO;
    for (int i = 0; i < micViewList.count; ++i) {
        // 跳过机器人，前6默认添加机器人
        if (i >= 6) {
            AudioMicroView *view = micViewList[i];
            AudioRoomMicModel *m = view.model;
            if (!m || !m.user) {
                continue;
            }
            if ([m.user.userID isEqualToString:AppService.shared.login.loginUserInfo.userID] && !isExistUser) {
                return YES;
            }
            isExistUser = YES;
        }
    }
    return NO;
}

/// 处理是否需要响应该消息
- (void)handleIfNeedToRespDiscoInfo {

    // 响应数据给请求者
    // 贡献榜数据
    NSArray *rankArr = kDiscoRoomService.rankList;
    for (int i = 0; i < rankArr.count; ++i) {
        RespDiscoInfoModel *resp = [[RespDiscoInfoModel alloc] init];
        [resp configBaseInfoWithCmd:CMD_ROOM_DISCO_INFO_RESP];
        resp.contribution = @[rankArr[i]];
        [self sendMsg:resp isAddToShow:NO finished:nil];
    }
    NSMutableArray *waitSendList = [[NSMutableArray alloc] init];
    [waitSendList addObjectsFromArray:kDiscoRoomService.danceMenuList];
    [waitSendList addObjectsFromArray:kDiscoRoomService.finishedDanceMenuList];
    [self queueSendMenu:waitSendList];
}

/// 顺序发送舞池列表
/// @param arr
- (void)queueSendMenu:(NSMutableArray *)arr {
    WeakSelf
    if (arr.count > 0) {
        RespDiscoInfoModel *resp = [[RespDiscoInfoModel alloc] init];
        [resp configBaseInfoWithCmd:CMD_ROOM_DISCO_INFO_RESP];
        DiscoMenuModel *item = [arr firstObject];
        [arr removeObjectAtIndex:0];
        resp.dancingMenu = @[item];
        [self sendMsg:resp isAddToShow:NO finished:^(int errCode) {
            [weakSelf queueSendMenu:arr];
        }];
    } else {
        // 告知结束
        RespDiscoInfoModel *resp = [[RespDiscoInfoModel alloc] init];
        [resp configBaseInfoWithCmd:CMD_ROOM_DISCO_INFO_RESP];
        resp.isEnd = YES;
        [HSThreadUtils dispatchMainAfter:0.1 callback:^{
            [self sendMsg:resp isAddToShow:NO finished:nil];
        }];
    }
}

/// 处理蹦迪信息响应
- (void)handleDiscoInfoResp:(RespDiscoInfoModel *)resp {

    // 如果同步者非首次同步，忽略他的信息，只接受首次同步者信息
    if (self.syncDiscoInfoUserID && ![self.syncDiscoInfoUserID isEqualToString:resp.sendUser.userID]) {
        DDLogDebug(@"sync data end syncDiscoInfoUserID:%@, resp.sendUser.userID:%@", self.syncDiscoInfoUserID, resp.sendUser.userID);
        return;
    }
    if (self.syncEnd) {
        DDLogDebug(@"sync data end");
        return;
    }
    if (!self.syncDiscoInfoUserID) {
        self.syncDiscoInfoUserID = resp.sendUser.userID;
    }
    if (resp.dancingMenu.count > 0) {
        for (int i = 0; i < resp.dancingMenu.count; ++i) {
            [kDiscoRoomService addDanceMenuInfo:resp.dancingMenu[i]];
        }
    }
    if (resp.contribution.count > 0) {
        for (int i = 0; i < resp.contribution.count; ++i) {
            [kDiscoRoomService addRankInfo:resp.contribution[i]];
        }
    }
    if (resp.isEnd) {
        // 同步结束
        self.syncEnd = YES;
        [kDiscoRoomService handleFinishedSyncDataInfo];
    }
    [self updateNaviHeadIcon];
}

/// 展示公屏消息
/// @param msg 消息体
/// @param isShowOnScreen 是否展示公屏
- (void)addMsg:(RoomBaseCMDModel *)msg isShowOnScreen:(BOOL)isShowOnScreen {
    [super addMsg:msg isShowOnScreen:isShowOnScreen];
    [self handleRankInfo:msg];
}

/// 处理排行榜数据
- (void)handleRankInfo:(RoomBaseCMDModel *)msg {

    if (msg.cmd == CMD_CHAT_TEXT_NOTIFY) {
        // 公屏消息+1
        [kDiscoRoomService addRankCount:msg.sendUser count:1];
        [self updateNaviHeadIcon];
    } else if (msg.cmd == CMD_SEND_GIFT_NOTIFY) {
        RoomCmdSendGiftModel *m = (RoomCmdSendGiftModel *) msg;
        [kDiscoRoomService addRankCount:msg.sendUser count:m.getGiftModel.price];
        [self updateNaviHeadIcon];
    }
}

/// 更新导航排行榜头像
- (void)updateNaviHeadIcon {
    NSMutableArray *arrList = [[NSMutableArray alloc] init];
    NSArray<DiscoContributionModel *> *arr = kDiscoRoomService.rankList;
    for (int i = 0; i < 3; ++i) {
        if (arr.count > i) {
            [arrList addObject:arr[i].fromUser.icon];
        }
    }
    self.rankView.iconList = arrList.copy;
    [self.rankView dtUpdateUI];
}

- (void)onWillSendMsg:(RoomBaseCMDModel *)msg shouldSend:(void (^)(BOOL))shouldSend {
    /// Game - 发送文本命中
    if ([msg isKindOfClass:RoomCmdChatTextModel.class]) {
        RoomCmdChatTextModel *m = (RoomCmdChatTextModel *) msg;
        [self handleMsgContent:m.content];
    } else if ([msg isKindOfClass:RoomCmdUpMicModel.class] && msg.cmd == CMD_UP_MIC_NOTIFY) {
        if ([self checkIfCanJoin]) {
            [kDiscoRoomService joinAnchorField1:nil field2:msg.sendUser.isRobot ? msg.sendUser.userID : nil];
        }
    } else if ([msg isKindOfClass:RoomCmdSendGiftModel.class]) {
        RoomCmdSendGiftModel *m = (RoomCmdSendGiftModel *) msg;
        [self handleGiftMsg:m];
    } else if (msg.cmd == CMD_ENTER_ROOM_NOTIFY) {
        // 首次进入房间
        [self sendCmdToGetDiscoInfo];
    } else if (msg.cmd == CMD_ROOM_DISCO_BECOME_DJ) {
        // 上DJ台
        RespDiscoBecomeDJModel *model = (RespDiscoBecomeDJModel *) msg;
        [self handleUpDJ:model];
    }
    return [super onWillSendMsg:msg shouldSend:shouldSend];

}

/// 处理上DJ
- (void)handleUpDJ:(RespDiscoBecomeDJModel *)model {
    if ([AppService.shared.login.loginUserInfo isMeByUserID:model.userID]) {
        [kDiscoRoomService upToDJ:180];
    }
}


- (void)sendCmdToGetDiscoInfo {
    RoomBaseCMDModel *m = [RoomBaseCMDModel alloc];
    [m configBaseInfoWithCmd:CMD_ROOM_DISCO_INFO_REQ];
    [self sendMsg:m isAddToShow:NO finished:nil];
}

- (void)handleGiftMsg:(RoomCmdSendGiftModel *)m {
    switch (m.giftID) {
        case 1: {
            // 礼物价格1
            NSString *content = [NSString stringWithFormat:@"我送了一个【%@】", m.giftName];
            [kDiscoRoomService showMsgPop:3 field1:content];
        }
            break;
        case 2: {
            // 礼物价格100
            NSString *content = [NSString stringWithFormat:@"我送了一个【%@】", m.giftName];
            [kDiscoRoomService showMsgPop:3 field1:content];
            // 特写镜头
            [kDiscoRoomService specialRole:3 isTop:NO];
        }
            break;
        case 3: {
            // 礼物价格1000
            NSString *content = [NSString stringWithFormat:@"我送了一个【%@】", m.giftName];
            [kDiscoRoomService showMsgPop:6 field1:content];
            // 特写镜头
            [kDiscoRoomService specialRole:3 isTop:NO];
            // 角色放大
            [kDiscoRoomService scaleBiggerRole:30 field1:@"2"];
        }
            break;
        case 4: {
            // 礼物价格10000
            NSString *content = [NSString stringWithFormat:@"我送了一个【%@】", m.giftName];
            [kDiscoRoomService showMsgPop:9 field1:content];
            // 特写镜头
            [kDiscoRoomService specialRole:5 isTop:NO];
            // 角色特效
            [kDiscoRoomService switchEffectRole:2 * 60 * 60 field1:nil];
            // 角色放大
            [kDiscoRoomService scaleBiggerRole:60 field1:@"2"];
        }
            break;
        default:
            break;
    }
}

/// 处理消息内容, 响应游戏指令
- (void)handleMsgContent:(NSString *)content {

    if ([discoKeyWordsJoinWork isEqualToString:content]) {
        // 加入主播位
        if ([self isInMic]) {
            if ([self checkIfCanJoin]) {
                [kDiscoRoomService joinAnchorField1:nil field2:nil];
            }
        }
    } else if ([discoKeyWordsMove isEqualToString:content]) {
        // 移动
        [kDiscoRoomService movePosition:10 field1:nil];
    } else if ([discoKeyWordsLeaveWork isEqualToString:content]) {
        // 离开主播位
        [kDiscoRoomService leaveAnchorPositionWithPlayerId:AppService.shared.loginUserID];
    } else if ([discoKeyWordsUp isEqualToString:content]) {
        // 上天
        [kDiscoRoomService flySky:3];
    } else if ([discoKeyWordsSwitchRole isEqualToString:content]) {
        // 切换角色
        [kDiscoRoomService switchRole:nil];
    } else if ([discoKeyWordsFocus isEqualToString:content]) {
        // 聚焦
        if ([self isInMic]) {
            [kDiscoRoomService specialRole:4 isTop:false];
        }
    }

}

/// 检测是否满足主播位，不满足则提示错误
/// @return
- (BOOL)checkIfCanJoin {
//    if (self.currentMicCount > 8) {
//        [ToastUtil show:@"最多同时8个主播上台"];
//        return NO;
//    }
    return YES;
}

/// 当前麦位总数
/// @return
- (NSInteger)currentMicCount {
    NSInteger count = 0;
    NSArray *micArr = self.dicMicModel.allValues;
    for (AudioRoomMicModel *m in micArr) {
        if (m.user) {
            count++;
        }
    }
    return count;
}

- (void)updateTipLabel {
    self.tipOpenLabel.attributedText = [self createTip:YES];
    self.tipLabel.attributedText = [self createTip:NO];
}

/// 处理DJ随机上台
- (void)handleDJTimerCallback {
    self.djCountdown--;
    if (self.djCountdown <= 0) {
        self.djCountdown = 60;
        [self checkUpToDJ];
    }
    [self updateTipLabel];
}

- (void)checkUpToDJ {

    if (![self checkIsFirstMicUser]) {
        DDLogDebug(@"handleDJTimerCallback, but not in the first mic,so skip");
        return;
    }
    NSMutableArray *randUserList = [[NSMutableArray alloc] init];
    NSArray *rankList = kDiscoRoomService.rankList;
    for (int i = 0; i < 5; ++i) {
        if (rankList.count > i) {
            DiscoContributionModel *m = rankList[i];
            if (m.fromUser.userID) {
                [randUserList addObject:m.fromUser.userID];
            }
        }
    }
    NSString *userID = nil;
    if (randUserList.count > 0) {
        NSInteger randIndex = arc4random() % randUserList.count;
        userID = randUserList[randIndex];
    }
    if (!userID) {
        DDLogDebug(@"up dj user id is empty, randUserList count:%@", @(randUserList.count));
        return;
    }
    RespDiscoBecomeDJModel *djModel = [[RespDiscoBecomeDJModel alloc] init];
    [djModel configBaseInfoWithCmd:CMD_ROOM_DISCO_BECOME_DJ];
    djModel.userID = userID;
    [self sendMsg:djModel isAddToShow:NO finished:nil];
    DDLogDebug(@"send the up dj cmd to all, up dj id is:%@", userID);
}

#pragma mark lazy

- (DiscoNaviRankView *)rankView {
    if (!_rankView) {
        _rankView = [[DiscoNaviRankView alloc] init];
    }
    return _rankView;
}

- (DiscoMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[DiscoMenuView alloc] init];
    }
    return _menuView;
}

- (DiscoRankTipView *)rankTipView {
    if (!_rankTipView) {
        _rankTipView = [[DiscoRankTipView alloc] init];
        _rankTipView.hidden = YES;
    }
    return _rankTipView;
}

- (BaseView *)settingView {
    if (!_settingView) {
        _settingView = [[BaseView alloc] init];
        _settingView.backgroundColor = HEX_COLOR_A(@"#FFFFFF", 0.2);
    }
    return _settingView;
}

- (NSMutableAttributedString *)createTip:(BOOL)isMoreLines {

    NSString *key1 = NSString.dt_room_disco_keyword_top_five;
    NSString *key2 = NSString.dt_room_disco_keyword_move;
    NSString *key3 = NSString.dt_room_disco_keyword_up_sky;
    NSString *key4 = NSString.dt_room_disco_keyword_witch_role;
    NSString *key5 = NSString.dt_room_disco_keyword_work;
    NSString *key6 = NSString.dt_room_disco_keyword_unwork;
    NSString *key7 = NSString.dt_room_disco_keyword_focus;

    NSString *tip1 = [NSString stringWithFormat:NSString.dt_room_disco_tip_one_fmt, key1, @(self.djCountdown)];
    NSString *tip2 = NSString.dt_room_disco_tip_two_fmt;
    NSString *tip3 = [NSString stringWithFormat:NSString.dt_room_disco_tip_three_fmt, key2, key3, key4];
    NSString *tip4 = [NSString stringWithFormat:NSString.dt_room_disco_tip_four_fmt, key5, key6];
    NSString *tip5 = [NSString stringWithFormat:NSString.dt_room_disco_tip_five_fmt, key7];
    if (isMoreLines) {
        tip1 = [NSString stringWithFormat:@"%@\n", tip1];
        tip2 = [NSString stringWithFormat:@"%@\n", tip2];
        tip3 = [NSString stringWithFormat:@"%@\n", tip3];
        tip4 = [NSString stringWithFormat:@"%@\n", tip4];
    }
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] init];
    [attrTitle appendAttributedString:[self createYYAttr:tip1 hilightStr:@[key1]]];
    [attrTitle appendAttributedString:[self createYYAttr:tip2 hilightStr:nil]];
    [attrTitle appendAttributedString:[self createYYAttr:tip3 hilightStr:@[key2, key3, key4]]];
    [attrTitle appendAttributedString:[self createYYAttr:tip4 hilightStr:@[key5, key6]]];
    [attrTitle appendAttributedString:[self createYYAttr:tip5 hilightStr:@[key7]]];
    return attrTitle;
}

- (MarqueeLabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[MarqueeLabel alloc] init];
        _tipLabel.textColor = UIColor.whiteColor;
        _tipLabel.font = UIFONT_REGULAR(12);
        _tipLabel.numberOfLines = 0;
        _tipLabel.scrollDuration = 30;
        _tipLabel.forceScrolling = YES;

    }
    return _tipLabel;
}


- (YYLabel *)tipOpenLabel {
    if (!_tipOpenLabel) {
        _tipOpenLabel = [[YYLabel alloc] init];
        _tipOpenLabel.textColor = UIColor.whiteColor;
        _tipOpenLabel.font = UIFONT_REGULAR(12);
        _tipOpenLabel.hidden = YES;
        _tipOpenLabel.numberOfLines = 0;
        _tipOpenLabel.attributedText = [self createTip:YES];;
    }
    return _tipOpenLabel;
}

- (NSMutableAttributedString *)createYYAttr:(NSString *)str hilightStr:(NSArray<NSString *> *)hilightStrList {
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:str];
    attrTitle.yy_lineSpacing = 5;
    attrTitle.yy_font = UIFONT_REGULAR(12);
    attrTitle.yy_color = HEX_COLOR_A(@"#ffffff", 0.9);
    for (int i = 0; i < hilightStrList.count; ++i) {
        [attrTitle yy_setAttribute:NSForegroundColorAttributeName value:HEX_COLOR(@"#FFD731") range:[str rangeOfString:hilightStrList[i]]];
    }
    return attrTitle;
}

- (UIView *)tipView {
    if (!_tipView) {
        _tipView = [[UIView alloc] init];
        _tipView.backgroundColor = HEX_COLOR_A(@"#000000", 0.8);
        _tipView.clipsToBounds = YES;
        _tipView.alpha = 0;
    }
    return _tipView;
}

- (MarqueeLabel *)settingLabel {
    if (!_settingLabel) {
        _settingLabel = [[UILabel alloc] init];
        _settingLabel.textColor = UIColor.whiteColor;
        _settingLabel.font = UIFONT_BOLD(12);
        _settingLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _settingLabel;
}

@end
