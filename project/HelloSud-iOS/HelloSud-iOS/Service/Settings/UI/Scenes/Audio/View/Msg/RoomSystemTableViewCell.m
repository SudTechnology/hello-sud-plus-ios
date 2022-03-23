//
//  RoomSystemTableViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "RoomSystemTableViewCell.h"

@implementation RoomSystemTableViewCell

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
    self.msgContentView.backgroundColor = [UIColor dt_colorWithHexString:@"#000000" alpha:0.3];
}

- (void)setModel:(BaseModel *)model {
    
    if ([model isKindOfClass:AudioMsgSystemModel.class]) {
        AudioMsgSystemModel *m = (AudioMsgSystemModel *)model;
        self.msgLabel.attributedText = m.attrContent;
        self.msgContentView.backgroundColor = m.bgColor;
    }
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
