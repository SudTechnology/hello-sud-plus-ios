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
#import "TicketService.h"

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

/// 登录服务
@property (nonatomic, strong)LoginService *login;
/// 房间场景服务
@property (nonatomic, strong)AudioRoomService *audioRoom;
/// 门票场景服务
@property (nonatomic, strong)TicketService *ticket;

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
@end

NS_ASSUME_NONNULL_END
