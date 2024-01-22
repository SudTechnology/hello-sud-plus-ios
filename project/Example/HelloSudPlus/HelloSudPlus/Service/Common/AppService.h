//
//  AppService.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import <UIKit/UIKit.h>
#import "AccountUserModel.h"
#import "ConfigModel.h"
#import "LoginService.h"
#import "AudioRoomService.h"
#import "TicketRoomService.h"
#import "PKRoomService.h"
#import "GuessRoomService.h"
#import "DanmakuRoomService.h"
#import "DiscoRoomService.h"
#import "LeagueRoomService.h"
#import "RocketService.h"
#import "CrossAppRoomService.h"
#import "BaseballService.h"
#import "Audio3dRoomService.h"

// 语音服务
#define kAudioRoomService ((AudioRoomService *)AppService.shared.scene)
// pk服务
#define kPKService ((PKRoomService *)AppService.shared.scene)
// 门票服务
#define kTicketService ((TicketRoomService *)AppService.shared.scene)
// 竞猜服务
#define kGuessService ((GuessRoomService *)AppService.shared.scene)
// 弹幕房间服务
#define kDanmakuRoomService ((DanmakuRoomService *)AppService.shared.scene)
// 蹦迪房间服务
#define kDiscoRoomService ((DiscoRoomService *)AppService.shared.scene)
// 蹦迪房间服务
#define kAudio3dRoomService ((Audio3dRoomService *)AppService.shared.scene)

@class AudioConfigModel;

/// RTC厂商类型key
extern NSString *const kRtcTypeZego;
extern NSString *const kRtcTypeAgora;
extern NSString *const kRtcTypeRongCloud;
extern NSString *const kRtcTypeCommEase;
extern NSString *const kRtcTypeVolcEngine;
extern NSString *const kRtcTypeAlibabaCloud;
extern NSString *const kRtcTypeTencentCloud;

#define APP_SERVICE [AppService shared]

NS_ASSUME_NONNULL_BEGIN

/// APP管理模块
@interface AppService : NSObject

/// 配置信息
@property(nonatomic, strong) ConfigModel *configModel;
/// 所有游戏列表
@property(nonatomic, strong)  NSArray <HSGameItem *> *gameList;

/// 所有sceneList游戏列表
@property(nonatomic, strong) NSArray <HSSceneModel *> *sceneList;

/// 选中rtc厂商类型
@property(nonatomic, copy, readonly) NSString *rtcType;
/// rtc配置
@property(nonatomic, strong) AudioConfigModel *rtcConfigModel;
/// 登录用户ID
@property(nonatomic, strong, readonly) NSString *loginUserID;
/// 登录服务
@property(nonatomic, strong) LoginService *login;
/// 场景服务
@property(nonatomic, strong) BaseSceneService *scene;
/// 更多竞猜头部数据列表缓存
@property(nonatomic, strong) NSArray <BaseModel *> *moreGuessHeaderArrayCache;
/// 是否已经展示过横屏提示
@property(nonatomic, assign) BOOL alreadyShowLandscapePopAlert;
/// 是否已经展示过横屏气泡指引提示
@property(nonatomic, assign) BOOL alreadyShowLandscapeBubbleTip;

+ (instancetype)shared;

- (void)prepare;

/// 是否同意登录协议
@property(nonatomic, assign, readonly) BOOL isAgreement;

/// 保存是否同意协议
- (void)saveAgreement;

/// 随机名字
- (NSString *)randomUserName;

/// 设置请求header
- (void)setupNetWorkHeader;

/// 切换RTC厂商
/// @param rtcType 对应rtc厂商类型
- (void)switchRtcType:(NSString *)rtcType;

/// 通过gameID获取游戏总人数
/// @param gameID 游戏ID
- (NSInteger)getTotalGameCountWithGameID:(NSInteger)gameID;

/// 登录成功请求配置信息
- (void)reqConfigData;

/// 请求版本更新
/// @param success
/// @param fail
- (void)reqAppUpdate:(RespModelBlock)success fail:(nullable ErrorStringBlock)fail;

/// 获取RTC厂商名称
/// @param rtcType rtc类型
- (NSString *)getRTCTypeName:(NSString *)rtcType;

/// 是否是相同rtc厂商
/// @param rtcConfig rtcConfig
/// @param rtcType rtcType
/// @return
- (BOOL)isSameRtc:(HSConfigContent *)rtcConfig rtcType:(NSString *)rtcType;

/// 获取游戏信息
/// @param gameId gameId
/// @return
- (HSGameItem *)getSceneGameInfo:(int64_t)gameId;

- (void)removeAllConfig;

/// 添加tab标签游戏数据
- (void)addGameListToTab:(NSInteger)tabId gameList:(NSArray *)gameList;

/// 获取对应标签游戏数据
- (nullable NSArray <HSGameItem *> *)getGameListByTab:(NSInteger)tabId;

/// 通过游戏ID获取游戏数据
/// - Parameter gameId: gameId description
- (nullable HSGameItem *)getGameInfoByGameId:(int64_t)gameId sceneType:(NSInteger)sceneType;
/// 是否支持视频
- (BOOL)isCurrentRtcSurpportVideo;
@end

NS_ASSUME_NONNULL_END
