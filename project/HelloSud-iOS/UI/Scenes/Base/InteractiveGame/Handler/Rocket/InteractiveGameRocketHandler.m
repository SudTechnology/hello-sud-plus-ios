//
// Created by kaniel on 2022/12/5.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "InteractiveGameRocketHandler.h"
#import "RocketSelectAnchorView.h"
#import "InteractiveGameManager.h"

@interface InteractiveGameRocketHandler ()

@property(nonatomic, strong) NSMutableArray *rocketQueue;



@property (nonatomic, copy)void(^rocketEffectBlock)(BOOL show);
@end

@implementation InteractiveGameRocketHandler

- (void)hideGameView {
    [super hideGameView];
    if (self.isGamePrepareOK) {
        [self.sudFSTAPPDecorator notifyAppCustomRocketHideGame];
    }
}

/// 播放火箭
/// @param jsonData
- (void)playRocket:(NSString *)jsonData {
    [self.rocketQueue addObject:jsonData];
    [self checkIfCanPlay];
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

/// 设置动效回调
/// @param rocketEffectBlock
- (void)setupRocketEffectBlock:(void(^)(BOOL show))rocketEffectBlock {
    self.rocketEffectBlock = rocketEffectBlock;
}


- (NSMutableArray *)rocketQueue {
    if (!_rocketQueue) {
        _rocketQueue = NSMutableArray.new;
    }
    return _rocketQueue;
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
        dicExData[@"userOrderIdsMap"] = @{micModel.user.userID: orderId};
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
    [self.interactiveGameManager destoryGame];
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
    [self.interactiveGameManager destoryGame];
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
- (void)onGameMGCustomRocketSetClickRect:(nonnull id <ISudFSMStateHandle>)handle model:(MGCustomGameSetClickRect *)model {
    self.gameClickRect = model;
}
@end
