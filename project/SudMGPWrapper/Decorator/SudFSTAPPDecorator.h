//
//  SudFSTAPPManager.h
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/1/19.
//

#import <Foundation/Foundation.h>
/// SudMGPSDK
#import <SudMGP/ISudFSMMG.h>
#import <SudMGP/ISudFSTAPP.h>
#import <SudMGP/SudMGP.h>
#import <SudMGP/ISudFSMStateHandle.h>
#import "SudMGPAPPState.h"

NS_ASSUME_NONNULL_BEGIN

/// app -> 游戏
@interface SudFSTAPPDecorator : NSObject
// 是否停止游戏后台状态维护;默认false,即自动维护切换前后台游戏状态
@property(nonatomic, assign) BOOL stopBackgroundGameState;
@property(nonatomic, strong) id <ISudFSTAPP> iSudFSTAPP;

/// setI SudFSTAPP
- (void)setISudFSTAPP:(id <ISudFSTAPP>)iSudFSTAPP;

/// 继续游戏
- (void)playMG;

/// 暂停游戏
- (void)pauseMG;

/// 重新加载游戏
- (void)reLoadMG;

/// 销毁游戏
- (void)destroyMG;

/// 获取游戏View
- (UIView *)getGameView;

/// 更新code
/// @param code 新的code
- (void)updateCode:(NSString *)code;

/// 传输音频数据： 传入的音频数据必须是：PCM格式，采样率：16000， 采样位数：16， 声道数： MONO
- (void)pushAudio:(NSData *)data;

/// 状态通知（app to mg）
/// @param state 状态名称
/// @param dataJson 需传递的json
- (void)notifyStateChange:(NSString *)state dataJson:(NSString *)dataJson;

/// 加入,退出游戏
/// @param isIn true 加入游戏，false 退出游戏
/// @param seatIndex 加入的游戏位(座位号) 默认传seatIndex = -1 随机加入，seatIndex 从0开始，不可大于座位数
/// @param isSeatRandom 默认为ture, 带有游戏位(座位号)的时候，如果游戏位(座位号)已经被占用，是否随机分配一个空位坐下 isSeatRandom=true 随机分配空位坐下，isSeatRandom=false 不随机分配
/// @param teamId 不支持分队的游戏：数值填1；支持分队的游戏：数值填1或2（两支队伍）
- (void)notifyAppComonSelfIn:(BOOL)isIn seatIndex:(int)seatIndex isSeatRandom:(BOOL)isSeatRandom teamId:(int)teamId;

/// 是否设置为准备状态
/// @param isReady  true 准备，false 取消准备
- (void)notifyAppCommonSelfReady:(BOOL)isReady;

/// 游戏中状态设置
/// @param isPlaying   true 开始游戏，false 结束游戏
- (void)notifyAppComonSelfPlaying:(BOOL)isPlaying reportGameInfoExtras:(NSString *)reportGameInfoExtras;

/// 设置用户为队长
/// @param userId   必填，指定队长uid
- (void)notifyAppComonSetCaptainStateWithUserId:(NSString *)userId;

/// 踢出用户
/// @param userId   被踢用户uid
- (void)notifyAppComonKickStateWithUserId:(NSString *)userId;

/// 结束游戏
- (void)notifyAppCommonSelfEnd;

/// 房间状态（depreated 已废弃v1.1.30.xx）
/// @param isIn    true 在房间内，false 不在房间内
- (void)notifyAppComonSelfRoom:(BOOL)isIn;

/// 麦位状态（depreated 已废弃v1.1.30.xx）
/// @param lastSeat    之前在几号麦，从0开始，之前未在麦上值为-1
/// @param currentSeat    目前在几号麦，从0开始，目前未在麦上值为-1
- (void)notifyAppComonSelfSeat:(NSInteger)lastSeat currentSeat:(NSInteger)currentSeat;

/// 麦克风状态
/// @param isOn   true 开麦，false 闭麦
/// @param isDisabled   true 被禁麦，false 未被禁麦
- (void)notifyAppComonMicrophoneState:(BOOL)isOn isDisabled:(BOOL)isDisabled;

/// 文字命中状态
/// @param isHit true 命中，false 未命中
/// @param keyWord 单个关键词， 兼容老版本
/// @param text 返回转写文本
/// @param wordType text:文本包含匹配; number:数字等于匹配
/// @param keyWordList 命中关键词，可以包含多个关键词
/// @param numberList 在number模式下才有，返回转写的多个数字
- (void)notifyAppComonDrawTextHit:(BOOL)isHit keyWord:(NSString *)keyWord text:(NSString *)text wordType:(NSString *)wordType keyWordList:(NSArray<NSString *> *)keyWordList numberList:(NSArray<NSNumber *> *)numberList;

/// 文字命中状态
/// @param isHit true 命中，false 未命中
/// @param keyWord 单个关键词， 兼容老版本
/// @param text 返回转写文本
- (void)notifyAppComonDrawTextHit:(BOOL)isHit keyWord:(NSString *)keyWord text:(NSString *)text;

/// 打开或关闭背景音乐
/// @param isOpen  true 打开背景音乐，false 关闭背景音乐
- (void)notifyAppComonOpenBgMusic:(BOOL)isOpen;

/// 打开或关闭音效
/// @param isOpen  true 打开音效，false 关闭音效
- (void)notifyAppComonOpenSound:(BOOL)isOpen;

/// 打开或关闭游戏中的振动效果
/// @param isOpen  true 打开振动效果，false 关闭振动效果
- (void)notifyAppComonOpenVibrate:(BOOL)isOpen;

/// 设置游戏的音量大小
/// @param volume  音量大小 0 到 100
- (void)notifyAppComonOpenSoundVolume:(int)volume;

/// 设置游戏上报信息扩展参数（透传）
/// @param reportGameInfoExtras   string类型，Https服务回调report_game_info参数，最大长度1024字节，超过则截断（2022-01-21）
- (void)notifyAppCommonReportGameInfoExtras:(NSString *)reportGameInfoExtras;

/// 设置游戏中的AI玩家（2022-05-11新增） APP_COMMON_GAME_ADD_AI_PLAYERS
/// @param appCommonGameAddAiPlayersModel  配置信息
- (void)notifyAppCommonGameAddAIPlayers:(AppCommonGameAddAIPlayersModel *)appCommonGameAddAiPlayersModel;

/// 元宇宙砂砂舞相关设置(app_common_game_disco_action)
/// 参考文档: https://docs.sud.tech/zh-CN/app/Client/APPFST/CommonStateForDisco.html
/// @param actionModel 指令参数model
- (void)notifyAppCommonGameDiscoAction:(AppCommonGameDiscoAction *)actionModel;

/// 设置游戏玩法选项（2022-05-10新增） APP_COMMON_GAME_SETTING_SELECT_INFO
/// @param actionModel 指令参数model
- (void)notifyAppCommonGameSettingSelectInfo:(AppCommonGameSettingGameInfo *)appCommonGameSettingGameInfo;

/// app在收到游戏断开连接通知后，通知游戏重试连接（2022-06-21新增，暂时支持ludo) APP_COMMON_GAME_RECONNECT
- (void)notifyAppCommonGameReconnect;

/// app返回玩家当前积分 (2022-09-26 新增)
- (void)notifyAppCommonGameScore:(AppCommonGameScore *)appCommonGameScore;

/// APP_COMMON_USERS_INFO
- (void)notifyAppCommonUsersInfo:(AppCommonUsersInfo *)model;

/// APP_COMMON_GAME_CREATE_ORDER_RESULT
- (void)notifyAppCommonGameCreateOrderResult:(AppCommonGameCreateOrderResult *)model;

/// APP_COMMON_GAME_CREATE_ORDER_RESULT
- (void)notifyAppCommonCustomHelpInfo:(AppCommonGameCustomHelpInfo *)model;

/// app主动调起主界面 APP_COMMON_SHOW_GAME_SCENE
- (void)notifyAppCommonShowGameScene;

/// app主动隐藏主界面 APP_COMMON_HIDE_GAME_SCENE
- (void)notifyAppCommonHideGameScene;

/// app通知游戏爆词内容(谁是卧底) APP_COMMON_GAME_SEND_BURST_WORD
- (void)notifyAppCommonGameSendBurstWord:(AppCommonGameSendBurstWord *)model;

/// app通知游戏玩家所持有的道具卡(大富翁) APP_COMMON_GAME_PLAYER_MONOPOLY_CARDS
- (void)notifyAppCommonGamePlayerMonopolyCards:(AppCommonGamePlayerMonopolyCards *)model;

/// app通知游戏获取到道具卡（大富翁） APP_COMMON_GAME_SHOW_MONOPOLY_CARD_EFFECT
- (void)notifyAppCommonGameShowMonopolyCardEffect:(AppCommonGameShowMonopolyCardEffect *)model;

/// app 通知游戏点赞玩家（2022-11-19 增加，当前支持你画我猜，你说我猜，友尽闯关）APP_COMMON_SELF_CLICK_GOOD
- (void)notifyAppCommonSelfClickGood:(AppCommonSelfClickGood *)model;

/// app 通知游戏扔大便玩家（2022-11-19 增加，当前支持你画我猜，你说我猜，友尽闯关）APP_COMMON_SELF_CLICK_POOP
- (void)notifyAppCommonSelfClickPoop:(AppCommonSelfClickPoop *)model;

/// app 通知游戏设置 FPS APP_COMMON_GAME_FPS
- (void)notifyAppCommonGameFps:(AppCommonGameFps *)model;

/// app 通知游戏设置玩法（只支持 德州 pro 和 teenpattipro）APP_COMMON_GAME_SETTINGS
- (void)notifyAppCommonGameSettings:(AppCommonGameSettings *)model;

/// app 通知游返回大厅（当前支持umo）APP_COMMON_GAME_BACK_LOBBY
- (void)notifyAppCommonGameBackLobby:(AppCommonGameBackLobby *)model;

/// app通知游戏定制UI配置表 (支持ludo和五子棋) APP_COMMON_GAME_UI_CUSTOM_CONFIG
- (void)notifyAppCommonGameUiCustomConfig:(AppCommonGameUiCustomConfig *)model;

#pragma mark - 互动礼物<火箭>

/// 礼物配置文件 APP_CUSTOM_ROCKET_CONFIG
- (void)notifyAppCustomRocketConfig:(AppCustomRocketConfigModel *)model;

/// 拥有模型列表(火箭) APP_CUSTOM_ROCKET_MODEL_LIST
- (void)notifyAppCustomRocketModelList:(AppCustomRocketModelListModel *)model;

/// 拥有组件列表(火箭) APP_CUSTOM_ROCKET_COMPONENT_LIST
- (void)notifyAppCustomRocketComponentList:(AppCustomRocketComponentListModel *)model;

/// 获取用户的信息(火箭) APP_CUSTOM_ROCKET_USER_INFO
- (void)notifyAppCustomRocketUserInfo:(AppCustomRocketUserInfoModel *)model;

/// app推送主播信息(火箭) APP_CUSTOM_ROCKET_NEW_USER_INFO
- (void)notifyAppCustomRocketNewUserInfo:(AppCustomRocketUserInfoModel *)model;

/// 订单记录列表(火箭) APP_CUSTOM_ROCKET_ORDER_RECORD_LIST
- (void)notifyAppCustomRocketOrderRecordList:(AppCustomRocketOrderRecordListModel *)model;

/// 展馆内列表(火箭) APP_CUSTOM_ROCKET_ROOM_RECORD_LIST
- (void)notifyAppCustomRocketRoomRecordList:(AppCustomRocketRoomRecordListModel *)model;

/// 展馆内玩家送出记录(火箭) APP_CUSTOM_ROCKET_USER_RECORD_LIST
- (void)notifyAppCustomRocketUserRecordList:(AppCustomRocketUserRecordListModel *)model;

/// 设置默认位置(火箭) APP_CUSTOM_ROCKET_SET_DEFAULT_MODEL
- (void)notifyAppCustomRocketSetDefaultSeat:(AppCustomRocketSetDefaultSeatModel *)model;

/// 动态计算一键发送价格(火箭) APP_CUSTOM_ROCKET_DYNAMIC_FIRE_PRICE
- (void)notifyAppCustomRocketDynamicFirePrice:(AppCustomRocketDynamicFirePriceModel *)model;

/// 一键发送(火箭) APP_CUSTOM_ROCKET_FIRE_MODEL
- (void)notifyAppCustomRocketFireModel:(AppCustomRocketFireModel *)model;

/// 新组装模型(火箭) APP_CUSTOM_ROCKET_CREATE_MODEL
- (void)notifyAppCustomRocketCreateModel:(AppCustomRocketCreateModel *)model;

/// 更换组件(火箭) APP_CUSTOM_ROCKET_REPLACE_COMPONENT
- (void)notifyAppCustomRocketReplaceComponent:(AppCustomRocketReplaceComponentModel *)model;

/// 购买组件(火箭) APP_CUSTOM_ROCKET_BUY_COMPONENT
- (void)notifyAppCustomRocketBuyComponent:(AppCustomRocketBuyComponentModel *)model;

/// app推送播放模型(火箭) APP_CUSTOM_ROCKET_PLAY_MODEL_LIST
- (void)notifyAppCustomRocketPlayModelList:(AppCustomRocketPlayModelListModel *)model;

/// 验证签名合规(火箭) APP_CUSTOM_ROCKET_VERIFY_SIGN
- (void)notifyAppCustomRocketVerifySign:(AppCustomRocketVerifySignModel *)model;

/// app主动调起游戏显示(火箭) APP_CUSTOM_ROCKET_SHOW_GAME_SCENE
- (void)notifyAppCustomRocketShowGame;

/// app主动调起游戏隐藏(火箭) APP_CUSTOM_ROCKET_HIDE_GAME_SCENE
- (void)notifyAppCustomRocketHideGame;

/// app推送解锁组件（火箭) APP_CUSTOM_ROCKET_UNLOCK_COMPONENT
- (void)notifyAppCustomRocketUnlockComponent:(AppCustomRocketUnlockComponent *)model;

/// app推送关闭火箭播放效果(火箭) APP_CUSTOM_ROCKET_CLOSE_PLAY_EFFECT
- (void)notifyAppCustomRocketClosePlayEffect;

/// app推送火箭效果飞行点击(火箭) APP_CUSTOM_ROCKET_FLY_CLICK
- (void)notifyAppCustomRocketFlyClick;

/// 颜色和签名自定义改到装配间的模式，保存颜色或签名 APP_CUSTOM_ROCKET_SAVE_SIGN_COLOR
- (void)notifyAppCustomRocketSaveSignColor:(AppCustomRocketSaveSignColorModel *)model;

#pragma mark - 互动礼物<棒球>

/// 查询排行榜数据 APP_BASEBALL_RANKING
- (void)notifyAppBaseballRanking:(AppBaseballRankingModel *)model;

/// 查询我的排名数据 APP_BASEBALL_MY_RANKING
- (void)notifyAppBaseballMyRanking:(AppBaseballMyRankingModel *)model;

/// 排在自己前后的玩家数据 APP_BASEBALL_RANGE_INFO
- (void)notifyAppBaseballRangeInfo:(AppBaseballRangeInfoModel *)model;

/// app主动调起主界面 APP_BASEBALL_SHOW_GAME_SCENE
- (void)notifyAppBaseballShowGameScene;

/// app主动隐藏主界面 APP_BASEBALL_HIDE_GAME_SCENE
- (void)notifyAppBaseballHideGameScene;

/// 排在自己前后的玩家数据 APP_BASEBALL_TEXT_CONFIG
- (void)notifyAppBaseballTextConfig:(AppBaseballTextConfigModel *)model;

#pragma mark - 3d语聊房

/// 设置房间配置 APP_CUSTOM_CR_SET_ROOM_CONFIG
- (void)notifyAppCustomCrSetRoomConfig:(AppCustomCrSetRoomConfigModel *)model;

/// 设置主播位数据 APP_CUSTOM_CR_SET_SEATS
- (void)notifyAppCustomCrSetSeats:(AppCustomCrSetSeatsModel *)model;

/// 播放收礼效果 APP_CUSTOM_CR_PLAY_GIFT_EFFECT
- (void)notifyAppCustomCrPlayGiftEffect:(AppCustomCrPlayGiftEffectModel *)model;

/// 通知播放爆灯特效 APP_CUSTOM_CR_SET_LIGHT_FLASH
- (void)notifyAppCustomCrSetLightFlash:(AppCustomCrSetLightFlashModel *)model;

/// 通知主播播放指定动作 APP_CUSTOM_CR_PLAY_ANIM
- (void)notifyAppCustomCrPlayAnim:(AppCustomCrPlayAnimModel *)model;

/// 通知麦浪值变化 APP_CUSTOM_CR_MICPHONE_VALUE_SEAT
- (void)notifyAppCustomCrMicphoneValueSeat:(AppCustomCrMicphoneValueSeatModel *)model;

/// 通知暂停或恢复立方体自转 APP_CUSTOM_CR_PAUSE_ROTATE
- (void)notifyAppCustomCrPauseRotate:(AppCustomCrPauseRotateModel *)model;
@end

NS_ASSUME_NONNULL_END
