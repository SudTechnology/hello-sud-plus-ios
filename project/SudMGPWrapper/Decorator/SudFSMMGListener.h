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
- (void)onGetGameViewInfo:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson;

/// 短期令牌code过期  【需要实现】
- (void)onExpireCode:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson;

/// 获取游戏Config  【需要实现】
- (void)onGetGameCfg:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson;


@optional
/// 游戏开始
- (void)onGameStarted;

/// 游戏销毁
- (void)onGameDestroyed;

/// 游戏日志
/// 最低版本：v1.1.30.xx
- (void)onGameLog:(nonnull NSString *)dataJson;

/// 通用状态-游戏
/// 游戏: 公屏消息状态    MG_COMMON_PUBLIC_MESSAGE
- (void)onGameMGCommonPublicMessage:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonPublicMessageModel *)model;

/// 游戏: 关键词状态    MG_COMMON_KEY_WORD_TO_HIT
- (void)onGameMGCommonKeyWordToHit:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonKeyWrodToHitModel *)model;

/// 游戏: 游戏结算状态     MG_COMMON_GAME_SETTLE
- (void)onGameMGCommonGameSettle:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonGameSettleModel *)model;

/// 游戏: 加入游戏按钮点击状态   MG_COMMON_SELF_CLICK_JOIN_BTN
- (void)onGameMGCommonSelfClickJoinBtn:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonSelfClickJoinBtn *)model;

/// 游戏: 取消加入游戏按钮点击状态   MG_COMMON_SELF_CLICK_CANCEL_JOIN_BTN
- (void)onGameMGCommonSelfClickCancelJoinBtn:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonSelfClickCancelJoinBtn *)model;

/// 游戏: 准备按钮点击状态   MG_COMMON_SELF_CLICK_READY_BTN
- (void)onGameMGCommonSelfClickReadyBtn:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonSelfClickReadyBtn *)model;

/// 游戏: 取消准备按钮点击状态   MG_COMMON_SELF_CLICK_CANCEL_READY_BTN
- (void)onGameMGCommonSelfClickCancelReadyBtn:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonSelfClickCancelReadyBtn *)model;

/// 游戏: 开始游戏按钮点击状态   MG_COMMON_SELF_CLICK_START_BTN
- (void)onGameMGCommonSelfClickStartBtn:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonSelfClickStartBtn *)model;

/// 游戏: 分享按钮点击状态   MG_COMMON_SELF_CLICK_SHARE_BTN
- (void)onGameMGCommonSelfClickShareBtn:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonSelfClickShareBtn *)model;

/// 游戏: 游戏状态   MG_COMMON_GAME_STATE
- (void)onGameMGCommonGameState:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonGameState *)model;

/// 游戏: 结算界面关闭按钮点击状态   MG_COMMON_SELF_CLICK_GAME_SETTLE_CLOSE_BTN
- (void)onGameMGCommonSelfClickGameSettleCloseBtn:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonSelfClickGameSettleCloseBtn *)model;

/// 游戏: 结算界面再来一局按钮点击状态   MG_COMMON_SELF_CLICK_GAME_SETTLE_AGAIN_BTN
- (void)onGameMGCommonSelfClickGameSettleAgainBtn:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonSelfClickGameSettleAgainBtn *)model;

/// 游戏: 游戏上报游戏中的声音列表   MG_COMMON_GAME_SOUND_LIST
- (void)onGameMGCommonGameSoundList:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonGameSoundListModel *)model;

/// 游戏: 游戏通知app层播放声音   MG_COMMON_GAME_SOUND
- (void)onGameMGCommonGameSound:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonGameSound *)model;

/// 游戏: 游戏通知app层播放背景音乐状态   MG_COMMON_GAME_BG_MUSIC_STATE
- (void)onGameMGCommonGameBgMusicState:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonGameBgMusicState *)model;

/// 游戏: 游戏通知app层播放音效的状态   MG_COMMON_GAME_SOUND_STATE
- (void)onGameMGCommonGameSoundState:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonGameSoundState *)model;

/// 游戏: ASR状态(开启和关闭语音识别状态   MG_COMMON_GAME_ASR
- (void)onGameMGCommonGameASR:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonGameASRModel *)model;

/// 游戏: 麦克风状态   MG_COMMON_GAME_SELF_MICROPHONE
- (void)onGameMGCommonGameSelfMicrophone:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonGameSelfMicrophone *)model;

/// 游戏: 耳机（听筒，扬声器）状态   MG_COMMON_GAME_SELF_HEADEPHONE
- (void)onGameMGCommonGameSelfHeadphone:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonGameSelfHeadphone *)model;

/// 元宇宙砂砂舞 指令回调  MG_COMMON_GAME_DISCO_ACTION
- (void)onGameMGCommonGameDiscoAction:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonGameDiscoActionModel *)model;

/// 元宇宙砂砂舞 指令动作结束通知  MG_COMMON_GAME_DISCO_ACTION_END
- (void)onGameMGCommonGameDiscoActionEnd:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonGameDiscoActionEndModel *)model;


/// 玩家状态变化
/// 玩家: 加入状态  MG_COMMON_PLAYER_IN
- (void)onPlayerMGCommonPlayerIn:(nonnull id<ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGCommonPlayerInModel *)model;

/// 玩家: 准备状态  MG_COMMON_PLAYER_READY
- (void)onPlayerMGCommonPlayerReady:(nonnull id<ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGCommonPlayerReadyModel *)model;

/// 玩家: 队长状态  MG_COMMON_PLAYER_CAPTAIN
- (void)onPlayerMGCommonPlayerCaptain:(nonnull id<ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGCommonPlayerCaptainModel *)model;

/// 玩家: 游戏状态  MG_COMMON_PLAYER_PLAYING
- (void)onPlayerMGCommonPlayerPlaying:(nonnull id<ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGCommonPlayerPlayingModel *)model;

/// 玩家: 玩家在线状态  MG_COMMON_PLAYER_ONLINE
- (void)onPlayerMGCommonPlayerOnline:(nonnull id<ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGCommonPlayerOnlineModel *)model;

/// 玩家: 玩家换游戏位状态  MG_COMMON_PLAYER_CHANGE_SEAT
- (void)onPlayerMGCommonPlayerChangeSeat:(nonnull id<ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGCommonPlayerChangeSeatModel *)model;

/// 玩家: 游戏通知app点击玩家头像  MG_COMMON_SELF_CLICK_GAME_PLAYER_ICON
- (void)onPlayerMGCommonSelfClickGamePlayerIcon:(nonnull id<ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGCommonSelfClickGamePlayerIconModel *)model;

/// 你画我猜状态
/// 你画我猜: 选词中  MG_DG_SELECTING
- (void)onPlayerMGDGSelecting:(nonnull id<ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGDGSelectingModel *)model;

/// 你画我猜: 作画中状态  MG_DG_PAINTING
- (void)onPlayerMGDGPainting:(nonnull id<ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGDGPaintingModel *)model;

/// 你画我猜: 显示错误答案状态  MG_DG_ERRORANSWER
- (void)onPlayerMGDGErrorAnswer:(nonnull id<ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGDGErrorAnswerModel *)model;

/// 你画我猜: 显示总积分状态  MG_DG_TOTALSCORE
- (void)onPlayerMGDGTotalScore:(nonnull id<ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGDGTotalScoreModel *)model;

/// 你画我猜: 本次获得积分状态  MG_DG_SCORE
- (void)onPlayerMGDGScore:(nonnull id<ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGDGScoreModel *)model;

@end

NS_ASSUME_NONNULL_END
