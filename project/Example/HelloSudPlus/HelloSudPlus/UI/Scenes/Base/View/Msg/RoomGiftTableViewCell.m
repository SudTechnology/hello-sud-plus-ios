//
//  RoomGiftTableViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "RoomGiftTableViewCell.h"

@implementation RoomGiftTableViewCell

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
    self.msgContentView.backgroundColor = [UIColor dt_colorWithHexString:@"#A99862" alpha:0.6];
}

- (void)setModel:(BaseModel *)model {
    if ([model isKindOfClass:RoomCmdSendGiftModel.class]) {
        [self setContent: (RoomCmdSendGiftModel *)model];
    }
}

- (void)setContent:(RoomCmdSendGiftModel *)model {
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
