//
//  SudFSTAPPManager.h
//  HelloSud-iOS
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

@property (nonatomic, weak) id<ISudFSTAPP> fsmAPP2MG;
- (instancetype)init:(id<ISudFSTAPP>)fsmAPP2MG;

/// 加入,退出游戏
/// @param isIn true 加入游戏，false 退出游戏
/// @param seatIndex 加入的游戏位(座位号) 默认传seatIndex = -1 随机加入，seatIndex 从0开始，不可大于座位数
/// @param isSeatRandom 默认为ture, 带有游戏位(座位号)的时候，如果游戏位(座位号)已经被占用，是否随机分配一个空位坐下 isSeatRandom=true 随机分配空位坐下，isSeatRandom=false 不随机分配
/// @param teamId 不支持分队的游戏：数值填1；支持分队的游戏：数值填1或2（两支队伍）
- (void)notifyComonSelfIn:(BOOL)isIn seatIndex:(int)seatIndex isSeatRandom:(BOOL)isSeatRandom teamId:(int)teamId;
/// 是否设置为准备状态
/// @param isReady  true 准备，false 取消准备
- (void)notifyComonSetReady:(BOOL)isReady;
/// 游戏中状态设置
/// @param isPlaying   true 开始游戏，false 结束游戏
- (void)notifyComonSelfPlaying:(BOOL)isPlaying;
/// 文字命中状态
/// @param isHit true 命中，false 未命中
/// @param keyWord 单个关键词， 兼容老版本
/// @param text 返回转写文本
- (void)notifyComonDrawTextHit:(BOOL)isHit keyWord:(NSString *)keyWord text:(NSString *)text;
/// 结束游戏
- (void)notifyComonSetEnd;
@end

NS_ASSUME_NONNULL_END
