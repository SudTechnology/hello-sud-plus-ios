#import "GameRunningModel.h"

#import <AVFoundation/AVFoundation.h>

#import <SudGIP/SudGIP-umbrella.h>

#import "GameEnv.h"
#import "GameInfo.h"
#import "GamePermissionModel.h"


typedef NS_ENUM(NSInteger, _StoppedState) {
    _STOPPED_STATE_NONE = 0,
    _STOPPED_STATE_FROM_BACKGROUND = 1,
    _STOPPED_STATE_FROM_USER = 2,
};

@interface GameRunningModel () <
SudRt2GameDrawFrameListener,
SudRt2GameLoadSubpackageListener,
SudRt2GameQueryExitListener,
SudRt2GameStateChangeListener,
SudRt2GameScreenStateChangeListener,
SudRt2GameQueryAudioOptionsListener,
SudRt2GameQueryClipboardListener,
SudRt2MediaPlayerListener>
@property (nonatomic, assign) int currentState;
@property (nonatomic, assign, getter=isStopping) BOOL stopping;
@property (nonatomic, assign) _StoppedState stoppedState;
@property (nonatomic, copy) GameInfo *gameInfo;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) void (^startHandler)(id<SudRt2GameHandle> _Nullable handle,
                                                 NSError * _Nullable error);
@property (nonatomic, copy) void (^stopHandler)(NSError * _Nullable error);

@property (nonatomic, strong) id<SudRt2GameHandle> gameHandle;
@property (nonatomic, strong) GamePermissionModel *permissionModel;
@property (nonatomic, strong) NSMutableDictionary *gameOptions;

@end

@implementation GameRunningModel
- (instancetype)initWithUserID:(NSString *)userID {
    self = [super init];
    if (self) {
        self.userID = userID;
        _currentState = SUD_RT2_GAME_STATE_UNAVAILABLE;
        _permissionModel = [[GamePermissionModel alloc] init];
        // 注册生命周期监听事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"GameRunningModel dealloc");
    [self quitWithCompletion:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)runGame:(GameInfo *)gameInfo
    gameOptions:(NSDictionary *)options
  handleCreated:(nullable void (^)(id<SudRt2GameHandle> handle))createHandler
     completion:(nullable void (^)(id<SudRt2GameHandle> _Nullable handle, NSError * _Nullable error))completion {
    
    if (_currentState == SUD_RT2_GAME_STATE_UNAVAILABLE) {
        _gameInfo = gameInfo;
        _gameOptions = [options mutableCopy];
        [_gameOptions setValue:_gameInfo.version forKey:SUD_RT2_KEY_GAME_START_OPTIONS_GAME_VERSION];
        // 将应用程序目录添加到 search path 中
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        [_gameOptions setValue:bundlePath
                        forKey:SUD_RT2_KEY_GAME_START_OPTIONS_CUSTOM_SEARCH_PATH];
        [_gameOptions setValue:[bundlePath stringByAppendingPathComponent:@"custom.js"]
                        forKey:SUD_RT2_KEY_GAME_START_OPTIONS_CUSTOM_JS_ENTRY];
//#if DEBUG
//        [_gameOptions setValue:@(1)
//                        forKey:SUD_RT2_KEY_GAME_DEBUG_OPTION_ENABLE_V_CONSOLE];
//#endif
        [_gameOptions setValue:@(1)
                        forKey:SUD_RT2_KEY_GAME_START_OPTIONS_ENABLE_THIRD_SCRIPT];
        // 复用 gameHandle
        NSLog(@"runGame gameTag:%@", gameInfo.tag);
        if (!_gameHandle) {
            GameEnv *gameEnv = [GameEnv getInstance];
            [SudRuntime2 createRuntime:nil completion:^(id<SudRt2GameRuntime>  _Nullable runtime, NSError *error) {
                
                NSString *gameUserId = [NSString stringWithFormat:@"%@_%@", _userID, gameInfo.tag];
                [runtime createGameHandleWithOptions:@{
                    SUD_RT2_KEY_GAME_USER_ID: gameUserId,
                    SUD_RT2_KEY_GAME_HTTP_CACHE_LIMIT_STORAGE: @(200),
                    SUD_RT2_KEY_GAME_HTTP_CACHE_PATH: [NSTemporaryDirectory() stringByAppendingPathComponent:@"http"],
                } completion:^(id<SudRt2GameHandle>  _Nullable handle, NSError * _Nullable error) {
                    NSLog(@"createGameHandleWithOptions gameTag:%@， error:%@, gameUserId:%@", gameInfo.tag, error, gameUserId);
                    if (error) {
                        if (completion) {
                            completion(nil, error);
                        }
                    } else {
                        self.gameHandle = handle;
                        if (createHandler) {
                            createHandler(handle);
                        }
                        self.startHandler = completion;
                        [self _onGameHandleCreateSuccess];
                    }
                }];
            }];

        } else {
            // 重用 handle
            if (createHandler) {
                createHandler(self.gameHandle);
            }
            self.startHandler = completion;
            [self _onGameHandleCreateSuccess];
        }
    } else {
        NSError *error = [NSError errorWithDomain:@"" code:-1000 userInfo:@{NSLocalizedDescriptionKey : @"Failed to start the game, game model is already running"}];
        completion(nil, error);
    }
}

- (void)quitWithCompletion:(nullable void (^)(NSError * _Nullable))completion {
    DDLogDebug(@"_gameHandle destroy begin:%@, _gameHandle:%@,_currentState:%@", self.gameInfo.tag, _gameHandle, @(_currentState));
    if (_currentState == SUD_RT2_GAME_STATE_UNAVAILABLE) {
        if (completion) {
            completion(nil);
        }
    } else {
        if (_stopping) {
            DDLogDebug(@"_gameHandle destroy stopping:%@, _gameHandle:%@", self.gameInfo.tag, _gameHandle);
            return;
        }
        _stopping = YES;
        _stopHandler = completion;
        DDLogDebug(@"_gameHandle before destroy _stopGameHandle:%@, _gameHandle:%@", self.gameInfo.tag, _gameHandle);
//        [self _stopGameHandle];
        [self stop];
        DDLogDebug(@"_gameHandle destroy:%@, _gameHandle:%@", self.gameInfo.tag, _gameHandle);
        [_gameHandle destroy];
    }
}

- (void)start {
    if (_stoppedState == _STOPPED_STATE_FROM_USER) {
        _stoppedState = _STOPPED_STATE_NONE;
        if (_gameHandle && _currentState != SUD_RT2_GAME_STATE_UNAVAILABLE) {
            [_gameHandle play];
        }
    }
}

- (void)stop {
    if (_stoppedState == _STOPPED_STATE_NONE) {
        _stoppedState = _STOPPED_STATE_FROM_USER;
        [self _stopGameHandle];
    }
}

- (void)startPlayGame {
    /// 主要控制声音
    /// 正常不需要，runtime内部应该联动处理，暂时先自行处理
    id<SudRt2GameAudioSession> session = [_gameHandle getGameAudioSession];
    if (session.isMute) {
        [session mute:NO];
    }
}


- (void)stopPlayGame {
    /// 主要控制声音
    /// 正常不需要，runtime内部应该联动处理，暂时先自行处理
    id<SudRt2GameAudioSession> session = [_gameHandle getGameAudioSession];
    if (!session.isMute) {
        [session mute:YES];
    }
}

#pragma mark -
- (void)_didBecomeActive {
    if (_stoppedState != _STOPPED_STATE_FROM_USER) {
        _stoppedState = _STOPPED_STATE_NONE;
        if (_gameHandle && _currentState != SUD_RT2_GAME_STATE_UNAVAILABLE) {
            [_gameHandle play];
        }
    }
}

- (void)_didEnterBackground {
    if (_stoppedState == _STOPPED_STATE_NONE) {
        _stoppedState = _STOPPED_STATE_FROM_BACKGROUND;
        [self _stopGameHandle];
    }
}

- (void)_willEnterForeground {
    if (_stoppedState != _STOPPED_STATE_FROM_USER) {
        [self _startGameHandle];
    }
}

- (void)_willResignActive {
    if (_stoppedState != _STOPPED_STATE_FROM_USER) {
        if (_gameHandle && _currentState != SUD_RT2_GAME_STATE_UNAVAILABLE) {
            [_gameHandle pause];
        }
    }
}

#pragma mark - CRGameQueryClipboardListener
- (void)onGetClipboardData:(id<SudRt2GameQueryClipboardHandle>)handle
                      data:(NSString *)data
                     appId:(NSString *)appId {
    // 可监听并过滤获取剪贴板内容
    // 以下代码，允许游戏获取剪贴板内容
    [handle allowGetClipboardData:data];
}

- (void)onSetClipboardData:(id<SudRt2GameQueryClipboardHandle>)handle
                      data:(NSString *)data
                     appId:(NSString *)appId {
    // 可监听并过滤设置剪贴板内容
    // 以下代码，允许游戏设置剪贴板内容
    [handle allowSetClipboardData:data];
}

#pragma mark - CRGameDrawFrameListener
- (void)onDrawFrame:(long)frameCounter {
    DDLogDebug(@"onDrawFrame:%@", _gameInfo.tag);
    [_gameHandle setGameDrawFrameListener:nil];
    // 真正开始绘制的时候代表游戏启动完成
    if (_startHandler) {
        _startHandler(_gameHandle, nil);
        _startHandler = nil;
    }
//    [self stop];
}


#pragma mark - CRGameQueryAudioOptionsListener
- (void)onQueryAudioSession:(id<SudRt2GameQueryAudioOptionsHandle>)handle appId:(NSString *)appId options:(NSDictionary *)options {
    // 当有多个游戏实例时，可根据业务逻辑确定某些游戏实例的音频播放状态
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    AVAudioSessionCategory catagory = 0;
    AVAudioSessionCategoryOptions catagoryOptions = 0;
    BOOL speakerOn = [[options objectForKey:SUD_RT2_KEY_AUDIO_SPEAKER_ON] boolValue];
    BOOL mixWithOther = [[options objectForKey:SUD_RT2_KEY_AUDIO_MIX_WITH_OTHER] boolValue];
    BOOL obeyMuteSwitch = [[options objectForKey:SUD_RT2_KEY_AUDIO_OBEY_MUTE_SWITCH] boolValue];
    
    if (mixWithOther) {
        catagoryOptions |= AVAudioSessionCategoryOptionMixWithOthers;
    }

    if (speakerOn) {
        if (obeyMuteSwitch) {
            catagory = AVAudioSessionCategoryAmbient;
        } else {
            catagoryOptions |= AVAudioSessionCategoryOptionDefaultToSpeaker;
            catagoryOptions |= AVAudioSessionCategoryOptionAllowBluetooth;
            catagory = AVAudioSessionCategoryPlayAndRecord;
        }
    } else {
        catagoryOptions |= AVAudioSessionCategoryOptionAllowBluetooth;
        catagory = AVAudioSessionCategoryPlayAndRecord;
    }
    
    NSError *error;
    BOOL result = [session setCategory:catagory
                           withOptions:catagoryOptions
                                 error:&error];
    [session setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    
    // 完成音频会话设置
    [handle complete:result error:error];
}

#pragma mark - CRGameQueryExitListener
- (void)onQueryExit:(nonnull NSString *)appID result:(nullable NSString *)result {
    // 游戏自己退出
    if ([_delegate respondsToSelector:@selector(runningModelDidInterrupt:)]) {
        [_delegate runningModelDidInterrupt:self];
    }
}

#pragma mark - CRGameScreenStateChangeListener
- (BOOL)queryChangeScreenBrightness:(float)brightness info:(NSDictionary *)info {
    // 根据自身业务逻辑，是否允许游戏更改屏幕亮度
    return YES;
}

- (BOOL)queryChangeScreenKeepOn:(BOOL)keepOn info:(NSDictionary *)info {
    // 根据自身业务逻辑，是否允许游戏更改屏幕常亮状态
    return YES;
}

#pragma mark - CRGameStateChangeListener
- (void)onStateChangedFailureFrom:(int)fromState to:(int)toState error:(nonnull NSError *)error {
    if (toState == SUD_RT2_GAME_STATE_UNAVAILABLE) {
        if ([self isStopping]) {
            // 应用主动停止
            _stopping = NO;
            DDLogDebug(@"_stopHandler callback 1:%@", self.gameInfo.tag);
            if (_stopHandler) {
                _stopHandler(error);
                _stopHandler = nil;
            }
        } else {
            // 游戏自己退出
            if ([_delegate respondsToSelector:@selector(runningModelDidInterrupt:)]) {
                [_delegate runningModelDidInterrupt:self];
            }
        }
    }
    NSLog(@"game state change failed: from=%d to=%d error=%@", fromState, toState, error);
}

- (void)onStateChangedFrom:(int)fromState to:(int)toState {
    DDLogDebug(@"onStateChangedFrom:%@->%@, tag:%@", @(fromState), @(toState), self.gameInfo.tag);
    _currentState = toState;
    switch (toState) {
        case SUD_RT2_GAME_STATE_UNAVAILABLE: {
            if ([self isStopping]) {
                // 应用主动停止
                _stopping = NO;
                
                DDLogDebug(@"_stopHandler callback 2:%@", self.gameInfo.tag);
                if (_stopHandler) {
                    _stopHandler(nil);
                    _stopHandler = nil;
                }
            } else {
                // 游戏自己退出
                if ([_delegate respondsToSelector:@selector(runningModelDidInterrupt:)]) {
                    [_delegate runningModelDidInterrupt:self];
                }
            }
            break;
        }
        default:
            break;
    }
}

- (void)preStateChangedFrom:(int)fromState to:(int)toState {
    
}

#pragma mark - CRMediaPlayerListener
- (void)onMediaPlayerCreated:(UInt64)instanceID {
    id<SudRt2CocosGameMediaPlayerHandle> mediaPlayerHandle = [_gameHandle getMediaPlayerHandle:instanceID];
    [_mediaPlayerHandleListener addMediaPlayerHandle:mediaPlayerHandle];
}

- (void)onMediaPlayerDestroyed:(UInt64)instanceID {
    [_mediaPlayerHandleListener removeMediaPlayerhandleWithInstanceID:instanceID];
}

#pragma mark - Private
- (void)_startGameHandle {
    if (_gameInfo && _gameHandle && _currentState != SUD_RT2_GAME_STATE_UNAVAILABLE) {
        NSData *startData = [NSJSONSerialization dataWithJSONObject:@{@"appId": _gameInfo.appID}
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:nil];
        NSLog(@"_gameHandle start:%@", _gameInfo.tag);
        [_gameHandle start:[[NSString alloc] initWithData:startData encoding:NSUTF8StringEncoding]];
    }
}

- (void)_stopGameHandle {
    DDLogDebug(@"_stopGameHandle");
    if (_gameInfo && _gameHandle && _currentState != SUD_RT2_GAME_STATE_UNAVAILABLE) {
        NSData *startData = [NSJSONSerialization dataWithJSONObject:@{@"appId": _gameInfo.appID}
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:nil];
        DDLogDebug(@"_gameHandle stop");
        [_gameHandle stop:[[NSString alloc] initWithData:startData encoding:NSUTF8StringEncoding]];
    }
}

- (void)_onGameHandleCreateSuccess {
    NSLog(@"_onGameHandleCreateSuccess:%@", _gameInfo.tag);
    [_gameHandle setGameDrawFrameListener:self];
    [_gameHandle setCustomCommandListener:_customCommandListener];
    [_gameHandle setGameLoadSubpackageListener:self];
    [_gameHandle setGameQueryExitListener:self];
    [_gameHandle setGameStateListener:self];
    [_gameHandle setGameScreenStateChangeListener:self];
    [_gameHandle setGameQueryClipboardListener:self];
    [_gameHandle setGameQueryPermissionListener:_permissionModel];
    [_gameHandle setGameQuerySystemPermissionListener:_permissionModel];
    [_gameHandle setMediaPlayerListener:self];
    id<SudRt2GameAudioSession> session = [_gameHandle getGameAudioSession];
    [session setGameQueryAudioOptionsListener:self];
    
    [_gameHandle setGameStartOptions:_gameInfo.appID
                             options:_gameOptions];

    // 创建游戏实例
    [_gameHandle create];
    // 开始游戏实例
    [self _startGameHandle];
    // 接受事件输入
    [_gameHandle play];
    /// 静音游戏
    [session mute:YES];
}
@end
