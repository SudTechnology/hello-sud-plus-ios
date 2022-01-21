//
//  HSRoomTextTableViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSRoomTextTableViewCell.h"

@implementation HSRoomTextTableViewCell

- (void)hsConfigUI {
    self.msgContentView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
}

- (void)setModel:(BaseModel *)model {
    
    [self setMsgContent];
}

/// 设置文本消息
- (void)setMsgContent {
    UIImage *iconImage = [UIImage imageNamed:@"room_ope_gift"];
    NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(16, 16) alignToFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
    NSMutableAttributedString *attrName = [[NSMutableAttributedString alloc] initWithString:@"傲性小仙女："];
    attrName.yy_lineSpacing = 6;
    attrName.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrName.yy_color = [UIColor colorWithHexString:@"#8FE5F6" alpha:1];
    NSMutableAttributedString *attrMsg = [[NSMutableAttributedString alloc] initWithString:@"叫上小伙伴们一起来玩"];
    attrMsg.yy_lineSpacing = 6;
    attrMsg.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrMsg.yy_color = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    [attrIcon appendAttributedString:attrName];
    [attrIcon appendAttributedString:attrMsg];
    
    self.msgLabel.attributedText = attrIcon;
}

@end
