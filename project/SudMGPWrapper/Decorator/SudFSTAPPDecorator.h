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

NS_ASSUME_NONNULL_BEGIN

/// app -> 游戏
@interface SudFSTAPPDecorator : NSObject

@property (nonatomic, strong) id<ISudFSTAPP> iSudFSTAPP;

/// setI SudFSTAPP
- (void)setISudFSTAPP:(id<ISudFSTAPP>)iSudFSTAPP;

/// 加入,退出游戏
/// @param isIn true 加入游戏，false 退出游戏
/// @param seatIndex 加入的游戏位(座位号) 默认传seatIndex = -1 随机加入，seatIndex 从0开始，不可大于座位数
/// @param isSeatRandom 默认为ture, 带有游戏位(座位号)的时候，如果游戏位(座位号)已经被占用，是否随机分配一个空位坐下 isSeatRandom=true 随机分配空位坐下，isSeatRandom=false 不随机分配
/// @param teamId 不支持分队的游戏：数值填1；支持分队的游戏：数值填1或2（两支队伍）
- (void)notifyAppComonSelfIn:(BOOL)isIn seatIndex:(int)seatIndex isSeatRandom:(BOOL)isSeatRandom teamId:(int)teamId;

/// 是否设置为准备状态
/// @param isReady  true 准备，false 取消准备
- (void)notifyAppComonSetReady:(BOOL)isReady;

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
- (void)notifyAppComonSetEnd;

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
- (void)notifyAppComonReportGameInfoExtras:(NSString *)reportGameInfoExtras;


/// 继续游戏
- (void)playMG;

/// 暂停游戏
- (void)pauseMG;

/// 销毁游戏
- (void)destroyMG;

/// 获取游戏View
- (UIView *) getGameView;

/// 更新code
/// @param code 新的code
- (void)updateCode:(NSString *) code;

/// 传输音频数据： 传入的音频数据必须是：PCM格式，采样率：16000， 采样位数：16， 声道数： MONO
- (void)pushAudio:(NSData *)data;


@end

NS_ASSUME_NONNULL_END
