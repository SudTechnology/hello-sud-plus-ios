//
//  HSBaseMsgCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSBaseMsgCell.h"

@interface HSBaseMsgCell ()

@end

@implementation HSBaseMsgCell

- (void)hsAddViews {
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.msgContentView];
    [self.msgContentView addSubview:self.msgLabel];
}

- (void)hsLayoutViews {
    [self.msgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(16);
        make.bottom.mas_equalTo(-4);
        make.width.mas_lessThanOrEqualTo(260);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(3, 3, 3, 5));
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.msgLabel.attributedText = nil;
}

- (UIView *)msgContentView {
    if (!_msgContentView) {
        _msgContentView = [[UIView alloc] init];
        _msgContentView.layer.cornerRadius = 2;
        _msgContentView.layer.masksToBounds = true;
    }
    return _msgContentView;
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
