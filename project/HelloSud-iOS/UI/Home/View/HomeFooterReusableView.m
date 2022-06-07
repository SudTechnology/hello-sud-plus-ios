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

- (void)dtConfigUI {
    self.backgroundColor = HEX_COLOR(@"#F5F6FB");
}

- (void)dtAddViews {
    [self addSubview:self.contentView];
}

- (void)dtLayoutViews {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(0);
        make.height.mas_equalTo(12);
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
