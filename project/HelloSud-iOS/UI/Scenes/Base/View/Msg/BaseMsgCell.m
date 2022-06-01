//
//  BaseMsgCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseMsgCell.h"

@interface BaseMsgCell ()

@end

@implementation BaseMsgCell

- (void)hsAddViews {
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.msgContentView];
}

- (void)hsLayoutViews {
    [self.msgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(16);
        make.bottom.mas_equalTo(-4);
        make.width.mas_lessThanOrEqualTo(260);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (UIView *)msgContentView {
    if (!_msgContentView) {
        _msgContentView = [[UIView alloc] init];
        _msgContentView.layer.cornerRadius = 2;
        _msgContentView.layer.masksToBounds = true;
    }
    return _msgContentView;
}



@end
