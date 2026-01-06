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

@interface SudGIP : NSObject

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
