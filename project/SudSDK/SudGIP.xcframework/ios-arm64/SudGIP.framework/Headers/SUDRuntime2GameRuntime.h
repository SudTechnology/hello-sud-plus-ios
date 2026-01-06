//
//  SUDRuntime2GameRuntime.h
//  SudGIP
//
//  Created by kaniel on 10/18/25.
//

#import <Foundation/Foundation.h>
#import "SUDRuntime2GameHandle.h"

NS_ASSUME_NONNULL_BEGIN

/// Path where the resources used by the Core are located
extern NSString * const SUD_RT2_KEY_RUNTIME_ASSETS_PATH;
/// Game package manager name
extern NSString * const SUD_RT2_KEY_MANAGER_GAME_PACKAGE;
/// User manager name
extern NSString * const SUD_RT2_KEY_MANAGER_USER;
/// Plugin manager name
extern NSString * const SUD_RT2_KEY_MANAGER_PLUGIN;
/// Path where the Runtime stores installed game packages
extern NSString * const SUD_RT2_KEY_RUNTIME_STORAGE_PATH_APP;
/// Temporary file storage path available for the Runtime
extern NSString * const SUD_RT2_KEY_RUNTIME_STORAGE_PATH_CACHE;
/// Path where the Runtime stores user game data
extern NSString * const SUD_RT2_KEY_RUNTIME_STORAGE_PATH_USER;
/// Path where the Runtime stores plugins
extern NSString * const SUD_RT2_KEY_RUNTIME_STORAGE_PATH_PLUGIN;


@protocol SUDRuntime2GameRuntime;

@protocol SUDRuntime2GameRuntime <NSObject>

+ (NSString *)getRuntimeDesc;

+ (nullable NSArray<NSString *> *)getRuntimeFeatures;

+ (NSString *)getRuntimeVersion;

- (void)cancelCleanUp;

- (void)cleanUpExpiredTemporaryFiles:(NSInteger)keepTimeInMinute
                               start:(nullable void (^)(void))start
                            progress:(nullable void (^)(NSString *path, NSError * _Nullable error))progress
                          completion:(nullable void (^)(NSError * _Nullable error))completion;

- (void)createGameHandleWithOptions:(NSDictionary *)options
                         completion:(nullable void (^)(id<SUDRuntime2GameHandle> _Nullable handle,
                                                       NSError * _Nullable error))completion;

- (nullable NSObject *)getManagerWithName:(NSString *)name options:(nullable NSDictionary *)options;

@end
NS_ASSUME_NONNULL_END
