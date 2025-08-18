//
//  AudioRoomViewController+Game.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseSceneViewController+Game.h"
#import "BaseSceneViewController+Voice.h"
#import "RocketSelectAnchorView.h"


@implementation BaseSceneViewController (Game)

/// 初始化sud
- (void)configSudGame {
    self.gameEventHandler = [self createGameEventHandler];
    self.gameEventHandler.vc = self;
    [self.gameManager registerGameEventHandler:self.gameEventHandler];
    [self hanldeInitSudFSMMG];
}

- (void)hanldeInitSudFSMMG {
    self.gameMicContentView.iSudFSMMG = self.gameEventHandler.sudFSMMGDecorator;
}


#pragma mark =======登录 加载 游戏=======
- (void)loadGame {
    // 如果是互动礼物，走互动模块去加载
    if ([self.interactiveGameManager checkIsInteractiveGame:self.gameId]) {
        self.loadingByInteractiveMode = YES;
        [self showInteractiveGame:self.gameId showMainView:YES];
        return;
    }
    self.loadingByInteractiveMode = NO;
    NSString *appID = HsAppPreferences.shared.appId;
    NSString *appKey = HsAppPreferences.shared.appKey;
    DDLogDebug(@"appId:%@", appID);
    if (appID.length == 0 || appKey.length == 0) {
        [ToastUtil show:@"Game appID or appKey is empty"];
        return;
    }
    NSString *userID = AppService.shared.login.loginUserInfo.userID;
    NSString *roomID = self.gameRoomID;
    if (userID.length == 0 || roomID.length == 0) {
        [ToastUtil show:NSString.dt_room_load_failed];
        return;
    }
    BOOL isTest = false;
#if DEBUG
    [ISudAPPD e:HsAppPreferences.shared.gameEnvType];
    [ISudAPPD d];
    if (HsAppPreferences.shared.gameEnvType != HsGameEnvTypePro) {
        isTest = YES;
    }
#endif
    // 控制SDK游戏加载背景
    BOOL isShowSDKLoadingBackground = [self showSudMGPLoadingGameBackground];
    [[SudGIP getCfg] setShowLoadingGameBg:isShowSDKLoadingBackground];
    [[SudGIP getCfg] setShowCustomLoading:self.showCustomLoadingView];

    SudGameLoadConfigModel *configModel = SudGameLoadConfigModel.new;
    configModel.appId = appID;
    configModel.appKey = appKey;
    configModel.roomId = roomID;
    configModel.userId = userID;
    configModel.gameId = self.gameId;
    configModel.gameView = self.gameView;
    configModel.language = self.language;
    configModel.isTestEnv = isTest;
    configModel.authorizationSecret = self.configModel.enterRoomModel.extraRoomVO.authSecret;
    [self.gameManager loadGame:configModel success:nil fail:nil];
}



/// 退出游戏
- (void)destroyGame {
    [self stopCaptureAudioToASR];
    // 销毁游戏
    [self.gameManager destroyGame];
}

/// 处理切换游戏
/// @param gameID 新的游戏ID
- (void)switchToGame:(int64_t)gameID {
    self.isGameForbiddenVoice = NO;
    if (gameID == 0) {
        // 切换语音房间
        self.gameId = 0;
        GameService.shared.gameId = 0;
        [self destroyGame];
        [self roomGameDidChanged:gameID];
        return;
    }
    /// 更新gameID
    self.gameId = gameID;
    GameService.shared.gameId = gameID;
    [self loadGame];
    [self roomGameDidChanged:gameID];
}
@end

