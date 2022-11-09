//
//  SudFSMMGListener.h
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/2/18.
//

#import <Foundation/Foundation.h>
#import <SudMGP/ISudFSMMG.h>
#import <SudMGP/ISudFSTAPP.h>
#import <SudMGP/SudMGP.h>
#import <SudMGP/ISudAPPD.h>
#import <SudMGP/ISudFSMStateHandle.h>
#import "SudMGPMGState.h"

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


/**
 * 游戏状态变化
 * @param handle 回调句柄
 * @param state 游戏状态
 * @param dataJson 回调json
 */
- (BOOL)onGameStateChange:(nonnull id <ISudFSMStateHandle>)handle state:(nonnull NSString *)state dataJson:(nonnull NSString *)dataJson;

/**
 * 游戏玩家状态变化,如实现方实现了改接口，并返回YES，则数据解析完全由实现方自行处理，内部不在做数据模型的解析，返回NO则内部执行数据序列化
 * @param handle 回调句柄
 * @param userId 用户id
 * @param state  玩家状态
 * @param dataJson 回调JSON
 */
- (BOOL)onPlayerStateChange:(nullable id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId state:(nonnull NSString *)state dataJson:(nonnull NSString *)dataJson;

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
- (void)onGameMGCommonGameNetworkState;

/// 游戏通知app获取积分 MG_COMMON_GAME_SCORE
- (void)onGameMGCommonGameGetScore:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameGetScoreModel *)model;

/// 游戏通知app带入积分 MG_COMMON_GAME_SET_SCORE
- (void)onGameMGCommonGameSetScore:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSetScoreModel *)model;

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

/// 火箭的可点击区域((火箭) MG_CUSTOM_ROCKET_SET_CLICK_RECT
- (void)onGameMGCustomRocketSetClickRect:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketSetClickRect *)model;

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
