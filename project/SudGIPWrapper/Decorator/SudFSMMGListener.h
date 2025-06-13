//
//  SudFSMMGListener.h
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/2/18.
//

#import <Foundation/Foundation.h>
#import "SudGIPMGState.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SudFSMMGListener <NSObject>

@required
/// 获取游戏View信息  【需要实现】
- (void)onGetGameViewInfo:(nonnull id <ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson;

/// 短期令牌code过期  【需要实现】
- (void)onExpireCode:(nonnull id <ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson;

/// 获取游戏Config  【需要实现】
- (void)onGetGameCfg:(nonnull id <ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson;


@optional
/// 游戏开始
- (void)onGameStarted;

/// 游戏销毁
- (void)onGameDestroyed;

/// 游戏日志
/// 最低版本：v1.1.30.xx
- (void)onGameLog:(nonnull NSString *)dataJson;

/// 游戏状态变化
/// 如果未接管相应指令回调，则会默认派发到该回调上
/// @param handle handle 回调句柄
/// @param state state 对应事件状态
/// @param dataJson dataJson 回调json串
- (void)onGameStateChange:(nonnull id <ISudFSMStateHandle>)handle state:(nonnull NSString *)state dataJson:(nonnull NSString *)dataJson;

 /// 游戏玩家状态变化
/// 如果未接管相应指令回调，则会默认派发到该回调上
 /// @param handle handle 回调句柄
 /// @param state state 对应事件状态
 /// @param dataJson dataJson 回调json串
- (void)onPlayerStateChange:(nullable id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId state:(nonnull NSString *)state dataJson:(nonnull NSString *)dataJson;

/// 游戏加载进度(loadMG)
/// @param stage start=1,loading=2,end=3
/// @param retCode 错误码，0成功
/// @param progress [0, 100]
/// 最低版本：v1.1.30.xx
- (void)onGameLoadingProgress:(int)stage retCode:(int)retCode progress:(int)progress;


#pragma mark - 通用状态-游戏

/// 通用状态-游戏
/// 游戏: 公屏消息状态    MG_COMMON_PUBLIC_MESSAGE
- (void)onGameMGCommonPublicMessage:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonPublicMessageModel *)model;

/// 游戏: 关键词状态    MG_COMMON_KEY_WORD_TO_HIT
- (void)onGameMGCommonKeyWordToHit:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonKeyWrodToHitModel *)model;

/// 游戏: 游戏结算状态     MG_COMMON_GAME_SETTLE
- (void)onGameMGCommonGameSettle:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSettleModel *)model;

/// 游戏: 加入游戏按钮点击状态   MG_COMMON_SELF_CLICK_JOIN_BTN
- (void)onGameMGCommonSelfClickJoinBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickJoinBtn *)model;

/// 游戏: 取消加入游戏按钮点击状态   MG_COMMON_SELF_CLICK_CANCEL_JOIN_BTN
- (void)onGameMGCommonSelfClickCancelJoinBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickCancelJoinBtn *)model;

/// 游戏: 准备按钮点击状态   MG_COMMON_SELF_CLICK_READY_BTN
- (void)onGameMGCommonSelfClickReadyBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickReadyBtn *)model;

/// 游戏: 取消准备按钮点击状态   MG_COMMON_SELF_CLICK_CANCEL_READY_BTN
- (void)onGameMGCommonSelfClickCancelReadyBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickCancelReadyBtn *)model;

/// 游戏: 开始游戏按钮点击状态   MG_COMMON_SELF_CLICK_START_BTN
- (void)onGameMGCommonSelfClickStartBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickStartBtn *)model;

/// 游戏: 分享按钮点击状态   MG_COMMON_SELF_CLICK_SHARE_BTN
- (void)onGameMGCommonSelfClickShareBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickShareBtn *)model;

/// 游戏: 游戏状态   MG_COMMON_GAME_STATE
- (void)onGameMGCommonGameState:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameState *)model;

/// 游戏: 结算界面关闭按钮点击状态   MG_COMMON_SELF_CLICK_GAME_SETTLE_CLOSE_BTN
- (void)onGameMGCommonSelfClickGameSettleCloseBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickGameSettleCloseBtn *)model;

/// 游戏: 结算界面再来一局按钮点击状态   MG_COMMON_SELF_CLICK_GAME_SETTLE_AGAIN_BTN
- (void)onGameMGCommonSelfClickGameSettleAgainBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickGameSettleAgainBtn *)model;

/// 游戏: 游戏上报游戏中的声音列表   MG_COMMON_GAME_SOUND_LIST
- (void)onGameMGCommonGameSoundList:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSoundListModel *)model;

/// 游戏: 游戏通知app层播放声音   MG_COMMON_GAME_SOUND
- (void)onGameMGCommonGameSound:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSound *)model;

/// 游戏: 游戏通知app层播放背景音乐状态   MG_COMMON_GAME_BG_MUSIC_STATE
- (void)onGameMGCommonGameBgMusicState:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameBgMusicState *)model;

/// 游戏: 游戏通知app层播放音效的状态   MG_COMMON_GAME_SOUND_STATE
- (void)onGameMGCommonGameSoundState:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSoundState *)model;

/// 游戏: ASR状态(开启和关闭语音识别状态   MG_COMMON_GAME_ASR
- (void)onGameMGCommonGameASR:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameASRModel *)model;

/// 游戏: 麦克风状态   MG_COMMON_GAME_SELF_MICROPHONE
- (void)onGameMGCommonGameSelfMicrophone:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSelfMicrophone *)model;

/// 游戏: 耳机（听筒，扬声器）状态   MG_COMMON_GAME_SELF_HEADEPHONE
- (void)onGameMGCommonGameSelfHeadphone:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSelfHeadphone *)model;

/// 元宇宙砂砂舞 指令回调  MG_COMMON_GAME_DISCO_ACTION
- (void)onGameMGCommonGameDiscoAction:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameDiscoActionModel *)model;

/// 元宇宙砂砂舞 指令动作结束通知  MG_COMMON_GAME_DISCO_ACTION_END
- (void)onGameMGCommonGameDiscoActionEnd:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameDiscoActionEndModel *)model;

/// App通用状态操作结果错误码 MG_COMMON_APP_COMMON_SELF_X_RESP
- (void)onGameMGCommonAppCommonSelfXResp:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonAppCommonSelfXRespModel *)model;

/// 游戏通知app层添加陪玩机器人是否成功 MG_COMMON_GAME_ADD_AI_PLAYERS
- (void)onGameMGCommonGameAddAIPlayers:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameAddAIPlayersModel *)model;

/// 游戏通知app层添当前网络连接状态 MG_COMMON_GAME_NETWORK_STATE
- (void)onGameMGCommonGameNetworkState:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameNetworkStateModel *)model;

/// 游戏通知app获取积分 MG_COMMON_GAME_SCORE
- (void)onGameMGCommonGameGetScore:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameGetScoreModel *)model;

/// 游戏通知app带入积分 MG_COMMON_GAME_SET_SCORE
- (void)onGameMGCommonGameSetScore:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSetScoreModel *)model;

/// 创建订单 MG_COMMON_GAME_CREATE_ORDER
- (void)onGameMGCommonGameCreateOrder:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGameCreateOrderModel *)model;

/// 获取玩家信息 MG_COMMON_USERS_INFO
- (void)onGameMGCommonUsersInfo:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonUsersInfoModel *)model;

/// 前期准备完成 MG_COMMON_GAME_PREPARE_FINISH
- (void)onGameMGCommonPrepareFinish:(nonnull id <ISudFSMStateHandle>)handle;

/// 展示主界面 MG_COMMON_SHOW_GAME_SCENE
- (void)onGameMGCommonShowGameScene:(nonnull id <ISudFSMStateHandle>)handle;

/// 隐藏主界面 MG_COMMON_HIDE_GAME_SCENE
- (void)onGameMGCommonHideGameScene:(nonnull id <ISudFSMStateHandle>)handle;

/// 可点击区域 MG_COMMON_SET_CLICK_RECT
- (void)onGameMGCommonSetClickRect:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomGameSetClickRect *)model;

/// 通知app点击了游戏的金币按钮 MG_COMMON_SELF_CLICK_GOLD_BTN
- (void)onGameMGCommonSelfClickGoldBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonSelfClickGoldBtnModel *)model;

/// 通知app棋子到达终点 MG_COMMON_GAME_PIECE_ARRIVE_END
- (void)onGameMGCommonGamePieceArriveEnd:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGamePieceArriveEndModel *)model;

/// 通知app玩家是否托管 MG_COMMON_GAME_PLAYER_MANAGED_STATE
- (void)onGameMGCommonGamePlayerManagedState:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGamePlayerManagedStateModel *)model;

/// 游戏通知app爆词的内容 MG_COMMON_GAME_SEND_BURST_WORD
- (void)onGameMGCommonGameSendBurstWord:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGameSendBurstWordModel *)model;

/// 游戏向app发送获取玩家持有的道具卡（只支持大富翁） MG_COMMON_GAME_PLAYER_MONOPOLY_CARDS
- (void)onGameMGPlayerMonopolyCards:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGamePlayerMonopolyCardsModel *)model;

///  游戏向app发送玩家实时排名（只支持怪物消消乐） MG_COMMON_GAME_PLAYER_RANKS
- (void)onGameMGPlayerRanks:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGamePlayerRanksModel *)model;

/// 游戏向app发送玩家即时变化的单双牌（只支持okey101） MG_COMMON_GAME_PLAYER_PAIR_SINGULAR
- (void)onGameMGPlayerPairSingular:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGamePlayerPairSingularModel *)model;

/// 游戏向app发送玩家实时积分（只支持怪物消消乐） MG_COMMON_GAME_PLAYER_SCORES
- (void)onGameMGPlayerScores:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGamePlayerScoresModel *)model;


/// 游戏通知 app 下发定制 ui 配置表（支持ludo和五子棋）MG_COMMON_GAME_UI_CUSTOM_CONFIG
- (void)onGameMGCommonGameUiCustomConfig:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGameUiCustomConfigModel *)model;

/// 游戏通知 app 钱币不足（只支持德州 pro，teenpatti pro）MG_COMMON_GAME_MONEY_NOT_ENOUGH
- (void)onGameMGCommonGameMoneyNotEnough:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGameMoneyNotEnoughModel *)model;

/// 游戏通知 app 进行玩法设置（只支持德州 pro，teenpatti pro）MG_COMMON_GAME_SETTINGS
- (void)onGameMGCommonGameSettings:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGameSettingsModel *)model;

/// 游戏通知 app 当前游戏的设置信息（只支持德州 pro，teenpatti pro）MG_COMMON_GAME_RULE
- (void)onGameMGCommonGameRule:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGameRuleModel *)model;

/// 游戏通知 app 是否要开启带入积分（只支持 teenpattipro 与 德州 pro）MG_COMMON_GAME_IS_APP_CHIP
- (void)onGameMGCommonGameIsAppChip:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGameIsAppChipModel *)model;

/// 游戏通知 app 退出游戏（只支持 teenpattipro 与 德州 pro）MG_COMMON_SELF_CLICK_EXIT_GAME_BTN
- (void)onGameMGCommonSelfClickExitGameBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonSelfClickExitGameBtnModel *)model;

/// 游戏通知 app 玩家头像的坐标（支持 ludo, 飞镖, umo, 多米诺, teenpatti, texasholdem）MG_COMMON_GAME_PLAYER_ICON_POSITION
- (void)onGameMgCommonGamePlayerIconPosition:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGamePlayerIconPositionModel *)model;

/// 游戏通知 app 玩家颜色（支持友尽闯关 与 ludo）MG_COMMON_GAME_PLAYER_COLOR
- (void)onGameMgCommonGamePlayerColor:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGamePlayerColorModel *)model;

/// 游戏通知 app 因玩家逃跑导致游戏结束（只支持友尽闯关）MG_COMMON_GAME_OVER_TIP
- (void)onGameMgCommonGameOverTip:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGameOverTipModel *)model;

/// 游戏通知 app 最坑队友（只支持友尽闯关）MG_COMMON_WORST_TEAMMATE
- (void)onGameMgCommonWorstTeammate:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonWorstTeammateModel *)model;

/// 游戏通知 app 游戏弹框 MG_COMMON_ALERT
- (void)onGameMgCommonAlert:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonAlertModel *)model;

/// 游戏通知 app 游戏 FPS(仅对碰碰，多米诺骨牌，飞镖达人生效) MG_COMMON_GAME_FPS
- (void)onGameMgCommonGameFps:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGameFpsModel *)model;

/// 游戏通知 app 玩家被点赞(仅对你画我猜有效) MG_COMMON_SELF_CLICK_GOOD
- (void)onGameMgCommonSelfClickGood:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonSelfClickGoodModel *)model;

/// 游戏通知 app 玩家被扔便便(仅对你画我猜有效) MG_COMMON_SELF_CLICK_POOP
- (void)onGameMgCommonSelfClickPoop:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonSelfClickPoopModel *)model;

/// 游戏通知游戏场景销毁 MG_COMMON_DESTROY_GAME_SCENE
- (void)onGameMgCommonDestroyGameScene:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonDestroyGameSceneModel *)model;
/// 游戏向app发送获取玩家持有的指定点数道具卡（只支持飞行棋） MG_COMMON_GAME_PLAYER_PROPS_CARDS
- (void)onGameMgCommonGamePlayerPropsCards:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGamePlayerPropsCardsModel *)model;

/// 游戏向app发送获游戏通用数据 MG_COMMON_GAME_INFO_X
- (void)onGameMgCommonGameInfoX:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGameInfoXModel *)model;

/// 游戏通知app击球状态（只支持桌球） MG_COMMON_GAME_BILLIARDS_HIT_STATE
- (void)onGameMgCommonGameBilliardsHitState:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGameBilliardsHitStateModel *)model;

/// 游戏通知app开启ai大模型消息 MG_COMMON_AI_MODEL_MESSAGE
- (void)onGameMgCommonAiModelMessage:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonAiModelMessageModel *)model;

/// 游戏通知app ai大模型消息内容 MG_COMMON_AI_MESSAGE
- (void)onGameMgCommonAiMessage:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonAiMessageModel *)model;

/// 游戏通知app ai大模型消息内容 MG_COMMON_AI_LARGE_SCALE_MODEL_MSG
- (void)onGameMgCommonAiLargeScaleModelMsg:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonAiLargeScaleModelMsg *)model;

/// 通知APP 玩家麦克风状态准备OK MG_COMMON_GAME_PLAYER_MIC_STATE
- (void)onGameMgCommonGamePlayerMicState:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonGamePlayerMicState *)model;
#pragma mark - 互动礼物<火箭>

/// 礼物配置文件(火箭) MG_CUSTOM_ROCKET_CONFIG
- (void)onGameMGCustomRocketConfig:(nonnull id <ISudFSMStateHandle>)handle;

/// 拥有模型列表(火箭) MG_CUSTOM_ROCKET_MODEL_LIST
- (void)onGameMGCustomRocketModelList:(nonnull id <ISudFSMStateHandle>)handle;

/// 拥有组件列表(火箭) MG_CUSTOM_ROCKET_COMPONENT_LIST
- (void)onGameMGCustomRocketComponentList:(nonnull id <ISudFSMStateHandle>)handle;

/// 获取用户信息(火箭) MG_CUSTOM_ROCKET_USER_INFO
- (void)onGameMGCustomRocketUserInfo:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketUserInfo *)model;

/// 订单记录列表(火箭) MG_CUSTOM_ROCKET_ORDER_RECORD_LIST
- (void)onGameMGCustomRocketOrderRecordList:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketOrderRecordList *)model;

/// 展馆内列表(火箭) MG_CUSTOM_ROCKET_ROOM_RECORD_LIST
- (void)onGameMGCustomRocketRoomRecordList:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketRoomRecordList *)model;

/// 展馆内玩家送出记录(火箭) MG_CUSTOM_ROCKET_USER_RECORD_LIST
- (void)onGameMGCustomRocketUserRecordList:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketUserRecordList *)model;

/// 设置默认位置(火箭) MG_CUSTOM_ROCKET_SET_DEFAULT_MODEL
- (void)onGameMGCustomRocketSetDefaultSeat:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketSetDefaultSeat *)model;

/// 动态计算一键发送价格(火箭) MG_CUSTOM_ROCKET_DYNAMIC_FIRE_PRICE
- (void)onGameMGCustomRocketDynamicFirePrice:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketDynamicFirePrice *)model;

/// 一键发送(火箭) MG_CUSTOM_ROCKET_FIRE_MODEL
- (void)onGameMGCustomRocketFireModel:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketFireModel *)model;

/// 新组装模型(火箭) MG_CUSTOM_ROCKET_CREATE_MODEL
- (void)onGameMGCustomRocketCreateModel:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketCreateModel *)model;

/// 更换组件(火箭) MG_CUSTOM_ROCKET_REPLACE_COMPONENT
- (void)onGameMGCustomRocketReplaceModel:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketReplaceModel *)model;

/// 购买组件(火箭) MG_CUSTOM_ROCKET_BUY_COMPONENT
- (void)onGameMGCustomRocketBuyModel:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketBuyModel *)model;

/// 播放效果开始((火箭) MG_CUSTOM_ROCKET_PLAY_EFFECT_START
- (void)onGameMGCustomRocketPlayEffectStart:(nonnull id <ISudFSMStateHandle>)handle;

/// 播放效果完成((火箭) MG_CUSTOM_ROCKET_PLAY_EFFECT_FINISH
- (void)onGameMGCustomRocketPlayEffectFinish:(nonnull id <ISudFSMStateHandle>)handle;

/// 验证签名合规((火箭) MG_CUSTOM_ROCKET_VERIFY_SIGN
- (void)onGameMGCustomRocketVerifySign:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketVerifySign *)model;

/// 上传icon(火箭) MG_CUSTOM_ROCKET_UPLOAD_MODEL_ICON
- (void)onGameMGCustomRocketUploadModelIcon:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketUploadModelIcon *)model;

/// 前期准备完成((火箭) MG_CUSTOM_ROCKET_PREPARE_FINISH
- (void)onGameMGCustomRocketPrepareFinish:(nonnull id <ISudFSMStateHandle>)handle;

/// 展示火箭主界面((火箭) MG_CUSTOM_ROCKET_SHOW_GAME_SCENE
- (void)onGameMGCustomRocketShowGameScene:(nonnull id <ISudFSMStateHandle>)handle;

/// 隐藏火箭主界面((火箭) MG_CUSTOM_ROCKET_HIDE_GAME_SCENE
- (void)onGameMGCustomRocketHideGameScene:(nonnull id <ISudFSMStateHandle>)handle;

/// 点击锁住组件((火箭) MG_CUSTOM_ROCKET_CLICK_LOCK_COMPONENT
- (void)onGameMGCustomRocketClickLockComponent:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketClickLockComponent *)model;

/// 火箭效果飞行点击(火箭) MG_CUSTOM_ROCKET_FLY_CLICK
- (void)onGameMGCustomRocketFlyClick:(nonnull id <ISudFSMStateHandle>)handle;

/// 火箭效果飞行结束(火箭) MG_CUSTOM_ROCKET_FLY_END
- (void)onGameMGCustomRocketFlyEnd:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketFlyEnd *)model;

/// 火箭的可点击区域((火箭) MG_CUSTOM_ROCKET_SET_CLICK_RECT
- (void)onGameMGCustomRocketSetClickRect:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonSetClickRect *)model;

/// 颜色和签名自定义改到装配间的模式，保存颜色或签名 MG_CUSTOM_ROCKET_SAVE_SIGN_COLOR
- (void)onGameMGCustomRocketSaveSignColor:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketSaveSignColorModel *)model;


#pragma mark - 互动礼物<棒球>

/// 查询排行榜数据(棒球) MG_BASEBALL_RANKING
- (void)onGameMGBaseballRanking:(nonnull id <ISudFSMStateHandle>)handle model:(MGBaseballRanking *)model;

/// 查询我的排名(棒球) MG_BASEBALL_MY_RANKING
- (void)onGameMGBaseballMyRanking:(nonnull id <ISudFSMStateHandle>)handle model:(MGBaseballMyRanking *)model;

/// 查询当前距离我的前后玩家数据(棒球) MG_BASEBALL_RANGE_INFO
- (void)onGameMGBaseballRangeInfo:(nonnull id <ISudFSMStateHandle>)handle model:(MGBaseballRangeInfo *)model;

/// 前期准备完成(棒球) MG_BASEBALL_PREPARE_FINISH
- (void)onGameMGBaseballPrepareFinish:(nonnull id <ISudFSMStateHandle>)handle;

/// 展示主界面(棒球) MG_BASEBALL_SHOW_GAME_SCENE
- (void)onGameMGBaseballShowGameScene:(nonnull id <ISudFSMStateHandle>)handle;

/// 隐藏主界面(棒球) MG_BASEBALL_HIDE_GAME_SCENE
- (void)onGameMGBaseballHideGameScene:(nonnull id <ISudFSMStateHandle>)handle;

/// 可点击区域(棒球) MG_BASEBALL_SET_CLICK_RECT
- (void)onGameMGBaseballSetClickRect:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomGameSetClickRect *)model;

/// 获取文本配置(棒球) MG_BASEBALL_TEXT_CONFIG
- (void)onGameMGBaseballTextConfig:(nonnull id <ISudFSMStateHandle>)handle;

#pragma mark - 3d语聊房状态变化

/// 请求房间数据 MG_CUSTOM_CR_ROOM_INIT_DATA
- (void)onGameMGCustomCrRoomInitData:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomCrRoomInitData *)model;

/// 点击主播位或老板位通知 MG_CUSTOM_CR_CLICK_SEAT
- (void)onGameMGCustomCrClickSeat:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomCrClickSeat *)model;

#pragma mark - 玩家状态变化

/// 玩家状态变化
/// 玩家: 加入状态  MG_COMMON_PLAYER_IN
- (void)onPlayerMGCommonPlayerIn:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGCommonPlayerInModel *)model;

/// 玩家: 准备状态  MG_COMMON_PLAYER_READY
- (void)onPlayerMGCommonPlayerReady:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGCommonPlayerReadyModel *)model;

/// 玩家: 队长状态  MG_COMMON_PLAYER_CAPTAIN
- (void)onPlayerMGCommonPlayerCaptain:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGCommonPlayerCaptainModel *)model;

/// 玩家: 游戏状态  MG_COMMON_PLAYER_PLAYING
- (void)onPlayerMGCommonPlayerPlaying:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGCommonPlayerPlayingModel *)model;

/// 玩家: 玩家在线状态  MG_COMMON_PLAYER_ONLINE
- (void)onPlayerMGCommonPlayerOnline:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGCommonPlayerOnlineModel *)model;

/// 玩家: 玩家换游戏位状态  MG_COMMON_PLAYER_CHANGE_SEAT
- (void)onPlayerMGCommonPlayerChangeSeat:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGCommonPlayerChangeSeatModel *)model;

/// 玩家: 游戏通知app点击玩家头像  MG_COMMON_SELF_CLICK_GAME_PLAYER_ICON
- (void)onPlayerMGCommonSelfClickGamePlayerIcon:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGCommonSelfClickGamePlayerIconModel *)model;

/// 游戏通知app层当前玩家死亡后变成ob视角
- (void)onGameMGCommonSelfObStatus:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonSelfObStatusModel *)model;

/// 游戏通知app玩家角色(狼人杀，谁是卧底) MG_COMMON_PLAYER_ROLE_ID
- (void)onPlayerMGCommonPlayerRoleId:(nonnull id <ISudFSMStateHandle>)handle model:(MgCommonPlayerRoleIdModel *)model;

/// 你画我猜状态
/// 你画我猜: 选词中  MG_DG_SELECTING
- (void)onPlayerMGDGSelecting:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGDGSelectingModel *)model;

/// 你画我猜: 作画中状态  MG_DG_PAINTING
- (void)onPlayerMGDGPainting:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGDGPaintingModel *)model;

/// 你画我猜: 显示错误答案状态  MG_DG_ERRORANSWER
- (void)onPlayerMGDGErrorAnswer:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGDGErrorAnswerModel *)model;

/// 你画我猜: 显示总积分状态  MG_DG_TOTALSCORE
- (void)onPlayerMGDGTotalScore:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGDGTotalScoreModel *)model;

/// 你画我猜: 本次获得积分状态  MG_DG_SCORE
- (void)onPlayerMGDGScore:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGDGScoreModel *)model;

/// 游戏通知app玩家死亡状态  MG_COMMON_SELF_DIE_STATUS
- (void)onPlayerMGCommonSelfDieStatus:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGCommonSelfDieStatusModel *)model;

/// 游戏通知app轮到玩家出手状态  MG_COMMON_SELF_TURN_STATUS
- (void)onPlayerMGCommonSelfTurnStatus:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGCommonSelfTurnStatusModel *)model;

/// 游戏通知app玩家选择状态  MG_COMMON_SELF_SELECT_STATUS
- (void)onPlayerMGCommonSelfSelectStatus:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGCommonSelfSelectStatusModel *)model;

/// 游戏通知app层当前游戏剩余时间  MG_COMMON_GAME_COUNTDOWN_TIME
- (void)onPlayerMGCommonGameCountdownTime:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGCommonGameCountdownTimeModel *)model;

@end

NS_ASSUME_NONNULL_END
