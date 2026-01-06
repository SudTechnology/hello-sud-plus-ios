//
//  SudRtWrapper.m
//  HelloSudPlus
//
//  Created by kaniel on 9/18/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SudRtWrapper.h"
#import <SudGIP/SudGIP-umbrella.h>
#import "GameEnv.h"
#import "GameInfo.h"
#import "GameRunningModel.h"
#import "GameCustomCommand.h"
#import "SudRtWrapperCalc.h"

@implementation SudRtGameInfo
- (instancetype)init
{
    self = [super init];
    if (self) {
        _version = @"1.0";
    }
    return self;
}
@end

@interface SudRtWrapper()<SUDRuntime2GameCustomCommandListener,SUDRuntime2MediaPlayerHandleListener, GameRunningModelDelegate>
@property(nonatomic, strong)GameRunningModel *gameRunningModel;
@property (nonatomic, copy) NSDictionary *options;
@property(nonatomic, strong)UIView *rtGameView;

@property(nonatomic,strong)SudRtWrapperCalc *loadRtCalc;
@property(nonatomic,strong)SudRtWrapperCalc *runRtCalc;
@end


@implementation SudRtWrapper


- (SudRtWrapperCalc *)loadRtCalc {
    if (!_loadRtCalc) {
        _loadRtCalc = SudRtWrapperCalc.new;
    }
    return _loadRtCalc;
}



- (SudRtWrapperCalc *)runRtCalc {
    if (!_runRtCalc) {
        _runRtCalc = SudRtWrapperCalc.new;
    }
    return _runRtCalc;
}

- (void)dealloc {
    DDLogDebug(@"SudRtWrapper dealloc");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self prepare];
    }
    return self;
}

- (void)setUserId:(NSString *)userId {
    _userId = userId;
    GameEnv.getInstance.userID = userId;
}

- (void)prepare {
    self.options = @{};
}


// 加载游戏，如果没有安装过，则执行下载并安装
- (void)loadGameWithGameInfo:(SudRtGameInfo *)sudRtGameInfo
      onUpdatedGameViewBlock:(void(^)(UIView *gameView))onUpdatedGameViewBlock
                  completion:(void(^)(NSError *error))completion {
 
    WeakSelf;
    [self loadGamePackage:sudRtGameInfo completion:^(NSError *error) {
        GameInfo *gameInfo = [[GameInfo alloc] init];

        gameInfo.appID = sudRtGameInfo.gameId;
        gameInfo.version = sudRtGameInfo.version;
        gameInfo.url = sudRtGameInfo.url;
        gameInfo.name = sudRtGameInfo.gameId;
        gameInfo.gameHash = sudRtGameInfo.gameHash;
        gameInfo.tag = sudRtGameInfo.gameTag;
        [weakSelf startLoadGame:gameInfo onUpdatedGameViewBlock:onUpdatedGameViewBlock completion:completion];
    }];
}


/// 加载游戏包
/// - Parameters:
///   - sudRtGameInfo: sudRtGameInfo description
///   - completion: completion description
- (void)loadGamePackage:(SudRtGameInfo *)sudRtGameInfo completion:(void(^)(NSError *error))completion {
    WeakSelf;
    SUDRuntimeInitSDKParamModel *paramModel = [[SUDRuntimeInitSDKParamModel alloc]init];
    [ISudAPPD e:HsAppPreferences.shared.gameEnvType];
    paramModel.appId = HsAppPreferences.shared.appId;
    paramModel.appKey = HsAppPreferences.shared.appKey;
    paramModel.code = sudRtGameInfo.code;
    [SUDRuntime2 initSDK:paramModel completion:^(NSError *error) {
        NSLog(@"initSDK result:%@", error.localizedDescription);
        if (error) {
            if (completion) {
                completion(error);
            }
            return;
        }

        
        SUDRuntime2LoadPackageParamModel *paramModel = SUDRuntime2LoadPackageParamModel.new;
        paramModel.gameId = sudRtGameInfo.gameId;
        paramModel.version = sudRtGameInfo.version;
        paramModel.path = sudRtGameInfo.url;
        [SUDRuntime2 loadPackage:paramModel progress:^(NSInteger progress) {
            DDLogDebug(@"loadPackage progress:%@%%", @(progress));
        } completion:^(NSError *error) {
            DDLogDebug(@"loadPackage result:%@", error.localizedDescription);
            if (error) {
                if (completion) {
                    completion(error);
                }
                return;
            }
            DDLogDebug(@"loadPackage finished:%@", sudRtGameInfo.gameTag);
            if (completion) {
                completion(error);
            }
        }];
    }];
}

/// 对应停止时，调用恢复
- (void)startGame {
    DDLogDebug(@"startGame");
    [_gameRunningModel start];
}
/// 停止游戏
- (void)stopGame {
    DDLogDebug(@"stopGame");
    [_gameRunningModel stop];
}

- (void)startPlayGame {
    [_gameRunningModel startPlayGame];
}

- (void)stopPlayGame {
    [_gameRunningModel stopPlayGame];
}
/// 停止并销毁游戏
- (void)destroyGame:(nullable void (^)(NSError * _Nullable error))completion  {
    DDLogDebug(@"rt destroyGame begin");
    if (_gameRunningModel) {
        [_gameRunningModel quitWithCompletion:completion];
        return;
    }
    if (completion) {
        completion(nil);
    }
}

- (void)startLoadGame:(GameInfo *)gameInfo
onUpdatedGameViewBlock:(void(^)(UIView *gameView))onUpdatedGameViewBlock
           completion:(void(^)(NSError *error))completion {
    WeakSelf;
    // 加载游戏
    self.loadRtCalc.stepName = [NSString stringWithFormat:@"rt startLoadGame, tag:%@", gameInfo.tag];
    [self.loadRtCalc begin];
    
    SUDRuntime2LoadPackageParamModel *paramModel = SUDRuntime2LoadPackageParamModel.new;
    paramModel.gameId = gameInfo.appID;
    paramModel.version = gameInfo.version;
    paramModel.path = gameInfo.url;
    [SUDRuntime2 loadPackage:paramModel progress:^(NSInteger progress) {
        DDLogDebug(@"loadGame progress:%@%%", @(progress));
    } completion:^(NSError *error) {
        DDLogDebug(@"loadGame result:%@", error.localizedDescription);
        if (error) {
            if (completion) {
                completion(error);
            }
            return;
        }
        DDLogDebug(@"rt load game finished:%@", gameInfo.tag);
        [weakSelf startRunGame:gameInfo gameOptions:weakSelf.options onUpdatedGameViewBlock:onUpdatedGameViewBlock completion:completion];
    }];
}

- (void)cacheGamePackage:(SudRtGameInfo *)sudRtGameInfo
              completion:(void(^)(NSError *error))completion {
    [self loadGamePackage:sudRtGameInfo completion:completion];
}

- (void)startRunGame:(GameInfo *)gameInfo
      gameOptions:(NSDictionary *)gameOptions
onUpdatedGameViewBlock:(void(^)(UIView *gameView))onUpdatedGameViewBlock
       completion:(void(^)(NSError *error))completion {
    
    GameEnv *env = [GameEnv getInstance];
    _gameRunningModel = [[GameRunningModel alloc] initWithUserID:env.userID];
    _gameRunningModel.delegate = self;
    GameCustomCommand *commandListener = [[GameCustomCommand alloc] init];
    commandListener.gameID = gameInfo.appID;
    [commandListener addCustomCommandListener:self];
    _gameRunningModel.customCommandListener = commandListener;
    _gameRunningModel.mediaPlayerHandleListener = self;
    WeakSelf;
    self.runRtCalc.stepName = [NSString stringWithFormat:@"rt runGame, tag:%@", gameInfo.tag];
    [self.runRtCalc begin];
    [_gameRunningModel runGame:gameInfo
                   gameOptions:gameOptions
                 handleCreated:^(id<SUDRuntime2GameHandle>  _Nonnull handle) {
        // handle 创建后立刻给 gameView 布局，以设置正确的宽高
        if (!weakSelf) {
            return;
        }
        UIView *gameView = [handle getGameView];
        if (weakSelf.rtGameView && weakSelf.rtGameView != gameView) {
            [weakSelf.rtGameView removeFromSuperview];
        }
        weakSelf.rtGameView = gameView;
        [weakSelf.gameView addSubview:gameView];
        [gameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.gameView);
        }];
        [weakSelf.gameView layoutIfNeeded];
        DDLogDebug(@"handleCreated:%@, gameView:%@, frame:%@", gameInfo.tag, gameView,@(gameView.frame));
        if (onUpdatedGameViewBlock){
            onUpdatedGameViewBlock(gameView);
        }
    } completion:^(id<SUDRuntime2GameHandle>  _Nullable handle, NSError * _Nullable error) {
        [weakSelf.runRtCalc end];
        if (error) {
            DDLogDebug(@"游戏运行失败，%@", error.localizedDescription);
        }
        if (completion){
            completion(error);
        }
    }];
}

- (void)onCallCustomCommand:(id<SUDRuntime2GameCustomCommandHandle>)handle info:(nullable NSDictionary *)argv {
    NSLog(@"onCallCustomCommand:%@", argv);
    int count = [[argv objectForKey:@"argc"] intValue];
    NSInteger index = 0;
    NSString *state = argv[[NSString stringWithFormat:@"%ld",(long)index++]];
    NSString *dataJson = argv[[NSString stringWithFormat:@"%ld",(long)index]];

    if (self.commandListener &&
        [self.commandListener respondsToSelector:@selector(onCommand:dataJson:success:fail:)]) {
        [self.commandListener onCommand:state dataJson:dataJson success:^(NSString * _Nonnull resultDataJson) {
            [handle pushResultWithString:resultDataJson];
            [handle customCommandSuccess];
        } fail:^(NSString * _Nonnull error) {
            [handle customCommandFailure:error];
        }];
    }
}

- (void)onCallCustomCommandSync:(id<SUDRuntime2GameCustomCommandHandle>)handle info:(nullable NSDictionary *)argv {
    NSLog(@"onCallCustomCommandSync:%@", argv);
}

- (void)addMediaPlayerHandle:(id<SUDRuntime2CocosGameMediaPlayerHandle>)mediaPlayerHandle {
    
}

- (void)removeMediaPlayerhandleWithInstanceID:(UInt64) instanceID {
    
}

- (void)runningModelDidInterrupt:(GameRunningModel *)model {
    NSLog(@"runningModelDidInterrupt:%@", model);
}


- (UIView *)gameView {
    if (!_gameView) {
        _gameView = [[UIView alloc]init];
        _gameView.frame = UIScreen.mainScreen.bounds;
    }
    return _gameView;
}
@end
