//
//  HSRoomSystemTableViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSRoomSystemTableViewCell.h"

@implementation HSRoomSystemTableViewCell

- (void)hsConfigUI {
    self.msgContentView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
}

- (void)setModel:(BaseModel *)model {
    
    [self setSystemContent];
}

- (void)setSystemContent {
    NSMutableAttributedString *attrMsg = [[NSMutableAttributedString alloc] initWithString:@"系统消息系统消息系统消息"];
    attrMsg.yy_lineSpacing = 6;
    attrMsg.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrMsg.yy_color = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    
    self.msgLabel.attributedText = attrMsg;
}

@end
