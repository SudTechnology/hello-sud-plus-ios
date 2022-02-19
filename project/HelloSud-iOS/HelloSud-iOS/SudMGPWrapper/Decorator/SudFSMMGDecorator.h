//
//  SudFSMMGManager.h
//  HelloSud-iOS
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
@interface SudFSMMGDecorator : NSObject
typedef NS_ENUM(NSInteger, GameStateType) {
    /// 空闲
    GameStateTypeLeisure = 0,
    /// loading
    GameStateTypeLoading = 1,
    /// playing
    GameStateTypePlaying = 2,
};

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


typedef void (^GameLoadSuccessBlock)(id<ISudFSTAPP> iSudFSTAPP);
@property (nonatomic, copy) GameLoadSuccessBlock gameLoadSuccessBlock;
/// 初始化
- (instancetype)init:(NSString *)roomID userID:(NSString *)userID language:(NSString *)language loadSuccess:(GameLoadSuccessBlock)loadSuccess;

/// 设置事件处理器
/// @param listener 事件处理实例
- (void)setEventListener:(id<SudFSMMGListener>)listener;

/// 更新code
/// @param code 新的code
- (void)updateGameCode:(NSString *)code;

/// 传输音频数据： 传入的音频数据必须是：PCM格式，采样率：16000， 采样位数：16， 声道数： MONO
- (void)pushAudio:(NSData *)data;

/// 游戏登录
/// 接入方客户端 调用 接入方服务端 login 获取 短期令牌code
/// 参考文档时序图：sud-mgp-doc(https://github.com/SudTechnology/sud-mgp-doc)
- (void)login:(UIView *)rootView gameId:(int64_t)gameId code:(NSString *)code appID:(NSString *)appID appKey:(NSString *)appKey;

/// 退出游戏
- (void)logoutGame;


/// 清除所有存储数组
- (void)clearAllStates;

/// 2MG成功回调
- (NSString *)handleMGSuccess;

/// 2MG失败回调
- (NSString *)handleMGFailure;

/// 获取用户加入状态
- (BOOL)isPlayerIn:(NSString *)userId;
/// 获取用户是否在准备中
- (BOOL)isPlayerIsReady:(NSString *)userId;
/// 获取用户是否在游戏中
- (BOOL)isPlayerIsPlaying:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
