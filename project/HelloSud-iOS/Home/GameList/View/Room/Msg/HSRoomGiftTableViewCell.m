//
//  HSRoomGiftTableViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSRoomGiftTableViewCell.h"

@implementation HSRoomGiftTableViewCell

- (void)hsConfigUI {
    self.msgContentView.backgroundColor = [UIColor colorWithHexString:@"#A99862" alpha:0.6];
}

- (void)setModel:(BaseModel *)model {
    [self setContent];
}

- (void)setContent {
    NSMutableAttributedString *attrSendName = [[NSMutableAttributedString alloc] initWithString:@"大眼萌嘟宝"];
    attrSendName.yy_lineSpacing = 6;
    attrSendName.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrSendName.yy_color = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    
    NSMutableAttributedString *attrSend = [[NSMutableAttributedString alloc] initWithString:@"送给"];
    attrSend.yy_lineSpacing = 6;
    attrSend.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrSend.yy_color = [UIColor colorWithHexString:@"#AAAAAA" alpha:1];
    
    NSMutableAttributedString *attrGetName = [[NSMutableAttributedString alloc] initWithString:@"零乳糖软妹   小仓鼠"];
    attrGetName.yy_lineSpacing = 6;
    attrGetName.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrGetName.yy_color = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    
    UIImage *iconImage = [UIImage imageNamed:@"room_ope_gift"];
    NSMutableAttributedString *attrGift = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(16, 16) alignToFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
    
    NSMutableAttributedString *attrGiftCount = [[NSMutableAttributedString alloc] initWithString:@"x1"];
    attrGiftCount.yy_lineSpacing = 6;
    attrGiftCount.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    attrGiftCount.yy_color = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    
    [attrSendName appendAttributedString:attrSend];
    [attrSendName appendAttributedString:attrGetName];
    [attrSendName appendAttributedString:attrGift];
    [attrSendName appendAttributedString:attrGiftCount];
    
    self.msgLabel.attributedText = attrSendName;
}

@end
