//
//  TicketViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/18.
//

#import <SDWebImage/SDImageCoder.h>
#import "CrossAppViewController.h"
#import "TicketJoinPopView.h"
#import "GameMatchingView.h"
#import "GameMatchGroupView.h"
#import "CrossAppSelectGameView.h"
#import "SuspendRoomView.h"

@interface CrossAppViewController ()
@property(nonatomic, strong) GameMatchingView *matchingView;
@property(nonatomic, strong) GameMatchGroupView *matchGroupView;
@property(nonatomic, strong) UIImageView *circleImageView;
/// 组队ID
@property(nonatomic, strong) NSString *groupId;
/// 跨APP类型 1 单人匹配 2 组队
@property(nonatomic, assign) NSInteger crossAppType;
/// 选择的游戏
@property(nonatomic, assign) int64_t matchGameId;
/// 队长
@property(nonatomic, assign) NSInteger captainId;
/// 匹配人数列表
@property(nonatomic, strong) NSArray <UserIndexInfo *> *matchUserList;
@property(nonatomic, assign) CrossAppMatchSate matchStatus;
@end

@implementation CrossAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateSelectGameState];
    // Do any additional setup after loading the view.
}

/// 服务类，子类返回对应服务类型，用于构建对应场景服务
- (Class)serviceClass {
    return [CrossAppRoomService class];
}

- (void)setConfigModel:(BaseSceneConfigModel *)configModel {
    [super setConfigModel:configModel];
    id crossAppType = configModel.enterRoomModel.dicExtData[@"crossAppType"];
    if (crossAppType) {
        // 用户选择匹配类型
        self.crossAppType = [crossAppType integerValue];
        self.matchGameId = [configModel.enterRoomModel.dicExtData[@"matchGameId"] longLongValue];
    } else if (self.enterModel.extraMatchVO.matchStatus != 0) {
        // 进入房间带入
        self.matchGameId = self.enterModel.extraMatchVO.matchGameId;
        self.groupId = self.enterModel.extraMatchVO.groupId;
        self.gameRoomID = self.enterModel.extraMatchVO.matchRoomId;
        self.gameId = self.enterModel.extraMatchVO.matchGameId;
        self.matchGroupView.captainId = self.enterModel.extraMatchVO.captain;
    }
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.bgImageView addSubview:self.circleImageView];
    [self.sceneView addSubview:self.matchingView];
    [self.sceneView addSubview:self.matchGroupView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.bgImageView);
        make.height.equalTo(@546);
        make.centerY.equalTo(self.bgImageView);
    }];
    [self.matchingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.sceneView).offset(-15);
    }];
    [self.matchGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.sceneView);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.bgImageView.image = [UIImage imageNamed:@"cross_app_search_bg"];
    HSGameItem *gameItem = [AppService.shared getSceneGameInfo:self.matchGameId];
    self.matchingView.gameItem = gameItem;
    self.matchGroupView.gameItem = gameItem;
    self.matchGroupView.seatCount = [AppService.shared getTotalGameCountWithGameID:self.matchGameId];
    NSInteger matchStatus = self.enterModel.extraMatchVO.matchStatus;
    self.matchStatus = matchStatus;
    self.matchUserList = self.enterModel.extraMatchVO.userList;
    [self.matchGroupView updateUser:self.enterModel.extraMatchVO.userList];
    [self.matchingView updateMembers:self.enterModel.extraMatchVO.userList.count total:[AppService.shared getTotalGameCountWithGameID:gameItem.gameId]];
    if (self.enterModel.extraMatchVO.totalNum > 0) {
        [self.matchingView updateMembers:self.enterModel.extraMatchVO.curNum total:self.enterModel.extraMatchVO.totalNum];
    }
    if (matchStatus == 2) {
        // 组队中
        [self showJoinGroupState:NO];
    } else if (matchStatus == 3) {
        // 匹配中
        [self showMatchSate:YES isInGroup:self.isMeInGroup];
    }

}

/// 展示加入组队
/// @param isJoin
- (void)showJoinGroupState:(BOOL)isJoin {
    self.matchingView.hidden = YES;
    self.matchGroupView.hidden = NO;
    self.circleImageView.hidden = YES;
    [self.matchGroupView showJoinState];
    if (self.gameId > 0) {
        [self handleChangeToGame:0];
    }
}


/// 展示匹配状态
/// @param matching
- (void)showMatchSate:(BOOL)matching isInGroup:(BOOL)isInGroup {
    self.matchingView.hidden = NO;
    self.matchGroupView.hidden = YES;
    self.circleImageView.hidden = NO;
    if (matching) {
        [self.matchingView showState:isInGroup ? GameMatchingViewShowStateTypeJoinMatching : GameMatchingViewShowStateTypeUnJoinMatching];
    } else {
        if (!isInGroup) {
            // 未加入组
            [self.matchingView showState:GameMatchingViewShowStateTypeFailed];
        } else {
            // 在组中
            [self.matchingView showState:self.isMeCaptain ? GameMatchingViewShowStateTypeCaptainFailed : GameMatchingViewShowStateTypeUnCaptainFailed];
        }
    }
    if (self.gameId > 0) {
        [self handleChangeToGame:0];
    }
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf;
    self.matchingView.retryBlock = ^{
        [weakSelf reqFastMatch];
    };
    self.matchingView.cancelBlock = ^{
        // 取消匹配
        [weakSelf handleCancelMatch];
    };
    self.matchingView.selectGameBlock = ^{
        // 选择游戏
        [weakSelf showSelectGameView];
    };
    self.matchGroupView.clickSeatBlock = ^(NSInteger index, BOOL isExistUser) {
        // 座位点击
        [weakSelf handleSeatClick:index isExistUser:isExistUser];
    };
    self.matchGroupView.clickExitBlock = ^{
        // 退出点击
        [weakSelf handleExitGroup];
    };
    self.matchGroupView.clickJoinBlock = ^(NSInteger index) {
        // 加入点击
        [self reqJoinGroup:index];
    };
    self.matchGroupView.clickMatchBlock = ^{
        // 匹配点击
        [weakSelf handleMatchGroup];
    };
}

/// 是否展示游戏麦位区域
- (BOOL)isShowGameMic {
    return YES;
}

/// 是否展示语音试图
- (BOOL)isShowAudioContent {
    return NO;
}

/// 是否展示火箭
- (BOOL)shouldShowRocket {
    return NO;
}

- (void)logoutRoom:(void (^)(void))finished {
    if (!self.isMeInGroup) {
        [super logoutRoom:finished];
        return;
    }
    switch (self.matchStatus) {
        case CrossAppMatchSateMatching: {
            // 退出匹配
            [CrossAppRoomService reqCancelCrossAppMatch:self.matchGameId roomId:self.roomID groupId:self.groupId finished:^(BaseRespModel *model) {
                // 退出组队
                [CrossAppRoomService reqExitMatchGroup:self.roomID
                                              finished:^(BaseRespModel *resp) {
                                                  [super logoutRoom:finished];
                                              } failure:^(NSError *error) {
                            [super logoutRoom:finished];
                        }];
            }                                   failure:^(NSError *error) {
                [super logoutRoom:finished];
            }];
        }
            break;
        default: {
            // 退出组队
            [CrossAppRoomService reqExitMatchGroup:self.roomID
                                          finished:^(BaseRespModel *resp) {
                                              [super logoutRoom:finished];
                                          } failure:^(NSError *error) {
                        [super logoutRoom:finished];
                    }];
        }
    }
}

/// 已经进入房间，消息通道已经建立
- (void)onHandleCrossRoomImConnected {
    [super onHandleCrossRoomImConnected];
    if (self.crossAppType == 1) {
        // 单人快速匹配
        [self reqFastMatch];
    } else if (self.crossAppType == 2) {
        // 多人加入组队
        [self reqJoinGroup:0];
    }
}

- (void)closeMatchViews {
    self.circleImageView.hidden = YES;
    self.matchGroupView.hidden = YES;
    self.matchingView.hidden = YES;
}

/// 展示选择切换游戏视图
- (void)showSelectGameView {
    WeakSelf
    // 选择游戏
    CrossAppSelectGameView *v = [[CrossAppSelectGameView alloc] init];
    v.isSwitchGameMode = YES;
    [v reloadData:SceneTypeCrossApp gameID:self.matchGameId > 0 ? self.matchGameId : self.gameId isShowCloseGame:false];
    v.matchClickCallback = ^(HSGameItem *selectedGame, NSInteger matchType) {
        [weakSelf handleSwitchGame:selectedGame];
        [DTSheetView close];
    };
    [DTSheetView show:v rootView:AppUtil.currentWindow hiddenBackCover:NO onCloseCallback:^{
    }];
}

/// 处理选择游戏
/// @param selectedGame selectedGame
- (void)handleSwitchGame:(HSGameItem *)selectedGame {
    [CrossAppRoomService reqSwitchMatchGame:selectedGame.gameId roomId:self.roomID finished:^(BaseRespModel *model) {

    }];
}

- (void)updateMatchGame:(int64_t)gameId {
    self.matchGameId = gameId;
    HSGameItem *gameItem = [AppService.shared getSceneGameInfo:self.matchGameId];
    self.matchGroupView.gameItem = gameItem;
    self.matchingView.gameItem = gameItem;
}

- (void)reqFastMatch {
    DDLogDebug(@"req fast match");
    // 恢复匹配展示人数
    [self.matchingView updateMembers:0 total:[AppService.shared getTotalGameCountWithGameID:self.matchGameId]];
    [CrossAppRoomService reqStartCrossAppMatch:self.matchGameId
                                        roomId:self.roomID
                                      finished:^(RespStartCrossAppMatchModel *model) {
                                          DDLogDebug(@"reqFastMatch groupId:%@", model.groupId);
                                          self.groupId = model.groupId;
                                      } failure:^(NSError *error) {


                [self showJoinGroupState:NO];

            }];
}

/// 请求加入组队
- (void)reqJoinGroup:(NSInteger)index {
    DDLogDebug(@"join group, index:%@", @(index));
    [CrossAppRoomService reqJoinMatchGroup:self.matchGameId
                                    roomId:self.roomID
                                     index:index
                                  finished:^(BaseRespModel *model) {
                                      DDLogDebug(@"join group success");
                                      [self showJoinGroupState:YES];
                                  } failure:^(NSError *error) {
                [self showJoinGroupState:NO];

            }];
}

- (void)handleCancelMatch {
    [DTAlertView showTextAlert:@"正在为您寻找玩伴中，\n确定要取消匹配吗？"
                      sureText:@"确定" cancelText:@"再等等"
                onSureCallback:^{
                    [DTAlertView close];
                    [CrossAppRoomService reqCancelCrossAppMatch:self.matchGameId roomId:self.roomID groupId:self.groupId finished:^(BaseRespModel *model) {
                        [self showJoinGroupState:NO];
                    }                                   failure:^(NSError *error) {
                    }];
                } onCloseCallback:^{

                [DTAlertView close];
            }];
}

- (void)handleExitGroup {
    if (!self.isMeInGroup) {
        DDLogDebug(@"Isn't in the group, not need to exit");
        return;
    }
    [CrossAppRoomService reqExitMatchGroup:self.roomID finished:^(BaseRespModel *resp) {
        [self showJoinGroupState:NO];
    }                              failure:^(NSError *error) {
    }];
}

- (void)handleMatchGroup {
    [self reqFastMatch];
}

- (void)handleSeatClick:(NSInteger)index isExistUser:(BOOL)isExistUser {
    if (isExistUser) {
        return;
    }
    [self reqJoinGroup:index];
}

- (BOOL)isMeInGroup {
    for (UserIndexInfo *indexInfo in self.matchUserList) {
        if ([AppService.shared.loginUserID isEqualToString:DT_STR(indexInfo.userId)]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isMeCaptain {
    return [AppService.shared.loginUserID isEqualToString:DT_STR(self.captainId)];
}


- (GameMatchingView *)matchingView {
    if (!_matchingView) {
        _matchingView = GameMatchingView.new;
        _matchingView.hidden = YES;
    }
    return _matchingView;
}

- (GameMatchGroupView *)matchGroupView {
    if (!_matchGroupView) {
        _matchGroupView = GameMatchGroupView.new;
        _matchGroupView.hidden = YES;
    }
    return _matchGroupView;
}

- (UIImageView *)circleImageView {
    if (!_circleImageView) {
        _circleImageView = [[UIImageView alloc] init];
        _circleImageView.image = [UIImage imageNamed:@"cross_app_circle_bg"];
        _circleImageView.contentMode = UIViewContentModeScaleAspectFill;
        _circleImageView.hidden = YES;
    }
    return _circleImageView;
}

/// 处理业务指令
- (void)handleBusyCommand:(NSInteger)cmd command:(NSString *)command {
    WeakSelf
    switch (cmd) {
        case CMD_GAME_EXTRA_JOIN_TEAM_NOTIFY: {
            // 跨域加入组队消息
            RoomCmdCrossAppJoinGroupModel *model = [RoomCmdCrossAppJoinGroupModel fromServerJSON:command];
        }
            break;
        case CMD_GAME_EXTRA_MATCH_USERS_CHANGED_NOTIFY: {
            // 跨域匹配人数变更通知
            RoomCmdCrossAppPersonChangedModel *model = [RoomCmdCrossAppPersonChangedModel fromServerJSON:command];
            [self.matchingView updateMembers:model.curNum total:model.totalNum];
        }
            break;
        case CMD_GAME_EXTRA_MATCH_STATUS_CHANGED_NOTIFY: {
            // 跨域匹配状态变更通知
            RoomCmdCrossAppPersonMatchStateChangedModel *model = [RoomCmdCrossAppPersonMatchStateChangedModel fromServerJSON:command];
            [self handleMatchResultState:model];
        }
            break;
        case CMD_GAME_EXTRA_TEAM_CHANGED_NOTIFY: {
            // 跨域匹配队伍变更通知
            RoomCmdCrossAppGroupOwnerChangedModel *model = [RoomCmdCrossAppGroupOwnerChangedModel fromServerJSON:command];
            self.matchUserList = model.userList;
            self.captainId = model.captain;
            self.matchGroupView.captainId = self.captainId;
            [self.matchGroupView updateUser:model.userList];
//            HSGameItem *gameItem = [AppService.shared getSceneGameInfo:self.matchGameId];
//            [self.matchingView updateMembers:model.userList.count total:[AppService.shared getTotalGameCountWithGameID:gameItem.gameId]];
            [self updateSelectGameState];
        }

            break;
        case CMD_GAME_EXTRA_GAME_SWITCH_NOTIFY: {
            // 跨域匹配游戏切换通知
            RoomCmdCrossAppGroupGameChangedModel *model = [RoomCmdCrossAppGroupGameChangedModel fromServerJSON:command];
            [self updateMatchGame:model.gameId];

        }
            break;
        default:
            break;
    }
}

/// 处理匹配结果
/// @param resp
- (void)handleMatchResultState:(RoomCmdCrossAppPersonMatchStateChangedModel *)resp {
    self.matchStatus = resp.matchStatus;
    switch (resp.matchStatus) {
        case CrossAppMatchSateNotBegin:
            // 未开启
            [self showJoinGroupState:self.isMeInGroup];
            break;
        case CrossAppMatchSateGroup:
            // 组队中
            [self showJoinGroupState:self.isMeInGroup];
            break;
        case CrossAppMatchSateMatching:
            // 匹配中
            self.groupId = resp.groupId;
            [self showMatchSate:YES isInGroup:self.isMeInGroup];
            break;
        case CrossAppMatchSateMatchSucceed:
            // 匹配成功
            self.gameRoomID = resp.matchRoomId;
            [self closeMatchViews];
            if ([AppService.shared.loginUserID isEqualToString:DT_STR(self.captainId)]) {
                [self reqChangeToGameGameId:self.matchGameId operatorUser:AppService.shared.login.loginUserInfo.userID];
            }
            // 如果在挂起，则进入房间
            if ([SuspendRoomView isShowSuspend]) {
                [SuspendRoomView enterSceneVC];
            }
            break;
        case CrossAppMatchSateMatchFailed:
            // 匹配失败
            [self showMatchSate:NO isInGroup:self.isMeInGroup];
            break;
    }
    [self updateSelectGameState];
}

- (void)roomGameDidChanged:(NSInteger)gameID {
    [super roomGameDidChanged:gameID];
    [self updateSelectGameState];
}

- (void)setIsShowEndGame:(BOOL)isShowEndGame {
    [super setIsShowEndGame:isShowEndGame];
    [self.naviView hiddenNodeWithEndGame:YES];
}

/// 是否展示选择游戏
/// @param show
- (void)updateSelectGameState {

    BOOL show = [AppService.shared.loginUserID isEqualToString:DT_STR(self.captainId)] &&
            self.gameId == 0 &&
            self.matchStatus != CrossAppMatchSateMatching &&
            self.matchStatus != CrossAppMatchSateMatchSucceed;
    [self.naviView hiddenNodeWithRoleType:show ? 1 : 0];
}

- (void)reqCloseGame {
    if (self.isMeCaptain) {
        // 调整组队游戏，触发组队状态变更
        [CrossAppRoomService reqSwitchMatchGame:self.gameId roomId:self.roomID finished:^(BaseRespModel *model) {
        }];
        // 关闭房间内游戏
        [self reqChangeToGameGameId:0 operatorUser:AppService.shared.login.loginUserInfo.userID];
    }
}

#pragma mark - SudFSMMGListener

/// 获取游戏Config  【需要实现】
- (NSString *)onGetGameCfg {
    GameCfgModel *m = [GameCfgModel defaultCfgModel];
    m.ui.nft_avatar.hide = NO;
    m.ui.game_opening.hide = NO;
    m.ui.game_mvp.hide = NO;
    m.ui.lobby_players.hide = true;
    m.ui.game_settle_again_btn.hide = YES;
    m.ui.game_settle_close_btn.custom = YES;
    return [m mj_JSONString];
}

/// 游戏: 结算界面关闭按钮点击状态   MG_COMMON_SELF_CLICK_GAME_SETTLE_CLOSE_BTN
- (void)onGameMGCommonSelfClickGameSettleCloseBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickGameSettleCloseBtn *)model {
    // 关闭游戏
    [self reqCloseGame];
    // 展示加入组队画面
    [self showJoinGroupState:self.isMeInGroup];
    [self updateSelectGameState];
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

@end
