//
//  HSSearchHeaderView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "HSSearchHeaderView.h"

@interface HSSearchHeaderView ()
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userIdLabel;
@property (nonatomic, strong) UIView *textFieldView;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *searchBtn;
@end

@implementation HSSearchHeaderView

- (void)hsConfigUI {
    self.backgroundColor = UIColor.whiteColor;
}

- (void)hsAddViews {
    [self addSubview:self.headerView];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.userIdLabel];
    [self addSubview:self.textFieldView];
    [self.textFieldView addSubview:self.searchTextField];
    [self.textFieldView addSubview:self.searchBtn];
}

- (void)hsLayoutViews {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7 + kAppSafeTop);
        make.left.mas_equalTo(24);
        make.size.mas_equalTo(CGSizeMake(56, 56));
    }];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerView.mas_right).offset(10);
        make.top.mas_equalTo(self.headerView.mas_top).offset(3);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerView.mas_right).offset(10);
        make.top.mas_equalTo(self.userNameLabel.mas_bottom).offset(6);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(15);
        make.height.mas_equalTo(32);
        make.bottom.mas_equalTo(-10);
    }];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self.textFieldView);
        make.width.mas_equalTo(56);
    }];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(self.searchBtn.mas_left).offset(-10);
        make.top.bottom.mas_equalTo(self.textFieldView);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
}

- (void)hsUpdateUI {
    HSAccountUserModel *userInfo = HSAppManager.shared.loginUserInfo;
    self.userNameLabel.text = userInfo.name;
    self.userIdLabel.text = [NSString stringWithFormat:@"用户ID: %@", userInfo.userID];
    if (userInfo.icon.length > 0) {
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:userInfo.icon]];
    }
}


- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
    }
    return _headerView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.text = @"傲性小仙女";
        _userNameLabel.numberOfLines = 1;
        _userNameLabel.textColor = [UIColor colorWithHexString:@"#13141A" alpha:1];
        _userNameLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    }
    return _userNameLabel;
}

- (UILabel *)userIdLabel {
    if (!_userIdLabel) {
        _userIdLabel = [[UILabel alloc] init];
        _userIdLabel.text = @"用户ID 0";
        _userIdLabel.numberOfLines = 1;
        _userIdLabel.textColor = [UIColor colorWithHexString:@"#13141A" alpha:1];
        _userIdLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _userIdLabel;
}

- (UIView *)textFieldView {
    if (!_textFieldView) {
        _textFieldView = [[UIView alloc] init];
        _textFieldView.backgroundColor = [UIColor colorWithHexString:@"#F2F3F7" alpha:1];
    }
    return _textFieldView;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.placeholder = @"房间ID";
        _searchTextField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _searchTextField.textColor = UIColor.blackColor;
        _searchTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _searchTextField;
}

- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] init];
        [_searchBtn setTitle:@"进入" forState:UIControlStateNormal];
        _searchBtn.backgroundColor = UIColor.blackColor;
        _searchBtn.titleLabel.textColor = UIColor.whiteColor;
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _searchBtn;
}

@end
