//
//  HSAudioMsgGiftModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "HSAudioMsgGiftModel.h"

@implementation HSAudioMsgGiftModel
- (NSString *)cellName {
    return @"HSRoomGiftTableViewCell";
}

/// 构建消息
/// @param giftID giftID description
/// @param giftCount giftCount description
/// @param toUser toUser description
+ (instancetype)makeMsgWithGiftID:(NSInteger)giftID giftCount:(NSInteger)giftCount toUser:(HSAudioUserModel *)toUser {
    HSAudioMsgGiftModel *m = HSAudioMsgGiftModel.new;
    [m configBaseInfoWithCmd:CMD_PUBLIC_SEND_GIFT_NTF];
    m.giftID = giftID;
    m.giftCount = giftCount;
    m.toUser = toUser;
    return m;
}
@end
