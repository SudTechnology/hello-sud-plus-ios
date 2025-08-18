//
//  BaseSceneGameEventHandler.m
//  HelloSudPlus
//
//  Created by kaniel on 2024/1/25.
//  Copyright © 2024 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseSceneGameEventHandler.h"
#import "SudAudioPlayer.h"

/// 大模型互动回调JSON数据结构
@interface AiRoomChatMsgModel : NSObject
/// 发送者id
@property(nonatomic, strong)NSString *uid;
/// base64语音数据（mp3）
@property(nonatomic, strong)NSString *audioData;
/// 文本内容
@property(nonatomic, strong)NSString *content;
@end

@implementation AiRoomChatMsgModel

@end

@interface BaseSceneGameEventHandler()
// AI代理人
@property(nonatomic, strong) id<ISudAiAgent> aiAgent;
// 用户播放语音状态
@property(nonatomic, strong)NSMutableDictionary *userAudioPlayStateMap;
/// 游戏玩家麦克风状态是否准备好
@property(nonatomic, assign)BOOL isGamePlayerMicStateOk;
@end


@implementation BaseSceneGameEventHandler

- (BOOL)isOpenAiAgent {
    return self.aiAgent != nil;
}


- (void)pushAudioToAiAgent:(NSData *)pcmData {
    if (self.aiAgent) {
        [self.aiAgent pushAudio:pcmData];
    }
}

- (void)pauseAudioToAiAgent {
    if (!self.aiAgent) {
        return;
    }
    [self.aiAgent pauseAudio];
}

- (void)sendTextToAiAgent:(NSString *)text {
    if (self.aiAgent) {
        [self.aiAgent sendText:text];
    }
}


- (void)createAiAgent:(id <ISudFSTAPP> )iSudFSTAPP {
    // 振魂石 和 飞行棋
    HSGameItem *gameItem = [AppService.shared getSceneGameInfo:self.loadConfigModel.gameId];
    if (gameItem.supportLlm) {
//    if (self.loadConfigModel.gameId == 1890346721291059202L || self.loadConfigModel.gameId == 1468180338417074177L) {
        self.aiAgent = [iSudFSTAPP getAiAgent];
        WeakSelf
        
        /// 监听AI大模型互动信息
        [self.aiAgent setOnRoomChatMessageListener:^(NSString * _Nonnull json) {

            [weakSelf handleAiRoomChatMsg:json];
        }];

    }
}


/// 处理大模型回调信息
/// - Parameter json: json字符串数据
- (void)handleAiRoomChatMsg:(NSString *)json {
    
    WeakSelf
    AiRoomChatMsgModel *aiRoomChatMsgModel = [AiRoomChatMsgModel mj_objectWithKeyValues:json];
    NSString *audioDataBase64 = aiRoomChatMsgModel.audioData;// infoDic[@"audioData"];
    NSString *playerId = aiRoomChatMsgModel.uid;// infoDic[@"userId"];
    DDLogDebug(@"handleAiRoomChatMsg:uid:%@,content:%@, audioData:%@", aiRoomChatMsgModel.uid, aiRoomChatMsgModel.content, @(aiRoomChatMsgModel.audioData.length));
    
    if (aiRoomChatMsgModel.content.length > 0 && aiRoomChatMsgModel.uid) {
        
        NSInteger uid = [aiRoomChatMsgModel.uid longLongValue];
        [UserService.shared asyncCacheUserInfo:@[@(uid)] forceRefresh:NO isAi:YES finished:^{
            
            HSUserInfoModel *userInfo = [UserService.shared getCacheUserInfo:uid];
            
            RoomCmdChatTextModel *msgModel = [RoomCmdChatTextModel makeMsg:aiRoomChatMsgModel.content];
            if (msgModel) {
                
                AudioUserModel *userModel = AudioUserModel.new;
                userModel.userID = [NSString stringWithFormat:@"%@",@(userInfo.userId)];
                userModel.name = userInfo.nickname;
                userModel.icon = userInfo.headImage;
                userModel.sex = [userInfo.gender isEqualToString:@"male"] ? 1 : 2;
                userModel.isAi = userInfo.ai;
                msgModel.sendUser = userModel;
                /// 公屏添加消息
                [self.vc addMsg:msgModel isShowOnScreen:YES];
            }
        }];
    }
    
    
    if (audioDataBase64) {
        NSData *audioData = [[NSData alloc]initWithBase64EncodedString:audioDataBase64 options:0];
        BOOL isPlyeByRtc = YES;
        if (isPlyeByRtc) {

            id audioEngine = AudioEngineFactory.shared.audioEngine;
            // rtc 如果支持本地播放，则选用
            if ([audioEngine respondsToSelector:@selector(playLocalAudio:)]) {
                
                SudRtcAudioItem *audioItem = [[SudRtcAudioItem alloc]init];
                audioItem.audioData = audioData;
                audioItem.extra = playerId;
                audioItem.playStateChangedBlock = ^(SudRtcAudioItem *item, SudRtcAudioItemPlayerState playerState) {
                    [weakSelf handleUserPlayerAudioState:item.extra state:playerState];
                };
                [audioEngine playLocalAudio:audioItem];
                return;
            }
        }
        // 自行创建播放器播放
        SudAudioItem *audioItem = [[SudAudioItem alloc]init];
        audioItem.audioData = audioData;
        audioItem.extra = playerId;
        audioItem.playStateChangedBlock = ^(SudAudioItem *item, SudAudioItemPlayerState playerState) {
            [weakSelf handleUserPlayerAudioState:item.extra state:playerState];
        };
        [SudAudioPlayer.shared playeAudioMulti:audioItem];
    }
    

}


- (GameCfgModel *)onGetGameCfg {
    return [self.vc onGetGameCfg];
}


- (GameViewInfoModel *)onGetGameViewInfo {
    GameViewInfoModel *m = [super onGetGameViewInfo];
    m.view_game_rect.top = (kStatusBarHeight + 120);
    m.view_game_rect.bottom = (kAppSafeBottom + 150);
    return m;
}

- (void)onGetCode:(nonnull NSString *)userId success:(nonnull SudGmSuccessStringBlock)success fail:(nonnull SudGmFailedBlock)fail {
    
    // 请求业务服务器刷新令牌 Code更新
    [GameService.shared reqGameLoginWithAppId:nil success:^(RespGameInfoModel *gameInfo) {
        // 回调成功结果
        if (success) {
            success(gameInfo.code);
        }
    }                                    fail:^(NSError *error) {
        [ToastUtil show:error.debugDescription];
        if (fail) {
            fail(error.code, error.debugDescription);
        }
    }];
}

/// 游戏开始
- (void)onGameStarted {
    DDLogDebug(@"onGameStarted");
    [self.vc handleGameStared];
    /// 创建AI大模型互动
    [self createAiAgent: self.sudFSTAPPDecorator.iSudFSTAPP];
}


- (void)onGameDestroyed {
    [self.vc updateGamePeopleCount];
    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:nil];

}

/// 游戏: 准备按钮点击状态   MG_COMMON_SELF_CLICK_READY_BTN
- (void)onGameMGCommonSelfClickReadyBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickReadyBtn *)model {
    [self.vc onGameMGCommonSelfClickReadyBtn];
}

/// 游戏: 结算界面再来一局按钮点击状态   MG_COMMON_SELF_CLICK_GAME_SETTLE_AGAIN_BTN
- (void)onGameMGCommonSelfClickGameSettleAgainBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickGameSettleAgainBtn *)model {
    [self.vc onGameMGCommonSelfClickReadyBtn];
}

/// 游戏: 开始游戏按钮点击状态   MG_COMMON_SELF_CLICK_START_BTN
- (void)onGameMGCommonSelfClickStartBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickStartBtn *)model {
    [self.vc onGameMGCommonSelfClickStartBtn];
}

/// 通用状态-游戏
/// 游戏: 公屏消息状态    MG_COMMON_PUBLIC_MESSAGE
- (void)onGameMGCommonPublicMessage:(id <ISudFSMStateHandle>)handle model:(MGCommonPublicMessageModel *)model {
    [self updateCommonPublicMessageAddMsg:model];
}

/// 游戏: 关键词状态    MG_COMMON_KEY_WORD_TO_HIT
- (void)onGameMGCommonKeyWordToHit:(id <ISudFSMStateHandle>)handle model:(MGCommonKeyWrodToHitModel *)model {
}

/// 游戏: 游戏状态   MG_COMMON_GAME_STATE
- (void)onGameMGCommonGameState:(id <ISudFSMStateHandle>)handle model:(MGCommonGameState *)model {
    DDLogDebug(@"onGameMGCommonGameState:%@", @(model.gameState));
    // 游戏进行开始时，把麦位缩小
    if (model.gameState == 1) {
        [self.vc.gameMicContentView switchToSmallView];
    }
}

/// 游戏: ASR状态(开启和关闭语音识别状态   MG_COMMON_GAME_ASR
- (void)onGameMGCommonGameASR:(id <ISudFSMStateHandle>)handle model:(MGCommonGameASRModel *)model {
    /// 语音采集 || 停止采集
    if (model.isOpen) {
        [self.vc startCaptureAudioToASR];
    } else {
        // ai开启，不要中断
        if (self.isOpenAiAgent) {
            return;
        }
        [self.vc stopCaptureAudioToASR];
    }
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
    reqModel.mgId = [NSString stringWithFormat:@"%@", @(self.vc.gameId)];;
    reqModel.roomId = self.vc.gameRoomID;
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
}

/// 玩家: 准备状态  MG_COMMON_PLAYER_READY
- (void)onPlayerMGCommonPlayerReady:(id <ISudFSMStateHandle>)handle userId:(NSString *)userId model:(MGCommonPlayerReadyModel *)model {
    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:nil];
}

/// 玩家: 队长状态  MG_COMMON_PLAYER_CAPTAIN
- (void)onPlayerMGCommonPlayerCaptain:(id <ISudFSMStateHandle>)handle userId:(NSString *)userId model:(MGCommonPlayerCaptainModel *)model {
    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:nil];

    if ([AppService.shared.login.loginUserInfo.userID isEqualToString:userId] && self.sudFSMMGDecorator.isPlaying && model.isCaptain) {
        self.vc.isShowEndGame = true;
    } else {
        self.vc.isShowEndGame = false;
    }
    if ([AppService.shared.loginUserID isEqualToString:userId] && model.isCaptain) {
        [self.vc onHandleIsGameCaptain];
    }

}

/// 玩家: 游戏状态  MG_COMMON_PLAYER_PLAYING
- (void)onPlayerMGCommonPlayerPlaying:(id <ISudFSMStateHandle>)handle userId:(NSString *)userId model:(MGCommonPlayerPlayingModel *)model {
    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:nil];

    if ([AppService.shared.login.loginUserInfo.userID isEqualToString:self.sudFSMMGDecorator.captainUserId] && self.vc.gameEventHandler.sudFSMMGDecorator.isPlaying) {
        self.vc.isShowEndGame = true;
    } else {
        self.vc.isShowEndGame = false;
    }
}

/// 你画我猜: 作画中状态  MG_DG_PAINTING
- (void)onPlayerMGDGPainting:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGDGPaintingModel *)model {
    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:nil];
}

/// 游戏: 麦克风状态   MG_COMMON_GAME_SELF_MICROPHONE
- (void)onGameMGCommonGameSelfMicrophone:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSelfMicrophone *)model {
    [self.vc handleGameTapVoice:model.isOn];
}

/// 游戏: 耳机（听筒，扬声器）状态   MG_COMMON_GAME_SELF_HEADEPHONE
- (void)onGameMGCommonGameSelfHeadphone:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSelfHeadphone *)model {
    if (model.isOn) {
        [AudioEngineFactory.shared.audioEngine startSubscribingStream];
    } else {
        [AudioEngineFactory.shared.audioEngine stopSubscribingStream];
    }
}

/// 元宇宙砂砂舞 指令回调  MG_COMMON_GAME_DISCO_ACTION
- (void)onGameMGCommonGameDiscoAction:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameDiscoActionModel *)model {
    DDLogDebug(@"onGameMGCommonGameDiscoAction: actionID:%@, isSuccess:%@", model.actionId, @(model.isSuccess));
}

/// 元宇宙砂砂舞 指令动作结束通知  MG_COMMON_GAME_DISCO_ACTION_END
- (void)onGameMGCommonGameDiscoActionEnd:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameDiscoActionEndModel *)model {
    
    DDLogDebug(@"onGameMGCommonGameDiscoActionEnd: actionID:%@, playerID:%@", model.actionId, model.playerId);
}

/// Create Order MG_COMMON_GAME_CREATE_ORDER
- (void)onGameMGCommonGameCreateOrder:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGameCreateOrderModel *)model {
    

    ReqAppOrderModel *reqModel = ReqAppOrderModel.new;
    reqModel.roomId = self.vc.roomID;
    reqModel.gameId = self.vc.gameId;
    reqModel.value = model.value;
    reqModel.cmd = model.cmd;
    reqModel.fromUid = model.fromUid;
    reqModel.toUid = model.toUid;
    reqModel.payload = model.payload;
    
    [AudioRoomService reqAppOrder:reqModel finished:^(BaseRespModel * _Nonnull respModel) {
        DDLogDebug(@"reqAppOrder success");
        AppCommonGameCreateOrderResult *m = AppCommonGameCreateOrderResult.new;
        m.result = 1;
        [self.vc.gameEventHandler.sudFSTAPPDecorator notifyAppCommonGameCreateOrderResult:m];
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"reqAppOrder fail:%@", error.debugDescription);
        AppCommonGameCreateOrderResult *m = AppCommonGameCreateOrderResult.new;
        m.result = 0;
        [self.vc.gameEventHandler.sudFSTAPPDecorator notifyAppCommonGameCreateOrderResult:m];
    }];
}

/// 游戏向app发送获取玩家持有的道具卡（只支持大富翁） MG_COMMON_GAME_PLAYER_MONOPOLY_CARDS
- (void)onGameMGPlayerMonopolyCards:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGamePlayerMonopolyCardsModel *)model {
    
 
    [AudioRoomService reqMonopolyCardsWithFinished:^(BaseRespModel * _Nonnull respModel) {
    
        RespMonopolyModel *resp = (RespMonopolyModel *)respModel;
        AppCommonGamePlayerMonopolyCards *cards = AppCommonGamePlayerMonopolyCards.new;
        cards.reroll_card_count = resp.rerollCardCount;
        cards.free_rent_card_count = resp.freeRentCardCount;
        cards.ctrl_dice_card_count = resp.ctrlDiceCardCount;
        [self.vc.gameEventHandler.sudFSTAPPDecorator notifyAppCommonGamePlayerMonopolyCards:cards];
    } failure:nil];
    
    
}


- (void)onGameMgCommonGamePlayerPropsCards:(id<ISudFSMStateHandle>)handle model:(MgCommonGamePlayerPropsCardsModel *)model {
    
        
    ReqPlayerPropsCardsParamModel *req = ReqPlayerPropsCardsParamModel.new;
    req.gameId = self.loadConfigModel.gameId;
    [AudioRoomService reqPlayerPropsCards:req finished:^(BaseRespModel * _Nonnull respModel) {
    
        RespPlayerPropsCardsModel *resp = (RespPlayerPropsCardsModel *)respModel;
        AppCommonGamePlayerPropsCards *cards = AppCommonGamePlayerPropsCards.new;
        cards.props = resp.props;
        [self.vc.gameEventHandler.sudFSTAPPDecorator notifyAppCommonGamePlayerPropsCards:cards];
    } failure:nil];
}

- (void)onGameLoadingProgress:(int)stage retCode:(int)retCode progress:(int)progress {
    NSLog(@"onGameLoadingProgress:stage:%@ retCode:%@, progress:%@", @(stage), @(retCode), @(progress));
}

#pragma mark =======Comonn状态处理=======

/// 公屏消息状态 ---> 添加公屏消息
- (void)updateCommonPublicMessageAddMsg:(MGCommonPublicMessageModel *)model {
    NSMutableAttributedString *attrMsg = [[NSMutableAttributedString alloc] init];
    for (GamePublicMsg *m in model.msg) {
        if (m.phrase == 2) {
            [attrMsg appendAttributedString:[AppUtil getAttributedStringWithString:m.user.name color:m.user.color]];
        } else if (m.phrase == 1) {
            NSString *textString = m.text.mj_keyValues[self.vc.language];
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
        [self.vc addMsg:msgModel isShowOnScreen:YES];
    } else {
        NSLog(@"error msg is empty");
    }

}

- (void)onGameMgCommonDestroyGameScene:(id<ISudFSMStateHandle>)handle model:(MgCommonDestroyGameSceneModel *)model {
    
    [self.vc switchToGame:0];
}

- (void)onGameMGCommonGameMoneyNotEnough:(id<ISudFSMStateHandle>)handle model:(MgCommonGameMoneyNotEnoughModel *)model {
    
    [UserService.shared reqAddUserCoin:^(int64_t i) {
        AppCommonUpdateGameMoney *model = AppCommonUpdateGameMoney.new;
        [self.sudFSTAPPDecorator notifyAppCommonUpdateGameMoney:model];
    } fail:^(NSString *str) {
        [ToastUtil show:str];
    }];
}

- (void)onGameStateChange:(id<ISudFSMStateHandle>)handle state:(NSString *)state dataJson:(NSString *)dataJson {
    
    if ([state isEqualToString:@"mg_happy_goat_chat"]) {
        [self handleHappyGoatChat:dataJson];
    }
}

- (void)handleHappyGoatChat:(NSString *)dataJson {
    DDLogDebug(@"handleHappyGoatChat:%@", dataJson);
    NSDictionary *dataDic = [dataJson mj_JSONObject];
    NSString *icon = dataDic[@"icon"];
    NSString *nickname = dataDic[@"nickname"];
    NSArray *textArr = dataDic[@"data"];
    
    AudioUserModel *userModel = AudioUserModel.new;
    userModel.name = nickname;
    userModel.icon = icon;
    if ([textArr isKindOfClass:NSArray.class]) {
        for (NSDictionary *itemDic in textArr) {
            NSString *text = itemDic[@"text"][@"text"];
            if (text && [text isKindOfClass:NSString.class]) {
                
                /// 发送文本消息
                RoomCmdChatTextModel *m = [RoomCmdChatTextModel makeMsg:text];
                m.sendUser = userModel;
                m.skipParseGameKey = YES;
                [kDiscoRoomService.currentRoomVC sendMsg:m isAddToShow:YES finished:nil];
            }
        }
    }

}

#pragma mark =======玩家状态处理=======

/// 加入状态处理
- (void)updatePlayerCommonPlayerIn:(MGCommonPlayerInModel *)model userId:(NSString *)userId {
    if (model.isIn && [AppService.shared.login.loginUserInfo.userID isEqualToString:userId]) {
        // 请求上麦
        [self.vc handleGameUpMic];
    }
    [self.vc updateGamePeopleCount];
    [self.vc playerIsInGameStateChanged:userId];
}

- (void)onGameMGCommonGameUiCustomConfig:(id<ISudFSMStateHandle>)handle model:(MgCommonGameUiCustomConfigModel *)model {
    
//    // UI自定义
//    AppCommonGameUiCustomConfigLudo *ludo = AppCommonGameUiCustomConfigLudo.new;
//    ludo.chessYellow = @"";
//    
//    [self.vc.gameEventHandler.sudFSTAPPDecorator notifyAppCommonGameUiCustomConfig:ludo];
    
}
- (void)onGameMgCommonAiModelMessage:(id<ISudFSMStateHandle>)handle model:(MgCommonAiModelMessageModel *)model {
    [self.vc handleGameAiModelMeassage:model];
}

- (void)onGameMgCommonAiMessage:(id<ISudFSMStateHandle>)handle model:(MgCommonAiMessageModel *)model {
    
    NSInteger uid = model.uid.integerValue;
    [UserService.shared asyncCacheUserInfo:@[@(uid)] forceRefresh:NO finished:^{
        
        HSUserInfoModel *userInfo = [UserService.shared getCacheUserInfo:uid];
        
        RoomCmdChatTextModel *msgModel = [RoomCmdChatTextModel makeMsg:model.content];
        if (msgModel) {
            
            AudioUserModel *userModel = AudioUserModel.new;
            userModel.userID = [NSString stringWithFormat:@"%@",@(userInfo.userId)];
            userModel.name = userInfo.nickname;
            userModel.icon = userInfo.headImage;
            userModel.sex = [userInfo.gender isEqualToString:@"male"] ? 1 : 2;
            userModel.isAi = userInfo.ai;
            msgModel.sendUser = userModel;
            /// 公屏添加消息
            [self.vc addMsg:msgModel isShowOnScreen:YES];
        }
    }];

}

- (void)onGameMgCommonGamePlayerMicState:(id<ISudFSMStateHandle>)handle model:(MgCommonGamePlayerMicState *)model {
    self.isGamePlayerMicStateOk = YES;
    for (NSString *key in self.userAudioPlayStateMap.allKeys) {
        NSInteger state = [self.userAudioPlayStateMap[key] integerValue];
        [self sendGamePlayerAudioState:key state:state];
    }
}

/// 游戏通知app ai大模型消息内容 MG_COMMON_AI_MESSAGE
- (void)onGameMgCommonAiLargeScaleModelMsg:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonAiLargeScaleModelMsg *)model {
//    NSString *audioDataBase64 = model.audioData;
//    if (audioDataBase64) {
//        NSData *audioData = [[NSData alloc]initWithBase64EncodedString:audioDataBase64 options:0];
//
//        WeakSelf
//        SudAudioItem *audioItem = [[SudAudioItem alloc]init];
//        audioItem.audioData = audioData;
//        audioItem.extra = model.sendUser.playerId;
//        audioItem.playStateChangedBlock = ^(SudAudioItem *item, SudAudioItemPlayerState playerState) {
//            [weakSelf handleUserPlayerAudioState:item.extra state:playerState];
//        };
//        [SudAudioPlayer.shared playeAudioMulti:audioItem];
//    }
}


/// 处理玩家语音播放状态
/// - Parameters:
///   - userId: userId description
///   - state: state description
- (void)handleUserPlayerAudioState:(NSString *)userId state:(NSInteger)state {
    // 注意忽略重复状态，不发送重复状态给游戏
    id tempNum = self.userAudioPlayStateMap[userId];
    if (tempNum && [tempNum integerValue] == state) {
        return;
    }
    DDLogDebug(@"handleUserPlayerAudioState:%@,userId:%@", @(state), userId);
    self.userAudioPlayStateMap[userId] = @(state);
    [self sendGamePlayerAudioState:userId state:state];
}

/// 发送给游戏播放状态
- (void)sendGamePlayerAudioState:(NSString *)userId state:(NSInteger)state {
    // 没有开启AI或者游戏没有通知玩家麦克风准备好了， 别发
    if (!self.isOpenAiAgent || !self.isGamePlayerMicStateOk) {
        return;
    }
    AppCommonGamePlayerMicState *stateModel = AppCommonGamePlayerMicState.new;
    stateModel.state = SudAudioItemPlayerStatePlaying == state ? 1 : 0;
    stateModel.uid = userId;
    [self.sudFSTAPPDecorator notifyAppCommonGamePlayerMicState:stateModel];
}

- (NSMutableDictionary *)userAudioPlayStateMap {
    if (!_userAudioPlayStateMap) {
        _userAudioPlayStateMap = [[NSMutableDictionary alloc]init];
    }
    return _userAudioPlayStateMap;
}
@end
