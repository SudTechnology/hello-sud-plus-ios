//
//  HSAudioRoomViewController+Game.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "HSAudioRoomViewController+Game.h"
#import <SudMGP/ISudFSMMG.h>
#import <SudMGP/ISudFSTAPP.h>
#import <SudMGP/SudMGP.h>
#import <SudMGP/ISudAPPD.h>
#import <SudMGP/ISudFSMStateHandle.h>

@implementation HSAudioRoomViewController(Game)

/// 游戏业务服务登录
- (void)loginGame {

    WeakSelf
    [HSGameManager.shared reqGameLoginWithSuccess:^(HSRespGameInfoDataModel * _Nonnull gameInfo) {
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
    NSString *appID = HSAppManager.shared.configData.sudCfg.appId;
    NSString *appKey = HSAppManager.shared.configData.sudCfg.appKey;
    if (appID.length == 0 || appKey.length == 0) {
        [ToastUtil show:@"Game appID or appKey is empty"];
        return;
    }
    [self initGameSDKWithAppID:appID appKey:appKey isTestEnv:YES mgID:self.gameId rootView:self.gameView];
}


#pragma mark =======ISudFSMMG Delegate=======
/**
 * Code过期
 * @param dataJson {"code":"value"}
 */
- (void)onExpireCode:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    NSLog(@"ISudFSMMG:onExpireCode:Code过期");
    // 请求业务服务器刷新令牌
    // Code更新
    [HSGameManager.shared reqGameLoginWithSuccess:^(HSRespGameInfoDataModel * _Nonnull gameInfo) {
        // 调用小游戏接口更新令牌
        [self updateGameCode:gameInfo.code];
    } fail:^(NSError *error) {
        [ToastUtil show:error.debugDescription];
    }];
    
    // 回调结果
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(0), @"ret_code", @"return form APP onExpireCode", @"ret_msg", nil];
    [handle success: [AppUtil dictionaryToJson: dict]];
}

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
 */
- (void)onGameLog:(nonnull NSString *)dataJson {
    NSLog(@"ISudFSMMG:onGameLog:%@", dataJson);
    NSDictionary * dic = [AppUtil turnStringToDictionary:dataJson];
    [self handleRetCode:[dic objectForKey:@"errorCode"] errorMsg:[dic objectForKey:@"msg"]];
}

/**
 * 获取游戏配置
 * @param handle 回调句柄
 * @param dataJson {}
 */
- (void)onGetGameCfg:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"ret_code"] = @(0);
    dict[@"ret_msg"] = @"success";
    NSString *dataJsonRet = @"";
    NSData *dataJsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    if (dataJsonData != nil) {
        dataJsonRet = [[NSString alloc]initWithData:dataJsonData encoding:NSUTF8StringEncoding];
    }
    [handle success:dataJsonRet];
}

/**
 * 获取游戏View信息
 * @param handle 回调句柄
 * @param dataJson {}
 */
- (void)onGetGameViewInfo:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    CGFloat scale = [[UIScreen mainScreen] nativeScale];
    GameViewInfoModel *m = [[GameViewInfoModel alloc] init];
    GameViewSize *viewSize = [[GameViewSize alloc] init];
    viewSize.width = kScreenWidth * scale;
    viewSize.height = kScreenHeight * scale;
    ViewGameRect *viewRect = [[ViewGameRect alloc] init];
    viewRect.top = (kStatusBarHeight + 120) * scale;
    viewRect.left = 0;
    viewRect.bottom = (kAppSafeBottom + 150) * scale;
    viewRect.right = 0;
    m.ret_code = 0;
    m.ret_msg = @"success";
    m.view_size = viewSize;
    m.view_game_rect = viewRect;
    /// 回调
    [handle success:[AppUtil dictionaryToJson:m.mj_keyValues]];
}

/**
 * 游戏状态变化
 * @param handle 回调句柄
 * @param state 游戏状态
 * @param dataJson 回调json
 */
- (void)onGameStateChange:(nonnull id<ISudFSMStateHandle>)handle state:(nonnull NSString *)state dataJson:(nonnull NSString *)dataJson {
    
    if ([state isEqualToString:MG_COMMON_PUBLIC_MESSAGE]) {
        NSLog(@"ISudFSMMG:onGameStateChange:游戏->APP:公屏消息");
        GamePublicMsgModel *publicMsgModel = [GamePublicMsgModel mj_objectWithKeyValues: dataJson];
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
        
        HSAudioMsgSystemModel *msgModel = [HSAudioMsgSystemModel makeMsgWithAttr:attrMsg];
        [self addMsg:msgModel isShowOnScreen:YES];
    } else if ([state isEqualToString:MG_COMMON_KEY_WORD_TO_HIT]) {
        NSLog(@"ISudFSMMG:onGameStateChange:游戏->APP:你画我猜关键词获取");
        GameKeyWordHitModel *m = [GameKeyWordHitModel mj_objectWithKeyValues: dataJson];
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
    }  else if ([state isEqualToString:MG_COMMON_GAME_ASR]) {
        GameCommonModel *m = [GameCommonModel mj_objectWithKeyValues: dataJson];
        if (m.isOpen) {
            self.keyWordASRing = YES;
            /// 语音采集
            [self startCaptureAudioToASR];
        } else {
            self.keyWordASRing = NO;
            [self stopCapture];
        }
    }else {
        /// 其他状态
        /// TODO
        NSLog(@"ISudFSMMG:onGameStateChange:游戏->APP:state:%@", state);
    }
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
    [self handleGameState:m];
    
    /// 通知麦位处理ui
    [[NSNotificationCenter defaultCenter]postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:@{@"model":m}];

    /// 回调
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(0), @"ret_code", @"return form APP onPlayerStateChange", @"ret_msg", nil];
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
        if (m.isIn) {
            // 请求上麦
            
            BOOL isUpMic = false;
            NSArray *arr = self.dicMicModel.allValues;
            for (HSAudioRoomMicModel *m in arr) {
                if (m.user != nil && m.user.userID == HSAppManager.shared.loginUserInfo.userID) {
                    isUpMic = true;
                }
            }
            if (!isUpMic) {
                [self handleTapVoice];
            }
        }
        
    } else if ([state isEqualToString:MG_COMMON_PLAYER_READY]) {
        dataStr = @"玩家: 准备状态";
        self.gameInfoModel.isReady = m.isReady;
    } else if ([state isEqualToString:MG_COMMON_PLAYER_CAPTAIN]) {
        dataStr = @"玩家: 队长状态";
        HSGameManager.shared.captainUserId = m.userId;
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
/**
 * 初始化游戏SDK
 *
 * @param appID           NSString        项目的appID
 * @param appKey         NSString        项目的appKey
 * @param isTestEnv  Boolean         是否是测试环境，true:测试环境, false:正式环境
 * @param mgID             NSInteger      游戏ID，如 碰碰我最强:1001；飞刀我最强:1002；你画我猜:1003
 */
- (void)initGameSDKWithAppID:(NSString *)appID appKey:(NSString *)appKey isTestEnv:(Boolean)isTestEnv mgID:(int64_t)mgID rootView:(UIView*)rootView {
//    [ISudAPPD e:4];
//    [ISudAPPD d];
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
    self.fsm2MGManager = [[FSMApp2MGManager alloc] init:self.iSudFSTAPP];
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
    self.gameInfoModel.currentPlayerUserId = HSAppManager.shared.loginUserInfo.userID;
    [self loginGame];
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
    WeakSelf
    [self.audioCapture startAudioRecording:^(NSData * _Nonnull data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.iSudFSTAPP pushAudio:data];
        });
    }];
}

/// 停止音频采集
- (void)stopCapture {
    [self.audioCapture stopCapture];
}

@end

