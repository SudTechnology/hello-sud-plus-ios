//
//  SudFSTAPPManager.m
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/1/19.
//

#import "SudFSTAPPDecorator.h"
#import <MJExtension/MJExtension.h>
#import "SudMGPAPPState.h"

@implementation SudFSTAPPDecorator

- (void)dealloc {
    NSLog(@"dealloc:%@", [self class]);
}

- (void)setISudFSTAPP:(id <ISudFSTAPP>)iSudFSTAPP {
    if (_iSudFSTAPP) {
        NSLog(@"_iSudFSTAPP will destroy");
        [_iSudFSTAPP destroyMG];
    }
    _iSudFSTAPP = iSudFSTAPP;
    if (!self.stopBackgroundGameState) {
        [self addNotification];
    }
}

- (void)addNotification {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
    // 维护游戏进入前后台状态
    [defaultCenter addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    if (_iSudFSTAPP) {
        [_iSudFSTAPP pauseMG];
    }
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    if (_iSudFSTAPP) {
        [_iSudFSTAPP playMG];
    }
}


/// 继续游戏
- (void)playMG {
    [self.iSudFSTAPP playMG];
}

/// 暂停游戏
- (void)pauseMG {
    [self.iSudFSTAPP pauseMG];
}

/// 重新加载游戏
- (void)reLoadMG {
    [self.iSudFSTAPP reloadMG];
}

- (void)destroyMG {
    [self.iSudFSTAPP destroyMG];
    self.iSudFSTAPP = nil;
}

- (UIView *)getGameView {
    return [self.iSudFSTAPP getGameView];
}

/// 更新code
/// @param code 新的code
- (void)updateCode:(NSString *)code {
    [self.iSudFSTAPP updateCode:code listener:^(int retCode, const NSString *retMsg, const NSString *dataJson) {
        NSLog(@"ISudFSMMG:updateGameCode retCode=%@ retMsg=%@ dataJson=%@", @(retCode), retMsg, dataJson);
    }];
}

/// 传输音频数据： 传入的音频数据必须是：PCM格式，采样率：16000， 采样位数：16， 声道数： MONO
- (void)pushAudio:(NSData *)data {
    /// 必须要在主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.iSudFSTAPP pushAudio:data];
    });
}

/// 加入,退出游戏
/// @param isIn true 加入游戏，false 退出游戏
/// @param seatIndex 加入的游戏位(座位号) 默认传seatIndex = -1 随机加入，seatIndex 从0开始，不可大于座位数
/// @param isSeatRandom 默认为ture, 带有游戏位(座位号)的时候，如果游戏位(座位号)已经被占用，是否随机分配一个空位坐下 isSeatRandom=true 随机分配空位坐下，isSeatRandom=false 不随机分配
/// @param teamId 不支持分队的游戏：数值填1；支持分队的游戏：数值填1或2（两支队伍）
- (void)notifyAppComonSelfIn:(BOOL)isIn seatIndex:(int)seatIndex isSeatRandom:(BOOL)isSeatRandom teamId:(int)teamId {
    NSDictionary *dic = @{@"isIn": @(isIn), @"seatIndex": @(seatIndex), @"isSeatRandom": @(isSeatRandom), @"teamId": @(teamId)};
    [self notifyStateChange:APP_COMMON_SELF_IN dataJson:dic.mj_JSONString];
}

/// 是否设置为准备状态
/// @param isReady  true 准备，false 取消准备
- (void)notifyAppCommonSelfReady:(BOOL)isReady {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(isReady), @"isReady", nil];
    [self notifyStateChange:APP_COMMON_SELF_READY dataJson:dic.mj_JSONString];
}

/// 游戏中状态设置
/// @param isPlaying   true 开始游戏，false 结束游戏
- (void)notifyAppComonSelfPlaying:(BOOL)isPlaying reportGameInfoExtras:(NSString *)reportGameInfoExtras {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(isPlaying), @"isPlaying", reportGameInfoExtras, @"reportGameInfoExtras", nil];
    [self notifyStateChange:APP_COMMON_SELF_PLAYING dataJson:dic.mj_JSONString];
}

/// 设置用户为队长
/// @param userId   必填，指定队长uid
- (void)notifyAppComonSetCaptainStateWithUserId:(NSString *)userId {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"curCaptainUID", nil];
    [self notifyStateChange:APP_COMMON_SELF_CAPTAIN dataJson:dic.mj_JSONString];
}

/// 踢出用户
/// @param userId   被踢用户uid
- (void)notifyAppComonKickStateWithUserId:(NSString *)userId {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"kickedUID", nil];
    [self notifyStateChange:APP_COMMON_SELF_KICK dataJson:dic.mj_JSONString];
}

/// 结束游戏
- (void)notifyAppCommonSelfEnd {

    [self notifyStateChange:APP_COMMON_SELF_END dataJson:@{}.mj_JSONString];
}

/// 房间状态（depreated 已废弃v1.1.30.xx）
/// @param isIn    true 在房间内，false 不在房间内
- (void)notifyAppComonSelfRoom:(BOOL)isIn {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(isIn), @"isIn", nil];
    [self notifyStateChange:APP_COMMON_SELF_ROOM dataJson:dic.mj_JSONString];
}

/// 麦位状态（depreated 已废弃v1.1.30.xx）
/// @param lastSeat    之前在几号麦，从0开始，之前未在麦上值为-1
/// @param currentSeat    目前在几号麦，从0开始，目前未在麦上值为-1
- (void)notifyAppComonSelfSeat:(NSInteger)lastSeat currentSeat:(NSInteger)currentSeat {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(lastSeat), @"isIn", @(currentSeat), @"currentSeat", nil];
    [self notifyStateChange:APP_COMMON_SELF_SEAT dataJson:dic.mj_JSONString];
}

/// 麦克风状态
/// @param isOn   true 开麦，false 闭麦
/// @param isDisabled   true 被禁麦，false 未被禁麦
- (void)notifyAppComonMicrophoneState:(BOOL)isOn isDisabled:(BOOL)isDisabled {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(isOn), @"isOn", @(isDisabled), @"isDisabled", nil];
    [self notifyStateChange:APP_COMMON_SELF_MICROPHONE dataJson:dic.mj_JSONString];
}

/// 文字命中状态
/// @param isHit true 命中，false 未命中
/// @param keyWord 单个关键词， 兼容老版本
/// @param text 返回转写文本
/// @param wordType text:文本包含匹配; number:数字等于匹配
/// @param keyWordList 命中关键词，可以包含多个关键词
/// @param numberList 在number模式下才有，返回转写的多个数字
- (void)notifyAppComonDrawTextHit:(BOOL)isHit keyWord:(NSString *)keyWord text:(NSString *)text wordType:(NSString *)wordType keyWordList:(NSArray<NSString *> *)keyWordList numberList:(NSArray<NSNumber *> *)numberList {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(isHit), @"isHit", keyWord, @"keyWord", text, @"text", wordType, @"wordType", keyWordList, @"keyWordList", numberList, @"numberList", nil];
    [self notifyStateChange:APP_COMMON_SELF_TEXT_HIT dataJson:dic.mj_JSONString];
}

/// 文字命中状态
/// @param isHit true 命中，false 未命中
/// @param keyWord 单个关键词， 兼容老版本
/// @param text 返回转写文本
- (void)notifyAppComonDrawTextHit:(BOOL)isHit keyWord:(NSString *)keyWord text:(NSString *)text {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(isHit), @"isHit", keyWord, @"keyWord", text, @"text", nil];
    [self notifyStateChange:APP_COMMON_SELF_TEXT_HIT dataJson:dic.mj_JSONString];
}

/// 打开或关闭背景音乐
/// @param isOpen  true 打开背景音乐，false 关闭背景音乐
- (void)notifyAppComonOpenBgMusic:(BOOL)isOpen {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(isOpen), @"isOpen", nil];
    [self notifyStateChange:APP_COMMON_OPEN_BG_MUSIC dataJson:dic.mj_JSONString];
}

/// 打开或关闭音效
/// @param isOpen  true 打开音效，false 关闭音效
- (void)notifyAppComonOpenSound:(BOOL)isOpen {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(isOpen), @"isOpen", nil];
    [self notifyStateChange:APP_COMMON_OPEN_SOUND dataJson:dic.mj_JSONString];
}

/// 打开或关闭游戏中的振动效果
/// @param isOpen  true 打开振动效果，false 关闭振动效果
- (void)notifyAppComonOpenVibrate:(BOOL)isOpen {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(isOpen), @"isOpen", nil];
    [self notifyStateChange:APP_COMMON_OPEN_BRATE dataJson:dic.mj_JSONString];
}

/// 设置游戏的音量大小
/// @param volume  音量大小 0 到 100
- (void)notifyAppComonOpenSoundVolume:(int)volume {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(volume), @"volume", nil];
    [self notifyStateChange:APP_COMMON_SOUND_VOLUME dataJson:dic.mj_JSONString];
}

/// 设置游戏上报信息扩展参数（透传）
/// @param reportGameInfoExtras   string类型，Https服务回调report_game_info参数，最大长度1024字节，超过则截断（2022-01-21）
- (void)notifyAppCommonReportGameInfoExtras:(NSString *)reportGameInfoExtras {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:reportGameInfoExtras, @"reportGameInfoExtras", nil];
    [self notifyStateChange:APP_COMMON_GAME_INFO_EXTRAS dataJson:dic.mj_JSONString];
}

/// 设置游戏中的AI玩家（2022-05-11新增） APP_COMMON_GAME_ADD_AI_PLAYERS
/// @param appCommonGameAddAiPlayersModel  配置信息
- (void)notifyAppCommonGameAddAIPlayers:(AppCommonGameAddAIPlayersModel *)appCommonGameAddAiPlayersModel {

    NSString *jsonStr = [appCommonGameAddAiPlayersModel mj_JSONString];
    [self notifyStateChange:APP_COMMON_GAME_ADD_AI_PLAYERS dataJson:jsonStr];
}

/// 元宇宙砂砂舞相关设置(app_common_game_disco_action)
/// 参考文档: https://docs.sud.tech/zh-CN/app/Client/APPFST/CommonStateForDisco.html
/// @param actionModel 指令参数model
- (void)notifyAppCommonGameDiscoAction:(AppCommonGameDiscoAction *)actionModel {
    [self notifyStateChange:APP_COMMON_GAME_DISCO_ACTION dataJson:actionModel.mj_JSONString];
}

/// 设置游戏玩法选项（2022-05-10新增） APP_COMMON_GAME_SETTING_SELECT_INFO
/// @param actionModel 指令参数model
- (void)notifyAppCommonGameSettingSelectInfo:(AppCommonGameSettingGameInfo *)appCommonGameSettingGameInfo {
    [self notifyStateChange:APP_COMMON_GAME_SETTING_SELECT_INFO dataJson:appCommonGameSettingGameInfo.mj_JSONString];
}

/// app在收到游戏断开连接通知后，通知游戏重试连接（2022-06-21新增，暂时支持ludo) APP_COMMON_GAME_RECONNECT
- (void)notifyAppCommonGameReconnect {
    [self notifyStateChange:APP_COMMON_GAME_RECONNECT dataJson:@{}.mj_JSONString];
}

/// app返回玩家当前积分 (2022-09-26 新增)
- (void)notifyAppCommonGameScore:(AppCommonGameScore *)appCommonGameScore {
    [self notifyStateChange:APP_COMMON_GAME_SCORE dataJson:appCommonGameScore.mj_JSONString];
}

#pragma mark =======APP->游戏状态处理=======

/// 状态通知（app to mg）
/// @param state 状态名称
/// @param dataJson 需传递的json
- (void)notifyStateChange:(NSString *)state dataJson:(NSString *)dataJson {
    [self.iSudFSTAPP notifyStateChange:state dataJson:dataJson listener:^(int retCode, const NSString *retMsg, const NSString *dataJson) {
        NSLog(@"ISudFSMMG:notifyStateChange:state=%@ retCode=%@ retMsg=%@ dataJson=%@", state, @(retCode), retMsg, dataJson);
    }];
}

/// APP_COMMON_USERS_INFO
- (void)notifyAppCommonUsersInfo:(AppCommonUsersInfo *)model {
    [self notifyStateChange:APP_COMMON_USERS_INFO dataJson:model.mj_JSONString];
}

/// APP_COMMON_GAME_CREATE_ORDER_RESULT
- (void)notifyAppCommonGameCreateOrderResult:(AppCommonGameCreateOrderResult *)model {
    [self notifyStateChange:APP_COMMON_GAME_CREATE_ORDER_RESULT dataJson:model.mj_JSONString];
}

/// APP_COMMON_CUSTOM_HELP_INFO
- (void)notifyAppCommonCustomHelpInfo:(AppCommonGameCustomHelpInfo *)model {
    [self notifyStateChange:APP_COMMON_CUSTOM_HELP_INFO dataJson:model.mj_JSONString];
}

/// app主动调起主界面 APP_COMMON_SHOW_GAME_SCENE
- (void)notifyAppCommonShowGameScene {
    [self notifyStateChange:APP_COMMON_SHOW_GAME_SCENE dataJson:@{}.mj_JSONString];
}

/// app主动隐藏主界面 APP_COMMON_HIDE_GAME_SCENE
- (void)notifyAppCommonHideGameScene {
    [self notifyStateChange:APP_COMMON_HIDE_GAME_SCENE dataJson:@{}.mj_JSONString];
}

/// app通知游戏爆词内容(谁是卧底) APP_COMMON_GAME_SEND_BURST_WORD
- (void)notifyAppCommonGameSendBurstWord:(AppCommonGameSendBurstWord *)model {
    [self notifyStateChange:APP_COMMON_GAME_SEND_BURST_WORD dataJson:model.mj_JSONString];
}

/// app通知游戏玩家所持有的道具卡(大富翁) APP_COMMON_GAME_PLAYER_MONOPOLY_CARDS
- (void)notifyAppCommonGamePlayerMonopolyCards:(AppCommonGamePlayerMonopolyCards *)model {
    [self notifyStateChange:APP_COMMON_GAME_PLAYER_MONOPOLY_CARDS dataJson:model.mj_JSONString];
}

/// app通知游戏获取到道具卡（大富翁） APP_COMMON_GAME_SHOW_MONOPOLY_CARD_EFFECT
- (void)notifyAppCommonGameShowMonopolyCardEffect:(AppCommonGameShowMonopolyCardEffect *)model {
    [self notifyStateChange:APP_COMMON_GAME_SHOW_MONOPOLY_CARD_EFFECT dataJson:model.mj_JSONString];
}

/// app 通知游戏点赞玩家（2022-11-19 增加，当前支持你画我猜，你说我猜，友尽闯关）APP_COMMON_SELF_CLICK_GOOD
- (void)notifyAppCommonSelfClickGood:(AppCommonSelfClickGood *)model {
    [self notifyStateChange:APP_COMMON_SELF_CLICK_GOOD dataJson:model.mj_JSONString];
}

/// app 通知游戏扔大便玩家（2022-11-19 增加，当前支持你画我猜，你说我猜，友尽闯关）APP_COMMON_SELF_CLICK_POOP
- (void)notifyAppCommonSelfClickPoop:(AppCommonSelfClickPoop *)model {
    [self notifyStateChange:APP_COMMON_SELF_CLICK_POOP dataJson:model.mj_JSONString];
}

/// app 通知游戏设置 FPS APP_COMMON_GAME_FPS
- (void)notifyAppCommonGameFps:(AppCommonGameFps *)model {
    [self notifyStateChange:APP_COMMON_GAME_FPS dataJson:model.mj_JSONString];
}

/// app 通知游戏设置玩法（只支持 德州 pro 和 teenpattipro）APP_COMMON_GAME_SETTINGS
- (void)notifyAppCommonGameSettings:(AppCommonGameSettings *)model {
    [self notifyStateChange:APP_COMMON_GAME_SETTINGS dataJson:model.mj_JSONString];
}

/// app 通知游返回大厅（当前支持umo）APP_COMMON_GAME_BACK_LOBBY
- (void)notifyAppCommonGameBackLobby:(AppCommonGameBackLobby *)model {
    [self notifyStateChange:APP_COMMON_GAME_BACK_LOBBY dataJson:model.mj_JSONString];
}

/// app通知游戏定制UI配置表 (支持ludo和五子棋) APP_COMMON_GAME_UI_CUSTOM_CONFIG
- (void)notifyAppCommonGameUiCustomConfig:(AppCommonGameUiCustomConfig *)model {
    [self notifyStateChange:APP_COMMON_GAME_UI_CUSTOM_CONFIG dataJson:model.mj_JSONString];
}

#pragma mark - 互动礼物

/// 礼物配置文件 APP_CUSTOM_ROCKET_CONFIG
- (void)notifyAppCustomRocketConfig:(AppCustomRocketConfigModel *)model {
    [self notifyStateChange:APP_CUSTOM_ROCKET_CONFIG dataJson:model.mj_JSONString];
}

/// 拥有模型列表(火箭) APP_CUSTOM_ROCKET_MODEL_LIST
- (void)notifyAppCustomRocketModelList:(AppCustomRocketModelListModel *)model {
    [self notifyStateChange:APP_CUSTOM_ROCKET_MODEL_LIST dataJson:model.mj_JSONString];
}

/// 拥有组件列表(火箭) APP_CUSTOM_ROCKET_COMPONENT_LIST
- (void)notifyAppCustomRocketComponentList:(AppCustomRocketComponentListModel *)model {
    [self notifyStateChange:APP_CUSTOM_ROCKET_COMPONENT_LIST dataJson:model.mj_JSONString];
}

/// 获取用户的信息(火箭) APP_CUSTOM_ROCKET_USER_INFO
- (void)notifyAppCustomRocketUserInfo:(AppCustomRocketUserInfoModel *)model {
    [self notifyStateChange:APP_CUSTOM_ROCKET_USER_INFO dataJson:model.mj_JSONString];
}

/// app推送主播信息(火箭) APP_CUSTOM_ROCKET_NEW_USER_INFO
- (void)notifyAppCustomRocketNewUserInfo:(AppCustomRocketUserInfoModel *)model {
    [self notifyStateChange:APP_CUSTOM_ROCKET_NEW_USER_INFO dataJson:model.mj_JSONString];
}

/// 订单记录列表(火箭) APP_CUSTOM_ROCKET_ORDER_RECORD_LIST
- (void)notifyAppCustomRocketOrderRecordList:(AppCustomRocketOrderRecordListModel *)model {
    [self notifyStateChange:APP_CUSTOM_ROCKET_ORDER_RECORD_LIST dataJson:model.mj_JSONString];
}

/// 展馆内列表(火箭) APP_CUSTOM_ROCKET_ROOM_RECORD_LIST
- (void)notifyAppCustomRocketRoomRecordList:(AppCustomRocketRoomRecordListModel *)model {
    [self notifyStateChange:APP_CUSTOM_ROCKET_ROOM_RECORD_LIST dataJson:model.mj_JSONString];
}

/// 展馆内玩家送出记录(火箭) APP_CUSTOM_ROCKET_USER_RECORD_LIST
- (void)notifyAppCustomRocketUserRecordList:(AppCustomRocketUserRecordListModel *)model {
    [self notifyStateChange:APP_CUSTOM_ROCKET_USER_RECORD_LIST dataJson:model.mj_JSONString];
}

/// 设置默认位置(火箭) APP_CUSTOM_ROCKET_SET_DEFAULT_MODEL
- (void)notifyAppCustomRocketSetDefaultSeat:(AppCustomRocketSetDefaultSeatModel *)model {
    [self notifyStateChange:APP_CUSTOM_ROCKET_SET_DEFAULT_MODEL dataJson:model.mj_JSONString];
}

/// 动态计算一键发送价格(火箭) APP_CUSTOM_ROCKET_DYNAMIC_FIRE_PRICE
- (void)notifyAppCustomRocketDynamicFirePrice:(AppCustomRocketDynamicFirePriceModel *)model {
    [self notifyStateChange:APP_CUSTOM_ROCKET_DYNAMIC_FIRE_PRICE dataJson:model.mj_JSONString];
}

/// 一键发送(火箭) APP_CUSTOM_ROCKET_FIRE_MODEL
- (void)notifyAppCustomRocketFireModel:(AppCustomRocketFireModel *)model {
    [self notifyStateChange:APP_CUSTOM_ROCKET_FIRE_MODEL dataJson:model.mj_JSONString];
}

/// 新组装模型(火箭) APP_CUSTOM_ROCKET_CREATE_MODEL
- (void)notifyAppCustomRocketCreateModel:(AppCustomRocketCreateModel *)model {
    [self notifyStateChange:APP_CUSTOM_ROCKET_CREATE_MODEL dataJson:model.mj_JSONString];
}

/// 更换组件(火箭) APP_CUSTOM_ROCKET_REPLACE_COMPONENT
- (void)notifyAppCustomRocketReplaceComponent:(AppCustomRocketReplaceComponentModel *)model {
    [self notifyStateChange:APP_CUSTOM_ROCKET_REPLACE_COMPONENT dataJson:model.mj_JSONString];
}

/// 购买组件(火箭) APP_CUSTOM_ROCKET_BUY_COMPONENT
- (void)notifyAppCustomRocketBuyComponent:(AppCustomRocketBuyComponentModel *)model {
    [self notifyStateChange:APP_CUSTOM_ROCKET_BUY_COMPONENT dataJson:model.mj_JSONString];
}

/// app推送播放模型(火箭) APP_CUSTOM_ROCKET_PLAY_MODEL_LIST
- (void)notifyAppCustomRocketPlayModelList:(AppCustomRocketPlayModelListModel *)model {
    [self notifyStateChange:APP_CUSTOM_ROCKET_PLAY_MODEL_LIST dataJson:model.mj_JSONString];
}

/// 验证签名合规(火箭) APP_CUSTOM_ROCKET_VERIFY_SIGN
- (void)notifyAppCustomRocketVerifySign:(AppCustomRocketVerifySignModel *)model {
    [self notifyStateChange:APP_CUSTOM_ROCKET_VERIFY_SIGN dataJson:model.mj_JSONString];
}

/// app主动调起游戏显示(火箭) APP_CUSTOM_ROCKET_SHOW_GAME_SCENE
- (void)notifyAppCustomRocketShowGame {
    [self notifyStateChange:APP_CUSTOM_ROCKET_SHOW_GAME_SCENE dataJson:@{}.mj_JSONString];
}

/// app主动调起游戏隐藏(火箭) APP_CUSTOM_ROCKET_HIDE_GAME_SCENE
- (void)notifyAppCustomRocketHideGame {
    [self notifyStateChange:APP_CUSTOM_ROCKET_HIDE_GAME_SCENE dataJson:@{}.mj_JSONString];
}

/// app推送解锁组件（火箭) APP_CUSTOM_ROCKET_UNLOCK_COMPONENT
- (void)notifyAppCustomRocketUnlockComponent:(AppCustomRocketUnlockComponent *)model {
    [self notifyStateChange:APP_CUSTOM_ROCKET_UNLOCK_COMPONENT dataJson:model.mj_JSONString];
}

/// app推送关闭火箭播放效果(火箭) APP_CUSTOM_ROCKET_CLOSE_PLAY_EFFECT
- (void)notifyAppCustomRocketClosePlayEffect {
    [self notifyStateChange:APP_CUSTOM_ROCKET_CLOSE_PLAY_EFFECT dataJson:@{}.mj_JSONString];
}

/// app推送火箭效果飞行点击(火箭) APP_CUSTOM_ROCKET_FLY_CLICK
- (void)notifyAppCustomRocketFlyClick {
    [self notifyStateChange:APP_CUSTOM_ROCKET_FLY_CLICK dataJson:@{}.mj_JSONString];
}

/// 颜色和签名自定义改到装配间的模式，保存颜色或签名 APP_CUSTOM_ROCKET_SAVE_SIGN_COLOR
- (void)notifyAppCustomRocketSaveSignColor:(AppCustomRocketSaveSignColorModel *)model {
    [self notifyStateChange:APP_CUSTOM_ROCKET_SAVE_SIGN_COLOR dataJson:model.mj_JSONString];
}

#pragma mark - 互动礼物<棒球>

/// 查询排行榜数据 APP_BASEBALL_RANKING
- (void)notifyAppBaseballRanking:(AppBaseballRankingModel *)model {
    [self notifyStateChange:APP_BASEBALL_RANKING dataJson:model.mj_JSONString];
}

/// 查询我的排名数据 APP_BASEBALL_MY_RANKING
- (void)notifyAppBaseballMyRanking:(AppBaseballMyRankingModel *)model {
    [self notifyStateChange:APP_BASEBALL_MY_RANKING dataJson:model.mj_JSONString];
}

/// 排在自己前后的玩家数据 APP_BASEBALL_RANGE_INFO
- (void)notifyAppBaseballRangeInfo:(AppBaseballRangeInfoModel *)model {
    [self notifyStateChange:APP_BASEBALL_RANGE_INFO dataJson:model.mj_JSONString];
}

/// app主动调起主界面 APP_BASEBALL_SHOW_GAME_SCENE
- (void)notifyAppBaseballShowGameScene {
    [self notifyStateChange:APP_BASEBALL_SHOW_GAME_SCENE dataJson:@{}.mj_JSONString];
}

/// app主动隐藏主界面 APP_BASEBALL_HIDE_GAME_SCENE
- (void)notifyAppBaseballHideGameScene {
    [self notifyStateChange:APP_BASEBALL_HIDE_GAME_SCENE dataJson:@{}.mj_JSONString];
}

/// 排在自己前后的玩家数据 APP_BASEBALL_TEXT_CONFIG
- (void)notifyAppBaseballTextConfig:(AppBaseballTextConfigModel *)model {
    [self notifyStateChange:APP_BASEBALL_TEXT_CONFIG dataJson:model.mj_JSONString];
}

#pragma mark - 3d语聊房

/// 设置房间配置 APP_CUSTOM_CR_SET_ROOM_CONFIG
- (void)notifyAppCustomCrSetRoomConfig:(AppCustomCrSetRoomConfigModel *)model {
    [self notifyStateChange:APP_CUSTOM_CR_SET_ROOM_CONFIG dataJson:model.mj_JSONString];
}

/// 设置主播位数据 APP_CUSTOM_CR_SET_SEATS
- (void)notifyAppCustomCrSetSeats:(AppCustomCrSetSeatsModel *)model {
    [self notifyStateChange:APP_CUSTOM_CR_SET_SEATS dataJson:model.mj_JSONString];
}

/// 播放收礼效果 APP_CUSTOM_CR_PLAY_GIFT_EFFECT
- (void)notifyAppCustomCrPlayGiftEffect:(AppCustomCrPlayGiftEffectModel *)model {
    [self notifyStateChange:APP_CUSTOM_CR_PLAY_GIFT_EFFECT dataJson:model.mj_JSONString];
}

/// 通知播放爆灯特效 APP_CUSTOM_CR_SET_LIGHT_FLASH
- (void)notifyAppCustomCrSetLightFlash:(AppCustomCrSetLightFlashModel *)model {
    [self notifyStateChange:APP_CUSTOM_CR_SET_LIGHT_FLASH dataJson:model.mj_JSONString];
}


/// 通知主播播放指定动作 APP_CUSTOM_CR_PLAY_ANIM
- (void)notifyAppCustomCrPlayAnim:(AppCustomCrPlayAnimModel *)model {
    [self notifyStateChange:APP_CUSTOM_CR_PLAY_ANIM dataJson:model.mj_JSONString];

}

/// 通知麦浪值变化 APP_CUSTOM_CR_MICPHONE_VALUE_SEAT
- (void)notifyAppCustomCrMicphoneValueSeat:(AppCustomCrMicphoneValueSeatModel *)model {
    [self notifyStateChange:APP_CUSTOM_CR_MICPHONE_VALUE_SEAT dataJson:model.mj_JSONString];
}

/// 通知暂停或恢复立方体自转 APP_CUSTOM_CR_PAUSE_ROTATE
- (void)notifyAppCustomCrPauseRotate:(AppCustomCrPauseRotateModel *)model {
    [self notifyStateChange:APP_CUSTOM_CR_PAUSE_ROTATE dataJson:model.mj_JSONString];
}
@end
