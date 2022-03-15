//
//  SearchHeaderView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "SearchHeaderView.h"

@interface SearchHeaderView () <UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userIdLabel;
@property (nonatomic, strong) UIView *textFieldView;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UITextField *searchTextField;
@end

@implementation SearchHeaderView

- (void)dtConfigUI {
    self.backgroundColor = UIColor.whiteColor;
}

- (void)dtAddViews {
    [self addSubview:self.headerView];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.userIdLabel];
    [self addSubview:self.textFieldView];
    [self.textFieldView addSubview:self.searchTextField];
    [self.textFieldView addSubview:self.searchBtn];
}

- (void)dtLayoutViews {
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

- (void)dtUpdateUI {
    AccountUserModel *userInfo = AppService.shared.loginUserInfo;
    self.userNameLabel.text = userInfo.name;
    self.userIdLabel.text = [NSString stringWithFormat:@"%@ %@", NSString.dt_home_user_id, userInfo.userID];
    if (userInfo.icon.length > 0) {
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:userInfo.icon]];
    }
}

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.clipsToBounds = true;
        _headerView.layer.cornerRadius = 56/2;
    }
    return _headerView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.text = @"";
        _userNameLabel.numberOfLines = 1;
        _userNameLabel.textColor = [UIColor dt_colorWithHexString:@"#13141A" alpha:1];
        _userNameLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    }
    return _userNameLabel;
}

- (UILabel *)userIdLabel {
    if (!_userIdLabel) {
        _userIdLabel = [[UILabel alloc] init];
        _userIdLabel.text = @"用户ID 0";
        _userIdLabel.numberOfLines = 1;
        _userIdLabel.textColor = [UIColor dt_colorWithHexString:@"#13141A" alpha:1];
        _userIdLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _userIdLabel;
}

- (UIView *)textFieldView {
    if (!_textFieldView) {
        _textFieldView = [[UIView alloc] init];
        _textFieldView.backgroundColor = [UIColor dt_colorWithHexString:@"#F2F3F7" alpha:1];
    }
    return _textFieldView;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.placeholder = NSString.dt_home_enter_room_num;
        _searchTextField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _searchTextField.textColor = UIColor.blackColor;
        _searchTextField.keyboardType = UIKeyboardTypeNumberPad;
        _searchTextField.delegate = self;
    }
    return _searchTextField;
}

- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] init];
        [_searchBtn setTitle:NSString.dt_home_enter forState:UIControlStateNormal];
        _searchBtn.backgroundColor = UIColor.blackColor;
        _searchBtn.titleLabel.textColor = UIColor.whiteColor;
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        [_searchBtn addTarget:self action:@selector(enterEvent) forControlEvents:UIControlEventTouchUpInside];
        [_searchBtn setHidden:true];
    }
    return _searchBtn;
}

- (void)enterEvent {
    [self.searchTextField resignFirstResponder];
    NSString *searchText = self.searchTextField.text;
    WeakSelf
    [AudioRoomService.shared reqEnterRoom:searchText.longLongValue success:^{
        weakSelf.searchTextField.text = nil;
    } fail:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location == 0 && string.length == 0) {
        [self.searchBtn setHidden:true];
    } else {
        [self.searchBtn setHidden:false];
    }
    return true;
}

@end
