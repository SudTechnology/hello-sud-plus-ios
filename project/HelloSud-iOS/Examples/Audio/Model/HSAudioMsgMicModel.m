//
//  HSAudioMsgMicModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "HSAudioMsgMicModel.h"

@implementation HSAudioMsgMicModel
/// 构建消息
/// @param micIndex micIndex description
+ (instancetype)makeUpMicMsgWithMicIndex:(NSInteger)micIndex {
    HSAudioMsgMicModel *m = HSAudioMsgMicModel.new;
    [m configBaseInfoWithCmd:CMD_UP_MIC_NTF];
    return m;
}

/// 构建下麦消息
/// @param micIndex micIndex description
+ (instancetype)makeDownMicMsgWithMicIndex:(NSInteger)micIndex {
    HSAudioMsgMicModel *m = HSAudioMsgMicModel.new;
    [m configBaseInfoWithCmd:CMD_DOWN_MIC_NTF];
    return m;
}
@end
