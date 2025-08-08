//
//  SudGameManager.m
//  QuickStart
//
//  Created by kaniel on 2024/1/12.
//  Copyright © 2024 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SudGameManager.h"

@interface SudGameManager()
/// 游戏事件处理对象
/// Game event handling object
@property(nonatomic, weak)SudGameBaseEventHandler *sudGameEventHandler;
@end

@implementation SudGameManager

- (void)dealloc {
    NSLog(@"SudGameManager dealloc");
}

#pragma mark --- public

- (void)registerGameEventHandler:(SudGameBaseEventHandler *)eventHandler {
    self.sudGameEventHandler = eventHandler;
    [self.sudGameEventHandler.sudFSMMGDecorator setEventListener:eventHandler];
}

- (void)loadGame:(nonnull SudGameLoadConfigModel *)configModel
         success:(nullable SudGmSuccessVoidBlock)success
            fail:(nullable SudGmFailedBlock)fail {
    NSAssert(self.sudGameEventHandler, @"Must registerGameEventHandler before!");
    if (!self.sudGameEventHandler) {
        if (fail){
            fail(-1, @"Game event handler is nil");
        }
        return;
    }
    [self.sudGameEventHandler setupLoadConfigModel:configModel];
    __weak typeof(self) weakSelf = self;
    [self.sudGameEventHandler onGetCode:configModel.userId success:^(NSString * _Nonnull code) {
        NSLog(@"on getCode success");
        [weakSelf initSudGIPSDK:configModel code:code success:success fail:fail];
    } fail:fail];
}

- (void)destroyGame {
    NSAssert(self.sudGameEventHandler, @"Must registerGameEventHandler before!");
    [self.sudGameEventHandler.sudFSMMGDecorator clearAllStates];
    [self.sudGameEventHandler.sudFSTAPPDecorator destroyMG];
}

#pragma mark --- private

/// 初始化游戏SudMDP SDK
- (void)initSudGIPSDK:(SudGameLoadConfigModel *)configModel
                 code:(NSString *)code
              success:(SudGmSuccessVoidBlock)success
                 fail:(SudGmFailedBlock)fail  {
    
    __weak typeof(self) weakSelf = self;
    if (configModel.gameId <= 0) {
        NSLog(@"Game id is empty can not load the game:%@, currentRoomID:%@", @(configModel.gameId), configModel.roomId);
        if (fail) {
            fail(-1, @"game id is empty");
        }
        return;
    }
    /// Show how to embed a local pkg in the project
    //    [[SudGIP getCfg]addEmbeddedMGPkg:1763401430010871809 mgPath:@"GreedyStar_1.0.0.1.sp"];
    NSString *version = [SudGIP getVersion];
    NSString *versionAlis = [SudGIP getVersionAlias];
    NSLog(@"SudGIP:version:%@,versionAlis:%@", version, versionAlis);
    // 2. 初始化SudMGP SDK<SudGIP initSDK>
    // 2. Initialize the SudMGP SDK <SudGIP initSDK>
    SudInitSDKParamModel *paramModel = SudInitSDKParamModel.new;
    paramModel.appId = configModel.appId;
    paramModel.appKey = configModel.appKey;
    paramModel.userId = configModel.userId;
    paramModel.isTestEnv = configModel.isTestEnv;
    [SudGIP initSDK:paramModel listener:^(int retCode,NSString * _Nonnull retMsg) {
        
        if (retCode != 0) {
            NSLog(@"ISudFSMMG:initGameSDKWithAppID init sdk failed :%@(%@)", retMsg, @(retCode));
            if (fail) {
                fail(retCode, retMsg);
            }
            return;
        }
        NSLog(@"ISudFSMMG:initGameSDKWithAppID: init sdk successfully");
        // 加载游戏
        // Load the game
        [weakSelf loadMG:configModel code:code success:success fail:fail];
    }];
}

/// 加载游戏MG
/// Initialize the SudMDP SDK for the game
/// @param configModel 配置model
/// @param code config model
/// @param success success callback
/// @param fail fail callback
- (void)loadMG:(SudGameLoadConfigModel *)configModel
          code:(NSString *)code
       success:(SudGmSuccessVoidBlock)success
          fail:(SudGmFailedBlock)fail{
    
    NSAssert(self.sudGameEventHandler, @"Must registerGameEventHandler before!");
    [self.sudGameEventHandler setupLoadConfigModel:configModel];
    // 确保初始化前不存在已加载的游戏 保证SudMGP initSDK前，销毁SudMGP
    // Ensure that there are no loaded games before initialization. Ensure SudMGP is destroyed before initSDK
    [self destroyGame];
    NSLog(@"loadMG:userId:%@, gameRoomId:%@, gameId:%@", configModel.userId, configModel.roomId, @(configModel.gameId));
    if (configModel.userId.length == 0 ||
        configModel.roomId.length == 0 ||
        code.length == 0 ||
        configModel.language.length == 0 ||
        configModel.gameId <= 0) {
        
        NSLog(@"loadGame: param has some one empty");
        if (fail) {
            fail(-1, @"At least one parameter is empty.");
        }
        return;
    }
    // 必须配置当前登录用户
    // The current login user must be configured
    [self.sudGameEventHandler.sudFSMMGDecorator setCurrentUserId:configModel.userId];
    // 3. 加载SudMGP SDK<SudGIP loadMG>，注：客户端必须持有iSudFSTAPP实例
    // 3. Load SudMGP SDK<SudGIP loadMG>. Note: The client must hold the iSudFSTAPP instance
    SudLoadMGParamModel *paramModel = SudLoadMGParamModel.new;
    paramModel.userId = configModel.userId;
    paramModel.roomId = configModel.roomId;
    paramModel.code = code;
    paramModel.mgId = configModel.gameId;
    paramModel.language = configModel.language;
    paramModel.gameViewContainer = configModel.gameView;
    paramModel.authorizationSecret = configModel.authorizationSecret;
    id <ISudFSTAPP> iSudFSTAPP = [SudGIP loadMG:paramModel fsmMG:self.sudGameEventHandler.sudFSMMGDecorator];
    if (!iSudFSTAPP) {
        if (fail){
            fail(-1, @"loadMG error, please check detail from console");
        }
        return;
    }
    [self.sudGameEventHandler.sudFSTAPPDecorator setISudFSTAPP:iSudFSTAPP];
    if (success) {
        success();
    }
}


@end
