#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ISudListenerInitSDK.h"
#import "ISudListenerGetMGList.h"
#import "ISudListenerUninitSDK.h"
#import "ISudListenerReportStatsEvent.h"
#import "ISudCfg.h"
#import "ISudLogger.h"
#import "SudInitSDKParamModel.h"
#import "SudLoadMGParamModel.h"
#import "SudNetworkCheckParamModel.h"
#import "ISudListener.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ISudFSTAPP;
@protocol ISudFSMMG;
@protocol ISudListenerPrepareGame;
__attribute__((deprecated("This class is deprecated. Use SudGIP instead.")))
@interface SudMGP : NSObject

/**
 * 获取SDK版本
 * @return 示例:"1.1.35.286"
 */
+ (NSString*_Nonnull)getVersion;

/**
 * 获取SDK版本别名
 * @return 示例:"v1.1.35.286-et"
 */
+ (NSString*_Nonnull)getVersionAlias;

+ (id<ISudCfg>_Nonnull)getCfg;

/**
 * 初始化SDK
 * @param appId 小游戏平台生成
 * @param appKey 小游戏平台生成
 * @param isTestEnv true:测试环境 false:生产环境
 * @param listener ISudListenerInitSDK
 * @deprecated Use initSDK:listener: instead
 */
+ (void)initSDK:(NSString*_Nonnull)appId
         appKey:(NSString*_Nonnull)appKey
      isTestEnv:(BOOL)isTestEnv
       listener:(ISudListenerInitSDK _Nullable )listener __attribute__((deprecated("Use initSDK:listener: instead")));
/**
 * 初始化SDK
 * @param model SudInitSDKParamModel
 * @param listener ISudListenerInitSDK
 * 最低版本：v1.1.54.xx
 */
+ (void)initSDK:(SudInitSDKParamModel*)model
       listener:(ISudListenerInitSDK _Nullable )listener;

/**
 * 反初始化SDK
 * @param listener ISudListenerUninitSDK
 */
+ (void)uninitSDK:(ISudListenerUninitSDK _Nullable )listener;

/**
 * 获取游戏列表
 * @param listener ISudListenerGetMGList
 */
+ (void)getMGList:(ISudListenerGetMGList _Nullable )listener;

/**
 * 加载游戏
 * @param userId 用户ID，业务系统保证每个用户拥有唯一ID
 * @param roomId 房间ID，业务系统保证唯一性，进入同一房间内
 * @param code 短期令牌Code
 * @param mgId 小游戏ID，测试环境和生成环境小游戏ID是一致的
 * @param language 游戏语言 现支持，简体：zh-CN 繁体：zh-TW 英语：en-US 马来语：ms-MY
 * @param fsmMG ISudFSMMG
 * @param rootView 用于显示游戏的根视图（gameViewContainer）
 * @return ISudFSTAPP
 * @deprecated Use loadMG:fsmMG: instead
 */
+ (id<ISudFSTAPP>_Nonnull)loadMG:(NSString*_Nonnull)userId
                          roomId:(NSString*_Nonnull)roomId
                            code:(NSString*_Nonnull)code
                            mgId:(int64_t)mgId
                        language:(NSString*_Nonnull)language
                           fsmMG:(id<ISudFSMMG>_Nonnull)fsmMG
                        rootView:(UIView*_Nonnull)rootView __attribute__((deprecated("Use loadMG:fsmMG instead")));

/**
 * 加载游戏
 * @param model SudLoadMGParamModel
 * @param fsmMG ISudFSMMG
 * @return ISudFSTAPP
 * 最低版本：v1.1.54.xx
 */
+ (id<ISudFSTAPP>_Nonnull)loadMG:(SudLoadMGParamModel*_Nonnull)model
                           fsmMG:(id<ISudFSMMG>_Nonnull)fsmMG;

/**
 * 销毁游戏
 * @param fstAPP 加载游戏返回的对象ISudFSTAPP
 * @return boolean
 */
+ (bool)destroyMG:(id<ISudFSTAPP>_Nonnull) fstAPP;

/**
 * 预加载游戏包列表
 * @param mgIdList 游戏ID列表
 */
+ (void) prepareGameList:(NSArray<NSNumber *> *) mgIdList listener:(id<ISudListenerPrepareGame>) listener;

/**
 * 取消预加载游戏包
 * @param mgIdList 游戏ID列表
 */
+ (void) cancelPrepareGameList:(NSArray<NSNumber *> *) mgIdList;

/**
 * 设置统计上报userId
 * @param userId 用户ID
 * @deprecated deprecated since v1.3.5
 */
+ (void)setUserId:(NSString*)userId __attribute__((deprecated("deprecated since v1.3.5")));

/**
 * 设置统计上报回调
 * @param listener 回调
 * @return 返回值
 */
+ (bool)setReportStatsEventListener:(ISudListenerReportStatsEvent)listener;

/**
 * 设置日志等级
 * @param logLevel 输出log的等级,SudLogVERBOSE,SudLogDEBUG,SudLogINFO 见ISudLogger.h
 */
+ (void)setLogLevel:(SudLogType)logLevel;

/// 获取SDK本地日志存储路径
+ (NSString *_Nonnull)getLogDirPath;

/// 开启网络检测，检测当前网络环境下，SDK连通性
/// @param paramModel 检测参数
/// @param listener 检测结果回调
+ (void)startNetworkDetection:(SudNetworkDetectionParamModel *)paramModel listener:(INetworkDetectionListener)listener;
@end

NS_ASSUME_NONNULL_END
