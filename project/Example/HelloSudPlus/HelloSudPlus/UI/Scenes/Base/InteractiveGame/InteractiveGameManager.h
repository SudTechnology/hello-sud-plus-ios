//
// Created by kaniel on 2022/11/4.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>


#define INTERACTIVE_GAME_ROCKET_ID          1583284410804244481L // 火箭游戏ID
#define INTERACTIVE_GAME_BASEBALL_ID        1594978084509368321L // 棒球游戏ID
#define INTERACTIVE_GAME_CRAZY_CAR_ID        1649319572314173442L // 塞车游戏ID
#define INTERACTIVE_GAME_BIG_EATER_ID        1641330097642704898L // 大胃王游戏ID

/// 互动游戏管理模块
@interface InteractiveGameManager : NSObject
/// 游戏ID
@property(nonatomic, assign, readonly) int64_t gameId;
/// 游戏销毁回调
@property(nonatomic, strong)void(^onGameDestryedBlock)(void);

/// 加载互动游戏
/// @param gameId gameId
/// @param roomId roomId
/// @param gameView gameView
- (void)loadInteractiveGame:(int64_t)gameId roomId:(NSString *)roomId gameView:(UIView *)gameView;

/// 销毁互动游戏
- (void)destoryGame;

/// 展示游戏视图
/// @param showMainView 是否展示游戏主界面，YES时通知游戏拉起主界面，否则默认不展示主界面，只有空白页
- (void)showGameView:(BOOL)showMainView;

/// 隐藏游戏视图
- (void)hideGameView;

/// 是否已经退出游戏
- (BOOL)isExistGame;

/// 是否是互动礼物
- (BOOL)checkIsInteractiveGame:(int64_t)gameId;

#pragma mark - 火箭

/// 播放火箭
/// @param jsonData
- (void)playRocket:(NSString *)jsonData;

/// 检测点是否在游戏可点击区域，如果游戏没有指定，则默认游戏需要响应该点，返回YES;否则按照游戏指定区域判断是否在区域内，在则返回YES,不在则返回NO
/// @param clickPoint 点击事件点
/// @return
- (BOOL)checkIfPointInGameClickRect:(CGPoint)clickPoint;

/// 礼物面板发送火箭
/// @param giftModel
/// @param toMicList
- (void)sendRocketGift:(GiftModel *)giftModel toMicList:(NSArray<AudioUserModel *> *)toMicList finished:(void (^)(BOOL success))finished;

/// 通知游戏关闭火箭动效
- (void)notifyGameCloseRocketEffect;

/// 通知游戏火箭加速
- (void)notifyGameFlyRocket;

/// 设置动效回调
/// @param rocketEffectBlock
- (void)setupRocketEffectBlock:(void(^)(BOOL show))rocketEffectBlock;

/// 清除加载状态
- (void)clearLoadGameState;
@end
