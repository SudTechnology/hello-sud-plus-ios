//
//  RoomGiftTableViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "RoomGiftTableViewCell.h"

@implementation RoomGiftTableViewCell

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
    self.msgContentView.backgroundColor = [UIColor colorWithHexString:@"#A99862" alpha:0.6];
}

- (void)setModel:(BaseModel *)model {
    if ([model isKindOfClass:AudioMsgGiftModel.class]) {
        [self setContent: (AudioMsgGiftModel *)model];
    }
}

- (void)setContent:(AudioMsgGiftModel *)model {
    self.msgLabel.attributedText = model.attrContent;
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
