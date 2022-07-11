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


// 语音服务
#define kAudioRoomService ((AudioRoomService *)AppService.shared.scene)


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
@property(nonatomic, strong) NSArray <HSGameItem *> *gameList;
/// 所有sceneList游戏列表
@property(nonatomic, strong) NSArray <HSSceneModel *> *sceneList;

/// 选中rtc厂商类型
@property(nonatomic, copy, readonly) NSString *rtcType;
/// rtc配置
@property(nonatomic, strong) AudioConfigModel *rtcConfigModel;
/// 登录用户ID
@property (nonatomic, strong, readonly)NSString * loginUserID;
/// 登录服务
@property (nonatomic, strong)LoginService *login;
/// 场景服务
@property (nonatomic, strong)BaseSceneService *scene;
/// 更多竞猜头部数据列表缓存
@property(nonatomic, strong) NSArray <BaseModel *> *moreGuessHeaderArrayCache;
/// 是否已经展示过横屏提示
@property(nonatomic, assign) BOOL alreadyShowLandscapePopAlert;
/// 是否已经展示过横屏气泡指引提示
@property(nonatomic, assign) BOOL alreadyShowLandscapeBubbleTip;
/// 应用列表
@property(nonatomic, strong) NSArray<AppIDInfoModel *> *appIdList;
/// 当前AppId信息
@property(nonatomic, strong) AppIDInfoModel *currentAppIdModel;

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

/// 更新应用列表
/// @param appIdList 应用列表
- (void)updateAppIdList:(NSArray<AppIDInfoModel *> *)appIdList;

/// 缓存选中指定AppIdInfoModel
/// @param model <#model description#>
- (void)cacheAppIdInfoModel:(AppIDInfoModel *)model;
@end

NS_ASSUME_NONNULL_END
