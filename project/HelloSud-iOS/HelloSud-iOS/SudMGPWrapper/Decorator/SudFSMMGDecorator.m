//
//  SudFSMMGManager.m
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/2/18.
//

#import "SudFSMMGDecorator.h"

@interface SudFSMMGDecorator ()
/// 事件处理器
@property(nonatomic, weak) id<SudFSMMGListener> listener;

@end

@implementation SudFSMMGDecorator

/// 设置事件处理器
/// @param listener 事件处理实例
- (void)setEventListener:(id<SudFSMMGListener>)listener {
    _listener = listener;
}


#pragma mark =======ISudFSMMG Delegate=======

/**
 * 游戏开始
 */
- (void)onGameStarted {
    NSLog(@"ISudFSMMG:onGameStarted:游戏开始");
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameStarted)]) {
        [self.listener onGameStarted];
    }
}

/**
 * 游戏销毁
 */
- (void)onGameDestroyed {
    NSLog(@"ISudFSMMG:onGameDestroyed:游戏销毁");
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameDestroyed)]) {
        [self.listener onGameDestroyed];
    }
}

/**
 * 游戏日志
 * 最低版本：v1.1.30.xx
 */
- (void)onGameLog:(nonnull NSString *)dataJson {
    NSLog(@"ISudFSMMG:onGameLog:%@", dataJson);
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameLog:)]) {
        [self.listener onGameLog:dataJson];
    }
}

/**
 * 短期令牌code过期  【需要实现】
 * APP接入方需要调用handle.success或handle.fail
 * @param dataJson {"code":"value"}
 */
- (void)onExpireCode:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    NSLog(@"ISudFSMMG:onExpireCode:Code过期");
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onExpireCode:dataJson:)]) {
        [self.listener onExpireCode:handle dataJson:dataJson];
    }
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
    NSLog(@"ISudFSMMG:onGetGameCfg:配置游戏Config");
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onGetGameCfg:dataJson:)]) {
        [self.listener onGetGameCfg:handle dataJson:dataJson];
    }
    [handle success:[self handleMGSuccess]];
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
    NSLog(@"ISudFSMMG:onGetGameViewInfo:配置游戏View信息");
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onGetGameViewInfo:dataJson:)]) {
        [self.listener onGetGameViewInfo:handle dataJson:dataJson];
        return;
    } else {
        /// 默认实现配置游戏区域
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
        [handle success:m.mj_JSONString];
    }
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
        MGCommonPublicMessageModel *m = [MGCommonPublicMessageModel mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonPublicMessage:model:)]) {
            [self.listener onGameMGCommonPublicMessage:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_KEY_WORD_TO_HIT]) {
        MGCommonKeyWrodToHitModel *m = [MGCommonKeyWrodToHitModel mj_objectWithKeyValues: dataJson];
        /// 更新当前状态
        [self updateCommonKeyWrodToHit:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonKeyWordToHit:model:)]) {
            [self.listener onGameMGCommonKeyWordToHit:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_STATE]) {
        MGCommonGameState *m = [MGCommonGameState mj_objectWithKeyValues: dataJson];
        /// 更新当前状态
        [self updateCommonGameState:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameState:model:)]) {
            [self.listener onGameMGCommonGameState:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_JOIN_BTN]) {
        MGCommonSelfClickJoinBtn *m = [MGCommonSelfClickJoinBtn mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickJoinBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickJoinBtn:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_CANCEL_JOIN_BTN]) {
        MGCommonSelfClickCancelJoinBtn *m = [MGCommonSelfClickCancelJoinBtn mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickCancelJoinBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickCancelJoinBtn:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_READY_BTN]) {
        MGCommonSelfClickReadyBtn *m = [MGCommonSelfClickReadyBtn mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickReadyBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickReadyBtn:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_CANCEL_READY_BTN]) {
        MGCommonSelfClickCancelReadyBtn *m = [MGCommonSelfClickCancelReadyBtn mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickCancelReadyBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickCancelReadyBtn:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_START_BTN]) {
        MGCommonSelfClickStartBtn *m = [MGCommonSelfClickStartBtn mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickStartBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickStartBtn:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_SHARE_BTN]) {
        MGCommonSelfClickShareBtn *m = [MGCommonSelfClickShareBtn mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickShareBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickShareBtn:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_STATE]) {
        MGCommonGameState *m = [MGCommonGameState mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameState:model:)]) {
            [self.listener onGameMGCommonGameState:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_GAME_SETTLE_CLOSE_BTN]) {
        MGCommonSelfClickGameSettleCloseBtn *m = [MGCommonSelfClickGameSettleCloseBtn mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickGameSettleCloseBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickGameSettleCloseBtn:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_GAME_SETTLE_AGAIN_BTN]) {
        MGCommonSelfClickGameSettleAgainBtn *m = [MGCommonSelfClickGameSettleAgainBtn mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickGameSettleAgainBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickGameSettleAgainBtn:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_SOUND_LIST]) {
        MGCommonGameSoundListModel *m = [MGCommonGameSoundListModel mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameSoundList:model:)]) {
            [self.listener onGameMGCommonGameSoundList:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_SOUND]) {
        MGCommonGameSound *m = [MGCommonGameSound mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameSound:model:)]) {
            [self.listener onGameMGCommonGameSound:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_BG_MUSIC_STATE]) {
        MGCommonGameBgMusicState *m = [MGCommonGameBgMusicState mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameBgMusicState:model:)]) {
            [self.listener onGameMGCommonGameBgMusicState:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_SOUND_STATE]) {
        MGCommonGameSoundState *m = [MGCommonGameSoundState mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameSoundState:model:)]) {
            [self.listener onGameMGCommonGameSoundState:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_ASR]) {
        MGCommonGameASRModel *m = [MGCommonGameASRModel mj_objectWithKeyValues: dataJson];
        /// 更新当前状态
        [self updateCommonGameASR:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameASR:model:)]) {
            [self.listener onGameMGCommonGameASR:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_SELF_MICROPHONE]) {
        MGCommonGameSelfMicrophone *m = [MGCommonGameSelfMicrophone mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameSelfMicrophone:model:)]) {
            [self.listener onGameMGCommonGameSelfMicrophone:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_SELF_HEADEPHONE]) {
        MGCommonGameSelfHeadphone *m = [MGCommonGameSelfHeadphone mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameSelfHeadphone:model:)]) {
            [self.listener onGameMGCommonGameSelfHeadphone:handle model:m];
            return;
        }
    } else {
        /// 其他状态
        NSLog(@"ISudFSMMG:onGameStateChange:游戏->APP:state:%@", state);
    }
    
    [handle success:[self handleMGSuccess]];
}


/**
 * 游戏玩家状态变化
 * @param handle 回调句柄
 * @param userId 用户id
 * @param state  玩家状态
 * @param dataJson 回调JSON
 */
- (void)onPlayerStateChange:(nullable id<ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId state:(nonnull NSString *)state dataJson:(nonnull NSString *)dataJson {
    NSLog(@"%@", [NSString stringWithFormat:@"ISudFSMMG:userId:%@, onPlayerStateChange:%@ --dataJson:%@", userId, state, dataJson]);
    
    if ([state isEqualToString:MG_COMMON_PLAYER_IN]) {
        MGCommonPlayerInModel *m = [MGCommonPlayerInModel mj_objectWithKeyValues: dataJson];
        /// 更新
        [self setValueGamePlayerStateMap:userId state:state model:m];
        [self updateCommonPlayerIn:m userId:userId];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonPlayerIn:userId:model:)]) {
            [self.listener onPlayerMGCommonPlayerIn:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_PLAYER_READY]) {
        MGCommonPlayerReadyModel *m = [MGCommonPlayerReadyModel mj_objectWithKeyValues: dataJson];
        /// 更新
        [self setValueGamePlayerStateMap:userId state:state model:m];
        self.isReady = m.isReady;
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonPlayerReady:userId:model:)]) {
            [self.listener onPlayerMGCommonPlayerReady:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_PLAYER_CAPTAIN]) {
        MGCommonPlayerCaptainModel *m = [MGCommonPlayerCaptainModel mj_objectWithKeyValues: dataJson];
        /// 更新
        [self updateCommonPlayerCaptain:m userId:userId];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonPlayerCaptain:userId:model:)]) {
            [self.listener onPlayerMGCommonPlayerCaptain:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_PLAYER_PLAYING]) {
        MGCommonPlayerPlayingModel *m = [MGCommonPlayerPlayingModel mj_objectWithKeyValues: dataJson];
        self.isPlaying = m.isPlaying;
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonPlayerPlaying:userId:model:)]) {
            [self.listener onPlayerMGCommonPlayerPlaying:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_PLAYER_ONLINE]) {
        MGCommonPlayerOnlineModel *m = [MGCommonPlayerOnlineModel mj_objectWithKeyValues: dataJson];
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonPlayerOnline:userId:model:)]) {
            [self.listener onPlayerMGCommonPlayerOnline:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_PLAYER_CHANGE_SEAT]) {
        MGCommonPlayerChangeSeatModel *m = [MGCommonPlayerChangeSeatModel mj_objectWithKeyValues: dataJson];
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonPlayerChangeSeat:userId:model:)]) {
            [self.listener onPlayerMGCommonPlayerChangeSeat:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_GAME_PLAYER_ICON]) {
        MGCommonSelfClickGamePlayerIconModel *m = [MGCommonSelfClickGamePlayerIconModel mj_objectWithKeyValues: dataJson];
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonSelfClickGamePlayerIcon:userId:model:)]) {
            [self.listener onPlayerMGCommonSelfClickGamePlayerIcon:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_DG_SELECTING]) {
        MGDGSelectingModel *m = [MGDGSelectingModel mj_objectWithKeyValues: dataJson];
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGDGSelecting:userId:model:)]) {
            [self.listener onPlayerMGDGSelecting:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_DG_PAINTING]) {
        MGDGPaintingModel *m = [MGDGPaintingModel mj_objectWithKeyValues: dataJson];
        if (m.isPainting) {
            [self setValueGamePlayerStateMap:userId state:state model:m];
        }
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGDGPainting:userId:model:)]) {
            [self.listener onPlayerMGDGPainting:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_DG_ERRORANSWER]) {
        MGDGErrorAnswerModel *m = [MGDGErrorAnswerModel mj_objectWithKeyValues: dataJson];
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGDGErrorAnswer:userId:model:)]) {
            [self.listener onPlayerMGDGErrorAnswer:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_DG_TOTALSCORE]) {
        MGDGTotalScoreModel *m = [MGDGTotalScoreModel mj_objectWithKeyValues: dataJson];
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGDGTotalScore:userId:model:)]) {
            [self.listener onPlayerMGDGTotalScore:handle userId:userId model:m];
            return;
        } else {
            [handle success:[self handleMGSuccess]];
        }
    } else if ([state isEqualToString:MG_DG_SCORE]) {
        MGDGScoreModel *m = [MGDGScoreModel mj_objectWithKeyValues: dataJson];
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGDGScore:userId:model:)]) {
            [self.listener onPlayerMGDGScore:handle userId:userId model:m];
            return;
        }
    } else {
        NSLog(@"ISudFSMMG:onPlayerStateChange:未做解析状态");
    }
    [handle success:[self handleMGSuccess]];
}

#pragma mark - GameState状态处理
/// 关键词获取状态 - 更新
- (void)updateCommonKeyWrodToHit:(MGCommonKeyWrodToHitModel *)m {
    self.drawKeyWord = m.word;
    if (m.word == (id) [NSNull null] || [m.word isEqualToString:@""]) {
        self.keyWordHiting = false;
    } else {
        self.keyWordHiting = true;
    }
    if ([m.wordType isEqualToString:@"number"]) {
        self.isHitBomb = true;
    }
}

/// 游戏状态 - 更新
- (void)updateCommonGameState:(MGCommonGameState *)m {
    self.gameStateType = m.gameState;
    if (m.gameState != 2) {
        self.isHitBomb = false;
    }
}

/// ASR状态 - 更新
- (void)updateCommonGameASR:(MGCommonGameASRModel *)m {
    if (m.isOpen) {
        self.keyWordASRing = YES;
    } else {
        self.keyWordASRing = NO;
    }
}

#pragma mark - PlayerState状态处理
/// 加入状态 - 更新
- (void)updateCommonPlayerIn:(MGCommonPlayerInModel *)m userId:(nonnull NSString *)userId  {
    
    if (userId == AppService.shared.login.loginUserInfo.userID) {
        self.isInGame = m.isIn;
    }
    
    if (m.isIn) {
        [self.onlineUserIdList addObject:userId];
        NSSet *set = [NSSet setWithArray:self.onlineUserIdList];
        [self.onlineUserIdList setArray:[set allObjects]];
    } else {
        [self.gamePlayerStateMap removeObjectForKey:userId];
        if (self.onlineUserIdList.count > 0) {
            NSMutableArray *arrTemp = [[NSMutableArray alloc]initWithArray:self.onlineUserIdList];
            for (NSString *item in arrTemp) {
                if ([item isEqualToString:userId]) {
                    [self.onlineUserIdList removeObject:userId];
                }
            }
        }
    }
}

/// 队长状态 - 更新
- (void)updateCommonPlayerCaptain:(MGCommonPlayerCaptainModel *)m userId:(nonnull NSString *)userId  {
    if (m.isCaptain) {
        self.captainUserId = userId;
    } else {
        if ([self.captainUserId isEqualToString:userId]) {
            self.captainUserId = @"";
        }
    }
}

/// 存储playerMap
- (void)setValueGamePlayerStateMap:(NSString *)userId state:(NSString *)state model:(id)model {
    MGPlayerStateMapModel *mapModel = MGPlayerStateMapModel.new;
    mapModel.state = state;
    mapModel.model = model;
    [self.gamePlayerStateMap setValue:mapModel forKey:userId];
}

/// 清除所有存储数组
- (void)clearAllStates {
    [self.onlineUserIdList removeAllObjects];
    self.drawKeyWord = @"";
    self.captainUserId = @"";
    self.keyWordHiting = false;
    self.isReady = false;
    self.isInGame = false;
    self.isHitBomb = false;
    self.keyWordASRing = false;
    self.isPlaying = false;
    self.gameStateType = GameStateTypeLeisure;
    [self.gamePlayerStateMap removeAllObjects];
}

/// 2MG成功回调
- (NSString *)handleMGSuccess {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(0), @"ret_code", @"success", @"ret_msg", nil];
    return dict.mj_JSONString;
}

/// 2MG失败回调
- (NSString *)handleMGFailure {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(0), @"ret_code", @"success", @"ret_msg", nil];
    return dict.mj_JSONString;
}

/// 获取用户加入状态
- (BOOL)isPlayerIn:(NSString *)userId {
    MGPlayerStateMapModel *mapModel = [self.gamePlayerStateMap objectForKey:userId];
    if ([mapModel.state isEqualToString:MG_COMMON_PLAYER_IN] && [mapModel.model isKindOfClass:MGCommonPlayerInModel.class]) {
        MGCommonPlayerInModel *m = mapModel.model;
        return m.isIn;
    }
    return false;
}

/// 获取用户是否在准备中
- (BOOL)isPlayerIsReady:(NSString *)userId {
    MGPlayerStateMapModel *mapModel = [self.gamePlayerStateMap objectForKey:userId];
    if ([mapModel.state isEqualToString:MG_COMMON_PLAYER_READY] && [mapModel.model isKindOfClass:MGCommonPlayerReadyModel.class]) {
        MGCommonPlayerReadyModel *m = mapModel.model;
        return m.isReady;
    }
    return false;
}

/// 获取用户是否在游戏中
- (BOOL)isPlayerIsPlaying:(NSString *)userId {
    MGPlayerStateMapModel *mapModel = [self.gamePlayerStateMap objectForKey:userId];
    if ([mapModel.state isEqualToString:MG_COMMON_PLAYER_PLAYING] && [mapModel.model isKindOfClass:MGCommonPlayerPlayingModel.class]) {
        MGCommonPlayerPlayingModel *m = mapModel.model;
        return m.isPlaying;
    }
    return false;
}

/// 获取用户是否已经加入了游戏
- (BOOL)isPlayerInGame:(NSString *)userId {
    MGPlayerStateMapModel *mapModel = [self.gamePlayerStateMap objectForKey:userId];
    if (mapModel != nil) {
        return true;
    }
    return false;
}

/// 获取用户是否在在绘画
- (BOOL)isPlayerPaining:(NSString *)userId {

    MGPlayerStateMapModel *mapModel = [self.gamePlayerStateMap objectForKey:userId];
    if ([mapModel.state isEqualToString:MG_DG_PAINTING] && [mapModel.model isKindOfClass:MGDGPaintingModel.class]) {
        MGDGPaintingModel *m = mapModel.model;
        return m.isPainting;
    }
    return false;

}

/// 获取用户是否在队长
- (BOOL)isPlayerIsCaptain:(NSString *)userId {
    BOOL isCaptain = [self.captainUserId isEqualToString:userId];
    return isCaptain;
}



- (NSMutableArray<NSString *> *)onlineUserIdList {
    if (_onlineUserIdList == nil) {
        _onlineUserIdList = NSMutableArray.new;
    }
    return _onlineUserIdList;;
}

- (NSMutableDictionary *)gamePlayerStateMap {
    if (_gamePlayerStateMap == nil) {
        _gamePlayerStateMap = NSMutableDictionary.new;
    }
    return _gamePlayerStateMap;
}

@end
