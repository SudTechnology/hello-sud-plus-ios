//
//  BaseSceneGameEventHandler.m
//  HelloSudPlus
//
//  Created by kaniel on 2024/1/25.
//  Copyright © 2024 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseSceneGameEventHandler.h"

@implementation BaseSceneGameEventHandler

- (GameCfgModel *)onGetGameCfg {
    return [self.vc onGetGameCfg];
}


- (GameViewInfoModel *)onGetGameViewInfo {
    GameViewInfoModel *m = [[GameViewInfoModel alloc] init];
    CGRect gameViewRect = self.loadConfigModel.gameView.bounds;
    m.view_size.width = gameViewRect.size.width;
    m.view_size.height = gameViewRect.size.height;
    m.view_game_rect.top = (kStatusBarHeight + 120);
    m.view_game_rect.bottom = (kAppSafeBottom + 150);
    return m;
}

- (void)onGetCode:(NSString *)userId result:(void (^)(NSString * _Nonnull))result {
    
    // 请求业务服务器刷新令牌 Code更新
    [GameService.shared reqGameLoginWithAppId:nil success:^(RespGameInfoModel *gameInfo) {
        // 回调成功结果
        result(gameInfo.code);
    }                                    fail:^(NSError *error) {
        [ToastUtil show:error.debugDescription];
    }];
}

/// 游戏开始
- (void)onGameStarted {
    DDLogDebug(@"onGameStarted");
    [self.vc handleGameStared];
}

- (void)onGameDestroyed {
    [self.vc updateGamePeopleCount];
    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:nil];

}

/// 游戏: 准备按钮点击状态   MG_COMMON_SELF_CLICK_READY_BTN
- (void)onGameMGCommonSelfClickReadyBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickReadyBtn *)model {
    [self.vc onGameMGCommonSelfClickReadyBtn];
    [handle success:[self.vc.gameEventHandler.sudFSMMGDecorator handleMGSuccess]];
}

/// 游戏: 结算界面再来一局按钮点击状态   MG_COMMON_SELF_CLICK_GAME_SETTLE_AGAIN_BTN
- (void)onGameMGCommonSelfClickGameSettleAgainBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickGameSettleAgainBtn *)model {
    [self.vc onGameMGCommonSelfClickReadyBtn];
    [handle success:[self.vc.gameEventHandler.sudFSMMGDecorator handleMGSuccess]];
}

/// 游戏: 开始游戏按钮点击状态   MG_COMMON_SELF_CLICK_START_BTN
- (void)onGameMGCommonSelfClickStartBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickStartBtn *)model {
    [self.vc onGameMGCommonSelfClickStartBtn];
    [handle success:[self.vc.gameEventHandler.sudFSMMGDecorator handleMGSuccess]];
}

/// 通用状态-游戏
/// 游戏: 公屏消息状态    MG_COMMON_PUBLIC_MESSAGE
- (void)onGameMGCommonPublicMessage:(id <ISudFSMStateHandle>)handle model:(MGCommonPublicMessageModel *)model {
    [self updateCommonPublicMessageAddMsg:model];
    [handle success:[self.vc.gameEventHandler.sudFSMMGDecorator handleMGSuccess]];
}

/// 游戏: 关键词状态    MG_COMMON_KEY_WORD_TO_HIT
- (void)onGameMGCommonKeyWordToHit:(id <ISudFSMStateHandle>)handle model:(MGCommonKeyWrodToHitModel *)model {

    [handle success:[self.vc.gameEventHandler.sudFSMMGDecorator handleMGSuccess]];
}

/// 游戏: 游戏状态   MG_COMMON_GAME_STATE
- (void)onGameMGCommonGameState:(id <ISudFSMStateHandle>)handle model:(MGCommonGameState *)model {
    [handle success:[self.vc.gameEventHandler.sudFSMMGDecorator handleMGSuccess]];
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
        [self.vc stopCaptureAudioToASR];
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
        self.vc.isShowEndGame = true;
    } else {
        self.vc.isShowEndGame = false;
    }
    if ([AppService.shared.loginUserID isEqualToString:userId] && model.isCaptain) {
        [self.vc onHandleIsGameCaptain];
    }

    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 玩家: 游戏状态  MG_COMMON_PLAYER_PLAYING
- (void)onPlayerMGCommonPlayerPlaying:(id <ISudFSMStateHandle>)handle userId:(NSString *)userId model:(MGCommonPlayerPlayingModel *)model {
    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:nil];

    if ([AppService.shared.login.loginUserInfo.userID isEqualToString:self.sudFSMMGDecorator.captainUserId] && self.vc.gameEventHandler.sudFSMMGDecorator.isPlaying) {
        self.vc.isShowEndGame = true;
    } else {
        self.vc.isShowEndGame = false;
    }
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 你画我猜: 作画中状态  MG_DG_PAINTING
- (void)onPlayerMGDGPainting:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGDGPaintingModel *)model {
    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_PLAYER_STATE_CHANGED object:nil userInfo:nil];
    [handle success:[self.vc.gameEventHandler.sudFSMMGDecorator handleMGSuccess]];
}

/// 游戏: 麦克风状态   MG_COMMON_GAME_SELF_MICROPHONE
- (void)onGameMGCommonGameSelfMicrophone:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSelfMicrophone *)model {
    [self.vc handleGameTapVoice:model.isOn];
    [handle success:[self.vc.gameEventHandler.sudFSMMGDecorator handleMGSuccess]];
}

/// 游戏: 耳机（听筒，扬声器）状态   MG_COMMON_GAME_SELF_HEADEPHONE
- (void)onGameMGCommonGameSelfHeadphone:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSelfHeadphone *)model {
    if (model.isOn) {
        [AudioEngineFactory.shared.audioEngine startSubscribingStream];
    } else {
        [AudioEngineFactory.shared.audioEngine stopSubscribingStream];
    }
    [handle success:[self.vc.gameEventHandler.sudFSMMGDecorator handleMGSuccess]];
}

/// 元宇宙砂砂舞 指令回调  MG_COMMON_GAME_DISCO_ACTION
- (void)onGameMGCommonGameDiscoAction:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameDiscoActionModel *)model {

    DDLogDebug(@"onGameMGCommonGameDiscoAction: actionID:%@, isSuccess:%@", model.actionId, @(model.isSuccess));
}

/// 元宇宙砂砂舞 指令动作结束通知  MG_COMMON_GAME_DISCO_ACTION_END
- (void)onGameMGCommonGameDiscoActionEnd:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameDiscoActionEndModel *)model {
    DDLogDebug(@"onGameMGCommonGameDiscoActionEnd: actionID:%@, playerID:%@", model.actionId, model.playerId);
}

/// 创建订单 MG_COMMON_GAME_CREATE_ORDER
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

- (BOOL)onGameStateChange:(id<ISudFSMStateHandle>)handle state:(NSString *)state dataJson:(NSString *)dataJson {
    if ([state isEqualToString:@"mg_happy_goat_chat"]) {
        [self handleHappyGoatChat:dataJson];
        return YES;
    }
    return NO;
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
@end
