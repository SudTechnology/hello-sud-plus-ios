//
//  AudioRoomViewController+IM.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "BaseSceneViewController+IM.h"
#import "IMRoomManager.h"

@implementation BaseSceneViewController (IM)

/// 发送消息
/// @param msg 消息体
/// @param isAddToShow 是否公屏展示
- (void)sendMsg:(RoomBaseCMDModel *)msg isAddToShow:(BOOL)isAddToShow finished:(void (^)(int errorCode))finished {
    msg.sendUser.roomID = self.roomID;
    NSData *jsonData = [msg mj_JSONData];
    NSString *command = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    DDLogDebug(@"send content:%@, bytes:%@", command, @(jsonData.length));
    WeakSelf
    [self onWillSendMsg:msg shouldSend:^(BOOL shouldSend) {
        if (!shouldSend) {
            return;
        }
        [AudioEngineFactory.shared.audioEngine sendCommand:command listener:^(int errorCode) {
            DDLogDebug(@"sendCommand result:%d", errorCode);
//            if (errorCode != 0) {
//                [ToastUtil show:[NSString stringWithFormat:@"RTC send msg error(%@)", @(errorCode)]];
//            }
            [weakSelf onDidSendMsg:msg];
            if (finished) finished(errorCode);
        }];
        [self addMsg:msg isShowOnScreen:isAddToShow];
        /// Game - 发送文本命中
        if ([msg isKindOfClass:RoomCmdChatTextModel.class]) {
            RoomCmdChatTextModel *m = (RoomCmdChatTextModel *) msg;
            [self handleGameKeywordHitting:m.content];
        } else if ([msg isKindOfClass:RoomCmdUpMicModel.class]) {
            BOOL isMe = [AppService.shared.login.loginUserInfo isMeByUserID:msg.sendUser.userID];
            if (self.isEnteredRoom && isMe) {
                RoomCmdUpMicModel *m = (RoomCmdUpMicModel *) msg;
                if (m.cmd == CMD_UP_MIC_NOTIFY) {
                    if ([self isAutoJoinGame]) {
                        [self notifyGameToJoin];
                    }
                } else if (m.cmd == CMD_DOWN_MIC_NOTIFY) {
                    [self notifyGameToExit];
                }
            }
        }
    }];


}

/// 发送跨房消息
/// @param msg 消息体
/// @param isAddToShow 是否公屏展示
- (void)sendCrossRoomMsg:(RoomBaseCMDModel *)msg toRoomId:(NSString *)toRoomId isAddToShow:(BOOL)isAddToShow finished:(void (^)(NSInteger errCode))finished {
    if (toRoomId.length == 0) {
        [ToastUtil show:NSString.dt_room_cross_id_not_empty];
        return;
    }
    msg.sendUser.roomID = self.roomID;
    NSString *command = [[NSString alloc] initWithData:[msg mj_JSONData] encoding:NSUTF8StringEncoding];
    DDLogDebug(@"send cross content, my roomId:%@, toRoomId:%@ \ncontent:%@", self.roomID, toRoomId, command);
    WeakSelf
    [self onWillSendMsg:msg shouldSend:^(BOOL shouldSend) {
        if (!shouldSend) {
            return;
        }
        [IMRoomManager.sharedInstance sendXRoomCommand:toRoomId command:command listener:^(int errorCode) {
            DDLogDebug(@"send cross room:%@ msg result:%d", toRoomId, errorCode);
            [weakSelf onDidSendMsg:msg];
            if (finished) {
                finished(errorCode);
            }
        }];
        [self addMsg:msg isShowOnScreen:isAddToShow];
    }];

}

/// 发送进房消息
- (void)sendEnterRoomMsg {
    self.isEnteredRoom = YES;
    AudioMsgSystemModel *msg = [AudioMsgSystemModel makeMsg:[NSString stringWithFormat:@"%@ %@", AppService.shared.login.loginUserInfo.name, NSString.dt_enter_room_tip]];
    [msg configBaseInfoWithCmd:CMD_ENTER_ROOM_NOTIFY];
    /// 公屏添加消息
    [self sendMsg:msg isAddToShow:YES finished:nil];
    /// 连接成功后拉取麦位列表
    [self reqMicList];
}

/// 接收引擎回调回来消息响应
- (void)onRecvCommand:(NSString *)fromUserID command:(NSString *)command {
    DDLogDebug(@"❤️ recv command:\nuserID:%@\ncontent:%@", fromUserID, command);
    [self handleCommand:command user:fromUserID];
}

/// 接收聊天室消息回调
/// @param fromRoomID  消息的房间 ID
/// @param fromUserID  消息的用户 ID
/// @param command     消息的内容
- (void)onRecvXRoomCommand:(NSString *)fromRoomID fromUserID:(NSString *)fromUserID command:(NSString *)command {
    DDLogDebug(@"❤️ recv cross room:%@\ncommand:\nuserID:%@\ncontent:%@", fromRoomID, fromUserID, command);
    [self handleCommand:command user:fromUserID];
}


/// 处理收到房间信令
/// @param command 指令内容
/// @param userID 发送者
- (void)handleCommand:(NSString *)command user:(NSString *)userID {
    if (command.length == 0) {
        DDLogDebug(@"❌recv content is empty.");
        return;
    }
    NSData *data = [command dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        DDLogDebug(@"parse json err:%@", error.debugDescription);
        return;
    }
    NSInteger cmd = [dic[@"cmd"] integerValue];
    RoomBaseCMDModel *msgModel = nil;
    BOOL isShowOnScreen = YES;
    switch (cmd) {
        case CMD_CHAT_TEXT_NOTIFY: {
            // 公屏消息
            RoomCmdChatTextModel *msgTextModel = [RoomCmdChatTextModel fromJSON:command];
            msgModel = msgTextModel;
        }
            break;
        case CMD_SEND_GIFT_NOTIFY: {
            // 礼物消息
            msgModel = [RoomCmdSendGiftModel fromJSON:command];
        }
            break;
        case CMD_UP_MIC_NOTIFY: {
            // 上麦消息
            msgModel = [RoomCmdUpMicModel fromJSON:command];
            isShowOnScreen = NO;
        }
            break;
        case CMD_DOWN_MIC_NOTIFY: {
            // 下麦消息
            msgModel = [RoomCmdUpMicModel fromJSON:command];
            isShowOnScreen = NO;
        }
            break;
        case CMD_CHANGE_GAME_NOTIFY: {
            // 游戏切换
            RoomCmdChangeGameModel *m = [RoomCmdChangeGameModel fromJSON:command];
            HSGameItem *gameItem = [AppService.shared getGameInfoByGameId:m.gameID tabType:self.tabType];
            if (gameItem) {
                self.loadType = gameItem.loadType;
            }
            
            [self switchToGame:m.gameID];
        }
            break;

        case CMD_ENTER_ROOM_NOTIFY: {
            // 进入房间
            AudioMsgSystemModel *m = [AudioMsgSystemModel fromJSON:command];
            [m updateContent:[NSString stringWithFormat:@"%@ %@", m.sendUser.name, NSString.dt_enter_room_tip]];
            msgModel = m;
        }
            break;
        case CMD_KICK_OUT_ROOM: {
            // 踢出房间
            RoomCmdKickoutRoomModel *m = [RoomCmdKickoutRoomModel fromJSON:command];
            msgModel = m;
            isShowOnScreen = NO;
        }
            break;
            
        case CMD_CHAT_MEDIA_NOTIFY: {
            // 公屏消息V2
            RoomCmdChatTextModelV2 *m = [RoomCmdChatTextModelV2 fromJSON:command];
            msgModel = m;
        }
            break;


        default:
            // 业务指令
            [self handleBusyCommand:cmd command:command];
            break;
    }
    if (msgModel) {
        [self addMsg:msgModel isShowOnScreen:isShowOnScreen];
    }
}

/// 处理cmd - 用于重写
- (void)handleBusyCommand:(NSInteger)cmd command:(NSString *)command {
    // 无法解析消息
    DDLogWarn(@"无法解析消息 cmd：%@, content:%@", @(cmd), command);
    //    RoomCmdChatTextModel *textModel = RoomCmdChatTextModel.new;
    //    textModel.content = [NSString stringWithFormat:NSString.dt_room_unable_display_msg, cmd];
    //    [self addMsg:textModel isShowOnScreen:YES];
    switch (cmd) {
        case CMD_GAME_MONOPOLY_CARD_GIFT_NOTIFY: {
            // 进入房间
            RoomGameMonopolyCardGiftNotifyCMDModel *m = [RoomGameMonopolyCardGiftNotifyCMDModel fromServerJSON:command];
            
            for (NSNumber *n in m.receiverUidList) {
                
                AppCommonGameShowMonopolyCardEffect *cardEffect = AppCommonGameShowMonopolyCardEffect.new;
                cardEffect.fromUid =[NSString stringWithFormat:@"%@", @(m.senderUid)];
                cardEffect.type = m.type;
                cardEffect.toUid = [NSString stringWithFormat:@"%@", n];
                cardEffect.count = m.amount;
                [self.gameEventHandler.sudFSTAPPDecorator notifyAppCommonGameShowMonopolyCardEffect:cardEffect];
                
            }
            
        }
            break;
        case CMD_GAME_PROPS_CARD_GIFT_NOTIFY: {
            // 进入房间
            RoomGamePropsCardGiftNotifyCMDModel *m = [RoomGamePropsCardGiftNotifyCMDModel fromServerJSON:command];
            
            for (NSNumber *n in m.receiverUidList) {
                
                AppCommonGamePlayerPropsCardsEffect *cardEffect = AppCommonGamePlayerPropsCardsEffect.new;
                cardEffect.fromUid = [NSString stringWithFormat:@"%@", @(m.senderUid)];
                cardEffect.paid_events_type = m.paidEventType;
                cardEffect.toUid = [NSString stringWithFormat:@"%@", n];
                cardEffect.count = m.amount;
                [self.gameEventHandler.sudFSTAPPDecorator notifyAppCommonGamePlayerPropsCardsEffect:cardEffect];
            }
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 业务处理

/// 加入游戏
- (void)notifyGameToJoin {

    if (![self.gameEventHandler.sudFSMMGDecorator isPlayerIn:AppService.shared.login.loginUserInfo.userID]) {
        if (self.gameEventHandler.sudFSMMGDecorator.gameStateType == GameStateTypeLeisure && !self.gameEventHandler.sudFSMMGDecorator.isInGame) {
            /// 上麦，就是加入游戏
            [self.gameEventHandler.sudFSTAPPDecorator notifyAppComonSelfIn:YES seatIndex:-1 isSeatRandom:true teamId:1];
        }
    }
}

/// 退出游戏
- (void)notifyGameToExit {

    if (![self.gameEventHandler.sudFSMMGDecorator isPlayerInGame:AppService.shared.login.loginUserInfo.userID]) {
        return;
    }
    if (self.gameEventHandler.sudFSMMGDecorator.isReady) {
        /// 如果已经准备先退出准备状态
        [self.gameEventHandler.sudFSTAPPDecorator notifyAppCommonSelfReady:false];
    }
    /// 下麦，就是退出游戏
    [self.gameEventHandler.sudFSTAPPDecorator notifyAppComonSelfIn:NO seatIndex:-1 isSeatRandom:true teamId:1];
}

/// 你画我猜命中
- (void)handleGameKeywordHitting:(NSString *)content {

    if (self.gameEventHandler.sudFSMMGDecorator.isHitBomb) {
        if ([self isPureInt:content]) {
            /// 关键词命中
            [self.gameEventHandler.sudFSTAPPDecorator notifyAppComonDrawTextHit:false keyWord:@"" text:content];
        }
        return;
    }
    if (self.gameEventHandler.sudFSMMGDecorator.keyWordHiting == YES && [content isEqualToString:self.gameEventHandler.sudFSMMGDecorator.drawKeyWord]) {
        /// 关键词命中
        [self.gameEventHandler.sudFSTAPPDecorator notifyAppComonDrawTextHit:true keyWord:self.gameEventHandler.sudFSMMGDecorator.drawKeyWord text:self.gameEventHandler.sudFSMMGDecorator.drawKeyWord];
    }
}

- (BOOL)isPureInt:(NSString *)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

@end
