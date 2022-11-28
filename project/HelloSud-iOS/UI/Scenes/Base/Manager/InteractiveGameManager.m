//
// Created by kaniel on 2022/11/4.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "InteractiveGameManager.h"

#import <SudMGP/ISudCfg.h>
#import "RocketSelectAnchorView.h"
#import "RocketLoadingView.h"

@interface InteractiveGameManager ()
/// ISudFSTAPP
@property(nonatomic, strong) SudFSMMGDecorator *sudFSMMGDecorator;
/// app To 游戏 管理类
@property(nonatomic, strong) SudFSTAPPDecorator *sudFSTAPPDecorator;
/// 游戏ID
@property(nonatomic, assign) int64_t gameId;
/// 游戏加载主view
@property(nonatomic, strong) UIView *gameView;
@property(nonatomic, strong) NSString *roomID;
@property(nonatomic, strong) NSString *gameRoomID;
@property(nonatomic, strong) NSString *language;
@property(nonatomic, strong) RocketLoadingView *rocketLoadingView;
@property(nonatomic, strong) NSMutableArray *rocketQueue;
/// 是否游戏已经准备完毕
@property(nonatomic, assign) BOOL isGamePrepareOK;
/// 是否需要展示游戏
@property(nonatomic, assign) BOOL isShowGame;
/// 是否需要展示游戏主界面
@property(nonatomic, assign) BOOL showMainView;
/// 是否加载了游戏
@property(nonatomic, assign) BOOL isLoadedGame;
/// 游戏设置点击区域
@property(nonatomic, strong) MGCustomRocketSetClickRect *rocketSetClickRect;
@end

@implementation InteractiveGameManager


- (instancetype)init {

    if (self = [super init]) {
        [self initSudFSMMG];
    }
    return self;
}

/// 初始化sud
- (void)initSudFSMMG {
    self.language = [SettingsService getCurLanguageLocale];
    self.sudFSTAPPDecorator = [[SudFSTAPPDecorator alloc] init];
    self.sudFSMMGDecorator = [[SudFSMMGDecorator alloc] init];
    [self.sudFSMMGDecorator setCurrentUserId:AppService.shared.login.loginUserInfo.userID];
    [self.sudFSMMGDecorator setEventListener:self];
    [self hanldeInitSudFSMMG];
}

- (void)hanldeInitSudFSMMG {

}


/// 加载互动游戏 火箭
/// @param gameId
/// @param gameView
- (void)loadInteractiveGame:(int64_t)gameId roomId:(NSString *)roomId gameView:(UIView *)gameView {
    self.roomID = roomId;
    self.gameRoomID = roomId;
    self.gameId = gameId;
    self.gameView = gameView;
    self.isLoadedGame = YES;
    [self showLoadingView:gameView];
    [self loginGame];
}

- (void)clearLoadGameState {
    self.isLoadedGame = NO;
}

- (BOOL)isExistGame {
    return self.isLoadedGame;
}

/// 播放火箭
/// @param jsonData
- (void)playRocket:(NSString *)jsonData {
    [self.rocketQueue addObject:jsonData];
    [self checkIfCanPlay];
}

/// 检测点是否在游戏可点击区域，如果游戏没有指定，则默认游戏需要响应该点，返回YES;否则按照游戏指定区域判断是否在区域内，在则返回YES,不在则返回NO
/// @param clickPoint 点击事件点
/// @return
- (BOOL)checkIfPointInGameClickRect:(CGPoint)clickPoint {
    if (!self.rocketSetClickRect || self.rocketSetClickRect.list.count == 0) {
        return YES;
    }
    CGFloat scale = 1;
    if (UIScreen.mainScreen.nativeScale > 0) {
        scale = UIScreen.mainScreen.nativeScale;
    }

    for (RocketSetClickRectItem *item in self.rocketSetClickRect.list) {
        CGRect rect = CGRectMake(item.x / scale, item.y / scale, item.width / scale, item.height / scale);
        if (CGRectContainsPoint(rect, clickPoint)) {
            return YES;
        }
    }
    return NO;
}

/// 礼物面板发送火箭
/// @param giftModel
/// @param toMicList
- (void)sendRocketGift:(GiftModel *)giftModel toMicList:(NSArray<AudioRoomMicModel *> *)toMicList finished:(void (^)(BOOL success))finished {

    WeakSelf
    MGCustomRocketFireModel *model = MGCustomRocketFireModel.new;
    [RocketService reqRocketFireModel:model
                            toMicList:toMicList
                               sucess:^(BaseRespModel *resp) {
                                   [weakSelf handleSendRocketInfo:resp userList:toMicList triggerFromGame:NO];
                                   if (finished) {
                                       finished(YES);
                                   }
                               } failure:^(NSError *error) {
                if (finished) {
                    finished(NO);
                }
            }];
}

/// 通知游戏关闭火箭动效
- (void)notifyGameCloseRocketEffect {
    [self.sudFSTAPPDecorator notifyAppCustomRocketClosePlayEffect];
}

/// 通知游戏火箭加速
- (void)notifyGameFlyRocket {
    [self.sudFSTAPPDecorator notifyAppCustomRocketFlyClick];
}

- (void)checkIfCanPlay {
    if (self.rocketQueue.count == 0) {
        DDLogDebug(@"no rocket to play rocket");
        return;
    }
    if (!self.isGamePrepareOK) {
        DDLogDebug(@"game is not prepare to play rocket");
        return;
    }
    for (NSString *str in self.rocketQueue) {

        DDLogDebug(@"rocket queue:%@", str);
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        AppCustomRocketPlayModelListModel *listModel = [RocketService decodeModel:AppCustomRocketPlayModelListModel.class FromDic:dicData];
        NSDictionary *dicOrderMaps = dicData[@"userOrderIdsMap"];
        if (dicOrderMaps) {
            NSArray *orderList = dicOrderMaps.allValues;
            for (NSString *order in orderList) {
                listModel.orderId = order;
                DDLogDebug(@"notify game play rocket order:%@", order);
                // 给每个主播播放火箭动效
                [self.sudFSTAPPDecorator notifyAppCustomRocketPlayModelList:listModel];
            }
        } else {
            DDLogError(@"dicOrderMaps is empty");
        }
    }
    [self.rocketQueue removeAllObjects];
}

/// 展示游戏视图
- (void)showGameView:(BOOL)showMainView {
    self.gameView.hidden = NO;
    self.isShowGame = YES;
    self.showMainView = showMainView;
    if (self.isGamePrepareOK && showMainView) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketShowGame];
    }
}

/// 隐藏游戏视图
- (void)hideGameView {
    // 暂时不隐藏，由游戏隐藏自己的界面就行，穿透游戏区域
//    self.gameView.hidden = YES;
    self.isShowGame = NO;
    self.showMainView = NO;
    if (self.isGamePrepareOK) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketHideGame];
    }
}

/// 销毁互动游戏
- (void)destoryGame {
    self.gameView.hidden = YES;
    [self logoutGame];
    [self clearLoadGameState];
}

- (void)showLoadingView:(UIView *)gameView {
    [gameView.superview insertSubview:self.rocketLoadingView aboveSubview:gameView];
    [self.rocketLoadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.rocketLoadingView show];
}

- (void)closeLoadingView {
    if (_rocketLoadingView) {
        [_rocketLoadingView close];
        [_rocketLoadingView removeFromSuperview];
        _rocketLoadingView = nil;
    }
}

- (RocketLoadingView *)rocketLoadingView {
    if (!_rocketLoadingView) {
        _rocketLoadingView = RocketLoadingView.new;
    }
    return _rocketLoadingView;
}

- (NSMutableArray *)rocketQueue {
    if (!_rocketQueue) {
        _rocketQueue = NSMutableArray.new;
    }
    return _rocketQueue;
}

#pragma mark =======SudFSMMGListener=======

/// 游戏开始
- (void)onGameStarted {
    DDLogDebug(@"onGameStarted");
    [self closeLoadingView];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)onGameDestroyed {
    DDLogDebug(@"onGameDestroyed");
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

/// 获取游戏View信息  【需要实现】
- (void)onGetGameViewInfo:(nonnull id <ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    CGFloat scale = [[UIScreen mainScreen] nativeScale];
    GameViewInfoModel *m = [[GameViewInfoModel alloc] init];
    m.view_size.width = kScreenWidth * scale;
    m.view_size.height = kScreenHeight * scale;
    m.view_game_rect.top = (kStatusBarHeight + 120) * scale;
    m.view_game_rect.left = 0;
    m.view_game_rect.bottom = (kAppSafeBottom + 150) * scale;
    m.view_game_rect.right = 0;

    m.ret_code = 0;
    m.ret_msg = @"success";
    [handle success:m.mj_JSONString];
}

/// 短期令牌code过期  【需要实现】
- (void)onExpireCode:(nonnull id <ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    // 请求业务服务器刷新令牌 Code更新
    [GameService.shared reqGameLoginWithSuccess:^(RespGameInfoModel *_Nonnull gameInfo) {
        // 调用游戏接口更新令牌
        [self.sudFSTAPPDecorator updateCode:gameInfo.code];
        // 回调成功结果
        [handle success:[self.sudFSMMGDecorator handleMGSuccess]];
    }                                      fail:^(NSError *error) {
        [ToastUtil show:error.debugDescription];
        // 回调失败结果
        [handle failure:[self.sudFSMMGDecorator handleMGFailure]];
    }];
}

/// 获取游戏Config  【需要实现】
- (void)onGetGameCfg:(nonnull id <ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    GameCfgModel *m = [GameCfgModel defaultCfgModel];
    m.ui.lobby_players.hide = true;
    m.ui.nft_avatar.hide = NO;
    m.ui.game_opening.hide = NO;
    m.ui.game_mvp.hide = NO;
    [handle success:[m mj_JSONString]];
}

#pragma mark =======登录 加载 游戏=======

/// 游戏登录
/// 接入方客户端 调用 接入方服务端 loginGame: 获取 短期令牌code
/// 参考文档时序图：sud-mgp-doc(https://github.com/SudTechnology/sud-mgp-doc)
- (void)loginGame {
    NSString *appID = AppService.shared.configModel.sudCfg.appId;
    NSString *appKey = AppService.shared.configModel.sudCfg.appKey;
    if (appID.length == 0 || appKey.length == 0) {
        [ToastUtil show:@"Game appID or appKey is empty"];
        return;
    }
    WeakSelf
    [GameService.shared reqGameLoginWithSuccess:^(RespGameInfoModel *_Nonnull gameInfo) {
        [weakSelf login:weakSelf.gameView gameId:weakSelf.gameId code:gameInfo.code appID:appID appKey:appKey];
    }                                      fail:^(NSError *error) {
        [ToastUtil show:error.debugDescription];
        [self clearLoadGameState];
    }];
}

/// 退出游戏
- (void)logoutGame {
    // 销毁游戏
    [self.sudFSTAPPDecorator destroyMG];
}


#pragma mark =======登录 加载 游戏=======

/// 游戏登录
/// 接入方客户端 调用 接入方服务端 loginGame: 获取 短期令牌code
/// 参考文档时序图：sud-mgp-doc(https://github.com/SudTechnology/sud-mgp-doc)
- (void)login:(UIView *)rootView gameId:(int64_t)gameId code:(NSString *)code appID:(NSString *)appID appKey:(NSString *)appKey {
    [self initSdk:rootView gameId:gameId code:code appID:appID appKey:appKey];
}

/// 加载游戏
- (void)initSdk:(UIView *)rootView gameId:(int64_t)gameId code:(NSString *)code appID:(NSString *)appID appKey:(NSString *)appKey {
    WeakSelf
    [self logoutGame];
    if (gameId <= 0) {
        DDLogDebug(@"游戏ID为空，无法加载游戏:%@, currentRoomID:%@, currentGameRoomID:%@", gameId, self.roomID, self.gameRoomID);
        [self clearLoadGameState];
        return;
    }
    BOOL isTest = false;
#if DEBUG
    [ISudAPPD e:HsAppPreferences.shared.gameEnvType];
    if (HsAppPreferences.shared.gameEnvType != HsGameEnvTypePro) {
        isTest = YES;
    }
#endif
    [[SudMGP getCfg] setShowCustomLoading:YES];
    [[SudMGP getCfg] setShowLoadingGameBg:NO];
    [SudMGP initSDK:appID appKey:appKey isTestEnv:isTest listener:^(int retCode, const NSString *retMsg) {
        if (retCode == 0) {
            DDLogInfo(@"ISudFSMMG:initGameSDKWithAppID:初始化游戏SDK成功");
            if (weakSelf) {
                // SudMGPSDK初始化成功 加载MG
                NSString *userID = AppService.shared.login.loginUserInfo.userID;
                NSString *roomID = weakSelf.gameRoomID;
                if (userID.length == 0 || roomID.length == 0 || code.length == 0) {
                    [ToastUtil show:NSString.dt_room_load_failed];
                    return;
                }
                DDLogInfo(@"loadGame:userId:%@, gameRoomId:%@, currentRoomId:%@, gameId:%@", userID, roomID, weakSelf.roomID, @(gameId));
                [weakSelf loadGame:userID roomId:roomID code:code mgId:gameId language:weakSelf.language fsmMG:weakSelf.sudFSMMGDecorator rootView:rootView];
            }
        } else {
            /// 初始化失败, 可根据业务重试
            DDLogError(@"ISudFSMMG:initGameSDKWithAppID:初始化sdk失败 :%@", retMsg);
            [self clearLoadGameState];
        }
    }];
}

/// 加载游戏MG
/// @param userId 用户唯一ID
/// @param roomId 房间ID
/// @param code 游戏登录code
/// @param mgId 游戏ID
/// @param language 支持简体"zh-CN "    繁体"zh-TW"    英语"en-US"   马来"ms-MY"
/// @param fsmMG 控制器
/// @param rootView 游戏根视图
- (void)loadGame:(NSString *)userId roomId:(NSString *)roomId code:(NSString *)code mgId:(int64_t)mgId language:(NSString *)language fsmMG:(id)fsmMG rootView:(UIView *)rootView {


    id <ISudFSTAPP> iSudFSTAPP = [SudMGP loadMG:userId roomId:roomId code:code mgId:mgId language:language fsmMG:self.sudFSMMGDecorator rootView:rootView];
    [self.sudFSTAPPDecorator setISudFSTAPP:iSudFSTAPP];
}

#pragma mark - Rocket MG state callback

/// 礼物配置文件(火箭) MG_CUSTOM_ROCKET_CONFIG
- (void)onGameMGCustomRocketConfig:(nonnull id <ISudFSMStateHandle>)handle {

    /// 查询火箭配置信息
    [RocketService reqRocketConfigWithFinished:^(AppCustomRocketConfigModel *respModel) {
        /// 将配置信息返回给游戏
        [self.sudFSTAPPDecorator notifyAppCustomRocketConfig:respModel];
    }];
}

/// 拥有模型列表(火箭) MG_CUSTOM_ROCKET_MODEL_LIST
- (void)onGameMGCustomRocketModelList:(nonnull id <ISudFSMStateHandle>)handle {
    [RocketService reqRocketModelListWithFinished:^(AppCustomRocketModelListModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketModelList:respModel];
    }];
}


/// 拥有组件列表(火箭) MG_CUSTOM_ROCKET_COMPONENT_LIST
- (void)onGameMGCustomRocketComponentList:(nonnull id <ISudFSMStateHandle>)handle {
    [RocketService reqRocketComponentListWithFinished:^(AppCustomRocketComponentListModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketComponentList:respModel];
    }];
}

/// 获取用户信息(火箭) MG_CUSTOM_ROCKET_USER_INFO
- (void)onGameMGCustomRocketUserInfo:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketUserInfo *)model {
    [UserService.shared asyncCacheUserInfo:model.userIdList forceRefresh:YES finished:^{
        AppCustomRocketUserInfoModel *resp = AppCustomRocketUserInfoModel.new;
        NSMutableArray *userList = NSMutableArray.new;
        for (NSString *t in model.userIdList) {

            HSUserInfoModel *userInfoModel = [UserService.shared getCacheUserInfo:t.longLongValue];
            if (!userInfoModel) {
                continue;
            }
            RocketUserInfoItemModel *itemModel = RocketUserInfoItemModel.new;
            itemModel.nickname = userInfoModel.nickname;
            itemModel.sex = [userInfoModel.gender isEqualToString:@"male"] ? 0 : 1;
            itemModel.url = userInfoModel.avatar;
            itemModel.userId = [NSString stringWithFormat:@"%@", userInfoModel.userId];
            [userList addObject:itemModel];
        }
        resp.userList = userList;
        [self.sudFSTAPPDecorator notifyAppCustomRocketUserInfo:resp];
    }];
}

/// 订单记录列表(火箭) MG_CUSTOM_ROCKET_ORDER_RECORD_LIST
- (void)onGameMGCustomRocketOrderRecordList:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketOrderRecordList *)model {
    [RocketService reqRocketOrderRecordList:model.pageIndex pageSize:model.pageSize finished:^(AppCustomRocketOrderRecordListModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketOrderRecordList:respModel];
    }];
}

/// 展馆内列表(火箭) MG_CUSTOM_ROCKET_ROOM_RECORD_LIST
- (void)onGameMGCustomRocketRoomRecordList:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketRoomRecordList *)model {
    [RocketService reqRocketRoomRecordList:model.pageIndex pageSize:model.pageSize roomId:kAudioRoomService.currentRoomVC.roomID.integerValue finished:^(AppCustomRocketRoomRecordListModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketRoomRecordList:respModel];
    }];
}

/// 展馆内玩家送出记录(火箭) MG_CUSTOM_ROCKET_USER_RECORD_LIST
- (void)onGameMGCustomRocketUserRecordList:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketUserRecordList *)model {
    [RocketService reqRocketUserRecordList:model.pageIndex pageSize:model.pageSize userId:model.userId finished:^(AppCustomRocketUserRecordListModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketUserRecordList:respModel];
    }];
}

/// 设置默认位置(火箭) MG_CUSTOM_ROCKET_SET_DEFAULT_MODEL
- (void)onGameMGCustomRocketSetDefaultSeat:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketSetDefaultSeat *)model {
    [RocketService reqRocketSetDefaultSeat:model finished:^(AppCustomRocketSetDefaultSeatModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketSetDefaultSeat:respModel];
    }];
}

/// 动态计算一键发送价格(火箭) MG_CUSTOM_ROCKET_DYNAMIC_FIRE_PRICE
- (void)onGameMGCustomRocketDynamicFirePrice:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketDynamicFirePrice *)model {
    [RocketService reqRocketDynamicFirePrice:model finished:^(AppCustomRocketDynamicFirePriceModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketDynamicFirePrice:respModel];
    }];
}

/// 一键发送(火箭) MG_CUSTOM_ROCKET_FIRE_MODEL
- (void)onGameMGCustomRocketFireModel:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketFireModel *)model {

    WeakSelf
    RocketSelectAnchorView *v = RocketSelectAnchorView.new;
    v.confirmBlock = ^(NSArray<AudioRoomMicModel *> *toMicList) {
        [RocketService reqRocketFireModel:model
                                toMicList:toMicList
                                   sucess:^(BaseRespModel *resp) {

                                       // 响应给游戏
                                       AppCustomRocketFireModel *respModel = AppCustomRocketFireModel.new;
                                       [weakSelf.sudFSTAPPDecorator notifyAppCustomRocketFireModel:respModel];
                                       [weakSelf handleSendRocketInfo:resp userList:toMicList triggerFromGame:YES];

                                   } failure:^(NSError *error) {

                    AppCustomRocketFireModel *respModel = AppCustomRocketFireModel.new;
                    respModel.resultCode = error.code;
                    respModel.error = error.dt_errMsg;
                    [weakSelf.sudFSTAPPDecorator notifyAppCustomRocketFireModel:respModel];
                }];
    };
    [DTAlertView show:v rootView:nil clickToClose:YES showDefaultBackground:YES onCloseCallback:nil];

}

/// 处理火箭发送信息
- (void)handleSendRocketInfo:(BaseRespModel *)resp userList:(NSArray<AudioRoomMicModel *> *)userList triggerFromGame:(BOOL)triggerFromGame {
    [self sendGiftMsgForRoomUsers:userList resp:resp];
}

/// 发送火箭礼物消息给房间其它玩家
/// @param anchorUserList
/// @param resp
- (void)sendGiftMsgForRoomUsers:(NSArray<AudioRoomMicModel *> *)anchorUserList resp:(BaseRespModel *)resp {
    NSDictionary *dicOrderMaps = resp.srcData[@"userOrderIdsMap"];
    for (AudioRoomMicModel *micModel in anchorUserList) {
        AudioUserModel *user = micModel.user;
        if (!user) {
            continue;
        }
        id orderId = dicOrderMaps[micModel.user.userID];
        if (!orderId) {
            continue;
        }
        // 推送礼物信息给房间其余用户 拆分成单个
        NSMutableDictionary *dicExData = [[NSMutableDictionary alloc] initWithDictionary:resp.srcData];
        dicExData[@"userOrderIdsMap"] = @{micModel.user.userID:orderId};
        GiftModel *giftModel = [GiftService.shared giftByID:kRocketGiftID];
        AudioUserModel *toUser = user;
        RoomCmdSendGiftModel *giftMsg = [RoomCmdSendGiftModel makeMsgWithGiftID:giftModel.giftID giftCount:1 toUser:toUser];
        giftMsg.type = giftModel.type;
        giftMsg.giftName = giftModel.giftName;
        giftMsg.extData = [dicExData mj_JSONString];
        giftMsg.skillFee = YES;// 一键发射已经扣费，这里标识发送礼物时不再扣费
        // 指令内容可能超1024限制，改用跨房指令
        [kAudioRoomService.currentRoomVC sendCrossRoomMsg:giftMsg toRoomId:kAudioRoomService.currentRoomVC.roomID isAddToShow:YES finished:nil];
    }

}

/// 新组装模型(火箭) MG_CUSTOM_ROCKET_CREATE_MODEL
- (void)onGameMGCustomRocketCreateModel:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketCreateModel *)model {

    [RocketService reqRocketSaveCreateModel:model finished:^(AppCustomRocketCreateModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketCreateModel:respModel];
    }];
}

/// 更换组件(火箭) MG_CUSTOM_ROCKET_REPLACE_COMPONENT
- (void)onGameMGCustomRocketReplaceModel:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketReplaceModel *)model {
    [RocketService reqRocketReplaceModel:model finished:^(AppCustomRocketReplaceComponentModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketReplaceComponent:respModel];
    }];
}

/// 购买组件(火箭) MG_CUSTOM_ROCKET_BUY_COMPONENT
- (void)onGameMGCustomRocketBuyModel:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketBuyModel *)model {
    [RocketService reqRocketBuyModel:model finished:^(AppCustomRocketBuyComponentModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketBuyComponent:respModel];
    }];
}

/// 播放效果开始((火箭) MG_CUSTOM_ROCKET_PLAY_EFFECT_START
- (void)onGameMGCustomRocketPlayEffectStart:(nonnull id <ISudFSMStateHandle>)handle {
    DDLogDebug(@"mg：播放效果开始((火箭)");
    if (self.rocketEffectBlock) self.rocketEffectBlock(YES);
}

/// 播放效果完成(火箭) MG_CUSTOM_ROCKET_PLAY_EFFECT_FINISH
- (void)onGameMGCustomRocketPlayEffectFinish:(nonnull id <ISudFSMStateHandle>)handle {
    DDLogDebug(@"mg：播放效果完成(火箭) ");
    if (self.rocketEffectBlock) self.rocketEffectBlock(NO);
    [self destoryGame];
}

/// 验证签名合规((火箭) MG_CUSTOM_ROCKET_VERIFY_SIGN
- (void)onGameMGCustomRocketVerifySign:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketVerifySign *)model {

    [RocketService reqRocketVerifySign:model finished:^(AppCustomRocketVerifySignModel *respModel) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketVerifySign:respModel];
    }];
}

/// 上传icon(火箭) MG_CUSTOM_ROCKET_UPLOAD_MODEL_ICON
- (void)onGameMGCustomRocketUploadModelIcon:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketUploadModelIcon *)model {

    NSString *imagePath = [GiftService.shared saveRocketImage:model.data];
    if (imagePath) {
        /// 改变火箭礼物图片为截图
        GiftModel *giftModel = [GiftService.shared giftByID:kRocketGiftID];
        giftModel.smallGiftURL = imagePath;
        giftModel.giftURL = imagePath;
    }
    DDLogDebug(@"save rocket file path:%@", imagePath);
}

/// 前期准备完成((火箭) MG_CUSTOM_ROCKET_PREPARE_FINISH
- (void)onGameMGCustomRocketPrepareFinish:(nonnull id <ISudFSMStateHandle>)handle {
    DDLogDebug(@"mg：前期准备完成((火箭)");
    self.isGamePrepareOK = YES;
    [self closeLoadingView];
    if (self.isShowGame && self.showMainView) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketShowGame];
    }
    [self checkIfCanPlay];
}

/// 隐藏火箭主界面((火箭) MG_CUSTOM_ROCKET_HIDE_GAME_SCENE
- (void)onGameMGCustomRocketHideGameScene:(nonnull id <ISudFSMStateHandle>)handle {
    DDLogDebug(@"mg：隐藏火箭主界面((火箭)");
//    [self hideGameView];
    [self destoryGame];
}

/// 展示火箭主界面((火箭) MG_CUSTOM_ROCKET_SHOW_GAME_SCENE
- (void)onGameMGCustomRocketShowGameScene:(nonnull id <ISudFSMStateHandle>)handle {
    DDLogDebug(@"mg：显示火箭主界面((火箭)");
}

/// 点击锁住组件((火箭) MG_CUSTOM_ROCKET_CLICK_LOCK_COMPONENT
- (void)onGameMGCustomRocketClickLockComponent:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketClickLockComponent *)model {

    [DTAlertView showTextAlert:@"该商品锁定中，是否解锁？" sureText:NSString.dt_common_sure cancelText:NSString.dt_common_cancel onSureCallback:^{
        [DTAlertView close];
        [RocketService reqRocketUnlockComponent:model finished:^{
            AppCustomRocketUnlockComponent *respModel = AppCustomRocketUnlockComponent.new;
            respModel.componentId = model.componentId;
            respModel.type = model.type;
            [self.sudFSTAPPDecorator notifyAppCustomRocketUnlockComponent:respModel];
        }];
    }          onCloseCallback:^{
        [DTAlertView close];
    }];

}

/// 火箭的可点击区域((火箭) MG_CUSTOM_ROCKET_SET_CLICK_RECT
- (void)onGameMGCustomRocketSetClickRect:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomRocketSetClickRect *)model {
    self.rocketSetClickRect = model;
}
@end
