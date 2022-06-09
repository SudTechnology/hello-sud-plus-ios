//
// Created by kaniel on 2022/5/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "QSGameRoomViewController+Game.h"
#import "HttpRequest.h"

@implementation QSGameRoomViewController (Game)


#pragma mark =======初始化 登录 加载 游戏=======

/// 一：创建SudMGPWrapper
- (void)createSudMGPWrapper {
    // 构建SudMGPWrapper实例
    self.sudFSTAPPDecorator = [[SudFSTAPPDecorator alloc] init];
    self.sudFSMMGDecorator = [[SudFSMMGDecorator alloc] init];
    // 设置游戏回调监听
    [self.sudFSMMGDecorator setEventListener:self];
}

/// 二：游戏登录
/// 接入方客户端 调用 接入方服务端 loginGame: 获取 短期令牌code
/// 参考文档时序图：sud-mgp-doc(https://github.com/SudTechnology/sud-mgp-doc)
/// 执行步骤：
/// 1. 请求业务服务接口获取游戏初始化SDK需要的code码<reqGameLoginWithSuccess>
/// 2. 初始化SudMGP SDK<SudMGP initSDK>
/// 3. 加载SudMGP SDK<SudMGP loadMG>
- (void)loginGame:(QSSudMGPLoadConfigModel *)configModel {
    NSString *appID = SUDMGP_APP_ID;
    NSString *appKey = SUDMGP_APP_KEY;
    if (appID.length == 0 || appKey.length == 0) {
        [ToastUtil show:@"Game appID or appKey is empty"];
        return;
    }
    WeakSelf
    // 1. 请求业务服务接口获取游戏初始化SDK需要的code码<reqGameLoginWithSuccess>
    [self reqGameLogin:configModel.userId success:^(NSString *code, NSError *error, int retCode) {
        [weakSelf initSudMGPSDK:configModel code:code];
    }             fail:^(NSError *error) {
        [ToastUtil show:error.debugDescription];
    }];
}

/// 三：退出游戏 销毁SudMGP SDK
- (void)logoutGame {
    // 销毁游戏
    [self.sudFSMMGDecorator clearAllStates];
    [self.sudFSTAPPDecorator destroyMG];
}

/// 业务服务接口获取游戏授权code码
/// @param success 成功回调
/// @param fail 错误回调
- (void)reqGameLogin:(NSString *)userId success:(void (^)(NSString *code, NSError *error, int retCode))success fail:(ErrorBlock)fail {

    if (userId.length == 0) {
        if (fail) {
            fail([NSError errorWithDomain:nil code:-1 userInfo:@{NSDebugDescriptionErrorKey: @"参数错误"}]);
        }
        NSLog(@"reqGameLogin: 用户ID不能为空");
        return;
    }
    NSDictionary *dicParam = @{@"user_id": userId};
    [HttpRequest postRequestWithApi:SUDMGP_GAME_LOGIN_URL param:dicParam success:^(NSDictionary *rootDict) {

        NSDictionary *dic = [rootDict objectForKey:@"data"];
        /// 这里的code用于登录游戏sdk服务器
        NSString *code = [dic objectForKey:@"code"];
        int retCode = (int) [[dic objectForKey:@"ret_code"] longValue];
        success(code, nil, retCode);

    }                       failure:^(NSError *error) {
        NSLog(@"reqGameLogin: login game server error:%@", error.debugDescription);
        if (fail) {
            fail(error);
        }
    }];
}

/// 初始化游戏SudMDP SDK
- (void)initSudMGPSDK:(QSSudMGPLoadConfigModel *)configModel code:(NSString *)code {

    WeakSelf
    // 确保初始化前不存在已加载的游戏 保证SudMGP initSDK前，销毁SudMGP
    [self logoutGame];
    if (configModel.gameId <= 0) {
        NSLog(@"initSudMGPSDK: 游戏ID为空，无法加载游戏:%@, currentRoomID:%@", @(configModel.gameId), configModel.roomId);
        return;
    }
    // 2. 初始化SudMGP SDK<SudMGP initSDK>
    [SudMGP initSDK:SUDMGP_APP_ID
             appKey:SUDMGP_APP_KEY
          isTestEnv:GAME_TEST_ENV
           listener:^(int retCode, const NSString *retMsg) {

               if (retCode != 0) {
                   /// 初始化失败, 可根据业务重试
                   NSLog(@"ISudFSMMG:initGameSDKWithAppID:初始化sdk失败 :%@", retMsg);
                   return;
               }
               NSLog(@"ISudFSMMG:initGameSDKWithAppID:初始化游戏SDK成功");
               // 加载游戏SDK
               [weakSelf loadGame:configModel code:code];
           }];
}

/// 加载游戏MG
/// @param configModel 配置model
- (void)loadGame:(QSSudMGPLoadConfigModel *)configModel code:(NSString *)code {

    NSLog(@"loadMG:userId:%@, gameRoomId:%@, gameId:%@", configModel.userId, configModel.roomId, @(configModel.gameId));
    if (configModel.userId.length == 0 ||
            configModel.roomId.length == 0 ||
            code.length == 0 ||
            configModel.language.length == 0 ||
            configModel.gameId <= 0) {

        NSLog(@"游戏加载参数存在异常空值，请检查参数loadMG传入参数");
        return;
    }
    // 必须配置当前登录用户
    [self.sudFSMMGDecorator setCurrentUserId:configModel.userId];
    // 3. 加载SudMGP SDK<SudMGP loadMG>，注：客户端必须持有iSudFSTAPP实例
    id <ISudFSTAPP> iSudFSTAPP = [SudMGP loadMG:configModel.userId
                                         roomId:configModel.roomId
                                           code:code
                                           mgId:configModel.gameId
                                       language:configModel.language
                                          fsmMG:self.sudFSMMGDecorator
                                       rootView:configModel.gameView];
    [self.sudFSTAPPDecorator setISudFSTAPP:iSudFSTAPP];
}

#pragma mark =======SudFSMMGListener 游戏SDK回调=======

#pragma mark 游戏生命周期回调

/// 游戏开始
- (void)onGameStarted {

}

/// 游戏销毁
- (void)onGameDestroyed {

}

/// 短期令牌code过期  【需要实现】
- (void)onExpireCode:(nonnull id <ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {

    // TODO: 需要开发者根据该游戏code码失效，刷新code码

    // 请求业务服务器刷新令牌 Code更新
    [self reqGameLogin:self.sudFSMMGDecorator.currentUserId success:^(NSString *code, NSError *error, int retCode) {
        // 调用游戏接口更新令牌
        [self.sudFSTAPPDecorator updateCode:code];
        // 回调成功结果
        [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
    }             fail:^(NSError *error) {
        NSLog(@"reqGameLogin error:%@", error.debugDescription);
        // 回调失败结果
        [handle failure:[self.sudFSMMGDecorator handleMGFailure]];
    }];
}

#pragma mark 启动游戏开发者针对游戏相关自定义配置

/// 获取游戏Config  【需要实现】
- (void)onGetGameCfg:(nonnull id <ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {

    // TODO: 需要开发者根据自己需求配置游戏相关功能展示

    // 默认游戏配置
    GameCfgModel *m = [GameCfgModel defaultCfgModel];
    [handle success:m.toJSON];
}

/// 获取游戏View信息  【需要实现】
- (void)onGetGameViewInfo:(nonnull id <ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {

    // TODO: 需要开发者根据自己需求配置游戏界面

    // 屏幕缩放比例，游戏内部采用px，需要开发者获取本设备比值 x 屏幕点数来获得真实px值设置相关字段中
    CGFloat scale = [[UIScreen mainScreen] nativeScale];
    // 屏幕尺寸
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    // 屏幕安全区
    UIEdgeInsets safeArea = [self safeAreaInsets];
    // 状态栏高度
    CGFloat statusBarHeight = safeArea.top == 0 ? 20 : safeArea.top;

    GameViewInfoModel *m = [[GameViewInfoModel alloc] init];
    // 游戏展示区域
    GameViewSize *viewSize = [[GameViewSize alloc] init];
    viewSize.width = screenSize.width * scale;
    viewSize.height = screenSize.height * scale;
    ViewGameRect *viewRect = [[ViewGameRect alloc] init];
    // 游戏内容布局安全区域，根据自身业务调整顶部间距
    // 顶部间距
    viewRect.top = (statusBarHeight + 80) * scale;
    // 左边
    viewRect.left = 0;
    // 右边
    viewRect.right = 0;
    // 底部安全区域
    viewRect.bottom = (safeArea.bottom + 100) * scale;

    m.ret_code = 0;
    m.ret_msg = @"success";
    m.view_size = viewSize;
    m.view_game_rect = viewRect;
    [handle success:m.toJSON];
}

#pragma mark 游戏相关事件状态回调通知

/// 游戏: 准备按钮点击状态   MG_COMMON_SELF_CLICK_READY_BTN
- (void)onGameMGCommonSelfClickReadyBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickReadyBtn *)model {
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 游戏: 结算界面再来一局按钮点击状态   MG_COMMON_SELF_CLICK_GAME_SETTLE_AGAIN_BTN
- (void)onGameMGCommonSelfClickGameSettleAgainBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickGameSettleAgainBtn *)model {
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 游戏: 开始游戏按钮点击状态   MG_COMMON_SELF_CLICK_START_BTN
- (void)onGameMGCommonSelfClickStartBtn:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonSelfClickStartBtn *)model {
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 通用状态-游戏
/// 游戏: 公屏消息状态    MG_COMMON_PUBLIC_MESSAGE
- (void)onGameMGCommonPublicMessage:(id <ISudFSMStateHandle>)handle model:(MGCommonPublicMessageModel *)model {
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 游戏: 关键词状态    MG_COMMON_KEY_WORD_TO_HIT
- (void)onGameMGCommonKeyWordToHit:(id <ISudFSMStateHandle>)handle model:(MGCommonKeyWrodToHitModel *)model {

    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 游戏: 游戏状态   MG_COMMON_GAME_STATE
- (void)onGameMGCommonGameState:(id <ISudFSMStateHandle>)handle model:(MGCommonGameState *)model {
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 游戏: ASR状态(开启和关闭语音识别状态   MG_COMMON_GAME_ASR
- (void)onGameMGCommonGameASR:(id <ISudFSMStateHandle>)handle model:(MGCommonGameASRModel *)model {
    /// 语音采集 || 停止采集
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 玩家状态变化
/// 玩家: 加入状态  MG_COMMON_PLAYER_IN
- (void)onPlayerMGCommonPlayerIn:(id <ISudFSMStateHandle>)handle userId:(NSString *)userId model:(MGCommonPlayerInModel *)model {
    [self handleCommonPlayerJoin:model userId:userId];

    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 玩家: 准备状态  MG_COMMON_PLAYER_READY
- (void)onPlayerMGCommonPlayerReady:(id <ISudFSMStateHandle>)handle userId:(NSString *)userId model:(MGCommonPlayerReadyModel *)model {

    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 玩家: 队长状态  MG_COMMON_PLAYER_CAPTAIN
- (void)onPlayerMGCommonPlayerCaptain:(id <ISudFSMStateHandle>)handle userId:(NSString *)userId model:(MGCommonPlayerCaptainModel *)model {

    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 玩家: 游戏状态  MG_COMMON_PLAYER_PLAYING
- (void)onPlayerMGCommonPlayerPlaying:(id <ISudFSMStateHandle>)handle userId:(NSString *)userId model:(MGCommonPlayerPlayingModel *)model {
    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 你画我猜: 作画中状态  MG_DG_PAINTING
- (void)onPlayerMGDGPainting:(nonnull id <ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId model:(MGDGPaintingModel *)model {

    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 游戏: 麦克风状态   MG_COMMON_GAME_SELF_MICROPHONE
- (void)onGameMGCommonGameSelfMicrophone:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSelfMicrophone *)model {

    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

/// 游戏: 耳机（听筒，扬声器）状态   MG_COMMON_GAME_SELF_HEADEPHONE
- (void)onGameMGCommonGameSelfHeadphone:(nonnull id <ISudFSMStateHandle>)handle model:(MGCommonGameSelfHeadphone *)model {

    [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
}

#pragma mark ======= 执行游戏状态方法, 用户业务相关逻辑 =======

/// 设备安全区
-(UIEdgeInsets)safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return [[[UIApplication sharedApplication] keyWindow] safeAreaInsets];
    } else {
        // Fallback on earlier versions
    }
    return UIEdgeInsetsZero;
}

/// 加入状态处理
- (void)handleCommonPlayerJoin:(MGCommonPlayerInModel *)model userId:(NSString *)userId {
    [self updateGamePersons:self.sudFSMMGDecorator.onlineUserIdList.count];
}

@end

