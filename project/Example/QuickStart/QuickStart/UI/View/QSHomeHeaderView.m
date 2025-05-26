//
// Created by kaniel on 2022/5/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "QSHomeHeaderView.h"


@interface QSHomeHeaderView () <UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *sudLogoImageView;
@property (nonatomic, strong) UILabel *sudNameLabel;
@property (nonatomic, strong) UILabel *sudWebLabel;
@property (nonatomic, strong) UIView *textFieldView;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UITextField *searchTextField;
@end

@implementation QSHomeHeaderView

- (void)dtConfigUI {
    self.backgroundColor = UIColor.whiteColor;
}

- (void)dtAddViews {
    [self addSubview:self.sudLogoImageView];
    [self addSubview:self.sudNameLabel];
    [self addSubview:self.sudWebLabel];
    [self addSubview:self.textFieldView];
    [self.textFieldView addSubview:self.searchTextField];
    [self.textFieldView addSubview:self.searchBtn];
}

- (void)dtLayoutViews {
    [self.sudLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 + kAppSafeTop);
        make.leading.mas_equalTo(16);
        make.size.mas_equalTo(CGSizeMake(52, 24));
    }];
    [self.sudNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.sudLogoImageView.mas_trailing).offset(6);
        make.centerY.equalTo(self.sudLogoImageView);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.sudWebLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-16));
        make.centerY.equalTo(self.sudLogoImageView);
        make.height.equalTo(@14);
        make.width.equalTo(@94);
    }];
    [self.textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(self.sudLogoImageView.mas_bottom).offset(15);
        make.height.mas_equalTo(32);
        make.bottom.mas_equalTo(-10);
    }];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.mas_equalTo(self.textFieldView);
        make.width.mas_equalTo(56);
    }];
    if (LanguageUtil.isLanguageRTL) {
        self.searchTextField.textAlignment = NSTextAlignmentRight;
    }
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.trailing.mas_equalTo(self.searchBtn.mas_leading).offset(-10);
        make.top.bottom.mas_equalTo(self.textFieldView);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)dtUpdateUI {
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
}

- (UIImageView *)sudLogoImageView {
    if (!_sudLogoImageView) {
        _sudLogoImageView = [[UIImageView alloc] init];
        _sudLogoImageView.image = [UIImage imageNamed:@"sud_logo"];
    }
    return _sudLogoImageView;
}

- (UILabel *)sudNameLabel {
    if (!_sudNameLabel) {
        _sudNameLabel = [[UILabel alloc] init];
        _sudNameLabel.text = @"SudGIP";
        _sudNameLabel.numberOfLines = 1;
        _sudNameLabel.textColor = [UIColor dt_colorWithHexString:@"#13141A" alpha:1];
        _sudNameLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    }
    return _sudNameLabel;
}

- (UILabel *)sudWebLabel {
    if (!_sudWebLabel) {
        _sudWebLabel = [[UILabel alloc] init];
        _sudWebLabel.numberOfLines = 1;
        _sudWebLabel.text = @"www.sud.tech";
        _sudWebLabel.layer.cornerRadius = 7;
        _sudWebLabel.clipsToBounds = YES;
        _sudWebLabel.textAlignment = NSTextAlignmentCenter;
        _sudWebLabel.backgroundColor = [UIColor dt_colorWithHexString:@"#DBDEEC" alpha:0.4];
        _sudWebLabel.textColor = [UIColor dt_colorWithHexString:@"#666666" alpha:1];
        _sudWebLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _sudWebLabel;
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
        _searchTextField.placeholder = @"10000";
        _searchTextField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _searchTextField.textColor = UIColor.blackColor;
        _searchTextField.keyboardType = UIKeyboardTypeNumberPad;
        _searchTextField.textAlignment = NSTextAlignmentLeft;
        _searchTextField.delegate = self;
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
        [_searchBtn addTarget:self action:@selector(onSearchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_searchBtn setHidden:true];
    }
    return _searchBtn;
}

/// 搜索按钮点击
- (void)onSearchBtnClick:(UIButton *)sender {
    [self.searchTextField resignFirstResponder];
    NSString *searchText = self.searchTextField.text;
    if (self.onSearchEnterBlock) {
        self.onSearchEnterBlock(searchText);
    }
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
