//
//  RoomCmdUpMicModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "RoomCmdOneOneInfoModel.h"

@interface RoomCmdOneOneInfoModel(){
    NSAttributedString *_attrContent;
}

@end

@implementation RoomCmdOneOneInfoModel

/// 构建消息
/// @param micIndex micIndex description
+ (instancetype)makeModelWithDuration:(NSInteger)duration {
    RoomCmdOneOneInfoModel *m = RoomCmdOneOneInfoModel.new;
    m.duration = duration;
    [m configBaseInfoWithCmd:CMD_ONEONE_INFO_RESP];
    return m;
}

@end
