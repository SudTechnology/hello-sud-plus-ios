//
//  AppService.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import <UIKit/UIKit.h>
#import "AccountUserModel.h"
#import "ConfigModel.h"

@class AudioConfigModel;

extern NSString *const kRtcNameZego;
extern NSString *const kRtcNameAgora;
extern NSString *const kRtcNameRongCloud;
extern NSString *const kRtcNameCommEase;
extern NSString *const kRtcNameVoicEngine;
extern NSString *const kRtcNameAlibabaCloud;
extern NSString *const kRtcNameTencentCloud;

NS_ASSUME_NONNULL_BEGIN

/// APP管理模块
@interface AppService : NSObject
/// 登录用户信息
@property(nonatomic, strong, readonly) AccountUserModel *loginUserInfo;
/// token
@property(nonatomic, copy, readonly) NSString *token;
/// 配置信息
@property(nonatomic, strong) ConfigModel *configModel;
/// 所有游戏列表
@property(nonatomic, strong) NSArray <HSGameItem *> *gameList;
/// 所有sceneList游戏列表
@property(nonatomic, strong) NSArray <HSSceneModel *> *sceneList;
/// 所有支持rtc厂商列表
@property(nonatomic, strong) NSArray <HSConfigContent *> *rtcList;
/// 选中rtc厂商类型
@property(nonatomic, copy, readonly) NSString *rtcType;
/// rtc配置
@property(nonatomic, strong) AudioConfigModel *rtcConfigModel;

+ (instancetype)shared;

/// 保持用户信息
- (void)saveLoginUserInfo;

/// 是否同意登录协议
@property(nonatomic, assign, readonly) BOOL isAgreement;

/// 保存是否同意协议
- (void)saveAgreement;

/// 是否已经登录
@property(nonatomic, assign, readonly) BOOL isLogin;
/// 是否已经刷新token
@property(nonatomic, assign) BOOL isRefreshedToken;

/// 保存是否同意协议
- (void)saveIsLogin;

/// 随机名字
- (NSString *)randomUserName;

/// 设置请求header
- (void)setupNetWorkHeader;

/// 保存token
- (void)saveToken:(NSString *)token;

/// 刷新token
- (void)refreshToken;

/// 切换RTC厂商
/// @param rtcType 对应rtc厂商类型
- (void)switchRtcType:(NSString *)rtcType;

/// 通过gameID获取游戏总人数
/// @param gameID 游戏ID
- (NSInteger)getTotalGameCountWithGameID:(NSInteger)gameID;
@end

NS_ASSUME_NONNULL_END
