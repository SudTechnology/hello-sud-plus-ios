//
//  RoomCmdUpMicModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "RoomCmdUpMicModel.h"

@interface RoomCmdUpMicModel(){
    NSAttributedString *_attrContent;
}

@end

@implementation RoomCmdUpMicModel

/// 构建消息
/// @param micIndex micIndex description
+ (instancetype)makeUpMicMsgWithMicIndex:(NSInteger)micIndex {
    RoomCmdUpMicModel *m = RoomCmdUpMicModel.new;
    m.micIndex = micIndex;
    [m configBaseInfoWithCmd:CMD_UP_MIC_NOTIFY];
    return m;
}

/// 构建下麦消息
/// @param micIndex micIndex description
+ (instancetype)makeDownMicMsgWithMicIndex:(NSInteger)micIndex {
    RoomCmdUpMicModel *m = RoomCmdUpMicModel.new;
    m.micIndex = micIndex;
    [m configBaseInfoWithCmd:CMD_DOWN_MIC_NOTIFY];
    return m;
}

- (NSString *)cellName {
    return @"RoomSystemTableViewCell";
}

- (void)refreshAttrContent:(void (^)(void))completed {
    if (self.sendUser.icon.length == 0) {
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
    NSString *content = self.cmd == CMD_UP_MIC_NOTIFY ? [NSString stringWithFormat:NSString.dt_up_mic, self.micIndex]  : NSString.dt_down_mic;
    UIImage *iconImage = image;
    if (iconImage) {
        iconImage = [iconImage dt_circleImage];
    } else {
        iconImage = [UIImage imageNamed:@"default_head"];
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
    [attrIcon appendAttributedString:attrName];
    [attrIcon appendAttributedString:attrMsg];
    _attrContent = attrIcon;
    return attrName;
}

- (CGFloat)caculateHeight {
    CGFloat h = [super caculateHeight];
    CGFloat yMargin = 3;
    h += yMargin * 2;
    NSMutableAttributedString *attrIcon = [self generateAttrContent:UIImage.new];
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(MAX_CELL_CONTENT_WIDTH - 8, CGFLOAT_MAX) text:attrIcon];
    if (layout) {
        h += layout.textBoundingSize.height;
    }
    return h;
}

- (NSAttributedString *)attrContent {
    return _attrContent;
}
@end
