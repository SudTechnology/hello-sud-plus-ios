//
// Created by kaniel on 2022/5/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "QuickStartViewController.h"
/// Model
#import "SudMGPWrapper.h"

NS_ASSUME_NONNULL_BEGIN

// TODO: 登录接入方服务器url
#define GAME_LOGIN_URL          @"https://mgp-hello.sudden.ltd/login/v3"

// TODO: 必须填写由SudMGP提供的appId 及 appKey
#define SUDMGP_APP_ID                  @"1461564080052506636"
#define SUDMGP_APP_KEY                 @"03pNxK2lEXsKiiwrBQ9GbH541Fk2Sfnc"

// TODO: 是否是测试环境,生产环境必须设置为NO
#if DEBUG
#define GAME_TEST_ENV    YES
#else
#define GAME_TEST_ENV    NO
#endif

/// 加载SudMGP SDK加载必须的业务参数
@interface SudMGPLoadConfigModel : NSObject
/// 游戏ID
@property (nonatomic, assign)int64_t gameId;
/// 房间ID
@property (nonatomic, strong)NSString * roomId;
/// 当前用户ID
@property (nonatomic, strong)NSString * userId;
/// 语言 支持简体"zh-CN "    繁体"zh-TW"    英语"en-US"   马来"ms-MY"
@property (nonatomic, strong)NSString * language;
/// 加载展示视图
@property (nonatomic, strong)UIView * gameView;
@end

#pragma mark =======QuickStartViewController (Game)=======

/// 游戏房内处理游戏相关交互逻辑分类
@interface QuickStartViewController(Game) <SudFSMMGListener>

/// SudFSMMGDecorator game -> app 辅助接收解析SudMGP SDK抛出的游戏回调事件、获取相关游戏状态模块
@property (nonatomic, strong) SudFSMMGDecorator *sudFSMMGDecorator;

/// SudFSTAPPDecorator app -> game 辅助APP操作游戏相关指令模块
@property (nonatomic, strong) SudFSTAPPDecorator *sudFSTAPPDecorator;

/// 一：创建SudMGPWrapper
- (void)createSudMGPWrapper;

/// 二：游戏登录
/// 接入方客户端 调用 接入方服务端 getCode: 获取 短期令牌code
/// 参考文档时序图：sud-mgp-doc(https://github.com/SudTechnology/sud-mgp-doc)
/// 执行步骤：
/// 1. 请求业务服务接口获取游戏初始化SDK需要的code码<getCode>
/// 2. 初始化SudMGP SDK<SudMGP initSDK>
/// 3. 加载SudMGP SDK<SudMGP loadMG>
- (void)loginGame:(SudMGPLoadConfigModel *)configModel;

/// 三：退出游戏 销毁SudMGP SDK
- (void)logoutGame;

/// 接入方客户端调用接入方服务端获取短期令牌code（getCode）
/// { 接入方服务端仓库：https://github.com/SudTechnology/hello-sud-java }
/// @param success 成功回调
/// @param fail 错误回调
- (void)getCode:(NSString *)userId success:(void (^)(NSString *code, NSError *error, int retCode))success fail:(void(^)(NSError *error))fail;
@end

NS_ASSUME_NONNULL_END
