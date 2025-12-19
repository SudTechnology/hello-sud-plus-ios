//
//  SudRt2GameHandle.h
//  SudGIP
//
//  Created by kaniel on 10/18/25.
//

#ifndef SudRt2GameHandle_h
#define SudRt2GameHandle_h

#import <Foundation/Foundation.h>
#import "SudRt2GameMediaPlayerHandle.h"
#import "SudRt2GameAudioSession.h"

NS_ASSUME_NONNULL_BEGIN

/// Pixel ratio
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_PIXEL_RATIO;
/// Limit download content size
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_LIMIT_DOWNLOAD_CONTENT_SIZE;
/// Limit user storage size
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_LIMIT_USER_STORAGE;
/// Limit localStorage size
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_LIMIT_LOCAL_STORAGE;
/// JSC obfuscation secret key
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_JSC_SECRET_KEY;
/// Custom JS entry
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_CUSTOM_JS_ENTRY;
/// Custom search path
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_CUSTOM_SEARCH_PATH;
/// Disable default JS entry
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_DISABLE_DEFAULT_JS_ENTRY;
/// Game version
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_GAME_VERSION;
/// Game launch parameters
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_LAUNCH_OPTIONS;
/// Company name
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_COMPANY_NAME;
/// Company ID
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_COMPANY_ID;
/// Statistics service ID
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_STATISTICS_SERVICE_ID;

/// Whether to enable JS debugger support
extern NSString * const SUD_RT2_KEY_GAME_DEBUG_OPTION_ENABLE_DEBUGGER;
/// Whether to enable FPS display
extern NSString * const SUD_RT2_KEY_GAME_DEBUG_OPTION_ENABLE_FPS;
/// Whether to enable VConsole
extern NSString * const SUD_RT2_KEY_GAME_DEBUG_OPTION_ENABLE_V_CONSOLE;

/// Download network timeout
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_NETWORK_TIMEOUT_DOWNLOAD;
/// Upload network timeout
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_NETWORK_TIMEOUT_UPLOAD;
/// WebSocket network timeout
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_NETWORK_TIMEOUT_WEB_SOCKET;
/// XMLHttpRequest network timeout
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_NETWORK_TIMEOUT_XML_HTTP_REQUEST;

/// Whether to allow execution of dynamic scripts
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_ENABLE_THIRD_SCRIPT;
/// Whether to enable game launch timing logs
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_ENABLE_TIMING_LOG;
/// Set game render thread mode
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_RENDER_THREAD_MODE;

/// HTTP cache storage limit
extern NSString * const SUD_RT2_KEY_GAME_HTTP_CACHE_LIMIT_STORAGE;
/// HTTP cache path
extern NSString * const SUD_RT2_KEY_GAME_HTTP_CACHE_PATH;

/// Game user ID
extern NSString * const SUD_RT2_KEY_GAME_USER_ID;

/// Whether to force WebGLContextAttributes alpha to true
extern NSString * const SUD_RT2_KEY_GAME_START_OPTIONS_WEBGL_CONTEXT_FORCE_ALPHA;


typedef NS_ENUM(NSUInteger, SudRt2GameState) {
    SUD_RT2_GAME_STATE_UNAVAILABLE = 0,
    SUD_RT2_GAME_STATE_WAITING = 1,
    SUD_RT2_GAME_STATE_RUNNING = 2,
    SUD_RT2_GAME_STATE_PLAYING = 3,
};

typedef NS_ENUM(NSUInteger, SudRt2RenderThreadMode) {
    SUD_RT2_RENDER_THREAD_MODE_AUTO = 0,
    SUD_RT2_RENDER_THREAD_MODE_GAME_THREAD = 1,
    SUD_RT2_RENDER_THREAD_MODE_STANDALONE = 2,
    SUD_RT2_RENDER_THREAD_MODE_UI_THREAD = 3
};

typedef NS_ENUM(NSUInteger, SudRt2PermissionAuthStatus) {
    SUD_RT2_PERMISSION_AUTH_STATUS_UNDETERMINED = 0,
    SUD_RT2_PERMISSION_AUTH_STATUS_GRANTED = 1,
    SUD_RT2_PERMISSION_AUTH_STATUS_DENIED = 2,
};

typedef NS_ENUM(NSUInteger, SudRt2SystemPermissionAuthStatus) {
    SUD_RT2_SYSTEM_PERMISSION_AUTH_STATUS_UNDETERMINED = 0,
    SUD_RT2_SYSTEM_PERMISSION_AUTH_STATUS_GRANTED = 1,
    SUD_RT2_SYSTEM_PERMISSION_AUTH_STATUS_DENIED = 2,
};

@class UIView;

@protocol SudRt2GameAudioSession;

@protocol SudRt2GameCustomCommandHandle <NSObject>
- (void)customCommandFailure:(NSString *)err;
- (void)customCommandSuccess;
- (void)pushResultWithBool:(BOOL)res;
- (void)pushResultWithBoolArr:(NSArray<NSNumber *> *)res;
- (void)pushResultWithDouble:(double)res;
- (void)pushResultWithDoubleArr:(NSData *)res;
- (void)pushResultWithFloatArr:(NSData *)res;
- (void)pushResultWithInt8Arr:(NSData *)res;
- (void)pushResultWithInt16Arr:(NSData *)res;
- (void)pushResultWithInt32Arr:(NSData *)res;
- (void)pushResultWithLong:(long)res;
- (void)pushResultWithString:(NSString *)res;
- (void)pushResultWithStringArr:(NSArray<NSString *> *)res;
- (void)pushResultNull;
@end

@protocol SudRt2GameCustomCommandListener <NSObject>

@optional
- (void)onCallCustomCommand:(id<SudRt2GameCustomCommandHandle>)handle info:(nullable NSDictionary *)argv;

- (void)onCallCustomCommandSync:(id<SudRt2GameCustomCommandHandle>)handle info:(nullable NSDictionary *)argv;

@end

@protocol SudRt2GameDrawFrameListener <NSObject>

@optional
- (void)onDrawFrame:(long)frameCounter;

@end

@protocol SudRt2GameFatalErrorListener <NSObject>

@optional
- (void)onGameFatalError:(NSString *)message;

@end

@protocol SudRt2GameLoadSubpackageHandle <NSObject>

- (void)loadSubpackageFailure:(NSString *)packageName withError:(NSString *)error;

- (void)loadSubpackageProgress:(NSString *)packageName downloaded:(long)written total:(long)total;

- (void)loadSubpackageSuccess:(NSString *)packageName root:(NSString *)packageRoot;

@end

@protocol SudRt2GameLoadSubpackageListener <NSObject>

@optional
- (void)onLoadSubpackage:(id<SudRt2GameLoadSubpackageHandle>)handle name:(NSString *)name root:(NSString *)root;

@end

@protocol SudRt2GameQueryClipboardHandle <NSObject>

- (void)allowGetClipboardData:(NSString *)data;

- (void)allowSetClipboardData:(NSString *)data;

- (void)rejectGetClipboardData;

- (void)rejectSetClipboardData;

@end

@protocol SudRt2GameQueryClipboardListener <NSObject>

@optional
- (void)onGetClipboardData:(id<SudRt2GameQueryClipboardHandle>)handle
                      data:(NSString *)data
                     appId:(NSString *)appId;

- (void)onSetClipboardData:(id<SudRt2GameQueryClipboardHandle>)handle
                      data:(NSString *)data
                     appId:(NSString *)appId;

@end

@protocol SudRt2GameQueryExitListener <NSObject>

@optional
- (void)onQueryExit:(NSString *)appID result:(nullable NSString *)result;

@end

@protocol SudRt2GameQueryPermissionHandle <NSObject>

- (void)completeQueryPermission:(NSString *)permission authStatus:(SudRt2PermissionAuthStatus)authStatus;

@end

@protocol SudRt2GameQueryPermissionListener <NSObject>

- (void)onQueryPermission:(id<SudRt2GameQueryPermissionHandle>)handle
               permission:(NSString *)permission
                    appId:(NSString *)appId
               authStatus:(SudRt2PermissionAuthStatus)authStatus;

@end

@protocol SudRt2GameQuerySystemPermissionHandle <NSObject>

- (void)continueQuerySystemPermission:(NSString *)permission;

@end

@protocol SudRt2GameQuerySystemPermissionListener <NSObject>

@optional
- (void)beforeQuerySystemPermission:(id<SudRt2GameQuerySystemPermissionHandle>)handle
                       fromJSMethod:(NSString *)methodName
                         permission:(NSString *)permission
                              appId:(NSString *)appId
                         authStatus:(SudRt2SystemPermissionAuthStatus)authStatus
                      serviceStatus:(BOOL)enabled;

@end

@protocol SudRt2GameStateChangeListener <NSObject>

@optional
- (void)onStateChangedFailureFrom:(int)fromState to:(int)toSstate error:(NSError *)error;

- (void)onStateChangedFrom:(int)fromState to:(int)toState;

- (void)preStateChangedFrom:(int)fromState to:(int)toState;

@end

@protocol SudRt2GameScreenStateChangeListener <NSObject>

@optional
- (BOOL)queryChangeScreenBrightness:(float)brightness info:(NSDictionary *)info;

- (BOOL)queryChangeScreenKeepOn:(BOOL)keepOn info:(NSDictionary *)info;

@end

@protocol SudRt2MediaPlayerListener <NSObject>

- (void)onMediaPlayerCreated:(UInt64) instanceID;

- (void)onMediaPlayerDestroyed:(UInt64) instanceID;

@end

@protocol SudRt2GameHandle <NSObject>

- (void)create;

- (void)destroy;

- (id<SudRt2GameAudioSession>)getGameAudioSession;

- (id<SudRt2GameMediaPlayerHandle>)getMediaPlayerHandle:(UInt64) instanceID;

- (NSInteger)getGameState;

- (nullable UIView *)getGameView;

- (void)pause;

- (void)play;

- (void)runScript:(NSString *)script
       completion:(nullable void (^)(NSString * _Nullable returnType,
                                     NSDictionary * _Nullable returnValue,
                                     NSError * _Nullable error))completion;

- (void)setCustomCommandListener:(nullable id<SudRt2GameCustomCommandListener>)listener;

- (void)setGameDrawFrameListener:(nullable id<SudRt2GameDrawFrameListener>)listener;

- (void)setGameFatalErrorListener:(nullable id<SudRt2GameFatalErrorListener>)listener;

- (void)setGameLoadSubpackageListener:(nullable id<SudRt2GameLoadSubpackageListener>)listener;

- (void)setGameQueryClipboardListener:(nullable id<SudRt2GameQueryClipboardListener>)listener;

- (void)setGameQueryExitListener:(nullable id<SudRt2GameQueryExitListener>)listener;

- (void)setGameQueryPermissionListener:(nullable id<SudRt2GameQueryPermissionListener>)listener;

- (void)setGameQuerySystemPermissionListener:(nullable id<SudRt2GameQuerySystemPermissionListener>)listener;

- (BOOL)setGameStartOptions:(NSString *)gameId options:(NSDictionary *)options;

- (void)setGameStateListener:(nullable id<SudRt2GameStateChangeListener>)listener;

- (void)setGameScreenStateChangeListener:(nullable id<SudRt2GameScreenStateChangeListener>)listener;

- (void)setMediaPlayerListener:(nullable id<SudRt2MediaPlayerListener>)listener;

- (void)start:(nullable NSString *)onShowMsg;

- (void)stop:(nullable NSString *)onHideMsg;

@end

NS_ASSUME_NONNULL_END


#endif /* SudRt2GameHandle_h */
