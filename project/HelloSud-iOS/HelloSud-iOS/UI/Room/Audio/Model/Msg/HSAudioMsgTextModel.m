//
//  HSAudioMsgTextModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "HSAudioMsgTextModel.h"

@interface HSAudioMsgTextModel(){
    NSAttributedString *_attrContent;
}

@end

@implementation HSAudioMsgTextModel
/// 构建消息
/// @param content 消息内容
+ (instancetype)makeMsg:(NSString *)content {
    HSAudioMsgTextModel *m = HSAudioMsgTextModel.new;
    [m configBaseInfoWithCmd:CMD_PUBLIC_MSG_NTF];
    m.content = content;
    return m;
}

- (NSString *)cellName {
    return @"HSRoomTextTableViewCell";
}

- (CGFloat)caculateHeight {
    CGFloat h = [super caculateHeight];
    CGFloat yMargin = 3;
    h += yMargin * 2;
    NSString *name = self.sendUser.name;
    NSString *content = self.content;
    UIImage *iconImage = self.sendUser.icon.length > 0 ? [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.sendUser.icon]]] : [UIImage imageNamed:@"room_ope_gift"];
    NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(16, 16) alignToFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
    NSMutableAttributedString *attrName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：", name]];
    attrName.yy_lineSpacing = 6;
    attrName.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrName.yy_color = [UIColor colorWithHexString:@"#8FE5F6" alpha:1];
    NSMutableAttributedString *attrMsg = [[NSMutableAttributedString alloc] initWithString:content];
    attrMsg.yy_lineSpacing = 6;
    attrMsg.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrMsg.yy_color = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    if (!_hiddeHeadIcon) {
        [attrName insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:0];
        [attrName insertAttributedString:attrIcon atIndex:0];
    }
    [attrName appendAttributedString:attrMsg];
    _attrContent = attrName;
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
