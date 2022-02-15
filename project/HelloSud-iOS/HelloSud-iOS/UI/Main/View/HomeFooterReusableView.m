//
//  HomeFooterReusableView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "HomeFooterReusableView.h"

@interface HomeFooterReusableView ()
@property (nonatomic, strong) BaseView *contentView;
@end

@implementation HomeFooterReusableView

- (void)hsConfigUI {
//    self.backgroundColor = UIColor.whiteColor;
}

- (void)hsAddViews {
    [self addSubview:self.contentView];
}

- (void)hsLayoutViews {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (BaseView *)contentView {
    if (!_contentView) {
        _contentView = [[BaseView alloc] init];
        _contentView.backgroundColor = UIColor.whiteColor;
        [_contentView setPartRoundCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadius:8];
    }
    return _contentView;
}

@end
