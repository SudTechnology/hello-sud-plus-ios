//
//  SudFSMMGManager.h
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/2/18.
//

#import <Foundation/Foundation.h>
#import <SudMGP/ISudFSMMG.h>
#import <SudMGP/ISudFSTAPP.h>
#import <SudMGP/SudMGP.h>
#import <SudMGP/ISudAPPD.h>
#import <SudMGP/ISudFSMStateHandle.h>

#import "SudFSMMGListener.h"

NS_ASSUME_NONNULL_BEGIN

/// game -> app
@interface SudFSMMGDecorator : NSObject <ISudFSMMG>

typedef NS_ENUM(NSInteger, GameStateType) {
    /// 空闲
    GameStateTypeLeisure = 0,
    /// loading
    GameStateTypeLoading = 1,
    /// playing
    GameStateTypePlaying = 2,
};

/// 当前用户ID
@property(nonatomic, strong, readonly)NSString *currentUserId;

// 游戏状态枚举： GameStateType
@property (nonatomic, assign) GameStateType gameStateType;
/// 当前用户是否加入
@property (nonatomic, assign) BOOL isInGame;
/// 是否在游戏中
@property (nonatomic, assign) BOOL isPlaying;
/// 游戏是否准备
@property (nonatomic, assign) BOOL isReady;
/// 是否是需要命中文字 【数字炸弹】
@property (nonatomic, assign) BOOL isHitBomb;
/// 你画我猜专用，游戏中选中的关键词，会回调出来，通过 drawKeyWord 进行保存。
@property (nonatomic, copy) NSString *drawKeyWord;
/// 你画我猜，进入猜词环节，用来公屏识别关键字的状态标识
@property (nonatomic, assign) BOOL keyWordHiting;
/// ASR功能的开启关闭的状态标志
@property (nonatomic, assign) BOOL keyWordASRing;
/// 队长userid
@property (nonatomic, copy) NSString *captainUserId;
/// 当前游戏成员的游戏状态Map
@property (nonatomic, strong) NSMutableDictionary *gamePlayerStateMap;
/// 当前游戏在线userid列表
@property (nonatomic, strong) NSMutableArray <NSString *>*onlineUserIdList;

/// 设置事件处理器
/// @param listener 事件处理实例
- (void)setEventListener:(id<SudFSMMGListener>)listener;

/// 设置当前用户ID
/// @param userId 当前用户ID
- (void)setCurrentUserId:(NSString *)userId;

/// 清除所有存储数组
- (void)clearAllStates;

/// 2MG成功回调
- (NSString *)handleMGSuccess;

/// 2MG失败回调
- (NSString *)handleMGFailure;

#pragma mark - 获取gamePlayerStateMap中最新的一个状态
/// 获取用户加入状态
- (BOOL)isPlayerIn:(NSString *)userId;
/// 获取用户是否在准备中
- (BOOL)isPlayerIsReady:(NSString *)userId;
/// 获取用户是否在游戏中
- (BOOL)isPlayerIsPlaying:(NSString *)userId;
/// 获取用户是否在队长
- (BOOL)isPlayerIsCaptain:(NSString *)userId;
/// 获取用户是否在在绘画
- (BOOL)isPlayerPaining:(NSString *)userId;

#pragma mark - 获取是否存在gamePlayerStateMap中 （用于判断用户是否在游戏里了）
/// 获取用户是否已经加入了游戏
- (BOOL)isPlayerInGame:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
