//
//  GameSudManager.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/// SudMGPSDK
#import <SudMGP/ISudFSMMG.h>
#import <SudMGP/ISudFSTAPP.h>
#import <SudMGP/SudMGP.h>
#import <SudMGP/ISudFSMStateHandle.h>

NS_ASSUME_NONNULL_BEGIN

//@protocol GameSudManagerDelegate <NSObject>
//
///// 游戏状态变换 - 公屏消息
///// @param msgModel GamePublicMsgModel
////@required
//- (void)onGameStateChangePublicMessage:(GamePublicMsgModel *)msgModel;
//
///// 游戏状态变换 - 你画我猜关键词获取
///// @param model GameKeyWordHitModel
////@required
//- (void)onGameStateChangeDrawKeyWordHit:(GameKeyWordHitModel *)model;
//
///// 游戏玩家状态变化
///// @param state 状态类型
///// @param model GamePlayerStateModel
////@required
//- (void)onPlayerStateChangeWithModel:(GamePlayerStateModel *)model;
//
//@end

@interface GameSudManager : NSObject

/// 获取sud sdk版本号
+(NSString *)sudSDKVersion;


@end

NS_ASSUME_NONNULL_END
