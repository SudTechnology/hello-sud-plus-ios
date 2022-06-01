//
// Created by kaniel on 2022/5/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "QSGameRoomViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 游戏房内处理游戏相关交互逻辑分类
@interface QSGameRoomViewController(Game) <SudFSMMGListener>

/// 一：创建SudMGPWrapper
- (void)createSudMGPWrapper;

/// 二：游戏登录
/// 接入方客户端 调用 接入方服务端 loginGame: 获取 短期令牌code
/// 参考文档时序图：sud-mgp-doc(https://github.com/SudTechnology/sud-mgp-doc)
/// 执行步骤：
/// 1. 请求业务服务接口获取游戏初始化SDK需要的code码<reqGameLoginWithSuccess>
/// 2. 初始化SudMGP SDK<SudMGP initSDK>
/// 3. 加载SudMGP SDK<SudMGP loadMG>
- (void)loginGame:(QSSudMGPLoadConfigModel *)configModel;

/// 三：退出游戏 销毁SudMGP SDK
- (void)logoutGame;

/// 接入方客户端调用接入方服务端获取短期令牌code（getCode）
/// { 接入方服务端仓库：https://github.com/SudTechnology/hello-sud-java }
/// @param success 成功回调
/// @param fail 错误回调
- (void)reqGameLogin:(NSString *)userId success:(void (^)(NSString *code, NSError *error, int retCode))success fail:(ErrorBlock)fail;

@end

NS_ASSUME_NONNULL_END
