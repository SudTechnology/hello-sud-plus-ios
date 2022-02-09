//
//  HSAudioMsgMicModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "HSAudioMsgMicModel.h"

@interface HSAudioMsgMicModel(){
    NSAttributedString *_attrContent;
}

@end

@implementation HSAudioMsgMicModel

/// 构建消息
/// @param micIndex micIndex description
+ (instancetype)makeUpMicMsgWithMicIndex:(NSInteger)micIndex {
    HSAudioMsgMicModel *m = HSAudioMsgMicModel.new;
    m.micIndex = micIndex;
    [m configBaseInfoWithCmd:CMD_UP_MIC_NTF];
    return m;
}

/// 构建下麦消息
/// @param micIndex micIndex description
+ (instancetype)makeDownMicMsgWithMicIndex:(NSInteger)micIndex {
    HSAudioMsgMicModel *m = HSAudioMsgMicModel.new;
    m.micIndex = micIndex;
    [m configBaseInfoWithCmd:CMD_DOWN_MIC_NTF];
    return m;
}

- (NSString *)cellName {
    return @"HSRoomSystemTableViewCell";
}

- (CGFloat)caculateHeight {
    CGFloat h = [super caculateHeight];
    CGFloat yMargin = 3;
    h += yMargin * 2;
    NSString *name = self.sendUser.name;
    NSString *content = self.cmd == CMD_UP_MIC_NTF ? [NSString stringWithFormat:@"上%ld号麦", self.micIndex]  : @"下麦";
    UIImage *iconImage = self.sendUser.icon.length > 0 ? [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.sendUser.icon]]] : [UIImage new];
    NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(16, 16) alignToFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
    NSMutableAttributedString *attrName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：", name]];
    attrName.yy_lineSpacing = 6;
    attrName.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrName.yy_color = [UIColor colorWithHexString:@"#8FE5F6" alpha:1];
    NSMutableAttributedString *attrMsg = [[NSMutableAttributedString alloc] initWithString:content];
    attrMsg.yy_lineSpacing = 6;
    attrMsg.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrMsg.yy_color = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    [attrIcon appendAttributedString:attrName];
    [attrIcon appendAttributedString:attrMsg];
    _attrContent = attrIcon;
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
