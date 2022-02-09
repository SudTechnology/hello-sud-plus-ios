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
    
    /// 上下麦消息通知
    if ([model isKindOfClass:HSAudioMsgMicModel.class]) {
        HSAudioMsgMicModel *m = (HSAudioMsgMicModel *)model;
        self.msgLabel.attributedText = m.attrContent;
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
