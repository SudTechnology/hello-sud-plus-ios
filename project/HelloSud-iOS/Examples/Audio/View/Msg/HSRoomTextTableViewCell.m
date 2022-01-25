//
//  HSRoomTextTableViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSRoomTextTableViewCell.h"

@implementation HSRoomTextTableViewCell

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
    if ([model isKindOfClass:HSAudioMsgTextModel.class]) {
        HSAudioMsgTextModel *m = (HSAudioMsgTextModel *)model;
        [self setMsgContent: m];
    }
}

/// 设置文本消息
- (void)setMsgContent:(HSAudioMsgTextModel *)m {
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
