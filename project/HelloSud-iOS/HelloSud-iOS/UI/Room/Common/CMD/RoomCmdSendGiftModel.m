//
//  RoomCmdSendGiftModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "RoomCmdSendGiftModel.h"

@interface RoomCmdSendGiftModel(){
    NSAttributedString *_attrContent;
}

@end

@implementation RoomCmdSendGiftModel
- (NSString *)cellName {
    return @"RoomGiftTableViewCell";
}

- (NSAttributedString *)attrContent {
    return _attrContent;
}

/// 构建消息
/// @param giftID giftID description
/// @param giftCount giftCount description
/// @param toUser toUser description
+ (instancetype)makeMsgWithGiftID:(NSInteger)giftID giftCount:(NSInteger)giftCount toUser:(AudioUserModel *)toUser {
    RoomCmdSendGiftModel *m = RoomCmdSendGiftModel.new;
    [m configBaseInfoWithCmd:CMD_SEND_GIFT_NOTIFY];
    m.giftID = giftID;
    m.giftCount = giftCount;
    m.toUser = toUser;
    return m;
}

- (CGFloat)caculateHeight {
    CGFloat h = [super caculateHeight];
    CGFloat yMargin = 3;
    h += yMargin * 2;
    
    NSString *sendUserName = self.sendUser.name;
    NSString *toUserName = self.toUser.name;
    NSString *giftName = @"";
    if (!sendUserName) {
        sendUserName = @"";
    }
    if (!toUserName) {
        toUserName = @"";
    }
    GiftModel *giftModel = [GiftManager.shared giftByID:self.giftID];
    if (giftModel) {
        giftName = giftModel.giftName;
    }
    NSMutableAttributedString *attrSendName = [[NSMutableAttributedString alloc] initWithString:sendUserName];
    attrSendName.yy_lineSpacing = 6;
    attrSendName.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrSendName.yy_color = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    
    NSMutableAttributedString *attrSend = [[NSMutableAttributedString alloc] initWithString:@" 送给 "];
    attrSend.yy_lineSpacing = 6;
    attrSend.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrSend.yy_color = [UIColor colorWithHexString:@"#AAAAAA" alpha:1];
    
    NSMutableAttributedString *attrGetName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   %@", toUserName, giftName]];
    attrGetName.yy_lineSpacing = 6;
    attrGetName.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrGetName.yy_color = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    
    UIImage *iconImage = giftModel.smallGiftURL.length > 0 ? [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:giftModel.smallGiftURL]]] : [UIImage new];
    NSMutableAttributedString *attrGift = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(24, 20) alignToFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
    
    NSMutableAttributedString *attrGiftCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"x%ld", self.giftCount]];
    attrGiftCount.yy_lineSpacing = 6;
    attrGiftCount.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrGiftCount.yy_color = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    
    [attrSendName appendAttributedString:attrSend];
    [attrSendName appendAttributedString:attrGetName];
    [attrSendName appendAttributedString:attrGift];
    [attrSendName appendAttributedString:attrGiftCount];
    _attrContent = attrSendName;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(MAX_CELL_CONTENT_WIDTH - 8, CGFLOAT_MAX) text:attrSendName];
    if (layout) {
        h += layout.textBoundingSize.height;
    }
    return h;
}
@end
