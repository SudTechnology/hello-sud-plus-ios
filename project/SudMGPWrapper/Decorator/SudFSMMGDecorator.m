//
//  SudFSMMGManager.m
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/2/18.
//

#import "SudFSMMGDecorator.h"
#import "GameViewInfoModel.h"
#import "MGPlayerStateMapModel.h"
#import <MJExtension/MJExtension.h>

@interface SudFSMMGDecorator ()
/// 事件处理器
@property(nonatomic, weak) id <SudFSMMGListener> listener;
/// 当前用户ID
@property(nonatomic, strong) NSString *currentUserId;
@end

@implementation SudFSMMGDecorator

/// 设置事件处理器
/// @param listener 事件处理实例
- (void)setEventListener:(id <SudFSMMGListener>)listener {
    _listener = listener;
}

/// 设置当前用户ID
/// @param userId 当前用户ID
- (void)setCurrentUserId:(NSString *)userId {
    _currentUserId = userId;
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
    [self clearAllStates];
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
- (void)onExpireCode:(nonnull id <ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
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
- (void)onGetGameCfg:(nonnull id <ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
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
- (void)onGetGameViewInfo:(nonnull id <ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    NSLog(@"ISudFSMMG:onGetGameViewInfo:配置游戏View信息");
    if (self.listener != nil && [self.listener respondsToSelector:@selector(onGetGameViewInfo:dataJson:)]) {
        [self.listener onGetGameViewInfo:handle dataJson:dataJson];
        return;
    } else {
        /// 默认实现配置游戏区域
        UIEdgeInsets safeArea = [[UIApplication sharedApplication].keyWindow safeAreaInsets];
        CGFloat statusBarH = safeArea.top > 20 ? safeArea.top : 20;
        CGFloat safeBottom = safeArea.bottom;
        CGFloat scale = [[UIScreen mainScreen] nativeScale];
        GameViewInfoModel *m = [[GameViewInfoModel alloc] init];
        GameViewSize *viewSize = [[GameViewSize alloc] init];
        viewSize.width = UIScreen.mainScreen.bounds.size.width * scale;
        viewSize.height = UIScreen.mainScreen.bounds.size.height * scale;
        ViewGameRect *viewRect = [[ViewGameRect alloc] init];
        viewRect.top = (statusBarH + 120 + 20) * scale;
        viewRect.left = 0;
        viewRect.bottom = (safeBottom + 150) * scale;
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
- (void)onGameStateChange:(nonnull id <ISudFSMStateHandle>)handle state:(nonnull NSString *)state dataJson:(nonnull NSString *)dataJson {
    NSLog(@"%@", [NSString stringWithFormat:@"ISudFSMMG:onGameStateChange:%@ --dataJson:%@", state, dataJson]);

    if ([state isEqualToString:MG_COMMON_PUBLIC_MESSAGE]) {
        MGCommonPublicMessageModel *m = [MGCommonPublicMessageModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonPublicMessage:model:)]) {
            [self.listener onGameMGCommonPublicMessage:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_KEY_WORD_TO_HIT]) {
        MGCommonKeyWrodToHitModel *m = [MGCommonKeyWrodToHitModel mj_objectWithKeyValues:dataJson];
        /// 更新当前状态
        [self updateCommonKeyWrodToHit:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonKeyWordToHit:model:)]) {
            [self.listener onGameMGCommonKeyWordToHit:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_SETTLE]) {
        MGCommonGameSettleModel *m = [MGCommonGameSettleModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameSettle:model:)]) {
            [self.listener onGameMGCommonGameSettle:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_STATE]) {
        MGCommonGameState *m = [MGCommonGameState mj_objectWithKeyValues:dataJson];
        /// 更新当前状态
        [self updateCommonGameState:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameState:model:)]) {
            [self.listener onGameMGCommonGameState:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_JOIN_BTN]) {
        MGCommonSelfClickJoinBtn *m = [MGCommonSelfClickJoinBtn mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickJoinBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickJoinBtn:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_CANCEL_JOIN_BTN]) {
        MGCommonSelfClickCancelJoinBtn *m = [MGCommonSelfClickCancelJoinBtn mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickCancelJoinBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickCancelJoinBtn:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_READY_BTN]) {
        MGCommonSelfClickReadyBtn *m = [MGCommonSelfClickReadyBtn mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickReadyBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickReadyBtn:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_CANCEL_READY_BTN]) {
        MGCommonSelfClickCancelReadyBtn *m = [MGCommonSelfClickCancelReadyBtn mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickCancelReadyBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickCancelReadyBtn:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_START_BTN]) {
        MGCommonSelfClickStartBtn *m = [MGCommonSelfClickStartBtn mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickStartBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickStartBtn:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_SHARE_BTN]) {
        MGCommonSelfClickShareBtn *m = [MGCommonSelfClickShareBtn mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickShareBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickShareBtn:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_STATE]) {
        MGCommonGameState *m = [MGCommonGameState mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameState:model:)]) {
            [self.listener onGameMGCommonGameState:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_GAME_SETTLE_CLOSE_BTN]) {
        MGCommonSelfClickGameSettleCloseBtn *m = [MGCommonSelfClickGameSettleCloseBtn mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickGameSettleCloseBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickGameSettleCloseBtn:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_GAME_SETTLE_AGAIN_BTN]) {
        MGCommonSelfClickGameSettleAgainBtn *m = [MGCommonSelfClickGameSettleAgainBtn mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickGameSettleAgainBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickGameSettleAgainBtn:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_SOUND_LIST]) {
        MGCommonGameSoundListModel *m = [MGCommonGameSoundListModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameSoundList:model:)]) {
            [self.listener onGameMGCommonGameSoundList:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_SOUND]) {
        MGCommonGameSound *m = [MGCommonGameSound mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameSound:model:)]) {
            [self.listener onGameMGCommonGameSound:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_BG_MUSIC_STATE]) {
        MGCommonGameBgMusicState *m = [MGCommonGameBgMusicState mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameBgMusicState:model:)]) {
            [self.listener onGameMGCommonGameBgMusicState:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_SOUND_STATE]) {
        MGCommonGameSoundState *m = [MGCommonGameSoundState mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameSoundState:model:)]) {
            [self.listener onGameMGCommonGameSoundState:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_ASR]) {
        MGCommonGameASRModel *m = [MGCommonGameASRModel mj_objectWithKeyValues:dataJson];
        /// 更新当前状态
        [self updateCommonGameASR:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameASR:model:)]) {
            [self.listener onGameMGCommonGameASR:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_SELF_MICROPHONE]) {
        MGCommonGameSelfMicrophone *m = [MGCommonGameSelfMicrophone mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameSelfMicrophone:model:)]) {
            [self.listener onGameMGCommonGameSelfMicrophone:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_SELF_HEADEPHONE]) {
        MGCommonGameSelfHeadphone *m = [MGCommonGameSelfHeadphone mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameSelfHeadphone:model:)]) {
            [self.listener onGameMGCommonGameSelfHeadphone:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_DISCO_ACTION]) {
        /// 元宇宙砂砂舞 指令回调  MG_COMMON_GAME_DISCO_ACTION
        MGCommonGameDiscoActionModel *m = [MGCommonGameDiscoActionModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameDiscoAction:model:)]) {
            [self.listener onGameMGCommonGameDiscoAction:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_DISCO_ACTION_END]) {
        /// 元宇宙砂砂舞 指令动作结束通知  MG_COMMON_GAME_DISCO_ACTION_END
        MGCommonGameDiscoActionEndModel *m = [MGCommonGameDiscoActionEndModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameDiscoActionEnd:model:)]) {
            [self.listener onGameMGCommonGameDiscoActionEnd:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_APP_COMMON_SELF_X_RESP]) {
        /// App通用状态操作结果错误码（2022-05-10新增）
        MGCommonAppCommonSelfXRespModel *m = [MGCommonAppCommonSelfXRespModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonAppCommonSelfXResp:model:)]) {
            [self.listener onGameMGCommonAppCommonSelfXResp:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_ADD_AI_PLAYERS]) {
        /// 游戏通知app层添加陪玩机器人是否成功（2022-05-17新增）
        MGCommonGameAddAIPlayersModel *m = [MGCommonGameAddAIPlayersModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameAddAIPlayers:model:)]) {
            [self.listener onGameMGCommonGameAddAIPlayers:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_NETWORK_STATE]) {
        /// 游戏通知app层添当前网络连接状态（2022-06-21新增）
        MGCommonGameNetworkStateModel *m = [MGCommonGameNetworkStateModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameNetworkState)]) {
            [self.listener onGameMGCommonGameNetworkState];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_GET_SCORE]) {
        /// 游戏通知app获取积分 (2022-09-26新增)
        MGCommonGameGetScoreModel *m = [MGCommonGameGetScoreModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameGetScore:model:)]) {
            [self.listener onGameMGCommonGameGetScore:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_SET_SCORE]) {
        /// 游戏通知app带入积分 (2022-09-26新增)
        MGCommonGameSetScoreModel *m = [MGCommonGameSetScoreModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameSetScore:model:)]) {
            [self.listener onGameMGCommonGameSetScore:handle model:m];
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
- (void)onPlayerStateChange:(nullable id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId state:(nonnull NSString *)state dataJson:(nonnull NSString *)dataJson {
    NSLog(@"%@", [NSString stringWithFormat:@"ISudFSMMG:userId:%@, onPlayerStateChange:%@ --dataJson:%@", userId, state, dataJson]);

    if ([state isEqualToString:MG_COMMON_PLAYER_IN]) {
        MGCommonPlayerInModel *m = [MGCommonPlayerInModel mj_objectWithKeyValues:dataJson];
        /// 更新
        [self setValueGamePlayerStateMap:userId state:state model:m];
        [self updateCommonPlayerIn:m userId:userId];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonPlayerIn:userId:model:)]) {
            [self.listener onPlayerMGCommonPlayerIn:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_PLAYER_READY]) {
        MGCommonPlayerReadyModel *m = [MGCommonPlayerReadyModel mj_objectWithKeyValues:dataJson];
        /// 更新
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if ([userId isEqualToString:self.currentUserId]) {
            self.isReady = m.isReady;
        }
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonPlayerReady:userId:model:)]) {
            [self.listener onPlayerMGCommonPlayerReady:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_PLAYER_CAPTAIN]) {
        MGCommonPlayerCaptainModel *m = [MGCommonPlayerCaptainModel mj_objectWithKeyValues:dataJson];
        /// 更新
        [self updateCommonPlayerCaptain:m userId:userId];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonPlayerCaptain:userId:model:)]) {
            [self.listener onPlayerMGCommonPlayerCaptain:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_PLAYER_PLAYING]) {
        MGCommonPlayerPlayingModel *m = [MGCommonPlayerPlayingModel mj_objectWithKeyValues:dataJson];
        if ([userId isEqualToString:self.currentUserId]) {
            self.isPlaying = m.isPlaying;
        }
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonPlayerPlaying:userId:model:)]) {
            [self.listener onPlayerMGCommonPlayerPlaying:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_PLAYER_ONLINE]) {
        MGCommonPlayerOnlineModel *m = [MGCommonPlayerOnlineModel mj_objectWithKeyValues:dataJson];
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonPlayerOnline:userId:model:)]) {
            [self.listener onPlayerMGCommonPlayerOnline:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_PLAYER_CHANGE_SEAT]) {
        MGCommonPlayerChangeSeatModel *m = [MGCommonPlayerChangeSeatModel mj_objectWithKeyValues:dataJson];
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonPlayerChangeSeat:userId:model:)]) {
            [self.listener onPlayerMGCommonPlayerChangeSeat:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_GAME_PLAYER_ICON]) {
        MGCommonSelfClickGamePlayerIconModel *m = [MGCommonSelfClickGamePlayerIconModel mj_objectWithKeyValues:dataJson];
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonSelfClickGamePlayerIcon:userId:model:)]) {
            [self.listener onPlayerMGCommonSelfClickGamePlayerIcon:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_DG_SELECTING]) {
        MGDGSelectingModel *m = [MGDGSelectingModel mj_objectWithKeyValues:dataJson];
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGDGSelecting:userId:model:)]) {
            [self.listener onPlayerMGDGSelecting:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_DG_PAINTING]) {
        MGDGPaintingModel *m = [MGDGPaintingModel mj_objectWithKeyValues:dataJson];
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGDGPainting:userId:model:)]) {
            [self.listener onPlayerMGDGPainting:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_DG_ERRORANSWER]) {
        MGDGErrorAnswerModel *m = [MGDGErrorAnswerModel mj_objectWithKeyValues:dataJson];
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGDGErrorAnswer:userId:model:)]) {
            [self.listener onPlayerMGDGErrorAnswer:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_DG_TOTALSCORE]) {
        MGDGTotalScoreModel *m = [MGDGTotalScoreModel mj_objectWithKeyValues:dataJson];
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGDGTotalScore:userId:model:)]) {
            [self.listener onPlayerMGDGTotalScore:handle userId:userId model:m];
            return;
        } else {
            [handle success:[self handleMGSuccess]];
        }
    } else if ([state isEqualToString:MG_DG_SCORE]) {
        MGDGScoreModel *m = [MGDGScoreModel mj_objectWithKeyValues:dataJson];
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGDGScore:userId:model:)]) {
            [self.listener onPlayerMGDGScore:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_DIE_STATUS]) {
        /// 游戏通知app玩家死亡状态（2022-04-24新增）
        MGCommonSelfDieStatusModel *m = [MGCommonSelfDieStatusModel mj_objectWithKeyValues:dataJson];
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonSelfDieStatus:userId:model:)]) {
            [self.listener onPlayerMGCommonSelfDieStatus:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_TURN_STATUS]) {
        /// 游戏通知app轮到玩家出手状态（2022-04-24新增）
        MGCommonSelfTurnStatusModel *m = [MGCommonSelfTurnStatusModel mj_objectWithKeyValues:dataJson];
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonSelfTurnStatus:userId:model:)]) {
            [self.listener onPlayerMGCommonSelfTurnStatus:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_SELECT_STATUS]) {
        /// 游戏通知app玩家选择状态（2022-04-24新增）
        MGCommonSelfSelectStatusModel *m = [MGCommonSelfSelectStatusModel mj_objectWithKeyValues:dataJson];
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonSelfSelectStatus:userId:model:)]) {
            [self.listener onPlayerMGCommonSelfSelectStatus:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_COUNTDOWN_TIME]) {
        /// 游戏通知app层当前游戏剩余时间（2022-05-23新增，目前UMO生效）
        MGCommonGameCountdownTimeModel *m = [MGCommonGameCountdownTimeModel mj_objectWithKeyValues:dataJson];
        [self setValueGamePlayerStateMap:userId state:state model:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonGameCountdownTime:userId:model:)]) {
            [self.listener onPlayerMGCommonGameCountdownTime:handle userId:userId model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_OB_STATUS]) {
        /// 游戏通知app层当前玩家死亡后变成ob视角 （2022-08-23新增，前狼人杀生效）
        MgCommonSelfObStatusModel *m = [MgCommonSelfObStatusModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfObStatus:model:)]) {
            [self.listener onGameMGCommonSelfObStatus:handle model:m];
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
- (void)updateCommonPlayerIn:(MGCommonPlayerInModel *)m userId:(nonnull NSString *)userId {

    if ([userId isEqualToString:self.currentUserId]) {
        self.isInGame = m.isIn;
    }

    if (m.isIn) {
        [self.onlineUserIdList addObject:userId];
        NSSet *set = [NSSet setWithArray:self.onlineUserIdList];
        [self.onlineUserIdList setArray:[set allObjects]];
    } else {
        [self.gamePlayerStateMap removeObjectForKey:[NSString stringWithFormat:@"%@%@", userId, MG_COMMON_PLAYER_IN]];
        if (self.onlineUserIdList.count > 0) {
            NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithArray:self.onlineUserIdList];
            for (NSString *item in arrTemp) {
                if ([item isEqualToString:userId]) {
                    [self.onlineUserIdList removeObject:userId];
                }
            }
        }
    }
}

/// 队长状态 - 更新
- (void)updateCommonPlayerCaptain:(MGCommonPlayerCaptainModel *)m userId:(nonnull NSString *)userId {
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
    [self.gamePlayerStateMap setValue:mapModel forKey:[NSString stringWithFormat:@"%@%@", userId, state]];
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
    NSDictionary *dict = @{@"ret_code": @(0), @"ret_msg": @"success"};
    return dict.mj_JSONString;
}

/// 2MG失败回调
- (NSString *)handleMGFailure {
    NSDictionary *dict = @{@"ret_code": @(0), @"ret_msg": @"fail"};
    return dict.mj_JSONString;
}

/// 获取用户加入状态
- (BOOL)isPlayerIn:(NSString *)userId {
    MGPlayerStateMapModel *mapModel = self.gamePlayerStateMap[[NSString stringWithFormat:@"%@%@", userId, MG_COMMON_PLAYER_IN]];
    if ([mapModel.model isKindOfClass:MGCommonPlayerInModel.class]) {
        MGCommonPlayerInModel *m = mapModel.model;
        return m.isIn;
    }
    return false;
}

/// 获取用户是否在准备中
- (BOOL)isPlayerIsReady:(NSString *)userId {
    MGPlayerStateMapModel *mapModel = self.gamePlayerStateMap[[NSString stringWithFormat:@"%@%@", userId, MG_COMMON_PLAYER_READY]];
    if ([mapModel.model isKindOfClass:MGCommonPlayerReadyModel.class]) {
        MGCommonPlayerReadyModel *m = mapModel.model;
        return m.isReady;
    }
    return false;
}

/// 获取用户是否在游戏中
- (BOOL)isPlayerIsPlaying:(NSString *)userId {
    MGPlayerStateMapModel *mapModel = self.gamePlayerStateMap[[NSString stringWithFormat:@"%@%@", userId, MG_COMMON_PLAYER_PLAYING]];
    if ([mapModel.model isKindOfClass:MGCommonPlayerPlayingModel.class]) {
        MGCommonPlayerPlayingModel *m = mapModel.model;
        return m.isPlaying;
    }
    return false;
}

/// 获取用户是否已经加入了游戏
- (BOOL)isPlayerInGame:(NSString *)userId {
    MGPlayerStateMapModel *mapModel = self.gamePlayerStateMap[[NSString stringWithFormat:@"%@%@", userId, MG_COMMON_PLAYER_IN]];
//    MGPlayerStateMapModel *mapModel = [self.gamePlayerStateMap objectForKey:userId];
    if (mapModel != nil) {
        return true;
    }
    return false;
}

/// 获取用户是否在在绘画
- (BOOL)isPlayerPaining:(NSString *)userId {
    MGPlayerStateMapModel *mapModel = self.gamePlayerStateMap[[NSString stringWithFormat:@"%@%@", userId, MG_DG_PAINTING]];
    if ([mapModel.model isKindOfClass:MGDGPaintingModel.class]) {
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
