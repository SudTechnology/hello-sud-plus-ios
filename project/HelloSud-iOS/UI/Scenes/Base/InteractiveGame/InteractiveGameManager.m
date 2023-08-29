//
// Created by kaniel on 2022/11/4.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "InteractiveGameManager.h"

#import <SudMGP/ISudCfg.h>
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
@end

@implementation InteractiveGameManager


- (instancetype)init {

    if (self = [super init]) {
        [self initSudFSMMG];
    }
    return self;
}

/// 初始化sud
- (void)initSudFSMMG {
    self.language = [SettingsService getCurLanguageLocale];
    self.sudFSTAPPDecorator = [[SudFSTAPPDecorator alloc] init];
    self.sudFSMMGDecorator = [[SudFSMMGDecorator alloc] init];
    [self.sudFSMMGDecorator setCurrentUserId:AppService.shared.login.loginUserInfo.userID];
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
    [self loginGame];
}

/// 设置游戏处理
/// @param gameId
- (void)setupHandler:(int64_t)gameId {
    switch (gameId) {
        case INTERACTIVE_GAME_BASEBALL_ID:{
            // 棒球
            self.baseHandler = InteractiveGameBaseballHandler.new;
            [self.sudFSMMGDecorator setEventListener:self.baseHandler];
            self.baseHandler.sudFSTAPPDecorator = self.sudFSTAPPDecorator;
            self.baseHandler.sudFSMMGDecorator = self.sudFSMMGDecorator;
        }
            break;
        case INTERACTIVE_GAME_ROCKET_ID:{
            // 火箭
            self.baseHandler = InteractiveGameRocketHandler.new;
            [self.sudFSMMGDecorator setEventListener:self.baseHandler];
            self.baseHandler.sudFSTAPPDecorator = self.sudFSTAPPDecorator;
            self.baseHandler.sudFSMMGDecorator = self.sudFSMMGDecorator;
        }
            break;
        case INTERACTIVE_GAME_CRAZY_CAR_ID:{
            // 赛车
            self.baseHandler = InteractiveGameCrazyCarHandler.new;
            [self.sudFSMMGDecorator setEventListener:self.baseHandler];
            self.baseHandler.sudFSTAPPDecorator = self.sudFSTAPPDecorator;
            self.baseHandler.sudFSMMGDecorator = self.sudFSMMGDecorator;
        }
            break;
        case INTERACTIVE_GAME_BIG_EATER_ID:{
            // 大胃王
            self.baseHandler = InteractiveGameBigEaterHandler.new;
            [self.sudFSMMGDecorator setEventListener:self.baseHandler];
            self.baseHandler.sudFSTAPPDecorator = self.sudFSTAPPDecorator;
            self.baseHandler.sudFSMMGDecorator = self.sudFSMMGDecorator;
        }
            break;
        default:
            break;
    }
    self.baseHandler.gameId = gameId;
    self.baseHandler.interactiveGameManager = self;

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
    [self logoutGame];
    [self clearLoadGameState];
}


#pragma mark =======登录 加载 游戏=======

/// 游戏登录
/// 接入方客户端 调用 接入方服务端 loginGame: 获取 短期令牌code
/// 参考文档时序图：sud-mgp-doc(https://github.com/SudTechnology/sud-mgp-doc)
- (void)loginGame {
    NSString *appID = AppService.shared.configModel.sudCfg.appId;
    NSString *appKey = AppService.shared.configModel.sudCfg.appKey;
    if (appID.length == 0 || appKey.length == 0) {
        [ToastUtil show:@"Game appID or appKey is empty"];
        return;
    }
    WeakSelf
    [GameService.shared reqGameLoginWithAppId:appID success:^(RespGameInfoModel *gameInfo) {
        [weakSelf login:weakSelf.gameView gameId:weakSelf.gameId code:gameInfo.code appID:appID appKey:appKey];
    }                                    fail:^(NSError *error) {
        [ToastUtil show:error.debugDescription];
        [self clearLoadGameState];
    }];
}

/// 退出游戏
- (void)logoutGame {
    // 销毁游戏
    [self.sudFSTAPPDecorator destroyMG];
}


#pragma mark =======登录 加载 游戏=======

/// 游戏登录
/// 接入方客户端 调用 接入方服务端 loginGame: 获取 短期令牌code
/// 参考文档时序图：sud-mgp-doc(https://github.com/SudTechnology/sud-mgp-doc)
- (void)login:(UIView *)rootView gameId:(int64_t)gameId code:(NSString *)code appID:(NSString *)appID appKey:(NSString *)appKey {
    [self initSdk:rootView gameId:gameId code:code appID:appID appKey:appKey];
}

/// 加载游戏
- (void)initSdk:(UIView *)rootView gameId:(int64_t)gameId code:(NSString *)code appID:(NSString *)appID appKey:(NSString *)appKey {
    WeakSelf
    [self logoutGame];
    if (gameId <= 0) {
        DDLogDebug(@"游戏ID为空，无法加载游戏:%@, currentRoomID:%@, currentGameRoomID:%@", gameId, self.roomID, self.gameRoomID);
        [self clearLoadGameState];
        return;
    }
    BOOL isTest = false;
#if DEBUG
    [ISudAPPD e:HsAppPreferences.shared.gameEnvType];
    if (HsAppPreferences.shared.gameEnvType != HsGameEnvTypePro) {
        isTest = YES;
    }
#endif
    [[SudMGP getCfg] setShowCustomLoading:YES];
    [[SudMGP getCfg] setShowLoadingGameBg:NO];
    [SudMGP initSDK:appID appKey:appKey isTestEnv:isTest listener:^(int retCode, const NSString *retMsg) {
        if (retCode == 0) {
            DDLogInfo(@"ISudFSMMG:initGameSDKWithAppID:初始化游戏SDK成功");
            if (weakSelf) {
                // SudMGPSDK初始化成功 加载MG
                NSString *userID = AppService.shared.login.loginUserInfo.userID;
                NSString *roomID = weakSelf.gameRoomID;
                if (userID.length == 0 || roomID.length == 0 || code.length == 0) {
                    [ToastUtil show:NSString.dt_room_load_failed];
                    return;
                }
                DDLogInfo(@"loadGame:userId:%@, gameRoomId:%@, currentRoomId:%@, gameId:%@", userID, roomID, weakSelf.roomID, @(gameId));
                [weakSelf loadGame:userID roomId:roomID code:code mgId:gameId language:weakSelf.language fsmMG:weakSelf.sudFSMMGDecorator rootView:rootView];
            }
        } else {
            /// 初始化失败, 可根据业务重试
            DDLogError(@"ISudFSMMG:initGameSDKWithAppID:初始化sdk失败 :%@", retMsg);
            [self clearLoadGameState];
        }
    }];
}

/// 加载游戏MG
/// @param userId 用户唯一ID
/// @param roomId 房间ID
/// @param code 游戏登录code
/// @param mgId 游戏ID
/// @param language 支持简体"zh-CN "    繁体"zh-TW"    英语"en-US"   马来"ms-MY"
/// @param fsmMG 控制器
/// @param rootView 游戏根视图
- (void)loadGame:(NSString *)userId roomId:(NSString *)roomId code:(NSString *)code mgId:(int64_t)mgId language:(NSString *)language fsmMG:(id)fsmMG rootView:(UIView *)rootView {

    id <ISudFSTAPP> iSudFSTAPP = [SudMGP loadMG:userId roomId:roomId code:code mgId:mgId language:language fsmMG:self.sudFSMMGDecorator rootView:rootView];
    [self.sudFSTAPPDecorator setISudFSTAPP:iSudFSTAPP];
}

@end
