//
//  HSAudioMsgTextModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "HSAudioMsgTextModel.h"

@implementation HSAudioMsgTextModel
- (NSString *)cellName {
    return @"HSRoomTextTableViewCell";
}

/// 构建消息
/// @param content 消息内容
+ (instancetype)makeMsg:(NSString *)content {
    HSAudioMsgTextModel *m = HSAudioMsgTextModel.new;
    [m configBaseInfoWithCmd:CMD_PUBLIC_MSG_NTF];
    m.content = content;
    return m;
}
@end
