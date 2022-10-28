//
//  OrderentertainmentViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/18.
//

#import "OrderentertainmentViewController.h"
#import "OrderChooseView.h"
#import "SuspendRoomView.h"

// 用户当前点单状态
typedef NS_ENUM(NSInteger, OrderUserStateType) {
    OrderUserStateTypeNormal = 0, // 普通状态
    OrderUserStateTypeInvited = 1, // 主动邀请者
    OrderUserStateTypeAccempted = 2 // 接受邀请者
};

@interface OrderentertainmentViewController ()
/// 点单场景 
@property (nonatomic, strong) BaseView *wantOrderView;
@property (nonatomic, strong) MarqueeLabel *wantOrderLabel;
@property (nonatomic, strong) MarqueeLabel *gameStateLabel;
/// 点单游戏的用户ID
@property (nonatomic, copy) NSString *toGameUserId;

/// 用户当前点单状态
@property (nonatomic, assign) OrderUserStateType userOrderState;
@end

@implementation OrderentertainmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self handleRoomChange:self.roomType];
    
    if (self.gameId > 0) {
        self.orderStateType = OrderStateTypeGame;
    } else {
        self.orderStateType = OrderStateTypeWait;
    }
}

- (BOOL)showSudMGPLoadingGameBackground {
    return NO;
}

/// isInMic 为YES的情况下是否自动加入游戏，默认 YES,子场景可以根据需要返回
- (BOOL)isAutoJoinGame {
    // 点单场景不要自动上麦
    return self.userOrderState == OrderUserStateTypeInvited || self.userOrderState == OrderUserStateTypeAccempted;
}

- (void)dtAddViews {
    [super dtAddViews];
    
    [self.naviView addSubview:self.wantOrderView];
    [self.naviView addSubview:self.gameStateLabel];
    [self.wantOrderView addSubview:self.wantOrderLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    
    [self.wantOrderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.naviView.roomModeView.mas_leading).offset(-8);
        make.centerY.mas_equalTo(self.naviView.roomModeView);
        make.size.mas_equalTo(CGSizeMake(66, 20));
    }];
    [self.wantOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.wantOrderView);
    }];
    [self.gameStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.naviView.roomModeView.mas_leading).offset(-8);
        make.centerY.mas_equalTo(self.naviView.roomModeView);
        make.size.mas_equalTo(CGSizeMake(66, 20));
    }];
}

- (BOOL)showAudioMic {
    return self.gameId > 0;
}

#pragma mark - Handle

- (void)handleRoomChange:(RoomType)roomType {
    [super handleRoomChange:roomType];
    if (self.gameId > 0) {
        self.orderStateType = OrderStateTypeGame;
    } else {
        self.orderStateType = OrderStateTypeWait;
    }
    [self dtUpdateUI];
}

- (void)roomGameDidChanged:(NSInteger)gameID {
    [super roomGameDidChanged:gameID];
    if (gameID == 0) {
        self.isShowEndGame = NO;
    }
}

/// 处理点单状态改变
- (void)handleOrderStateTypeChange {
    self.isGameForbiddenVoice = NO;
    switch (self.orderStateType) {
        case OrderStateTypeWait:
            [self.wantOrderView setHidden:false];
            [self.gameStateLabel setHidden:true];
            self.roomType = HSAudio;
            self.gameId = 0;
            [self logoutGame];
            [self.sudFSMMGDecorator clearAllStates];
            break;
        case OrderStateTypeGame:
            [self.wantOrderView setHidden:true];
            [self.gameStateLabel setHidden:false];
            self.gameStateLabel.text = NSString.dt_room_suspend_game;
            break;
        case OrderStateTypeHangup:
            [self.wantOrderView setHidden:true];
            [self.gameStateLabel setHidden:false];
            self.gameStateLabel.text = NSString.dt_room_enter_game;
            break;
    }
    
    [super dtUpdateUI];
}

- (BOOL)isShowAudioContent {
    return self.orderStateType != OrderStateTypeGame;
}

- (BOOL)isShowGameMic {
    return false;
}

#pragma mark =======SudFSMMGListener=======

/// 获取游戏View信息  【需要实现】
- (void)onGetGameViewInfo:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    CGFloat scale = [[UIScreen mainScreen] nativeScale];
    GameViewInfoModel *m = [[GameViewInfoModel alloc] init];
    GameViewSize *viewSize = [[GameViewSize alloc] init];
    viewSize.width = kScreenWidth * scale;
    viewSize.height = kScreenHeight * scale;
    ViewGameRect *viewRect = [[ViewGameRect alloc] init];
    viewRect.top = (kStatusBarHeight + 44) * scale;
    viewRect.left = 0;
    viewRect.bottom = (kAppSafeBottom + 150) * scale;
    viewRect.right = 0;
    m.ret_code = 0;
    m.ret_msg = @"success";
    m.view_size = viewSize;
    m.view_game_rect = viewRect;
    [handle success:m.mj_JSONString];
}

- (NSString *)onGetGameCfg {
    GameCfgModel *m = [GameCfgModel defaultCfgModel];
    m.ui.nft_avatar.hide = NO;
    m.ui.game_opening.hide = NO;
    m.ui.game_mvp.hide = NO;
    m.ui.game_bg.hide = true;
    m.ui.lobby_players.hide = NO;
    return [m mj_JSONString];
}

/// 游戏: 游戏结算状态     MG_COMMON_GAME_SETTLE
- (void)onGameMGCommonGameSettle:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonGameSettleModel *)model {
    
    for (MGCommonGameSettleResults *item in model.results) {
        if (!item.isEscaped) {
            /// 游戏结束 回到9麦模式
            self.orderStateType = OrderStateTypeWait;
            self.userOrderState = OrderUserStateTypeNormal;
            self.gameId = 0;
            [self reqChangeToGameGameId:self.gameId operatorUser:AppService.shared.login.loginUserInfo.userID];
            break;
        }
    }
    
    WeakSelf
    if ([self.toGameUserId isEqualToString:AppService.shared.login.loginUserInfo.userID]) {
        [DTAlertView showTextAlert:NSString.dt_room_round_game_over sureText:NSString.dt_room_place_order cancelText:NSString.dt_common_back onSureCallback:^{
            if (SuspendRoomView.isShowSuspend) {
                [SuspendRoomView enterSceneVC];
            }
            [weakSelf wantOrderBtnEvent:nil];
        } onCloseCallback:^{}];
        self.toGameUserId = @"";
    }
    
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

#pragma mark - Event

- (void)dtConfigEvents {
    [super dtConfigEvents];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wantOrderBtnEvent:)];
    [_wantOrderView addGestureRecognizer:tap];
}

- (void)wantOrderBtnEvent:(UITapGestureRecognizer *)tap {
    WeakSelf
    OrderChooseView *node = OrderChooseView.new;
    [node.usersView configUsersData:[weakSelf getUserArr]];
    [node.gamesView configGamesData:[weakSelf getGameArr]];
    if ([weakSelf getUserArr].count == 0) {
        [node configOrderBtnNotClick];
        node.gamesView.isNotSelectedItem = true;
    }
    [DTSheetView show:node rootView:AppUtil.currentWindow hiddenBackCover:false onCloseCallback:^{}];
    node.enterOrderBlock = ^(NSArray * _Nonnull userIdList, NSArray *userNameList, HSGameItem * _Nonnull gameItem) {
        [DTSheetView close];
        [kAudioRoomService reqRoomOrderCreate:weakSelf.roomID.integerValue gameId:weakSelf.gameId userIdList:userIdList success:^(RoomOrderCreateModel * _Nonnull m) {
            RoomCmdOrderCreateModel *msg = RoomCmdOrderCreateModel.new;
            msg.orderId = m.orderId;
            msg.gameId = gameItem.gameId;
            msg.gameName = gameItem.gameName;
            msg.toUsers = userIdList;
            msg.toUserNames = userNameList;
            [msg configBaseInfoWithCmd:CMD_ROOM_ORDER_USER];
            /// 公屏添加消息
            [weakSelf sendMsg:msg isAddToShow:NO finished:nil];
            [weakSelf showOrderMsg:msg];
            /// 下单
            [ToastUtil show:NSString.dt_room_order_placed];
        } fail:nil];
    };
}

- (void)gameStateBtnEvent:(id)tap {
    [[NSNotificationCenter defaultCenter]postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:nil];
    if (self.orderStateType == OrderStateTypeGame) {
        self.orderStateType = OrderStateTypeHangup;
    } else if (self.orderStateType == OrderStateTypeHangup) {
        self.orderStateType = OrderStateTypeGame;
    }
}

/// 展示下单公屏消息
- (void)showOrderMsg:(RoomCmdOrderCreateModel *)m {

    NSString *nameStr = @"";
    if (m.toUserNames.count > 0) {
        NSArray *arrName = m.toUserNames;
        for (int i = 0; i < arrName.count; ++i) {
            if (nameStr.length > 0) {
                nameStr = [NSString stringWithFormat:@"%@、", nameStr];
            }
            nameStr = [NSString stringWithFormat:@"%@%@", nameStr, arrName[i]];
        }
    }

    NSString *msgStr = [NSString stringWithFormat:NSString.dt_ticket_order_msg_fmt, m.sendUser.name, nameStr, m.gameName];
    if (self.isJpanese) {
        msgStr = [NSString stringWithFormat:NSString.dt_ticket_order_msg_fmt, m.sendUser.name, m.gameName, nameStr];
    }
    AudioMsgSystemModel *msg = [AudioMsgSystemModel makeMsg:msgStr];
    [self addMsg:msg isShowOnScreen:true];
}

- (BOOL)isJpanese{
    NSString *lang = NSBundle.currentLanguage;
    return [lang hasPrefix:@"jp"];
}

- (void)handleBusyCommand:(NSInteger)cmd command:(NSString *)command {
    WeakSelf
    switch (cmd) {
        case CMD_ROOM_ORDER_USER: {
            // 下单
            RoomCmdOrderCreateModel *m = [RoomCmdOrderCreateModel fromJSON:command];

            [self showOrderMsg:m];
            if ([m.toUsers containsObject:AppService.shared.login.loginUserInfo.userID]) {
                // 主播同意或拒绝点单
                NSString *text = [NSString stringWithFormat:NSString.dt_room_hope_play_is_join, m.sendUser.name, m.gameName];
                [DTAlertView showTextAlert:text sureText:NSString.dt_home_join cancelText:NSString.dt_room_reject onSureCallback:^{


                    if (SuspendRoomView.isShowSuspend) {
                        [SuspendRoomView enterSceneVC];
                    }
                    
                    [weakSelf sendCmdOrderOperate:YES m:m];
                    weakSelf.userOrderState = OrderUserStateTypeAccempted;
                    // 加入游戏
                    [weakSelf handleGameUpMic];
                    [kAudioRoomService reqRoomOrderReceive:m.orderId success:^{
                        /// 跳转游戏
                        weakSelf.gameId = m.gameId;
                        weakSelf.orderStateType = OrderStateTypeGame;
                        [weakSelf reqChangeToGameGameId:m.gameId operatorUser:AppService.shared.login.loginUserInfo.userID];
                    } fail:^(NSError *error) {
                        
                    }];
                } onCloseCallback:^{
                    [weakSelf sendCmdOrderOperate:NO m:m];
                }];
            }
        }
            break;
        case CMD_ROOM_ORDER_OPERATE: {
            // 主播同意或拒绝点单
            RoomCmdOrderOperateModel *m = [RoomCmdOrderOperateModel fromJSON:command];
            if ([m.toUser isEqualToString:AppService.shared.login.loginUserInfo.userID]) {
                if (m.operate) {
                    self.userOrderState = OrderUserStateTypeInvited;
                    // 加入游戏
                    [self handleGameUpMic];
                    self.toGameUserId = AppService.shared.login.loginUserInfo.userID;
                    
                    /// 添加同意公屏消息
                    AudioMsgSystemModel *msg = [AudioMsgSystemModel makeMsg:[NSString stringWithFormat:NSString.dt_user_receive_invite_msg, m.sendUser.name, m.gameName]];
                    [self addMsg:msg isShowOnScreen:true];
                } else {
                    NSString *text = [NSString stringWithFormat:NSString.dt_room_refuse_invitation_find, m.sendUser.name];
                    [DTAlertView showTextAlert:text sureText:NSString.dt_common_sure cancelText:NSString.dt_common_cancel onSureCallback:^{
                    } onCloseCallback:^{}];
                }
            }
            
        }
            break;
            
        default:
            break;
    }
}

- (void)sendCmdOrderOperate:(BOOL)operate m:(RoomCmdOrderCreateModel*)m {
    RoomCmdOrderOperateModel *msg = RoomCmdOrderOperateModel.new;
    msg.orderId = m.orderId;
    msg.gameId = m.gameId;
    msg.gameName = m.gameName;
    msg.toUser = m.sendUser.userID;
    msg.operate = operate;
    [msg configBaseInfoWithCmd:CMD_ROOM_ORDER_OPERATE];
    /// 公屏添加消息
    [self sendMsg:msg isAddToShow:NO finished:nil];
}

#pragma mark - Lazy

/// 获取座位上的用户
- (NSArray <AudioRoomMicModel *> *)getUserArr {
    NSMutableArray <AudioRoomMicModel *>*micList = NSMutableArray.new;
    for (AudioRoomMicModel *item in self.dicMicModel.allValues) {
        if (item.user != nil && ![item.user.userID isEqualToString:AppService.shared.login.loginUserInfo.userID]) {
            item.isSelected = false;
            [micList addObject:item];
        }
    }
    return micList;
}

/// 获取当前可切换的游戏
- (NSArray <HSGameItem *> *)getGameArr {
    NSMutableArray <HSGameItem *>*gameList = NSMutableArray.new;
    NSArray <HSGameItem *> *dataArr = AppService.shared.gameList;
    for (HSGameItem *item in dataArr) {
        for (NSNumber *scene in item.suitScene) {
            if ([scene integerValue] == self.enterModel.sceneType) {
                item.isSelect = false;
                [gameList addObject:item];
            }
        }
    }
    return gameList;
}

- (BaseView *)wantOrderView {
    if (!_wantOrderView) {
        _wantOrderView = BaseView.new;
        NSArray *colorArr = @[(id)[UIColor dt_colorWithHexString:@"#F963FF" alpha:1].CGColor, (id)[UIColor dt_colorWithHexString:@"#CC00E7" alpha:1].CGColor];
        [_wantOrderView dtAddGradientLayer:@[@(0.0f), @(1.0f)] colors:colorArr startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) cornerRadius:0];
        [_wantOrderView setHidden:true];

    }
    return _wantOrderView;
}

- (MarqueeLabel *)wantOrderLabel {
    if (!_wantOrderLabel) {
        _wantOrderLabel = [[MarqueeLabel alloc] init];
        _wantOrderLabel.text = NSString.dt_room_my_order_list;
        _wantOrderLabel.font = UIFONT_BOLD(12);
        _wantOrderLabel.textAlignment = NSTextAlignmentCenter;
        _wantOrderLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
    }
    return _wantOrderLabel;
}

- (MarqueeLabel *)gameStateLabel {
    if (!_gameStateLabel) {
        _gameStateLabel = [[MarqueeLabel alloc]init];
        _gameStateLabel.backgroundColor = [UIColor dt_colorWithHexString:@"#4E9C39" alpha:0.3];
        _gameStateLabel.text = NSString.dt_room_enter_game;
        _gameStateLabel.font = UIFONT_MEDIUM(12);
        _gameStateLabel.textAlignment = NSTextAlignmentCenter;
        _gameStateLabel.textColor = [UIColor dt_colorWithHexString:@"#6AD04E" alpha:1];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gameStateBtnEvent:)];
        [_gameStateLabel addGestureRecognizer:tap];
        [_gameStateLabel setHidden:true];
        _gameStateLabel.userInteractionEnabled = YES;
    }
    return _gameStateLabel;
}


#pragma mark - Set
- (void)setOrderStateType:(OrderStateType)orderStateType {
    _orderStateType = orderStateType;
    [self handleOrderStateTypeChange];
}

@end
