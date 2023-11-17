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
    if ([self.listener respondsToSelector:@selector(onGameStateChange:state:dataJson:)]) {
        BOOL isHandled = [self.listener onGameStateChange:handle state:state dataJson:dataJson];
        if (isHandled) {
            return;
        }
    }

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
    } else if ([state isEqualToString:MG_COMMON_GAME_CREATE_ORDER]) {
        /// 创建订单 MG_COMMON_GAME_CREATE_ORDER
        MgCommonGameCreateOrderModel *m = [MgCommonGameCreateOrderModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameCreateOrder:model:)]) {
            [self.listener onGameMGCommonGameCreateOrder:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_CONFIG]) {
        /// 礼物配置文件(火箭)
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketConfig:)]) {
            [self.listener onGameMGCustomRocketConfig:handle];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_MODEL_LIST]) {
        /// 拥有模型列表(火箭)
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketModelList:)]) {
            [self.listener onGameMGCustomRocketModelList:handle];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_COMPONENT_LIST]) {
        /// 拥有组件列表(火箭)
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketComponentList:)]) {
            [self.listener onGameMGCustomRocketComponentList:handle];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_USER_INFO]) {
        /// 获取用户信息(火箭)
        MGCustomRocketUserInfo *m = [MGCustomRocketUserInfo mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketUserInfo:model:)]) {
            [self.listener onGameMGCustomRocketUserInfo:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_ORDER_RECORD_LIST]) {
        /// 订单记录列表(火箭)
        MGCustomRocketOrderRecordList *m = [MGCustomRocketOrderRecordList mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketOrderRecordList:model:)]) {
            [self.listener onGameMGCustomRocketOrderRecordList:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_ROOM_RECORD_LIST]) {
        /// 展馆内列表(火箭)
        MGCustomRocketRoomRecordList *m = [MGCustomRocketRoomRecordList mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketRoomRecordList:model:)]) {
            [self.listener onGameMGCustomRocketRoomRecordList:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_USER_RECORD_LIST]) {
        /// 展馆内玩家送出记录(火箭)
        MGCustomRocketUserRecordList *m = [MGCustomRocketUserRecordList mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketUserRecordList:model:)]) {
            [self.listener onGameMGCustomRocketUserRecordList:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_SET_DEFAULT_MODEL]) {
        /// 设置默认位置(火箭)
        MGCustomRocketSetDefaultSeat *m = [MGCustomRocketSetDefaultSeat mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketSetDefaultSeat:model:)]) {
            [self.listener onGameMGCustomRocketSetDefaultSeat:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_DYNAMIC_FIRE_PRICE]) {
        /// 动态计算一键发送价格(火箭)
        MGCustomRocketDynamicFirePrice *m = [MGCustomRocketDynamicFirePrice mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketDynamicFirePrice:model:)]) {
            [self.listener onGameMGCustomRocketDynamicFirePrice:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_FIRE_MODEL]) {
        /// 一键发送(火箭)
        MGCustomRocketFireModel *m = [MGCustomRocketFireModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketFireModel:model:)]) {
            [self.listener onGameMGCustomRocketFireModel:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_CREATE_MODEL]) {
        /// 新组装模型(火箭)
        MGCustomRocketCreateModel *m = [MGCustomRocketCreateModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketCreateModel:model:)]) {
            [self.listener onGameMGCustomRocketCreateModel:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_REPLACE_COMPONENT]) {
        /// 更换组件(火箭)
        MGCustomRocketReplaceModel *m = [MGCustomRocketReplaceModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketReplaceModel:model:)]) {
            [self.listener onGameMGCustomRocketReplaceModel:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_BUY_COMPONENT]) {
        /// 购买组件(火箭)
        MGCustomRocketBuyModel *m = [MGCustomRocketBuyModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketBuyModel:model:)]) {
            [self.listener onGameMGCustomRocketBuyModel:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_PLAY_EFFECT_START]) {
        /// 播放效果开始((火箭)
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketPlayEffectStart:)]) {
            [self.listener onGameMGCustomRocketPlayEffectStart:handle];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_PLAY_EFFECT_FINISH]) {
        /// 播放效果完成((火箭)
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketPlayEffectFinish:)]) {
            [self.listener onGameMGCustomRocketPlayEffectFinish:handle];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_VERIFY_SIGN]) {
        /// 验证签名合规((火箭)
        MGCustomRocketVerifySign *m = [MGCustomRocketVerifySign mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketVerifySign:model:)]) {
            [self.listener onGameMGCustomRocketVerifySign:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_UPLOAD_MODEL_ICON]) {
        /// 上传icon(火箭)
        MGCustomRocketUploadModelIcon *m = [MGCustomRocketUploadModelIcon mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketUploadModelIcon:model:)]) {
            [self.listener onGameMGCustomRocketUploadModelIcon:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_PREPARE_FINISH]) {
        /// 前期准备完成((火箭)
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketPrepareFinish:)]) {
            [self.listener onGameMGCustomRocketPrepareFinish:handle];
            return;
        }

    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_SHOW_GAME_SCENE]) {
        /// 显示火箭主界面((火箭)
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketShowGameScene:)]) {
            [self.listener onGameMGCustomRocketShowGameScene:handle];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_HIDE_GAME_SCENE]) {
        /// 隐藏火箭主界面((火箭)
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketHideGameScene:)]) {
            [self.listener onGameMGCustomRocketHideGameScene:handle];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_CLICK_LOCK_COMPONENT]) {
        /// 点击锁住组件((火箭)
        MGCustomRocketClickLockComponent *m = [MGCustomRocketClickLockComponent mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketClickLockComponent:model:)]) {
            [self.listener onGameMGCustomRocketClickLockComponent:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_FLY_CLICK]) {
        ///  火箭效果飞行点击(火箭)
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketFlyClick:)]) {
            [self.listener onGameMGCustomRocketFlyClick:handle];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_FLY_END]) {
        /// 火箭效果飞行结束(火箭)
        MGCustomRocketFlyEnd *m = [MGCustomRocketFlyEnd mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketFlyEnd:model:)]) {
            [self.listener onGameMGCustomRocketFlyEnd:handle model:m];
            return;
        }

    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_SET_CLICK_RECT]) {
        /// 设置点击区域((火箭)
        MgCommonSetClickRect *m = [MgCommonSetClickRect mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketSetClickRect:model:)]) {
            [self.listener onGameMGCustomRocketSetClickRect:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_ROCKET_SAVE_SIGN_COLOR]) {
        /// 设置点击区域((火箭)
        MGCustomRocketSaveSignColorModel *m = [MGCustomRocketSaveSignColorModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomRocketSaveSignColor:model:)]) {
            [self.listener onGameMGCustomRocketSaveSignColor:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_BASEBALL_RANKING]) {
        /// 查询排行榜数据(棒球)
        MGBaseballRanking *m = [MGBaseballRanking mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGBaseballRanking:model:)]) {
            [self.listener onGameMGBaseballRanking:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_BASEBALL_MY_RANKING]) {
        /// 查询我的排名(棒球)
        MGBaseballMyRanking *m = [MGBaseballMyRanking mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGBaseballMyRanking:model:)]) {
            [self.listener onGameMGBaseballMyRanking:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_BASEBALL_RANGE_INFO]) {
        /// 查询当前距离我的前后玩家数据(棒球)
        MGBaseballRangeInfo *m = [MGBaseballRangeInfo mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGBaseballRangeInfo:model:)]) {
            [self.listener onGameMGBaseballRangeInfo:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_BASEBALL_PREPARE_FINISH]) {
        /// 前期准备完成((棒球)
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGBaseballPrepareFinish:)]) {
            [self.listener onGameMGBaseballPrepareFinish:handle];
            return;
        }

    } else if ([state isEqualToString:MG_BASEBALL_SHOW_GAME_SCENE]) {
        /// 显示主界面((棒球)
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGBaseballShowGameScene:)]) {
            [self.listener onGameMGBaseballShowGameScene:handle];
            return;
        }
    } else if ([state isEqualToString:MG_BASEBALL_HIDE_GAME_SCENE]) {
        /// 隐藏主界面((棒球)
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGBaseballHideGameScene:)]) {
            [self.listener onGameMGBaseballHideGameScene:handle];
            return;
        }
    } else if ([state isEqualToString:MG_BASEBALL_SET_CLICK_RECT]) {
        /// 设置点击区域((棒球)
        MGCustomGameSetClickRect *m = [MGCustomGameSetClickRect mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGBaseballSetClickRect:model:)]) {
            [self.listener onGameMGBaseballSetClickRect:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_BASEBALL_TEXT_CONFIG]) {
        /// 获取配置((棒球)
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGBaseballTextConfig:)]) {
            [self.listener onGameMGBaseballTextConfig:handle];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_USERS_INFO]) {

        MgCommonUsersInfoModel *m = [MgCommonUsersInfoModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonUsersInfo:model:)]) {
            [self.listener onGameMGCommonUsersInfo:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_PREPARE_FINISH]) {

        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonPrepareFinish:)]) {
            [self.listener onGameMGCommonPrepareFinish:handle];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SHOW_GAME_SCENE]) {

        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonShowGameScene:)]) {
            [self.listener onGameMGCommonShowGameScene:handle];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_HIDE_GAME_SCENE]) {

        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonHideGameScene:)]) {
            [self.listener onGameMGCommonHideGameScene:handle];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SET_CLICK_RECT]) {

        MgCommonSetClickRect *m = [MgCommonSetClickRect mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSetClickRect:model:)]) {
            [self.listener onGameMGCommonSetClickRect:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_PLAYER_ROLE_ID]) {
        /// 游戏通知app玩家角色(狼人杀，谁是卧底)
        MgCommonPlayerRoleIdModel *m = [MgCommonPlayerRoleIdModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonPlayerRoleId:model:)]) {
            [self.listener onPlayerMGCommonPlayerRoleId:handle model:m];
            return;
        }

    } else if ([state isEqualToString:MG_CUSTOM_CR_ROOM_INIT_DATA]) {
        /// 请求房间数据
        MGCustomCrRoomInitData *m = [MGCustomCrRoomInitData mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomCrRoomInitData:model:)]) {
            [self.listener onGameMGCustomCrRoomInitData:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_CUSTOM_CR_CLICK_SEAT]) {
        /// 点击主播位或老板位通知
        MGCustomCrClickSeat *m = [MGCustomCrClickSeat mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCustomCrClickSeat:model:)]) {
            [self.listener onGameMGCustomCrClickSeat:handle model:m];
            return;
        }

    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_GOLD_BTN]) {
        /// 通知app点击了游戏的金币按钮
        MgCommonSelfClickGoldBtnModel *m = [MgCommonSelfClickGoldBtnModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickGoldBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickGoldBtn:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_PIECE_ARRIVE_END]) {
        /// 通知app棋子到达终点
        MgCommonGamePieceArriveEndModel *m = [MgCommonGamePieceArriveEndModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGamePieceArriveEnd:model:)]) {
            [self.listener onGameMGCommonGamePieceArriveEnd:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_PLAYER_MANAGED_STATE]) {
        /// 通知app玩家是否托管
        MgCommonGamePlayerManagedStateModel *m = [MgCommonGamePlayerManagedStateModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGamePlayerManagedState:model:)]) {
            [self.listener onGameMGCommonGamePlayerManagedState:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_SEND_BURST_WORD]) {
        /// 游戏通知app爆词的内容
        MgCommonGameSendBurstWordModel *m = [MgCommonGameSendBurstWordModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameSendBurstWord:model:)]) {
            [self.listener onGameMGCommonGameSendBurstWord:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_PLAYER_MONOPOLY_CARDS]) {
        /// 游戏向app发送获取玩家持有的道具卡（只支持大富翁）
        MgCommonGamePlayerMonopolyCardsModel *m = [MgCommonGamePlayerMonopolyCardsModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGPlayerMonopolyCards:model:)]) {
            [self.listener onGameMGPlayerMonopolyCards:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_PLAYER_RANKS]) {
        // 游戏向app发送玩家实时排名（只支持怪物消消乐）
        MgCommonGamePlayerRanksModel *m = [MgCommonGamePlayerRanksModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGPlayerRanks:model:)]) {
            [self.listener onGameMGPlayerRanks:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_PLAYER_PAIR_SINGULAR]) {
        /// 游戏向app发送玩家即时变化的单双牌（只支持okey101）
        MgCommonGamePlayerPairSingularModel *m = [MgCommonGamePlayerPairSingularModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGPlayerPairSingular:model:)]) {
            [self.listener onGameMGPlayerPairSingular:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_PLAYER_SCORES]) {
        /// 游戏向app发送玩家实时积分（只支持怪物消消乐）
        MgCommonGamePlayerScoresModel *m = [MgCommonGamePlayerScoresModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGPlayerScores:model:)]) {
            [self.listener onGameMGPlayerScores:handle model:m];
            return;
        }
    }

        //............
    else if ([state isEqualToString:MG_COMMON_GAME_UI_CUSTOM_CONFIG]) {
        /// 游戏通知 app 下发定制 ui 配置表（支持ludo和五子棋）MG_COMMON_GAME_UI_CUSTOM_CONFIG
        MgCommonGameUiCustomConfigModel *m = [MgCommonGameUiCustomConfigModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameUiCustomConfig:model:)]) {
            [self.listener onGameMGCommonGameUiCustomConfig:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_MONEY_NOT_ENOUGH]) {
        /// 游戏通知 app 钱币不足（只支持德州 pro，teenpatti pro）MG_COMMON_GAME_MONEY_NOT_ENOUGH
        MgCommonGameMoneyNotEnoughModel *m = [MgCommonGameMoneyNotEnoughModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameMoneyNotEnough:model:)]) {
            [self.listener onGameMGCommonGameMoneyNotEnough:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_SETTINGS]) {
        /// 游戏通知 app 进行玩法设置（只支持德州 pro，teenpatti pro）MG_COMMON_GAME_SETTINGS
        MgCommonGameSettingsModel *m = [MgCommonGameSettingsModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameSettings:model:)]) {
            [self.listener onGameMGCommonGameSettings:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_RULE]) {
        /// 游戏通知 app 当前游戏的设置信息（只支持德州 pro，teenpatti pro）MG_COMMON_GAME_RULE
        MgCommonGameRuleModel *m = [MgCommonGameRuleModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameRule:model:)]) {
            [self.listener onGameMGCommonGameRule:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_IS_APP_CHIP]) {
        /// 游戏通知 app 是否要开启带入积分（只支持 teenpattipro 与 德州 pro）MG_COMMON_GAME_IS_APP_CHIP
        MgCommonGameIsAppChipModel *m = [MgCommonGameIsAppChipModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameIsAppChip:model:)]) {
            [self.listener onGameMGCommonGameIsAppChip:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_EXIT_GAME_BTN]) {
        /// 游戏通知 app 退出游戏（只支持 teenpattipro 与 德州 pro）MG_COMMON_SELF_CLICK_EXIT_GAME_BTN
        MgCommonSelfClickExitGameBtnModel *m = [MgCommonSelfClickExitGameBtnModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickExitGameBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickExitGameBtn:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_PLAYER_ICON_POSITION]) {
        /// 游戏通知 app 玩家头像的坐标（支持 ludo, 飞镖, umo, 多米诺, teenpatti, texasholdem）MG_COMMON_GAME_PLAYER_ICON_POSITION
        MgCommonGamePlayerIconPositionModel *m = [MgCommonGamePlayerIconPositionModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMgCommonGamePlayerIconPosition:model:)]) {
            [self.listener onGameMgCommonGamePlayerIconPosition:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_PLAYER_COLOR]) {
        /// 游戏通知 app 玩家颜色（支持友尽闯关 与 ludo）MG_COMMON_GAME_PLAYER_COLOR
        MgCommonGamePlayerColorModel *m = [MgCommonGamePlayerColorModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMgCommonGamePlayerColor:model:)]) {
            [self.listener onGameMgCommonGamePlayerColor:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_OVER_TIP]) {
        /// 游戏通知 app 因玩家逃跑导致游戏结束（只支持友尽闯关）MG_COMMON_GAME_OVER_TIP
        MgCommonGameOverTipModel *m = [MgCommonGameOverTipModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMgCommonGameOverTip:model:)]) {
            [self.listener onGameMgCommonGameOverTip:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_WORST_TEAMMATE]) {
        /// 游戏通知 app 最坑队友（只支持友尽闯关）MG_COMMON_WORST_TEAMMATE
        MgCommonWorstTeammateModel *m = [MgCommonWorstTeammateModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMgCommonWorstTeammate:model:)]) {
            [self.listener onGameMgCommonWorstTeammate:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_ALERT]) {
        /// 游戏通知 app 游戏弹框 MG_COMMON_ALERT
        MgCommonAlertModel *m = [MgCommonAlertModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMgCommonAlert:model:)]) {
            [self.listener onGameMgCommonAlert:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_FPS]) {
        /// 游戏通知 app 游戏 FPS(仅对碰碰，多米诺骨牌，飞镖达人生效) MG_COMMON_GAME_FPS
        MgCommonGameFpsModel *m = [MgCommonGameFpsModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMgCommonGameFps:model:)]) {
            [self.listener onGameMgCommonGameFps:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_GOOD]) {
        /// 游戏通知 app 玩家被点赞(仅对你画我猜有效) MG_COMMON_SELF_CLICK_GOOD
        MgCommonSelfClickGoodModel *m = [MgCommonSelfClickGoodModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMgCommonSelfClickGood:model:)]) {
            [self.listener onGameMgCommonSelfClickGood:handle model:m];
            return;
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_POOP]) {
        /// 游戏通知 app 玩家被扔便便(仅对你画我猜有效) MG_COMMON_SELF_CLICK_POOP
        MgCommonSelfClickPoopModel *m = [MgCommonSelfClickPoopModel mj_objectWithKeyValues:dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMgCommonSelfClickPoop:model:)]) {
            [self.listener onGameMgCommonSelfClickPoop:handle model:m];
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
    if ([self.listener respondsToSelector:@selector(onPlayerStateChange:userId:state:dataJson:)]) {
        BOOL isHandled = [self.listener onPlayerStateChange:handle userId:userId state:state dataJson:dataJson];
        if (isHandled) {
            return;
        }
    }

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

/// 游戏加载进度(loadMG)
/// @param stage start=1,loading=2,end=3
/// @param retCode 错误码，0成功
/// @param progress [0, 100]
/// 最低版本：v1.1.30.xx
- (void)onGameLoadingProgress:(int)stage retCode:(int)retCode progress:(int)progress {
    if (self.listener && [self.listener respondsToSelector:@selector(onGameLoadingProgress:retCode:progress:)]) {
        [self.listener onGameLoadingProgress:stage retCode:retCode progress:progress];
    }
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
