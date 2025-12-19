#import "GameEnv.h"

#import <SudGIP/SudGIP-umbrella.h>

static NSString * const _KEY_DEFAULT_LAUNCH_GAME_MODE = @"default_launch_game_mode";
static NSString * const _KEY_ENABLE_GAME_FLOAT_BUTTON = @"enable_game_float_button";
static NSString * const _KEY_ENABLE_DEBUG_MODE_LAUNCH_GAME = @"enable_debug_mode_launch_game";
static NSString * const _KEY_ENABLE_DEBUGGER = @"enable_debugger";
static NSString * const _KEY_ENABLE_DEVELOPER_MODE = @"enable_developer_mode";

static NSString * const _KEY_ENABLE_DEBUGGER_WAITING = @"enable_debugger_waiting";
static NSString * const _KEY_ENABLE_DEBUGGER_PORT = @"enable_debugger_port";
static NSString * const _KEY_ENABLE_THIRD_SCRIPT = @"enable_third_script";
static NSString * const _KEY_ENABLE_TIMING_LOG = @"enable_timing_log";

static NSString * const _KEY_ENABLE_V_CONSOLE = @"enable_v_console";
static NSString * const _KEY_SHOW_FPS = @"show_FPS";
static NSString * const _KEY_TEMP_FILE_IDLE_TIME = @"temp_file_idle_time";
static NSString * const _KEY_USER_ID = @"user-id";
static NSString * const _KEY_WEBGL_RENDER_THREAD_MODE = @"webgl_render_thread_mode";

@interface GameEnv ()
@property (nonatomic, strong) id<SudRt2GameRuntime> runtime;
@end

@implementation GameEnv

@synthesize userID = _userID;

static GameEnv *_singleton = nil;

+ (instancetype)getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[super allocWithZone:NULL] init];
    });
    return _singleton;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [GameEnv getInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [GameEnv getInstance];
}

- (id<CRCocosGameRuntimeV2>)getCocosGameRuntime {
    if (!_runtime) {
        // get caches path
        NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *appPath = [cachesDir stringByAppendingPathComponent:@"app"];
        NSString *userPath = [cachesDir stringByAppendingPathComponent:@"user"];
        NSString *pluginPath = [cachesDir stringByAppendingPathComponent:@"plugin"];
        NSDictionary *gameInfo = @{
            SUD_RT2_KEY_RUNTIME_STORAGE_PATH_APP:appPath,
            SUD_RT2_KEY_RUNTIME_STORAGE_PATH_USER:userPath,
            SUD_RT2_KEY_RUNTIME_STORAGE_PATH_CACHE:NSTemporaryDirectory(),
            SUD_RT2_KEY_RUNTIME_STORAGE_PATH_PLUGIN:pluginPath
        };
        WeakSelf
        [SudRuntime2 createRuntime:nil completion:^(id<SudRt2GameRuntime>  _Nullable runtime, NSError *error) {
             weakSelf.runtime = runtime;
        }];
    }
    return _runtime;
}

- (GameLaunchMode)getDefaultLaunchGameMode {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    return [[userDefualts objectForKey:_KEY_DEFAULT_LAUNCH_GAME_MODE] unsignedIntegerValue];
}

- (BOOL)getEnableDebugger {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    return [[userDefualts objectForKey:_KEY_ENABLE_DEBUGGER] boolValue];
}

- (BOOL)getEnableDebugModeLaunchGame {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    return [[userDefualts objectForKey:_KEY_ENABLE_DEBUG_MODE_LAUNCH_GAME] boolValue];
}

- (BOOL)getEnableDeveloperMode {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    return [[userDefualts objectForKey:_KEY_ENABLE_DEVELOPER_MODE] boolValue];
}

- (BOOL)getEnableGameFloatButton {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    BOOL enable = YES;
    NSNumber *value = [userDefualts objectForKey:_KEY_ENABLE_GAME_FLOAT_BUTTON];
    if (value) {
        enable = [value boolValue];
    }
    return enable;
}

- (BOOL)getEnableVConsole {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    return [[userDefualts objectForKey:_KEY_ENABLE_V_CONSOLE] boolValue];
}

- (BOOL)getEnableThirdScript {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    return [[userDefualts objectForKey:_KEY_ENABLE_THIRD_SCRIPT] boolValue];
}

- (BOOL)getEnableTimingLog {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    return [[userDefualts objectForKey:_KEY_ENABLE_TIMING_LOG] boolValue];
}

- (BOOL)getShowFPS {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    return [[userDefualts objectForKey:_KEY_SHOW_FPS] boolValue];
}

- (NSInteger)getTempFileIdleTimeInMinute {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    NSInteger minute = 30;
    NSNumber *value = [userDefualts objectForKey:_KEY_TEMP_FILE_IDLE_TIME];
    if (value) {
        minute = [value integerValue];
    }
    return minute;
}

- (NSInteger)getWebGLRenderThreadMode {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    return [[userDefualts objectForKey:_KEY_WEBGL_RENDER_THREAD_MODE] integerValue];
}

- (void)setDefaultLaunchGameMode:(GameLaunchMode)mode {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    [userDefualts setValue:@(mode) forKey:_KEY_DEFAULT_LAUNCH_GAME_MODE];
}

- (void)setEnableGameFloatButton:(BOOL)enable {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    [userDefualts setValue:@(enable) forKey:_KEY_ENABLE_GAME_FLOAT_BUTTON];
}

- (void)setEnableVConsole:(BOOL)enable {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    [userDefualts setValue:@(enable) forKey:_KEY_ENABLE_V_CONSOLE];
}

- (void)setEnableDebugger:(BOOL)enable {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    [userDefualts setValue:@(enable) forKey:_KEY_ENABLE_DEBUGGER];
}

- (void)setEnableDebugModeLaunchGame:(BOOL)enable {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    [userDefualts setValue:@(enable) forKey:_KEY_ENABLE_DEBUG_MODE_LAUNCH_GAME];
}

- (void)setEnableDeveloperMode:(BOOL)enable {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    [userDefualts setValue:@(enable) forKey:_KEY_ENABLE_DEVELOPER_MODE];
}

- (void)setEnableThirdScript:(BOOL)enable {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    [userDefualts setValue:@(enable) forKey:_KEY_ENABLE_THIRD_SCRIPT];
}

- (void)setEnableTimingLog:(BOOL)enable {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    [userDefualts setValue:@(enable) forKey:_KEY_ENABLE_TIMING_LOG];
}

- (void)setShowFPS:(BOOL)enable {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    [userDefualts setValue:@(enable) forKey:_KEY_SHOW_FPS];
}

- (void)setTempFileIdleTimeInMinute:(NSInteger)minute {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    [userDefualts setValue:@(minute) forKey:_KEY_TEMP_FILE_IDLE_TIME];
}

- (void)setWebGLRenderThreadMode:(NSInteger)mode {
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    [userDefualts setValue:@(mode) forKey:_KEY_WEBGL_RENDER_THREAD_MODE];
}

- (NSString *)userID {
    if (!_userID.length) {
        NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
        return [userDefualts objectForKey:_KEY_USER_ID];
    } else {
        return _userID;
    }
}

- (BOOL)isLogin {
    return self.userID.length;
}

- (void)setUserID:(NSString *)userID {
    _userID = userID;
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    [userDefualts setValue:userID forKey:_KEY_USER_ID];
}

@end
