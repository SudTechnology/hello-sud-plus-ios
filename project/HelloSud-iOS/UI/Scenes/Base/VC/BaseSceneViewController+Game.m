//
//  AudioRoomViewController+Game.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseSceneViewController+Game.h"
#import "BaseSceneViewController+Voice.h"
#import <SudMGP/ISudCfg.h>
#import "RocketSelectAnchorView.h"

@implementation BaseSceneViewController (Game)

/// 初始化sud
- (void)initSudFSMMG {
    self.sudFSTAPPDecorator = [[SudFSTAPPDecorator alloc] init];
    self.sudFSMMGDecorator = [[SudFSMMGDecorator alloc] init];
    self.gameMicContentView.iSudFSMMG = self.sudFSMMGDecorator;
    [self.sudFSMMGDecorator setCurrentUserId:AppService.shared.login.loginUserInfo.userID];
    [self.sudFSMMGDecorator setEventListener:self];
    [self hanldeInitSudFSMMG];
    // 控制SDK游戏加载背景
    BOOL isShowSDKLoadingBackground = [self showSudMGPLoadingGameBackground];
    [[SudMGP getCfg] setShowLoadingGameBg:isShowSDKLoadingBackground];
}

- (void)hanldeInitSudFSMMG {
}

#pragma mark =======SudFSMMGListener=======

/// 游戏开始
- (void)onGameStarted {
    DDLogDebug(@"onGameStarted");
    [self handleGameStared];
}

- (void)onGameDestroyed {
    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:nil];

}

/// 获取游戏View信息  【需要实现】
- (void)onGetGameViewInfo:(nonnull id <ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    CGFloat scale = [[UIScreen mainScreen] nativeScale];
    GameViewInfoModel *m = [[GameViewInfoModel alloc] init];
    m.view_size.width = kScreenWidth * scale;
    m.view_size.height = kScreenHeight * scale;
    m.view_game_rect.top = (kStatusBarHeight + 120) * scale;
    m.view_game_rect.left = 0;
    m.view_game_rect.bottom = (kAppSafeBottom + 150) * scale;
    m.view_game_rect.right = 0;

    m.ret_code = 0;
    m.ret_msg = @"success";
    [handle success:m.mj_JSONString];
}

/// 短期令牌code过期  【需要实现】
- (void)onExpireCode:(nonnull id <ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    // 请求业务服务器刷新令牌 Code更新
    [GameService.shared reqGameLoginWithSuccess:^(RespGameInfoModel *_Nonnull gameInfo) {
        // 调用游戏接口更新令牌
        [self.sudFSTAPPDecorator updateCode:gameInfo.code];
        // 回调成功结果
        [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
    }                                      fail:^(NSError *error) {
        [ToastUtil show:error.debugDescription];
        // 回调失败结果
        [handle failure:[self.sudFSMMGDecorator handleMGFailure]];
    }];
}

/// 获取游戏Config  【需要实现】
- (void)onGetGameCfg:(nonnull id <ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    [handle success:[self onGetGameCfg]];
}

/// 游戏: 准备按钮点击状态   MG_COMMON_SELF_CLICK_READY_BTN
- (void)onGameMGCommonSelfClickReadyBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickReadyBtn *)model {
    [self onGameMGCommonSelfClickReadyBtn];
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 游戏: 结算界面再来一局按钮点击状态   MG_COMMON_SELF_CLICK_GAME_SETTLE_AGAIN_BTN
- (void)onGameMGCommonSelfClickGameSettleAgainBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickGameSettleAgainBtn *)model {
    [self onGameMGCommonSelfClickReadyBtn];
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 游戏: 开始游戏按钮点击状态   MG_COMMON_SELF_CLICK_START_BTN
- (void)onGameMGCommonSelfClickStartBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickStartBtn *)model {
    [self onGameMGCommonSelfClickStartBtn];
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 通用状态-游戏
/// 游戏: 公屏消息状态    MG_COMMON_PUBLIC_MESSAGE
- (void)onGameMGCommonPublicMessage:(id <ISudFSMStateHandle>)handle model:(MGCommonPublicMessageModel *)model {
    [self updateCommonPublicMessageAddMsg:model];
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 游戏: 关键词状态    MG_COMMON_KEY_WORD_TO_HIT
- (void)onGameMGCommonKeyWordToHit:(id <ISudFSMStateHandle>)handle model:(MGCommonKeyWrodToHitModel *)model {

    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 游戏: 游戏状态   MG_COMMON_GAME_STATE
- (void)onGameMGCommonGameState:(id <ISudFSMStateHandle>)handle model:(MGCommonGameState *)model {
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
    DDLogDebug(@"onGameMGCommonGameState:%@", @(model.gameState));
    // 游戏进行开始时，把麦位缩小
    if (model.gameState == 1) {
        [self.gameMicContentView switchToSmallView];
    }
}

/// 游戏: ASR状态(开启和关闭语音识别状态   MG_COMMON_GAME_ASR
- (void)onGameMGCommonGameASR:(id <ISudFSMStateHandle>)handle model:(MGCommonGameASRModel *)model {
    /// 语音采集 || 停止采集
    if (model.isOpen) {
        [self startCaptureAudioToASR];
    } else {
        [self stopCaptureAudioToASR];
    }
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_ASR_STATE_CHANGED object:nil userInfo:nil];
}

/// 游戏通知app获取积分 MG_COMMON_GAME_SCORE
- (void)onGameMGCommonGameGetScore:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameGetScoreModel *)model {
    DDLogDebug(@"onGameMGCommonGameScore");
    [UserService.shared reqUserCoinDetail:^(int64_t i) {
        DDLogError(@"onGameMGCommonGameScore notify game score:%@", @(i));
        AppCommonGameScore *m = AppCommonGameScore.new;
        m.score = i;
        [self.sudFSTAPPDecorator notifyAppCommonGameScore:m];
    }                                fail:^(NSString *str) {
        DDLogError(@"onGameMGCommonGameScore req user coin err:%@", str);
    }];
}

/// 游戏通知app带入积分 MG_COMMON_GAME_SET_SCORE
- (void)onGameMGCommonGameSetScore:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSetScoreModel *)model {
    DDLogDebug(@"onGameMGCommonGameSetScore");
    ReqAddScoreModel *reqModel = ReqAddScoreModel.new;
    reqModel.mgId = [NSString stringWithFormat:@"%@", @(self.gameId)];;
    reqModel.roomId = self.gameRoomID;
    reqModel.roundId = model.roundId;;
    reqModel.lastRoundScore = model.lastRoundScore;
    reqModel.incrementalScore = model.incrementalScore;
    reqModel.totalScore = model.totalScore;
    [UserService.shared reqAddGameScore:reqModel success:^(BaseRespModel *_Nonnull resp) {
        DDLogDebug(@"onGameMGCommonGameSetScore add success");
    }                              fail:^(NSError *error) {
        DDLogDebug(@"onGameMGCommonGameSetScore req add score fail:%@", error.dt_errMsg);
    }];
}

/// 玩家状态变化
/// 玩家: 加入状态  MG_COMMON_PLAYER_IN
- (void)onPlayerMGCommonPlayerIn:(id <ISudFSMStateHandle>)handle userId:(NSString *)userId model:(MGCommonPlayerInModel *)model {
    [self updatePlayerCommonPlayerIn:model userId:userId];
    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:nil];
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 玩家: 准备状态  MG_COMMON_PLAYER_READY
- (void)onPlayerMGCommonPlayerReady:(id <ISudFSMStateHandle>)handle userId:(NSString *)userId model:(MGCommonPlayerReadyModel *)model {
    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:nil];
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 玩家: 队长状态  MG_COMMON_PLAYER_CAPTAIN
- (void)onPlayerMGCommonPlayerCaptain:(id <ISudFSMStateHandle>)handle userId:(NSString *)userId model:(MGCommonPlayerCaptainModel *)model {
    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:nil];

    if ([AppService.shared.login.loginUserInfo.userID isEqualToString:userId] && self.sudFSMMGDecorator.isPlaying && model.isCaptain) {
        self.isShowEndGame = true;
    } else {
        self.isShowEndGame = false;
    }
    if ([AppService.shared.loginUserID isEqualToString:userId] && model.isCaptain) {
        [self onHandleIsGameCaptain];
    }

    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 玩家: 游戏状态  MG_COMMON_PLAYER_PLAYING
- (void)onPlayerMGCommonPlayerPlaying:(id <ISudFSMStateHandle>)handle userId:(NSString *)userId model:(MGCommonPlayerPlayingModel *)model {
    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:nil];

    if ([AppService.shared.login.loginUserInfo.userID isEqualToString:self.sudFSMMGDecorator.captainUserId] && self.sudFSMMGDecorator.isPlaying) {
        self.isShowEndGame = true;
    } else {
        self.isShowEndGame = false;
    }
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 你画我猜: 作画中状态  MG_DG_PAINTING
- (void)onPlayerMGDGPainting:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGDGPaintingModel *)model {
    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:nil];
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 游戏: 麦克风状态   MG_COMMON_GAME_SELF_MICROPHONE
- (void)onGameMGCommonGameSelfMicrophone:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSelfMicrophone *)model {
    [self handleGameTapVoice:model.isOn];
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 游戏: 耳机（听筒，扬声器）状态   MG_COMMON_GAME_SELF_HEADEPHONE
- (void)onGameMGCommonGameSelfHeadphone:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSelfHeadphone *)model {
    if (model.isOn) {
        [AudioEngineFactory.shared.audioEngine startSubscribingStream];
    } else {
        [AudioEngineFactory.shared.audioEngine stopSubscribingStream];
    }
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 元宇宙砂砂舞 指令回调  MG_COMMON_GAME_DISCO_ACTION
- (void)onGameMGCommonGameDiscoAction:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameDiscoActionModel *)model {

    DDLogDebug(@"onGameMGCommonGameDiscoAction: actionID:%@, isSuccess:%@", model.actionId, @(model.isSuccess));
}

/// 元宇宙砂砂舞 指令动作结束通知  MG_COMMON_GAME_DISCO_ACTION_END
- (void)onGameMGCommonGameDiscoActionEnd:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameDiscoActionEndModel *)model {
    DDLogDebug(@"onGameMGCommonGameDiscoActionEnd: actionID:%@, playerID:%@", model.actionId, model.playerId);
}


#pragma mark =======Comonn状态处理=======

/// 公屏消息状态 ---> 添加公屏消息
- (void)updateCommonPublicMessageAddMsg:(MGCommonPublicMessageModel *)model {
    NSMutableAttributedString *attrMsg = [[NSMutableAttributedString alloc] init];
    for (GamePublicMsg *m in model.msg) {
        if (m.phrase == 2) {
            [attrMsg appendAttributedString:[AppUtil getAttributedStringWithString:m.user.name color:m.user.color]];
        } else if (m.phrase == 1) {
            NSString *textString = m.text.mj_keyValues[self.language];
            if (textString.length == 0) {
                // 没有对应语言，取英文
                textString = m.text.mj_keyValues[@"en-US"];
            }
            if (textString.length > 0) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textString];
                [attrMsg appendAttributedString:attributedString];
            }
        }
    }
    if (attrMsg.length > 0) {
        attrMsg.yy_lineSpacing = 6;
        attrMsg.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        attrMsg.yy_color = [UIColor dt_colorWithHexString:@"#FFD620" alpha:1];
        AudioMsgSystemModel *msgModel = [AudioMsgSystemModel makeMsgWithAttr:attrMsg];
        /// 公屏添加消息
        [self addMsg:msgModel isShowOnScreen:YES];
    } else {
        NSLog(@"error msg is empty");
    }

}

#pragma mark =======玩家状态处理=======

/// 加入状态处理
- (void)updatePlayerCommonPlayerIn:(MGCommonPlayerInModel *)model userId:(NSString *)userId {
    if (model.isIn && [AppService.shared.login.loginUserInfo.userID isEqualToString:userId]) {
        // 请求上麦
        [self handleGameUpMic];
    }
    self.gameNumLabel.text = [NSString stringWithFormat:@"%@：%ld/%ld", NSString.dt_game_person_count, self.sudFSMMGDecorator.onlineUserIdList.count, self.totalGameUserCount];
    [self playerIsInGameStateChanged:userId];
}


#pragma mark =======登录 加载 游戏=======

/// 游戏登录
/// 接入方客户端 调用 接入方服务端 loginGame: 获取 短期令牌code
/// 参考文档时序图：sud-mgp-doc(https://github.com/SudTechnology/sud-mgp-doc)
- (void)loginGame {
    NSString *appID = AppService.shared.configModel.sudCfg.appId;
    NSString *appKey = AppService.shared.configModel.sudCfg.appKey;
    if (appID.length == 0 || appKey.length == 0) {
        [ToastUtil show:@"Game appID or appKey is empty"];
        return;
    }
    WeakSelf
    [GameService.shared reqGameLoginWithSuccess:^(RespGameInfoModel *_Nonnull gameInfo) {
        [weakSelf login:weakSelf.gameView gameId:weakSelf.gameId code:gameInfo.code appID:appID appKey:appKey];
    }                                      fail:^(NSError *error) {
        [ToastUtil show:error.debugDescription];
    }];
}

/// 退出游戏
- (void)logoutGame {
    [self stopCaptureAudioToASR];
    // 销毁游戏
    [self.sudFSTAPPDecorator destroyMG];
}

/// 处理切换游戏
/// @param gameID 新的游戏ID
- (void)handleChangeToGame:(int64_t)gameID {
    [self.sudFSMMGDecorator clearAllStates];
    self.isGameForbiddenVoice = NO;
    if (gameID == 0) {
        // 切换语音房间
        self.gameId = 0;
        GameService.shared.gameId = 0;
        [self logoutGame];
        [self.sudFSMMGDecorator clearAllStates];
        [self roomGameDidChanged:gameID];
        return;
    }
    /// 更新gameID
    self.gameId = gameID;
    GameService.shared.gameId = gameID;
    [self loginGame];
    [self roomGameDidChanged:gameID];
}

#pragma mark =======登录 加载 游戏=======

/// 游戏登录
/// 接入方客户端 调用 接入方服务端 loginGame: 获取 短期令牌code
/// 参考文档时序图：sud-mgp-doc(https://github.com/SudTechnology/sud-mgp-doc)
- (void)login:(UIView *)rootView gameId:(int64_t)gameId code:(NSString *)code appID:(NSString *)appID appKey:(NSString *)appKey {
    [self initSdk:rootView gameId:gameId code:code appID:appID appKey:appKey];
}

/// 加载游戏
- (void)initSdk:(UIView *)rootView gameId:(int64_t)gameId code:(NSString *)code appID:(NSString *)appID appKey:(NSString *)appKey {
    WeakSelf
    [self logoutGame];
    if (gameId <= 0) {
        DDLogDebug(@"游戏ID为空，无法加载游戏:%@, currentRoomID:%@, currentGameRoomID:%@", gameId, self.roomID, self.gameRoomID);
        return;
    }
    BOOL isTest = false;
#if DEBUG
    [ISudAPPD e:HsAppPreferences.shared.gameEnvType];
    if (HsAppPreferences.shared.gameEnvType != HsGameEnvTypePro) {
        isTest = YES;
    }
#endif
    [SudMGP initSDK:appID appKey:appKey isTestEnv:isTest listener:^(int retCode, const NSString *retMsg) {
        if (retCode == 0) {
            DDLogInfo(@"ISudFSMMG:initGameSDKWithAppID:初始化游戏SDK成功");
            if (weakSelf) {
                // SudMGPSDK初始化成功 加载MG
                NSString *userID = AppService.shared.login.loginUserInfo.userID;
                NSString *roomID = weakSelf.gameRoomID;
                if (userID.length == 0 || roomID.length == 0 || code.length == 0) {
                    [ToastUtil show:NSString.dt_room_load_failed];
                    return;
                }
                DDLogInfo(@"loadGame:userId:%@, gameRoomId:%@, currentRoomId:%@, gameId:%@", userID, roomID, weakSelf.roomID, @(gameId));
                [weakSelf loadGame:userID roomId:roomID code:code mgId:gameId language:weakSelf.language fsmMG:weakSelf.sudFSMMGDecorator rootView:rootView];
            }
        } else {
            /// 初始化失败, 可根据业务重试
            DDLogError(@"ISudFSMMG:initGameSDKWithAppID:初始化sdk失败 :%@", retMsg);
        }
    }];
}

/// 加载游戏MG
/// @param userId 用户唯一ID
/// @param roomId 房间ID
/// @param code 游戏登录code
/// @param mgId 游戏ID
/// @param language 支持简体"zh-CN "    繁体"zh-TW"    英语"en-US"   马来"ms-MY"
/// @param fsmMG 控制器
/// @param rootView 游戏根视图
- (void)loadGame:(NSString *)userId roomId:(NSString *)roomId code:(NSString *)code mgId:(int64_t)mgId language:(NSString *)language fsmMG:(id)fsmMG rootView:(UIView *)rootView {

    id <ISudFSTAPP> iSudFSTAPP = [SudMGP loadMG:userId roomId:roomId code:code mgId:mgId language:language fsmMG:self.sudFSMMGDecorator rootView:rootView];
    [self.sudFSTAPPDecorator setISudFSTAPP:iSudFSTAPP];
}

#pragma mark - Rocket MG state callback

/// 礼物配置文件(火箭) MG_CUSTOM_ROCKET_CONFIG
- (void)onGameMGCustomRocketConfig:(nonnull id <ISudFSMStateHandle>)handle {

    /// 查询火箭配置信息
    [RocketService reqRocketConfigWithFinished:^(AppCustomRocketConfigModel *respModel) {
        /// 将配置信息返回给游戏
        [self.sudFSTAPPDecorator notifyAppCustomRocketConfig:respModel];
    }];
}

/// 拥有模型列表(火箭) MG_CUSTOM_ROCKET_MODEL_LIST
- (void)onGameMGCustomRocketModelList:(nonnull id <ISudFSMStateHandle>)handle {
    [RocketService reqRocketModelListWithFinished:^(AppCustomRocketModelListModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketModelList:respModel];
    }];
}


/// 拥有组件列表(火箭) MG_CUSTOM_ROCKET_COMPONENT_LIST
- (void)onGameMGCustomRocketComponentList:(nonnull id <ISudFSMStateHandle>)handle {
    [RocketService reqRocketComponentListWithFinished:^(AppCustomRocketComponentListModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketComponentList:respModel];
    }];
}

/// 获取用户信息(火箭) MG_CUSTOM_ROCKET_USER_INFO
- (void)onGameMGCustomRocketUserInfo:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketUserInfo *)model {
    [UserService.shared asyncCacheUserInfo:model.userIdList forceRefresh:YES finished:^{
        AppCustomRocketUserInfoModel *resp = AppCustomRocketUserInfoModel.new;
        NSMutableArray *userList = NSMutableArray.new;
        for (NSString *t in model.userIdList) {

            HSUserInfoModel *userInfoModel = [UserService.shared getCacheUserInfo:t.longLongValue];
            if (!userInfoModel) {
                continue;
            }
            RocketUserInfoItemModel *itemModel = RocketUserInfoItemModel.new;
            itemModel.nickName = userInfoModel.nickname;
            itemModel.sex = [userInfoModel.gender isEqualToString:@"male"] ? 0 : 1;
            itemModel.url = userInfoModel.avatar;
            itemModel.userId = [NSString stringWithFormat:@"%@", userInfoModel.userId];
            [userList addObject:itemModel];
        }
        resp.userList = userList;
        [self.sudFSTAPPDecorator notifyAppCustomRocketUserInfo:resp];
    }];
}

/// 订单记录列表(火箭) MG_CUSTOM_ROCKET_ORDER_RECORD_LIST
- (void)onGameMGCustomRocketOrderRecordList:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketOrderRecordList *)model {
    [RocketService reqRocketOrderRecordList:model.pageIndex pageSize:model.pageSize finished:^(AppCustomRocketOrderRecordListModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketOrderRecordList:respModel];
    }];
}

/// 展馆内列表(火箭) MG_CUSTOM_ROCKET_ROOM_RECORD_LIST
- (void)onGameMGCustomRocketRoomRecordList:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketRoomRecordList *)model {
    [RocketService reqRocketRoomRecordList:model.pageIndex pageSize:model.pageSize roomId:kAudioRoomService.currentRoomVC.roomID.integerValue finished:^(AppCustomRocketRoomRecordListModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketRoomRecordList:respModel];
    }];
}

/// 展馆内玩家送出记录(火箭) MG_CUSTOM_ROCKET_USER_RECORD_LIST
- (void)onGameMGCustomRocketUserRecordList:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketUserRecordList *)model {
    [RocketService reqRocketUserRecordList:model.pageIndex pageSize:model.pageSize userId:AppService.shared.loginUserID finished:^(AppCustomRocketUserRecordListModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketUserRecordList:respModel];
    }];
}

/// 设置默认位置(火箭) MG_CUSTOM_ROCKET_SET_DEFAULT_MODEL
- (void)onGameMGCustomRocketSetDefaultSeat:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketSetDefaultSeat *)model {
    [RocketService reqRocketSetDefaultSeat:model finished:^(AppCustomRocketSetDefaultSeatModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketSetDefaultSeat:respModel];
    }];
}

/// 动态计算一键发送价格(火箭) MG_CUSTOM_ROCKET_DYNAMIC_FIRE_PRICE
- (void)onGameMGCustomRocketDynamicFirePrice:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketDynamicFirePrice *)model {
    [RocketService reqRocketDynamicFirePrice:model finished:^(AppCustomRocketDynamicFirePriceModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketDynamicFirePrice:respModel];
    }];
}

/// 一键发送(火箭) MG_CUSTOM_ROCKET_FIRE_MODEL
- (void)onGameMGCustomRocketFireModel:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketFireModel *)model {

    WeakSelf
    RocketSelectAnchorView *v = RocketSelectAnchorView.new;
    v.confirmBlock = ^(NSArray<AudioRoomMicModel *> *userList){
        [RocketService reqRocketFireModel:model userList:userList finished:^(AppCustomRocketFireModel *respModel) {
            [weakSelf.sudFSTAPPDecorator notifyAppCustomRocketFireModel:respModel];
        }];
    };
    [DTAlertView show:v rootView:nil clickToClose:YES showDefaultBackground:YES onCloseCallback:nil];

}

/// 新组装模型(火箭) MG_CUSTOM_ROCKET_CREATE_MODEL
- (void)onGameMGCustomRocketCreateModel:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketCreateModel *)model {

    [RocketService reqRocketSaveCreateModel:model finished:^(AppCustomRocketCreateModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketCreateModel:respModel];
    }];
}

/// 更换组件(火箭) MG_CUSTOM_ROCKET_REPLACE_COMPONENT
- (void)onGameMGCustomRocketReplaceModel:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketReplaceModel *)model {
    [RocketService reqRocketReplaceModel:model finished:^(AppCustomRocketReplaceComponentModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketReplaceComponent:respModel];
    }];
}

/// 购买组件(火箭) MG_CUSTOM_ROCKET_BUY_COMPONENT
- (void)onGameMGCustomRocketBuyModel:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketBuyModel *)model {
    [RocketService reqRocketBuyModel:model finished:^(AppCustomRocketBuyComponentModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketBuyComponent:respModel];
    }];
}

/// 播放效果开始((火箭) MG_CUSTOM_ROCKET_PLAY_EFFECT_START
- (void)onGameMGCustomRocketPlayEffectStart:(nonnull id <ISudFSMStateHandle>)handle {
    DDLogDebug(@"mg：播放效果开始((火箭)");
}

/// 播放效果完成(火箭) MG_CUSTOM_ROCKET_PLAY_EFFECT_FINISH
- (void)onGameMGCustomRocketPlayEffectFinish:(nonnull id <ISudFSMStateHandle>)handle {
    DDLogDebug(@"mg：播放效果完成(火箭) ");
}

/// 验证签名合规((火箭) MG_CUSTOM_ROCKET_VERIFY_SIGN
- (void)onGameMGCustomRocketVerifySign:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketVerifySign *)model {

    [RocketService reqRocketVerifySign:model finished:^(AppCustomRocketVerifySignModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketVerifySign:respModel];
    }];
}

/// 上传icon(火箭) MG_CUSTOM_ROCKET_UPLOAD_MODEL_ICON
- (void)onGameMGCustomRocketUploadModelIcon:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketUploadModelIcon *)model {

    NSString *imagePath = [GiftService.shared saveRocketImage:model.data];
    if (imagePath) {
        /// 改变火箭礼物图片为截图
        GiftModel *giftModel = [GiftService.shared giftByID:kRocketGiftID];
        giftModel.smallGiftURL = imagePath;
        giftModel.giftURL = imagePath;
    }
    DDLogDebug(@"save rocket file path:%@", imagePath);
}

/// 前期准备完成((火箭) MG_CUSTOM_ROCKET_PREPARE_FINISH
- (void)onGameMGCustomRocketPrepareFinish:(nonnull id <ISudFSMStateHandle>)handle {
    DDLogDebug(@"mg：前期准备完成((火箭)");
    [self.sudFSTAPPDecorator notifyAppCustomRocketShowGame];
}

/// 隐藏火箭主界面((火箭) MG_CUSTOM_ROCKET_HIDE_GAME_SCENE
- (void)onGameMGCustomRocketHideGameScene:(nonnull id <ISudFSMStateHandle>)handle {
    DDLogDebug(@"mg：隐藏火箭主界面((火箭)");
}

/// 点击锁住组件((火箭) MG_CUSTOM_ROCKET_CLICK_LOCK_COMPONENT
- (void)onGameMGCustomRocketClickLockComponent:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketClickLockComponent *)model {

    [DTAlertView showTextAlert:@"该商品锁定中，是否解锁？" sureText:NSString.dt_common_sure cancelText:NSString.dt_common_cancel onSureCallback:^{
        [DTAlertView close];
        [RocketService reqRocketUnlockComponent:model finished:^{
            AppCustomRocketUnlockComponent *respModel = AppCustomRocketUnlockComponent.new;
            respModel.componentId = model.componentId;
            respModel.type = model.type;
            [self.sudFSTAPPDecorator notifyAppCustomRocketUnlockComponent:respModel];
        }];
    }          onCloseCallback:^{
        [DTAlertView close];
    }];

}
@end

