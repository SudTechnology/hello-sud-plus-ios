//
//  HSGameListNaviView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "HSGameListNaviView.h"

@interface HSGameListNaviView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *searchTextField;
@end

@implementation HSGameListNaviView

- (void)hsConfigUI {
    self.backgroundColor = UIColor.whiteColor;
}

- (void)hsAddViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.searchView];
    [self.searchView addSubview:self.searchTextField];
}

- (void)hsLayoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.bottom.mas_equalTo(-6);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-24);
        make.bottom.mas_equalTo(-6);
        make.size.mas_equalTo(CGSizeMake(120, 32));
    }];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.top.bottom.mas_equalTo(self.searchView);
    }];
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"HelloSud";
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
    }
    return _titleLabel;
}

- (UIView *)searchView {
    if (!_searchView) {
        _searchView = [[UIView alloc] init];
        _searchView.backgroundColor = [UIColor colorWithHexString:@"#F2F3F7" alpha:1];
    }
    return  _searchView;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.placeholder = @"房间ID";
        _searchTextField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _searchTextField.textColor = UIColor.blackColor;
    }
    return _searchTextField;
}

@end
