//
//  AudioRoomViewController+IM.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "AudioRoomViewController+IM.h"

@implementation AudioRoomViewController(IM)

/// 发送消息
/// @param msg 消息体
/// @param isAddToShow 是否公屏展示
- (void)sendMsg:(RoomBaseCMDModel *)msg isAddToShow:(BOOL)isAddToShow {
    NSString *command = [[NSString alloc]initWithData:[msg mj_JSONData] encoding:NSUTF8StringEncoding];
    NSLog(@"send content:%@", command);
    [AudioEngineFactory.shared.audioEngine sendCommand:command roomID:self.roomID result:^(int errorCode) {
        NSLog(@"send result:%d", errorCode);
    }];
    [self addMsg:msg isShowOnScreen:isAddToShow];
    /// Game - 发送文本命中
    if ([msg isKindOfClass:RoomCmdChatTextModel.class]) {
        RoomCmdChatTextModel *m = (RoomCmdChatTextModel *)msg;
        [self gameKeyWordHiting: m.content];
    } else if ([msg isKindOfClass:RoomCmdUpMicModel.class]) {
        RoomCmdUpMicModel *m = (RoomCmdUpMicModel *)msg;
        if (m.cmd == CMD_UP_MIC_NOTIFY) {
            [self joinGame];
        } else if (m.cmd == CMD_DOWN_MIC_NOTIFY) {
            [self exitGame];
        }
    }
}

/// 发送进房消息
- (void)sendEnterRoomMsg {
    self.isEnteredRoom = YES;
    AudioMsgSystemModel *msg = [AudioMsgSystemModel makeMsg:[NSString stringWithFormat:@"%@ 进入了房间", AppService.shared.loginUserInfo.name]];
    [msg configBaseInfoWithCmd:CMD_ENTER_ROOM_NOTIFY];
    [self sendMsg:msg isAddToShow:YES];
}

/// 接收引擎回调回来消息响应
- (void)onIMRecvCustomCommand:(NSString *)command fromUser:(MediaUser *)fromUser roomID:(NSString *)roomID {
    NSLog(@"recv command:\nroom:%@\nuserID:%@\nnickname:%@,content:%@", roomID, fromUser.userID,fromUser.nickname, command);
    [self handleCommand:command user:fromUser.userID roomID:roomID];
}


/// 处理收到房间信令
/// @param command 指令内容
/// @param userID 发送者
/// @param roomID 房间号
- (void)handleCommand:(NSString *)command user:(NSString *)userID roomID:(NSString *)roomID {
    if (command.length == 0) {
        NSLog(@"recv content is empty.");
        return;
    }
    NSData *data = [command dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"parse json err:%@", error.debugDescription);
        return;
    }
    NSInteger cmd = [dic[@"cmd"] integerValue];
    RoomBaseCMDModel *msgModel = nil;
    BOOL isShowOnScreen = YES;
    switch (cmd) {
        case CMD_CHAT_TEXT_NOTIFY:{
            // 公屏消息
            RoomCmdChatTextModel *msgTextModel = [RoomCmdChatTextModel fromJSON:command];
            msgModel = msgTextModel;
        }
            break;
        case CMD_SEND_GIFT_NOTIFY:{
            // 礼物消息
            msgModel = [RoomCmdSendGiftModel fromJSON:command];
        }
            break;
        case CMD_UP_MIC_NOTIFY:{
            // 上麦消息
            msgModel = [RoomCmdUpMicModel fromJSON:command];
            isShowOnScreen = NO;
        }
            break;
        case CMD_DOWN_MIC_NOTIFY:{
            // 下麦消息
            msgModel = [RoomCmdUpMicModel fromJSON:command];
            isShowOnScreen = NO;
        }
            break;
        case CMD_CHANGE_GAME_NOTIFY: {
            // 游戏切换
            RoomCmdChangeGameModel *m = [RoomCmdChangeGameModel fromJSON:command];
            [self handleGameChange:m.gameID];
        }
            break;
            
        case CMD_ENTER_ROOM_NOTIFY: {
            // 进入房间
            AudioMsgSystemModel *m = [AudioMsgSystemModel fromJSON:command];
            [m updateContent:[NSString stringWithFormat:@"%@ 进入了房间", m.sendUser.name]];
            msgModel = m;
        }
            break;
        default:
        {
            // 无法解析消息
            RoomCmdChatTextModel *textModel = RoomCmdChatTextModel.new;
            textModel.content = [NSString stringWithFormat:@"无法显示该消息，请升级最新版本,cmd:%ld", cmd];
            msgModel = textModel;
        }
            break;
    }
    if (msgModel) {
        [self addMsg:msgModel isShowOnScreen:isShowOnScreen];
    }
}


#pragma mark - 业务处理
/// 加入游戏
- (void)joinGame {
    if (self.roomType == HSAudio) {
        return;
    }
    
    if (![self.sudFSMMGDecorator isPlayerIn:AppService.shared.loginUserInfo.userID]) {
        if (self.sudFSMMGDecorator.gameStateType == GameStateTypeLeisure && !self.sudFSMMGDecorator.isInGame) {
            /// 上麦，就是加入游戏
            [self.sudFSTAPPDecorator notifyAppComonSelfIn:YES seatIndex:-1 isSeatRandom:true teamId:1];
        }
    }
}

/// 退出游戏
- (void)exitGame {
    if (self.roomType == HSAudio) {
        return;
    }
    
    if (self.sudFSMMGDecorator.isReady) {
        /// 如果已经准备先退出准备状态
        [self.sudFSTAPPDecorator notifyAppComonSetReady:false];
    }
    /// 下麦，就是退出游戏
    [self.sudFSTAPPDecorator notifyAppComonSelfIn:NO seatIndex:-1 isSeatRandom:true teamId:1];
}

/// 你画我猜命中
- (void)gameKeyWordHiting:(NSString *)content {
    if (self.roomType == HSAudio) {
        return;
    }
    if (self.sudFSMMGDecorator.isHitBomb) {
        if ([self isPureInt: content]) {
            /// 关键词命中
            [self.sudFSTAPPDecorator notifyAppComonDrawTextHit:false keyWord:@"" text:content];
        }
        return;
    }
    if (self.sudFSMMGDecorator.keyWordHiting == YES && [content isEqualToString:self.sudFSMMGDecorator.drawKeyWord]) {
        /// 关键词命中
        [self.sudFSTAPPDecorator notifyAppComonDrawTextHit:true keyWord:self.sudFSMMGDecorator.drawKeyWord text:self.sudFSMMGDecorator.drawKeyWord];
    }
}

- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

@end
