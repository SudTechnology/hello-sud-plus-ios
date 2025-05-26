//
// Created by kaniel on 2022/11/4.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "InteractiveGameManager.h"
#import "RocketSelectAnchorView.h"
#import "InteractiveGameLoadingView.h"
#import "handler/InteractiveGameBaseHandler.h"
#import "Handler/Baseball/InteractiveGameBaseballHandler.h"
#import "Handler/Rocket/InteractiveGameRocketHandler.h"
#import "Handler/CrazyCar/InteractiveGameCrazyCarHandler.h"
#import "Handler/BigEater/InteractiveGameBigEaterHandler.h"


@interface InteractiveGameManager ()
/// ISudFSTAPP
@property(nonatomic, strong) SudFSMMGDecorator *sudFSMMGDecorator;
/// app To 游戏 管理类
@property(nonatomic, strong) SudFSTAPPDecorator *sudFSTAPPDecorator;
/// 游戏ID
@property(nonatomic, assign) int64_t gameId;
/// 游戏加载主view
@property(nonatomic, strong) UIView *gameView;
@property(nonatomic, strong) NSString *roomID;
@property(nonatomic, strong) NSString *gameRoomID;
@property(nonatomic, strong) NSString *language;

/// 是否加载了游戏
@property(nonatomic, assign) BOOL isLoadedGame;
@property(nonatomic, strong) InteractiveGameBaseHandler *baseHandler;
@property(nonatomic, strong)SudGameManager *gameManager;
@end

@implementation InteractiveGameManager


- (instancetype)init {

    if (self = [super init]) {
        [self configSudGame];
    }
    return self;
}

/// 初始化sud
- (void)configSudGame {
    self.language = [SettingsService getCurLanguageLocale];
    self.gameManager = SudGameManager.new;
    [self hanldeInitSudFSMMG];
}

- (void)hanldeInitSudFSMMG {

}


/// 加载互动游戏 火箭
/// @param gameId
/// @param gameView
- (void)loadInteractiveGame:(int64_t)gameId roomId:(NSString *)roomId gameView:(UIView *)gameView {
    self.roomID = roomId;
    self.gameRoomID = roomId;
    self.gameId = gameId;
    self.gameView = gameView;
    self.isLoadedGame = YES;
    gameView.hidden = NO;
    [self setupHandler:gameId];
    [self.baseHandler showLoadingView:gameView];
    [self loadGame];
}

/// 设置游戏处理
/// @param gameId
- (void)setupHandler:(int64_t)gameId {
    switch (gameId) {
        case INTERACTIVE_GAME_BASEBALL_ID:{
            // 棒球
            self.baseHandler = InteractiveGameBaseballHandler.new;
        }
            break;
        case INTERACTIVE_GAME_ROCKET_ID:{
            // 火箭
            self.baseHandler = InteractiveGameRocketHandler.new;

        }
            break;
        case INTERACTIVE_GAME_CRAZY_CAR_ID:{
            // 赛车
            self.baseHandler = InteractiveGameCrazyCarHandler.new;

        }
            break;
        case INTERACTIVE_GAME_BIG_EATER_ID:{
            // 大胃王
            self.baseHandler = InteractiveGameBigEaterHandler.new;

        }
            break;
        default:
            break;
    }
    self.baseHandler.gameId = gameId;
    self.baseHandler.interactiveGameManager = self;
    [self.gameManager registerGameEventHandler:self.baseHandler];
}

- (void)clearLoadGameState {
    self.isLoadedGame = NO;
}

- (BOOL)isExistGame {
    return self.isLoadedGame;
}

/// 播放火箭
/// @param jsonData
- (void)playRocket:(NSString *)jsonData {
    if ([self.baseHandler isKindOfClass:[InteractiveGameRocketHandler class]]) {
        [(InteractiveGameRocketHandler *) self.baseHandler playRocket:jsonData];
    }
}

/// 检测点是否在游戏可点击区域，如果游戏没有指定，则默认游戏需要响应该点，返回YES;否则按照游戏指定区域判断是否在区域内，在则返回YES,不在则返回NO
/// @param clickPoint 点击事件点
/// @return
- (BOOL)checkIfPointInGameClickRect:(CGPoint)clickPoint {
    return [self.baseHandler checkIfPointInGameClickRect:clickPoint];
}

/// 礼物面板发送火箭
/// @param giftModel
/// @param toMicList
- (void)sendRocketGift:(GiftModel *)giftModel toMicList:(NSArray<AudioRoomMicModel *> *)toMicList finished:(void (^)(BOOL success))finished {
    [InteractiveGameRocketHandler sendRocketGift:giftModel toMicList:toMicList finished:finished];
//    if ([self.baseHandler isKindOfClass:[InteractiveGameRocketHandler class]]) {
//        [(InteractiveGameRocketHandler *) self.baseHandler sendRocketGift:giftModel toMicList:toMicList finished:finished];
//    }
}

/// 通知游戏关闭火箭动效
- (void)notifyGameCloseRocketEffect {
    [self.sudFSTAPPDecorator notifyAppCustomRocketClosePlayEffect];
}

/// 通知游戏火箭加速
- (void)notifyGameFlyRocket {
    [self.sudFSTAPPDecorator notifyAppCustomRocketFlyClick];
}

/// 设置动效回调
/// @param rocketEffectBlock
- (void)setupRocketEffectBlock:(void (^)(BOOL show))rocketEffectBlock {
    if ([self.baseHandler isKindOfClass:[InteractiveGameRocketHandler class]]) {
        [(InteractiveGameRocketHandler *) self.baseHandler setupRocketEffectBlock:rocketEffectBlock];
    }
}

/// 展示游戏视图
- (void)showGameView:(BOOL)showMainView {
    self.gameView.hidden = NO;
    [self.baseHandler showGameView:showMainView];
}

/// 销毁互动游戏
- (void)destoryGame {
    self.gameView.hidden = YES;
    self.gameId = 0;
    self.gameRoomID = nil;
    [self destroyGame];
    [self clearLoadGameState];
    if (self.onGameDestryedBlock) {
        self.onGameDestryedBlock();
    }
}

/// 是否是互动礼物
- (BOOL)checkIsInteractiveGame:(int64_t)gameId {
    return gameId == INTERACTIVE_GAME_ROCKET_ID ||
    gameId == INTERACTIVE_GAME_BASEBALL_ID ||
    gameId == INTERACTIVE_GAME_CRAZY_CAR_ID||
    gameId == INTERACTIVE_GAME_BIG_EATER_ID;
}


#pragma mark =======登录 加载 游戏=======

/// 游戏登录
/// 接入方客户端 调用 接入方服务端 loadGame: 获取 短期令牌code
/// 参考文档时序图：sud-mgp-doc(https://github.com/SudTechnology/sud-mgp-doc)
- (void)loadGame {
    
    // 自定义进度条
    [[SudGIP getCfg] setShowCustomLoading:YES];
    
    NSString *appID = AppService.shared.configModel.sudCfg.appId;
    NSString *appKey = AppService.shared.configModel.sudCfg.appKey;
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
    if (HsAppPreferences.shared.gameEnvType != HsGameEnvTypePro) {
        isTest = YES;
    }
#endif
    SudGameLoadConfigModel *configModel = SudGameLoadConfigModel.new;
    configModel.appId = appID;
    configModel.appKey = appKey;
    configModel.roomId = roomID;
    configModel.userId = userID;
    configModel.gameId = self.gameId;
    configModel.gameView = self.gameView;
    configModel.language = self.language;
    configModel.isTestEnv = isTest;
    [self.gameManager loadGame:configModel success:nil fail:nil];
}

/// 退出游戏
- (void)destroyGame {
    // 销毁游戏
    [self.gameManager destroyGame];
}
@end
