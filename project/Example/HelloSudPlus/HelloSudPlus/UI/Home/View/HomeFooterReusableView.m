//
//  HomeFooterReusableView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "HomeFooterReusableView.h"

@interface HomeFooterReusableView ()

@end

@implementation HomeFooterReusableView

- (void)dtConfigUI {
    self.backgroundColor = HEX_COLOR(@"#F5F6FB");
}

- (void)dtAddViews {
    [self addSubview:self.whiteCoverView];
}

- (void)dtLayoutViews {
    [self.whiteCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(0);
        make.height.mas_equalTo(12);
    }];
}

- (BaseView *)whiteCoverView {
    if (!_whiteCoverView) {
        _whiteCoverView = [[BaseView alloc] init];
        _whiteCoverView.backgroundColor = UIColor.whiteColor;
        [_whiteCoverView setPartRoundCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadius:8];
    }
    return _whiteCoverView;
}

@end
