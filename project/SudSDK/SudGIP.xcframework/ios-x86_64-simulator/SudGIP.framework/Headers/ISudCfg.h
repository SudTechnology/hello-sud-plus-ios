//
// Created by guanghui on 2022/2/28.
//

#import <Foundation/Foundation.h>
#import "ISudLogger.h"

@protocol ISudCfg <NSObject>
/// 获取加载游戏时，是否显示游戏背景图
/// @return true:显示 false:隐藏 默认:显示true
/// 最低版本：v1.1.46.xx
-(BOOL) getShowLoadingGameBg;

/// 设置加载游戏时，是否显示游戏背景图
/// @param show true:显示 false:隐藏
/// 最低版本：v1.1.46.xx
-(void) setShowLoadingGameBg:(BOOL) show;

/// 获取加载游戏时，是否要显示自定义的Loading效果
/// @return true:显示 false:SDK默认Loading效果 默认:显示SDK默认Loading效果
/// 最低版本：v1.1.52.xx
- (BOOL)getShowCustomLoading;

/// 设置加载游戏时，是否要显示自定义的Loading效果
/// @param show true:自定义 false:SDK默认Loading效果
/// 最低版本：v1.1.52.xx
- (void)setShowCustomLoading:(BOOL) show;

/// 添加游戏嵌入包路径
/// @param mgId 游戏id
/// @param mgPath 游戏路径，app assets路径下
/// 最低版本：v1.1.52.xx
- (void)addEmbeddedMGPkg:(int64_t) mgId mgPath:(NSString*_Nonnull) mgPath;

/// 移除游戏嵌入包
/// @param mgId
/// 最低版本：v1.1.52.xx
- (void)removeEmbeddedMGPkg:(int64_t) mgId;

/// 获取游戏嵌入包路径
/// @param mgId 游戏ID
/// @return mgPath
/// 最低版本：v1.1.52.xx
- (NSString *_Nullable)getEmbeddedMGPkgPath:(int64_t) mgId;

/// 设置加载游戏时，是否使用后台模式，默认为false
/// @param mode true: 使用后台模式 false：使用默认模式
/// 最低版本：v1.2.7.xx
- (void) setBackgroundMode:(BOOL) mode;

/// 获取加载游戏时，是否使用后台模式，默认为false
/// @return true: 使用后台模式 false：使用默认模式
/// 最低版本：v1.2.7.xx
- (BOOL) getBackgroundMode;

/**
 * 小游戏是否能设置AudioSession的AudioSessionCategory的开关
 * 是否允许小游戏设置AudioSessionCategory
 * @param enable
 * YES:  (默认)允许小游戏设置Category
 * NO:  不允许小游戏设置Category，由应用控制AudioSessionCategory
 */
- (void)setEnableAudioSessionCategory:(BOOL)enable;

/**
 * 小游戏是否能设置AudioSession的AudioSessionCategory的开关
 * 是否允许小游戏设置AudioSessionCategory
 * @return YES:  (默认)允许小游戏设置Category      NO:  不允许小游戏设置Category，由应用控制AudioSessionCategory
 */
- (BOOL)getEnableAudioSessionCategory;

/**
 * 小游戏是否能激活AudioSession(调用setActive)的开关
 * 是否允许小游戏适时激活AudioSession
 * @param enable
 * YES:  (默认)允许小游戏适时激活AudioSession
 * NO: 不允许小游戏适时激活AudioSession, 由应用激活AudioSession
 */
- (void)setEnableAudioSessionActive:(BOOL)enable;

/**
 * 小游戏是否能激活AudioSession(调用setActive)的开关
 * 是否允许小游戏适时激活AudioSession
 * @return YES:  (默认)允许小游戏适时激活AudioSession     NO: 不允许小游戏适时激活AudioSession, 由应用激活AudioSession
 */
- (BOOL)getEnableAudioSessionActive;

/// 设置高级配置
/// @param advanceConfig 配置选项
- (void)setAdvancedConfig:(NSDictionary *_Nullable)advanceConfig;

/// 获取当前高级配置
- (NSDictionary *_Nullable)getAdvancedConfig;

/// 设置日志级别
/// @param logLevel logLevel description
- (void)setLogLevel:(SudLogType)logLevel;
@end
