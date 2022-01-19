//
//  GameSudManager.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// Model
#import "GameViewInfoModel.h"
#import "GamePublicMsgModel.h"
#import "GameKeyWordHitModel.h"
#import "GamePlayerStateModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GameSudManagerDelegate <NSObject>

/// 游戏状态变换 - 公屏消息
/// @param msgModel GamePublicMsgModel
//@required
- (void)onGameStateChangePublicMessage:(GamePublicMsgModel *)msgModel;

/// 游戏状态变换 - 你画我猜关键词获取
/// @param model GameKeyWordHitModel
//@required
- (void)onGameStateChangeDrawKeyWordHit:(GameKeyWordHitModel *)model;

/// 游戏玩家状态变化
/// @param state 状态类型
/// @param model GamePlayerStateModel
//@required
- (void)onPlayerStateChangeWithModel:(GamePlayerStateModel *)model;

@end

@interface GameSudManager : NSObject

/// delegate
@property (nonatomic, weak) id <GameSudManagerDelegate> delegate;

/**
 * 初始化游戏SDK
 *
 * @param appID           NSString        项目的appID
 * @param appKey         NSString        项目的appKey
 * @param isTestEnv  Boolean         是否是测试环境，true:测试环境, false:正式环境
 * @param mgID             NSInteger      游戏ID，如 碰碰我最强:1001；飞刀我最强:1002；你画我猜:1003
 */
- (void)initGameSDKWithAppID:(NSString *)appID appKey:(NSString *)appKey isTestEnv:(Boolean)isTestEnv mgID:(int64_t)mgID rootView:(UIView*)rootView;

/// 加载游戏MG
/// @param userId 用户唯一ID
/// @param roomId 房间ID
/// @param code 游戏登录code
/// @param mgId 游戏ID
/// @param language 支持简体"zh-CN "    繁体"zh-TW"    英语"en-US"   马来"ms-MY"
/// @param fsmMG 控制器
/// @param rootView 游戏根视图
- (void)loadMG:(NSString *)userId roomId:(NSString *)roomId code:(NSString *)code mgId:(int64_t) mgId language:(NSString *)language fsmMG:(id)fsmMG rootView:(UIView*)rootView;

/// 销毁MG
- (void)destroyMG;

/// 更新code
/// @param code 新的code
- (void)updateGameCode:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
