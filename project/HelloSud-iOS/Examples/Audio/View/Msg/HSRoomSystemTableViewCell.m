//
//  HSRoomSystemTableViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSRoomSystemTableViewCell.h"

@implementation HSRoomSystemTableViewCell

- (void)hsAddViews {
    [super hsAddViews];
    [self.msgContentView addSubview:self.msgLabel];
}

- (void)hsLayoutViews {
    [super hsLayoutViews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(3, 3, 3, 5));
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];

}

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

- (YYLabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[YYLabel alloc] init];
        _msgLabel.numberOfLines = 0;
        _msgLabel.preferredMaxLayoutWidth = 260 - 8;
        _msgLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    }
    return _msgLabel;
}

@end
