//
//  HSRoomTextTableViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSRoomTextTableViewCell.h"

@implementation HSRoomTextTableViewCell

- (void)dtAddViews {
    [super dtAddViews];
    [self.msgContentView addSubview:self.msgLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(3, 3, 3, 5));
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];

}

- (void)dtConfigUI {
    self.msgContentView.backgroundColor = [UIColor dt_colorWithHexString:@"#000000" alpha:0.3];
}

- (void)setModel:(BaseModel *)model {
    if ([model isKindOfClass:RoomCmdChatTextModel.class]) {
        RoomCmdChatTextModel *m = (RoomCmdChatTextModel *)model;
        [self setMsgContent: m];
    }
}

/// 设置文本消息
- (void)setMsgContent:(RoomCmdChatTextModel *)m {
    self.msgLabel.attributedText = m.attrContent;
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
