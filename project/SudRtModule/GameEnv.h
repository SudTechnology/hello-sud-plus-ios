#import <SudGIP/SudGIP-umbrella.h>
NS_ASSUME_NONNULL_BEGIN

@protocol CRCocosGameRuntimeV2;

typedef NS_ENUM(NSUInteger, GameLaunchMode) {
    kGameLaunchInThisWindow,
    kGameLaunchInNewWindow,
};

@interface GameEnv : NSObject
@property (nonatomic, assign, readonly) BOOL isLogin;
@property (nonatomic, copy) NSString *userID;

+ (instancetype)getInstance;

- (GameLaunchMode)getDefaultLaunchGameMode;
- (BOOL)getEnableDebugger;
- (BOOL)getEnableDebugModeLaunchGame;
- (BOOL)getEnableDeveloperMode;
- (BOOL)getEnableGameFloatButton;
- (BOOL)getEnableVConsole;
- (BOOL)getEnableThirdScript;
- (BOOL)getEnableTimingLog;
- (BOOL)getShowFPS;
- (NSInteger)getTempFileIdleTimeInMinute;
- (NSInteger)getWebGLRenderThreadMode;
- (id<SUDRuntime2GameRuntime>)getCocosGameRuntime;
- (void)setDefaultLaunchGameMode:(GameLaunchMode)mode;
- (void)setEnableDebugger:(BOOL)enable;
- (void)setEnableDebugModeLaunchGame:(BOOL)enable;
- (void)setEnableDeveloperMode:(BOOL)enable;
- (void)setEnableGameFloatButton:(BOOL)enable;
- (void)setEnableVConsole:(BOOL)enable;
- (void)setEnableThirdScript:(BOOL)enable;
- (void)setEnableTimingLog:(BOOL)enable;
- (void)setShowFPS:(BOOL)enable;
- (void)setTempFileIdleTimeInMinute:(NSInteger)minute;
- (void)setWebGLRenderThreadMode:(NSInteger)mode;
@end

NS_ASSUME_NONNULL_END
