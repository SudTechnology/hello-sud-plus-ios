//
//  RoomCmdSendGiftModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "RoomCmdSendGiftModel.h"

@interface RoomCmdSendGiftModel () {
    NSAttributedString *_attrContent;
    AudioUserModel *_toShowUser;
}

@end

@implementation RoomCmdSendGiftModel

/// 设置展示接收方这是支持多个人的礼物消息
- (void)setShowToUser:(AudioUserModel *)toUser {
    _toShowUser = toUser;
}

- (AudioUserModel *)toUser {
    return _toShowUser;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"toUserList": AudioUserModel.class};
}

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

    RoomCmdSendGiftModel *temp = [self makeMsgWithGiftID:giftID giftCount:giftCount toUserList:toUser ? @[toUser] : @[]];
    [temp setShowToUser:toUser];
    return temp;
}

/// 构建消息
/// @param giftID giftID description
/// @param giftCount giftCount description
/// @param toUserList toUserList description
+ (instancetype)makeMsgWithGiftID:(NSInteger)giftID giftCount:(NSInteger)giftCount toUserList:(NSArray<AudioUserModel *> *)toUserList {
    RoomCmdSendGiftModel *m = RoomCmdSendGiftModel.new;
    [m configBaseInfoWithCmd:CMD_SEND_GIFT_NOTIFY];
    m.giftID = giftID;
    m.giftCount = giftCount;
    m.toUserList = toUserList;
    return m;
}

/// 获取礼物model
- (GiftModel *)getGiftModel {
    GiftModel *giftModel = nil;
    if (self.type == 1) {
        // 后台礼物
        giftModel = [[GiftModel alloc] init];
        if (self.animationUrl) {
            NSURL *url = [[NSURL alloc] initWithString:self.animationUrl];
            giftModel.animateType = url.pathExtension;
        }
        giftModel.animateURL = self.animationUrl;
        giftModel.giftID = self.giftID;
        giftModel.giftName = self.giftName;
        giftModel.giftURL = self.giftUrl;
        giftModel.smallGiftURL = self.giftUrl;
    } else {
        // 内置
        giftModel = [GiftService.shared giftByID:self.giftID];
    }
    return giftModel;
}

- (CGFloat)caculateHeight {
    CGFloat h = [super caculateHeight];
    CGFloat yMargin = 3;
    h += yMargin * 2;

    NSString *sendUserName = self.sendUser.name;
    NSString *toUserName = _toShowUser.name;
    NSString *giftName = @"";
    if (!sendUserName) {
        sendUserName = @"";
    }
    if (!toUserName) {
        toUserName = @"";
    }
    GiftModel *giftModel = [self getGiftModel];
    if (giftModel) {
        giftName = giftModel.giftName;
    }
    NSMutableAttributedString *attrSendName = [[NSMutableAttributedString alloc] initWithString:sendUserName];
    attrSendName.yy_lineSpacing = 6;
    attrSendName.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrSendName.yy_color = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];

    NSMutableAttributedString *attrSend = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ", NSString.dt_send]];
    attrSend.yy_lineSpacing = 6;
    attrSend.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrSend.yy_color = [UIColor dt_colorWithHexString:@"#f6ff00" alpha:1];
    NSMutableAttributedString *attrGetName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   %@", toUserName, giftName]];
    attrGetName.yy_lineSpacing = 6;
    attrGetName.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrGetName.yy_color = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
    NSURL *giftIconURL = nil;
    if (giftModel.smallGiftURL.length > 0) {
        giftIconURL = giftModel.smallGiftURL.dt_toURL;
    }
    UIImage *iconImage = giftIconURL ? [UIImage imageWithData:[NSData dataWithContentsOfURL:giftIconURL]] : [UIImage new];
    NSMutableAttributedString *attrGift = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(24, 20) alignToFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];

    NSMutableAttributedString *attrGiftCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"x%ld", self.giftCount]];
    attrGiftCount.yy_lineSpacing = 6;
    attrGiftCount.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrGiftCount.yy_color = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];

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

// 根据用户列表产生展示的礼物消息
- (NSArray<RoomCmdSendGiftModel *> *)getShowGiftMsgModelListByUserList {

    NSMutableArray *giftShowList = NSMutableArray.new;
    NSDictionary *temp = [self mj_JSONObject];
    for (AudioUserModel *audioUserModel in self.toUserList) {
        RoomCmdSendGiftModel *m = [RoomCmdSendGiftModel mj_objectWithKeyValues:temp];
        [m setShowToUser:audioUserModel];
        [giftShowList addObject:m];
    }
    return giftShowList;
}
@end
