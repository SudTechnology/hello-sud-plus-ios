//
//  RoomCmdChatTextModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "RoomCmdChatTextModel.h"

@interface RoomCmdChatTextModel () {
    NSAttributedString *_attrContent;
}

@end

@implementation RoomCmdChatTextModel
/// 构建消息
/// @param content 消息内容
+ (instancetype)makeMsg:(NSString *)content {
    RoomCmdChatTextModel *m = RoomCmdChatTextModel.new;
    [m configBaseInfoWithCmd:CMD_CHAT_TEXT_NOTIFY];
    m.content = content;
    return m;
}

- (NSString *)cellName {
    return @"HSRoomTextTableViewCell";
}

- (void)refreshAttrContent:(void (^)(void))completed {
    if (_hiddeHeadIcon || self.sendUser.icon.length == 0) {
        if (completed) completed();
        return;
    }
    WeakSelf
    [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:self.sendUser.icon] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [weakSelf generateAttrContent:image];
        if (completed) completed();
    }];
}

- (NSAttributedString *)generateAttrContent:(UIImage *)image {
    NSString *name = self.sendUser.name;
    NSString *content = self.content;
    UIImage *iconImage = image;
    if (iconImage) {
        iconImage = [iconImage dt_circleImage];
    } else {
        iconImage = [[UIImage alloc]init];
    }
    NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(16, 16) alignToFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
    NSMutableAttributedString *attrName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：", name]];
    attrName.yy_lineSpacing = 6;
    attrName.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrName.yy_color = [UIColor dt_colorWithHexString:@"#8FE5F6" alpha:1];
    NSMutableAttributedString *attrMsg = [[NSMutableAttributedString alloc] initWithString:content];
    attrMsg.yy_lineSpacing = 6;
    attrMsg.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrMsg.yy_color = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
    if (!_hiddeHeadIcon) {
        [attrName insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:0];
        [attrName insertAttributedString:attrIcon atIndex:0];
    }
    [attrName appendAttributedString:attrMsg];
    _attrContent = attrName;
    return attrName;
}


- (CGFloat)caculateHeight {
    CGFloat h = [super caculateHeight];
    CGFloat yMargin = 3;
    h += yMargin * 2;
    NSMutableAttributedString *attrName = [self generateAttrContent:[UIImage imageNamed:@"login_sud_icon"]];
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(MAX_CELL_CONTENT_WIDTH - 8, CGFLOAT_MAX) text:attrName];
    if (layout) {
        h += layout.textBoundingSize.height;
    }
    return h;
}

- (NSAttributedString *)attrContent {
    return _attrContent;
}
@end
