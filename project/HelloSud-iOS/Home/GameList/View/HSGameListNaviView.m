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
@property (nonatomic, strong) UILabel *searchLabel;
@end

@implementation HSGameListNaviView

- (void)hsConfigUI {
    self.backgroundColor = UIColor.whiteColor;
}

- (void)hsAddViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.searchView];
    [self.searchView addSubview:self.searchLabel];
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
    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.mas_equalTo(self.searchView);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
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

- (UILabel *)searchLabel {
    if (!_searchLabel) {
        _searchLabel = [[UILabel alloc] init];
        _searchLabel.text = @"房间ID";
        _searchLabel.textColor = [UIColor colorWithHexString:@"#AAAAAA" alpha:1];
        _searchLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    }
    return _searchLabel;
}

@end
