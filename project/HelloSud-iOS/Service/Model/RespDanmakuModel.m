//
//  RespDanmakuModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/16.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RespDanmakuModel.h"

@interface DanmakuCallWarcraftModel() {
    CGFloat cellWidth_;
}
@end

@implementation DanmakuCallWarcraftModel
- (CGFloat)cellWidth {
    if (cellWidth_ <= 0) {
        cellWidth_ = 106;
        if (self.warcraftImageList.count > 2) {
            cellWidth_ += (self.warcraftImageList.count - 2) * 40;
        }
    }
    return cellWidth_;
}
@end

@implementation DanmakuJoinTeamModel

@end

@implementation RespDanmakuListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"callWarcraftInfoList": [DanmakuCallWarcraftModel class],
            @"joinTeamList": [DanmakuJoinTeamModel class]};
}
@end

@implementation RespDanmakuJoinTeamMsgNtf
@end