//
//  AudioRoomViewController+Game.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "AudioRoomViewController+Game.h"
#import <SudMGP/ISudFSMMG.h>
#import <SudMGP/ISudFSTAPP.h>
#import <SudMGP/SudMGP.h>
#import <SudMGP/ISudAPPD.h>
#import <SudMGP/ISudFSMStateHandle.h>

@implementation AudioRoomViewController(Game)

#pragma mark =======ISudFSMMG Delegate=======

/**
 * 游戏开始
 */
- (void)onGameStarted {
    NSLog(@"ISudFSMMG:onGameStarted:游戏开始");
}

/**
 * 游戏销毁
 */
- (void)onGameDestroyed {
    NSLog(@"ISudFSMMG:onGameDestroyed:游戏销毁");
}

/**
 * 游戏日志
 * 最低版本：v1.1.30.xx
 */
- (void)onGameLog:(nonnull NSString *)dataJson {
    NSLog(@"ISudFSMMG:onGameLog:%@", dataJson);
    NSDictionary * dic = [AppUtil turnStringToDictionary:dataJson];
    [self handleRetCode:[dic objectForKey:@"errorCode"] errorMsg:[dic objectForKey:@"msg"]];
}

/**
 * 短期令牌code过期  【需要实现】
 * APP接入方需要调用handle.success或handle.fail
 * @param dataJson {"code":"value"}
 */
- (void)onExpireCode:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    NSLog(@"ISudFSMMG:onExpireCode:Code过期");
    // 请求业务服务器刷新令牌
    // Code更新
    [GameManager.shared reqGameLoginWithSuccess:^(RespGameInfoModel * _Nonnull gameInfo) {
        // 调用游戏接口更新令牌
        [self updateGameCode:gameInfo.code];
        
        // 回调成功结果
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(0), @"ret_code", @"success", @"ret_msg", nil];
        [handle success: [AppUtil dictionaryToJson: dict]];
    } fail:^(NSError *error) {
        [ToastUtil show:error.debugDescription];
        
        // 回调失败结果
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(0), @"ret_code", error.debugDescription, @"ret_msg", nil];
        [handle success: [AppUtil dictionaryToJson: dict]];
    }];
}

/**
 *  获取游戏Config  【需要实现】
 *  文档：https://github.com/SudTechnology/sud-mgp-doc/blob/main/Client/API/ISudFSMMG/onGetGameCfg.md
 *  APP接入方需要调用handle.success或handle.fail
 *  @param handle ISudFSMStateHandle
 *  @param dataJson dataJson
 *   最低版本：v1.1.30.xx
 */
- (void)onGetGameCfg:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    GameCfgLobbyPlayers *l = [[GameCfgLobbyPlayers alloc] init];
    l.hide = true;
    GameCfgUIModel *ui = [[GameCfgUIModel alloc] init];
    ui.lobby_players = l;
    GameCfgModel *m = [[GameCfgModel alloc] init];
    m.ui = ui;
    NSString *dataJsonRet = [m mj_JSONString];
    [handle success:dataJsonRet];
}

/**
 * 获取游戏View信息  【需要实现】
 * 处理游戏视图信息(游戏安全区)
 * 文档：https://github.com/SudTechnology/sud-mgp-doc/blob/main/Client/API/ISudFSMMG/onGetGameViewInfo.md
 * APP接入方需要调用handle.success或handle.fail
 * @param handle ISudFSMStateHandle
 * @param dataJson {}
 */
- (void)onGetGameViewInfo:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    CGFloat scale = [[UIScreen mainScreen] nativeScale];
    GameViewInfoModel *m = [[GameViewInfoModel alloc] init];
    GameViewSize *viewSize = [[GameViewSize alloc] init];
    viewSize.width = kScreenWidth * scale;
    viewSize.height = kScreenHeight * scale;
    ViewGameRect *viewRect = [[ViewGameRect alloc] init];
    viewRect.top = (kStatusBarHeight + 120 + 20) * scale;
    viewRect.left = 0;
    viewRect.bottom = (kAppSafeBottom + 150) * scale;
    viewRect.right = 0;
    m.ret_code = 0;
    m.ret_msg = @"success";
    m.view_size = viewSize;
    m.view_game_rect = viewRect;
    [handle success:[AppUtil dictionaryToJson:m.mj_keyValues]];
}

/**
 * 游戏状态变化
 * @param handle 回调句柄
 * @param state 游戏状态
 * @param dataJson 回调json
 */
- (void)onGameStateChange:(nonnull id<ISudFSMStateHandle>)handle state:(nonnull NSString *)state dataJson:(nonnull NSString *)dataJson {
    NSLog(@"%@", [NSString stringWithFormat:@"ISudFSMMG:onGameStateChange:%@ --dataJson:%@", state, dataJson]);
    
    if ([state isEqualToString:MG_COMMON_PUBLIC_MESSAGE]) {
        NSLog(@"ISudFSMMG:onGameStateChange:游戏->APP:公屏消息");
        MGCommonPublicMessageModel *publicMsgModel = [MGCommonPublicMessageModel mj_objectWithKeyValues: dataJson];
        NSMutableAttributedString * attrMsg = [[NSMutableAttributedString alloc] init];
        for (GamePublicMsg *m in publicMsgModel.msg) {
            if (m.phrase == 2) {
                [attrMsg appendAttributedString:[AppUtil getAttributedStringWithString:m.user.name color:m.user.color]];
            } else if (m.phrase == 1) {
                NSString *textString = m.text.mj_keyValues[self.gameInfoModel.language];
                NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:textString];
                [attrMsg appendAttributedString:attributedString];
            }
        }
        attrMsg.yy_lineSpacing = 6;
        attrMsg.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        attrMsg.yy_color = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        AudioMsgSystemModel *msgModel = [AudioMsgSystemModel makeMsgWithAttr:attrMsg];
        /// 公屏添加消息
        [self addMsg:msgModel isShowOnScreen:YES];
    } else if ([state isEqualToString:MG_COMMON_KEY_WORD_TO_HIT]) {
        NSLog(@"ISudFSMMG:onGameStateChange:游戏->APP:你画我猜关键词获取");
        MGCommonKeyWrodToHitModel *m = [MGCommonKeyWrodToHitModel mj_objectWithKeyValues: dataJson];
        self.gameInfoModel.drawKeyWord = m.word;
        if (m.word == (id) [NSNull null] || [m.word isEqualToString:@""]) {
            self.gameInfoModel.keyWordHiting = false;
        } else {
            self.gameInfoModel.keyWordHiting = true;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_STATE]) {
        NSLog(@"游戏状态");
        GameCommonModel *m = [GameCommonModel mj_objectWithKeyValues: dataJson];
        self.gameInfoModel.gameState = m.gameState;
        
        if (m.gameState == 2 && [AppManager.shared.loginUserInfo.userID isEqualToString:GameManager.shared.captainUserId]) {
            self.isShowEndGame = true;
        } else {
            self.isShowEndGame = false;
        }
    }  else if ([state isEqualToString:MG_COMMON_GAME_ASR]) {
        NSLog(@"ASR");
        GameCommonModel *m = [GameCommonModel mj_objectWithKeyValues: dataJson];
        if (m.isOpen) {
            self.keyWordASRing = YES;
            /// 语音采集
            [self startCaptureAudioToASR];
        } else {
            self.keyWordASRing = NO;
            [self stopCapture];
        }
    } else {
        /// 其他状态
        /// TODO
        NSLog(@"ISudFSMMG:onGameStateChange:游戏->APP:state:%@", state);
    }
    
    /// 回调
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(0), @"ret_code", @"success", @"ret_msg", nil];
    [handle success:[AppUtil dictionaryToJson:dict]];
}

/**
 * 游戏玩家状态变化
 * @param handle 回调句柄
 * @param userId 用户id
 * @param state  玩家状态
 * @param dataJson 回调JSON
 */
- (void)onPlayerStateChange:(nullable id<ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId state:(nonnull NSString *)state dataJson:(nonnull NSString *)dataJson {
    GamePlayerStateModel *m = [GamePlayerStateModel mj_objectWithKeyValues: dataJson];
    m.userId = userId;
    m.state = state;
    
    if (![m.state isEqualToString:MG_COMMON_PLAYER_CAPTAIN]) {
        [GameManager.shared.gamePlayerStateMap setValue:m forKey:userId];
    }
    
    /// 处理状态解析
    [self handleGameState:m];
    
    /// 通知麦位处理ui
    [[NSNotificationCenter defaultCenter]postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:@{@"model":m}];

    /// 回调
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(0), @"ret_code", @"success", @"ret_msg", nil];
    [handle success:[AppUtil dictionaryToJson:dict]];
}

#pragma mark - 状态解析
- (void)handleGameState: (GamePlayerStateModel *)m {
    NSString *state = m.state;
    /// 状态解析
    NSString *dataStr = @"";
    if ([state isEqualToString:MG_COMMON_PLAYER_IN]) {
        dataStr = @"玩家: 加入状态";
        self.gameInfoModel.isInGame = m.isIn;
        if (m.isIn && m.userId == AppManager.shared.loginUserInfo.userID) {
            // 请求上麦
            BOOL isUpMic = false;
            NSArray *arr = self.dicMicModel.allValues;
            for (AudioRoomMicModel *m in arr) {
                if (m.user != nil && m.user.userID == AppManager.shared.loginUserInfo.userID) {
                    isUpMic = true;
                }
            }
            if (!isUpMic) {
                [self handleTapVoice];
            }
        }
        if (!m.isIn) {
            [GameManager.shared.gamePlayerStateMap removeObjectForKey:m.userId];
        }
    } else if ([state isEqualToString:MG_COMMON_PLAYER_READY]) {
        dataStr = @"玩家: 准备状态";
        self.gameInfoModel.isReady = m.isReady;
    } else if ([state isEqualToString:MG_COMMON_PLAYER_CAPTAIN]) {
        dataStr = @"玩家: 队长状态";
        if (m.isCaptain) {
            GameManager.shared.captainUserId = m.userId;
        } else {
            if (GameManager.shared.captainUserId == m.userId) {
                GameManager.shared.captainUserId = @"";
            }
        }
    } else if ([state isEqualToString:MG_COMMON_PLAYER_PLAYING]) {
        dataStr = @"玩家: 游戏状态";
    } else if ([state isEqualToString:MG_DG_SELECTING]) {
        dataStr = @"你画我猜 玩家: 选词中";
    } else if ([state isEqualToString:MG_DG_PAINTING]) {
        dataStr = @"你画我猜 玩家: 作画中";
    } else if ([state isEqualToString:MG_DG_ERRORANSWER]) {
        dataStr = @"你画我猜 玩家: 错误答";
    } else if ([state isEqualToString:MG_DG_TOTALSCORE]) {
        dataStr = @"你画我猜 玩家: 总积分";
    } else if ([state isEqualToString:MG_DG_SCORE]) {
        dataStr = @"你画我猜 玩家: 本次积分";
    } else {
        NSLog(@"ISudFSMMG:onPlayerStateChange:未做解析状态:%@", MG_DG_SCORE);
    }
    NSLog(@"ISudFSMMG:onPlayerStateChange:dataStr:%@", dataStr);
}


#pragma mark =======登录 加载 游戏=======
/// 游戏登录
/// 接入方客户端 调用 接入方服务端 login 获取 短期令牌code
/// 参考文档时序图：sud-mgp-doc(https://github.com/SudTechnology/sud-mgp-doc)
- (void)login {
    WeakSelf
    [GameManager.shared reqGameLoginWithSuccess:^(RespGameInfoModel * _Nonnull gameInfo) {
        weakSelf.gameInfoModel.code = gameInfo.code;
        [weakSelf loadGame];
    } fail:^(NSError *error) {
        [ToastUtil show:error.debugDescription];
    }];
}

/// 退出游戏
- (void)logoutGame {
    [self stopCapture];
    // 销毁游戏
    [self.iSudFSTAPP destroyMG];
}

/// 加载游戏
- (void)loadGame {
    NSString *appID = AppManager.shared.configModel.sudCfg.appId;
    NSString *appKey = AppManager.shared.configModel.sudCfg.appKey;
    if (appID.length == 0 || appKey.length == 0) {
        [ToastUtil show:@"Game appID or appKey is empty"];
        return;
    }
    [self initGameSDKWithAppID:appID appKey:appKey isTestEnv:YES mgID:self.gameId rootView:self.gameView];
}

/**
 * 初始化游戏SDK
 *
 * @param appID           NSString        项目的appID
 * @param appKey         NSString        项目的appKey
 * @param isTestEnv  Boolean         是否是测试环境，true:测试环境, false:正式环境
 * @param mgID             NSInteger      游戏ID，如 碰碰我最强:1001；飞刀我最强:1002；你画我猜:1003
 */
- (void)initGameSDKWithAppID:(NSString *)appID appKey:(NSString *)appKey isTestEnv:(Boolean)isTestEnv mgID:(int64_t)mgID rootView:(UIView*)rootView {
    WeakSelf
    [SudMGP initSDK:appID appKey:appKey isTestEnv:isTestEnv listener:^(int retCode, const NSString *retMsg) {
        if (retCode == 0) {
            NSLog(@"ISudFSMMG:initGameSDKWithAppID:初始化游戏SDK成功");
            if (weakSelf) {
                // SudMGPSDK初始化成功 加载MG
                NSString *userID =weakSelf.gameInfoModel.currentPlayerUserId;
                NSString *roomID = weakSelf.roomID;
                NSString *code = weakSelf.gameInfoModel.code;
                if (userID.length == 0 || roomID.length == 0 || code.length == 0) {
                    [ToastUtil show:@"加载游戏失败，请检查参数"];
                    return;
                }
                [weakSelf loadMG:userID roomId:roomID code:code mgId:mgID language:weakSelf.gameInfoModel.language fsmMG:weakSelf rootView:rootView];
            }
        } else {
            /// 初始化失败, 可根据业务重试
            NSLog(@"ISudFSMMG:initGameSDKWithAppID:初始化sdk失败 :%@",retMsg);
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
- (void)loadMG:(NSString *)userId roomId:(NSString *)roomId code:(NSString *)code mgId:(int64_t) mgId language:(NSString *)language fsmMG:(id)fsmMG rootView:(UIView*)rootView {
    self.iSudFSTAPP = [SudMGP loadMG:userId roomId:roomId code:code mgId:mgId language:language fsmMG:fsmMG rootView:rootView];
    self.sudFSTAPPManager = [[SudFSTAPPManager alloc] init:self.iSudFSTAPP];
}

/// 处理切换游戏
/// @param gameID 新的游戏ID
- (void)handleGameChange:(NSInteger)gameID {
    if (gameID == 0) {
        // 切换语音房间
        self.gameId = 0;
        self.roomType = HSAudio;
        return;
    }
    [self logoutGame];
    self.gameId = gameID;
    self.gameInfoModel.currentPlayerUserId = AppManager.shared.loginUserInfo.userID;
    [self login];
    self.roomType = HSGame;
}

/// 更新code
/// @param code 新的code
- (void)updateGameCode:(NSString *)code {
    [self.iSudFSTAPP updateCode:code listener:^(int retCode, const NSString *retMsg, const NSString *dataJson) {
        NSLog(@"ISudFSMMG:updateGameCode retCode=%@ retMsg=%@ dataJson=%@", @(retCode), retMsg, dataJson);
    }];
}

#pragma mark =======处理返回消息=======
- (void)handleRetCode:(NSString *)retCode errorMsg:(NSString *)msg {
//    [ToastUtil show:[NSString stringWithFormat:@"%@出错，错误码:%@", msg, retCode]];
}


/// 开始音频采集
- (void)startCaptureAudioToASR {
    [AudioEngineFactory.shared.audioEngine startCapture];
}

/// 停止音频采集
- (void)stopCapture {
    [AudioEngineFactory.shared.audioEngine stopCapture];
}

@end

