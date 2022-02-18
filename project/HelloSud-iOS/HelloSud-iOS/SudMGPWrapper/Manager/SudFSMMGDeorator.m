//
//  SudFSMMGManager.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/18.
//

#import "SudFSMMGDeorator.h"
#import "SudFSMMGListener.h"

@interface SudFSMMGDeorator () <ISudFSMMG>
/// ISudFSTAPP
@property (nonatomic, strong) id<ISudFSTAPP> iSudFSTAPP;

@property(nonatomic, weak) id<SudFSMMGListener> listener;

#pragma mark - 初始化需要的信息
/// 当前用户的游戏id
@property (nonatomic, copy) NSString *userID;
/// 当前游戏语言
@property (nonatomic, copy) NSString *language;
/// 房间ID
@property(nonatomic, copy)NSString *roomID;

/// 当前用户登录游戏的code
@property (nonatomic, copy) NSString *code;

#pragma mark - 游戏需要暂存的状态
/// 你画我猜专用，游戏中选中的关键词，会回调出来，通过 drawKeyWord 进行保存。
@property (nonatomic, copy) NSString *drawKeyWord;
/// 你画我猜，进入猜词环节，用来公屏识别关键字的状态标识
@property (nonatomic, assign) BOOL keyWordHiting;
/// 是否准备
@property (nonatomic, assign) BOOL isReady;
// 游戏状态： 0 = 空闲 1 = loading 2 = playing
@property (nonatomic, assign) NSInteger gameState;
/// true 已加入，false 未加入
@property (nonatomic, assign) BOOL isInGame;
/// 是否是数字炸弹  number
@property (nonatomic, assign) BOOL isHitBomb;
/// ASR功能的开启关闭的状态标志
@property (nonatomic, assign) BOOL keyWordASRing;
/// 当前游戏在线userid列表
@property (nonatomic, strong) NSMutableArray <NSString *>*onlineUserIdList;
/// 队长userid
@property (nonatomic, copy) NSString *captainUserId;
/// 当前游戏成员的游戏状态Map
@property (nonatomic, strong) NSMutableDictionary *gamePlayerStateMap;

@end

@implementation SudFSMMGDeorator

- (instancetype)init:(NSString *)roomID userID:(NSString *)userID language:(NSString *)language {
    if (self = [super init]) {
        self.roomID = roomID;
        self.userID = userID;
        self.language = language;
    }
    return self;
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

/// 关键词获取状态 - 更新
- (void)updateCommonGameState:(MGCommonGameStateModel *)m {
    self.gameState = m.gameState;
    if (m.gameState != 2) {
        self.isHitBomb = false;
    }
}

/// 关键词获取状态 - 更新
- (void)updateCommonGameASR:(MGCommonGameASRModel *)m {
    if (m.isOpen) {
        self.keyWordASRing = YES;
    } else {
        self.keyWordASRing = NO;
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
            [self.listener onGameMGCommonPublicMessage:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_KEY_WORD_TO_HIT]) {
        MGCommonKeyWrodToHitModel *m = [MGCommonKeyWrodToHitModel mj_objectWithKeyValues: dataJson];
        /// 更新当前状态
        [self updateCommonKeyWrodToHit:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonKeyWordToHit:model:)]) {
            [self.listener onGameMGCommonKeyWordToHit:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_STATE]) {
        MGCommonGameStateModel *m = [MGCommonGameStateModel mj_objectWithKeyValues: dataJson];
        /// 更新当前状态
        [self updateCommonGameState:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameState:model:)]) {
            [self.listener onGameMGCommonGameState:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_JOIN_BTN]) {
        MGCommonSelfClickJoinBtnModel *m = [MGCommonSelfClickJoinBtnModel mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickJoinBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickJoinBtn:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_CANCEL_JOIN_BTN]) {
        MGCommonSelfClickCancelJoinBtnModel *m = [MGCommonSelfClickCancelJoinBtnModel mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickCancelJoinBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickCancelJoinBtn:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_READY_BTN]) {
        MGCommonSelfClickReadyBtnModel *m = [MGCommonSelfClickReadyBtnModel mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickReadyBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickReadyBtn:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_CANCEL_READY_BTN]) {
        MGCommonSelfClickCancelReadyBtnModel *m = [MGCommonSelfClickCancelReadyBtnModel mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickCancelReadyBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickCancelReadyBtn:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_START_BTN]) {
        MGCommonSelfClickStartBtnModel *m = [MGCommonSelfClickStartBtnModel mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickStartBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickStartBtn:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_SHARE_BTN]) {
        MGCommonSelfClickShareBtnModel *m = [MGCommonSelfClickShareBtnModel mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickShareBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickShareBtn:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_STATE]) {
        MGCommonGameStateModel *m = [MGCommonGameStateModel mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameState:model:)]) {
            [self.listener onGameMGCommonGameState:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_GAME_SETTLE_CLOSE_BTN]) {
        MGCommonSelfClickGameSettleCloseBtnModel *m = [MGCommonSelfClickGameSettleCloseBtnModel mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickGameSettleCloseBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickGameSettleCloseBtn:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_GAME_SETTLE_AGAIN_BTN]) {
        MGCommonSelfClickGameSettleAgainBtnModel *m = [MGCommonSelfClickGameSettleAgainBtnModel mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonSelfClickGameSettleAgainBtn:model:)]) {
            [self.listener onGameMGCommonSelfClickGameSettleAgainBtn:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_SOUND_LIST]) {
        MGCommonGameSoundListModel *m = [MGCommonGameSoundListModel mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameSoundList:model:)]) {
            [self.listener onGameMGCommonGameSoundList:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_SOUND]) {
        MGCommonGameSoundModel *m = [MGCommonGameSoundModel mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameSound:model:)]) {
            [self.listener onGameMGCommonGameSound:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_BG_MUSIC_STATE]) {
        MGCommonGameBgMusicStateModel *m = [MGCommonGameBgMusicStateModel mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameBgMusicState:model:)]) {
            [self.listener onGameMGCommonGameBgMusicState:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_SOUND_STATE]) {
        MGCommonGameSoundStateModel *m = [MGCommonGameSoundStateModel mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameSoundState:model:)]) {
            [self.listener onGameMGCommonGameSoundState:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_ASR]) {
        MGCommonGameASRModel *m = [MGCommonGameASRModel mj_objectWithKeyValues: dataJson];
        /// 更新当前状态
        [self updateCommonGameASR:m];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameASR:model:)]) {
            [self.listener onGameMGCommonGameASR:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_SELF_MICROPHONE]) {
        MGCommonGameSelfMicrophoneModel *m = [MGCommonGameSelfMicrophoneModel mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameSelfMicrophone:model:)]) {
            [self.listener onGameMGCommonGameSelfMicrophone:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_GAME_SELF_HEADEPHONE]) {
        MGCommonGameSelfHeadphoneModel *m = [MGCommonGameSelfHeadphoneModel mj_objectWithKeyValues: dataJson];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onGameMGCommonGameSelfHeadphone:model:)]) {
            [self.listener onGameMGCommonGameSelfHeadphone:state model:m];
        }
    } else {
        /// 其他状态
        NSLog(@"ISudFSMMG:onGameStateChange:游戏->APP:state:%@", state);
    }
    
    [handle success:[self handleMGSuccess]];
}

/// 关键词获取状态 - 更新
- (void)updateCommonPlayerIn:(MGCommonPlayerInModel *)m userId:(nonnull NSString *)userId  {
    
    if (userId == AppManager.shared.loginUserInfo.userID) {
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

- (void)updateCommonPlayerCaptain:(MGCommonPlayerCaptainModel *)m userId:(nonnull NSString *)userId  {
    if (m.isCaptain) {
        self.captainUserId = userId;
    } else {
        if (self.captainUserId == userId) {
            self.captainUserId = @"";
        }
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
    NSLog(@"%@", [NSString stringWithFormat:@"ISudFSMMG:onPlayerStateChange:%@ --dataJson:%@", state, dataJson]);
    
    if ([state isEqualToString:MG_COMMON_PLAYER_IN]) {
        MGCommonPlayerInModel *m = [MGCommonPlayerInModel mj_objectWithKeyValues: dataJson];
        [GameManager.shared.gamePlayerStateMap setValue:m forKey:userId];
        /// 更新
        [self updateCommonPlayerIn:m userId:userId];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonPlayerIn:model:)]) {
            [self.listener onPlayerMGCommonPlayerIn:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_PLAYER_READY]) {
        MGCommonPlayerReadyModel *m = [MGCommonPlayerReadyModel mj_objectWithKeyValues: dataJson];
        [GameManager.shared.gamePlayerStateMap setValue:m forKey:userId];
        /// 更新
        self.isReady = m.isReady;
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonPlayerReady:model:)]) {
            [self.listener onPlayerMGCommonPlayerReady:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_PLAYER_CAPTAIN]) {
        MGCommonPlayerCaptainModel *m = [MGCommonPlayerCaptainModel mj_objectWithKeyValues: dataJson];
        /// 更新
        [self updateCommonPlayerCaptain:m userId:userId];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonPlayerCaptain:model:)]) {
            [self.listener onPlayerMGCommonPlayerCaptain:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_PLAYER_PLAYING]) {
        MGCommonPlayerPlayingModel *m = [MGCommonPlayerPlayingModel mj_objectWithKeyValues: dataJson];
        [GameManager.shared.gamePlayerStateMap setValue:m forKey:userId];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonPlayerPlaying:model:)]) {
            [self.listener onPlayerMGCommonPlayerPlaying:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_PLAYER_ONLINE]) {
        MGCommonPlayerOnlineModel *m = [MGCommonPlayerOnlineModel mj_objectWithKeyValues: dataJson];
        [GameManager.shared.gamePlayerStateMap setValue:m forKey:userId];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonPlayerOnline:model:)]) {
            [self.listener onPlayerMGCommonPlayerOnline:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_PLAYER_CHANGE_SEAT]) {
        MGCommonPlayerChangeSeatModel *m = [MGCommonPlayerChangeSeatModel mj_objectWithKeyValues: dataJson];
        [GameManager.shared.gamePlayerStateMap setValue:m forKey:userId];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonPlayerChangeSeat:model:)]) {
            [self.listener onPlayerMGCommonPlayerChangeSeat:state model:m];
        }
    } else if ([state isEqualToString:MG_COMMON_SELF_CLICK_GAME_PLAYER_ICON]) {
        MGCommonSelfClickGamePlayerIconModel *m = [MGCommonSelfClickGamePlayerIconModel mj_objectWithKeyValues: dataJson];
        [GameManager.shared.gamePlayerStateMap setValue:m forKey:userId];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGCommonSelfClickGamePlayerIcon:model:)]) {
            [self.listener onPlayerMGCommonSelfClickGamePlayerIcon:state model:m];
        }
    } else if ([state isEqualToString:MG_DG_SELECTING]) {
        MGDGSelectingModel *m = [MGDGSelectingModel mj_objectWithKeyValues: dataJson];
        [GameManager.shared.gamePlayerStateMap setValue:m forKey:userId];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGDGSelecting:model:)]) {
            [self.listener onPlayerMGDGSelecting:state model:m];
        }
    } else if ([state isEqualToString:MG_DG_PAINTING]) {
        MGDGPaintingModel *m = [MGDGPaintingModel mj_objectWithKeyValues: dataJson];
        [GameManager.shared.gamePlayerStateMap setValue:m forKey:userId];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGDGPainting:model:)]) {
            [self.listener onPlayerMGDGPainting:state model:m];
        }
    } else if ([state isEqualToString:MG_DG_ERRORANSWER]) {
        MGDGErrorAnswerModel *m = [MGDGErrorAnswerModel mj_objectWithKeyValues: dataJson];
        [GameManager.shared.gamePlayerStateMap setValue:m forKey:userId];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGDGErrorAnswer:model:)]) {
            [self.listener onPlayerMGDGErrorAnswer:state model:m];
        }
    } else if ([state isEqualToString:MG_DG_TOTALSCORE]) {
        MGDGTotalScoreModel *m = [MGDGTotalScoreModel mj_objectWithKeyValues: dataJson];
        [GameManager.shared.gamePlayerStateMap setValue:m forKey:userId];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGDGTotalScore:model:)]) {
            [self.listener onPlayerMGDGTotalScore:state model:m];
        }
    } else if ([state isEqualToString:MG_DG_SCORE]) {
        MGDGScoreModel *m = [MGDGScoreModel mj_objectWithKeyValues: dataJson];
        [GameManager.shared.gamePlayerStateMap setValue:m forKey:userId];
        if (self.listener != nil && [self.listener respondsToSelector:@selector(onPlayerMGDGScore:model:)]) {
            [self.listener onPlayerMGDGScore:state model:m];
        }
    } else {
        NSLog(@"ISudFSMMG:onPlayerStateChange:未做解析状态");
    }
    
    [handle success:[self handleMGSuccess]];
}



#pragma mark =======登录 加载 游戏=======
/// 游戏登录
/// 接入方客户端 调用 接入方服务端 login 获取 短期令牌code
/// 参考文档时序图：sud-mgp-doc(https://github.com/SudTechnology/sud-mgp-doc)
- (void)login:(UIView *)rootView gameId:(int64_t)gameId {
    WeakSelf
    [GameManager.shared reqGameLoginWithSuccess:^(RespGameInfoModel * _Nonnull gameInfo) {
        weakSelf.code = gameInfo.code;
        [weakSelf initSdk:rootView gameId:gameId];
    } fail:^(NSError *error) {
        [ToastUtil show:error.debugDescription];
    }];
}

/// 退出游戏
- (void)logoutGame {
    // 销毁游戏
    [self.iSudFSTAPP destroyMG];
}

/// 加载游戏
- (void)initSdk:(UIView *)rootView gameId:(int64_t)gameId {
    NSString *appID = AppManager.shared.configModel.sudCfg.appId;
    NSString *appKey = AppManager.shared.configModel.sudCfg.appKey;
    if (appID.length == 0 || appKey.length == 0) {
        [ToastUtil show:@"Game appID or appKey is empty"];
        return;
    }
    WeakSelf
    [SudMGP initSDK:appID appKey:appKey isTestEnv:true listener:^(int retCode, const NSString *retMsg) {
        if (retCode == 0) {
            NSLog(@"ISudFSMMG:initGameSDKWithAppID:初始化游戏SDK成功");
            if (weakSelf) {
                // SudMGPSDK初始化成功 加载MG
                NSString *userID = weakSelf.userID;
                NSString *roomID = weakSelf.roomID;
                NSString *code = weakSelf.code;
                if (userID.length == 0 || roomID.length == 0 || code.length == 0) {
                    [ToastUtil show:@"加载游戏失败，请检查参数"];
                    return;
                }
                [weakSelf loadGame:userID roomId:roomID code:code mgId:gameId language:weakSelf.language fsmMG:weakSelf rootView:rootView];
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
- (void)loadGame:(NSString *)userId roomId:(NSString *)roomId code:(NSString *)code mgId:(int64_t) mgId language:(NSString *)language fsmMG:(id)fsmMG rootView:(UIView*)rootView {
    self.iSudFSTAPP = [SudMGP loadMG:userId roomId:roomId code:code mgId:mgId language:language fsmMG:fsmMG rootView:rootView];
    self.sudFSTAPPManager = [[SudFSTAPPDeorator alloc] init:self.iSudFSTAPP];
}

/// 处理切换游戏
/// @param gameId 新的游戏ID
- (void)switchGameWithRootView:(UIView *)rootView gameId:(NSInteger)gameId  {
    if (gameId == 0) {
        // 切换语音房间
//        self.roomType = HSAudio;
        return;
    }
    [self logoutGame];
    [self login:rootView gameId:gameId];
//    self.roomType = HSGame;
}

/// 更新code
/// @param code 新的code
- (void)updateGameCode:(NSString *)code {
    [self.iSudFSTAPP updateCode:code listener:^(int retCode, const NSString *retMsg, const NSString *dataJson) {
        NSLog(@"ISudFSMMG:updateGameCode retCode=%@ retMsg=%@ dataJson=%@", @(retCode), retMsg, dataJson);
    }];
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
