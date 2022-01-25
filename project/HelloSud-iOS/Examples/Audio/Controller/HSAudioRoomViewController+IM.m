//
//  HSAudioRoomViewController+IM.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "HSAudioRoomViewController+IM.h"

@implementation HSAudioRoomViewController(IM)

/// 发送消息
/// @param msg 消息体
/// @param isAddToShow 是否公屏展示
- (void)sendMsg:(HSAudioMsgBaseModel *)msg isAddToShow:(BOOL)isAddToShow {
    NSString *command = [[NSString alloc]initWithData:[msg mj_JSONData] encoding:NSUTF8StringEncoding];
    NSLog(@"send content:%@", command);
    [MediaAudioEngineManager.shared.audioEngine sendCommand:command roomID:self.roomID result:^(int errorCode) {
        NSLog(@"send result:%d", errorCode);
    }];
    if (isAddToShow) {
        [self addMsg:msg];
    }
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
    HSAudioMsgBaseModel *msgModel = nil;
    switch (cmd) {
        case CMD_PUBLIC_MSG_NTF:{
            // 公屏消息
            msgModel = [HSAudioMsgTextModel mj_objectWithKeyValues:command];
        }
            break;
        case CMD_PUBLIC_SEND_GIFT_NTF:{
            // 礼物消息
            msgModel = [HSAudioMsgGiftModel mj_objectWithKeyValues:command];
        }
            break;
        case CMD_UP_MIC_NTF:{
            // 上麦消息
            msgModel = [HSAudioMsgMicModel mj_objectWithKeyValues:command];
        }
            break;
        case CMD_DOWN_MIC_NTF:{
            // 下麦消息
            msgModel = [HSAudioMsgMicModel mj_objectWithKeyValues:command];
        }
            break;
        default:
//        {
//            // 无法解析消息
//            HSAudioMsgTextModel *textModel = HSAudioMsgTextModel.new;
//            textModel.content = @"无法显示该消息，请升级最新版本";
//            msgModel = textModel;
//        }
            break;
    }
    if (msgModel) {
        [self addMsg:msgModel];
    }
}
@end
