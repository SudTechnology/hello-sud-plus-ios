//
//  LoginViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "LoginViewController.h"
#import "MainTabBarController.h"
#import "SweetPromptView.h"
#import "AppDelegate.h"

@interface LoginViewController ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *fieldView;
@property (nonatomic, strong) UILabel *nameTitleLabel;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!AppService.shared.isAgreement) {
        [self showWelcomeUse];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dtAddViews {
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.nameTitleLabel];
    [self.view addSubview:self.fieldView];
    [self.fieldView addSubview:self.nameTextField];
    [self.fieldView addSubview:self.changeBtn];
    [self.view addSubview:self.loginBtn];
    [self changeNodeEvent];
}

/// 立即体验点击事件
- (void)loginNodeEvent {
    [AppService.shared.login reqLogin:self.nameTextField.text userID:AppService.shared.login.loginUserInfo.userID sucess:^{

    }];
}

/// 更换昵称点击事件
- (void)changeNodeEvent {
    NSString *randomUserName = [AppService.shared randomUserName];
    self.nameTextField.text = randomUserName;
}

- (void)showWelcomeUse {
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", NSString.dt_login_welcome_helloSud]];
    attrTitle.yy_lineSpacing = 16;
    attrTitle.yy_font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    attrTitle.yy_color = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
    attrTitle.yy_alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *attrStr_0 = [[NSMutableAttributedString alloc] initWithString:NSString.dt_login_we_take_information];
    attrStr_0.yy_lineSpacing = 6;
    attrStr_0.yy_font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    attrStr_0.yy_color = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
    
    NSMutableAttributedString *attrStr_1 = [[NSMutableAttributedString alloc] initWithString:NSString.dt_login_user_agreement];
    attrStr_1.yy_lineSpacing = 6;
    attrStr_1.yy_font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    attrStr_1.yy_color = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
    
    NSMutableAttributedString *attrStr_2 = [[NSMutableAttributedString alloc] initWithString:NSString.dt_login_and];
    attrStr_2.yy_lineSpacing = 6;
    attrStr_2.yy_font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    attrStr_2.yy_color = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
    
    NSMutableAttributedString *attrStr_3 = [[NSMutableAttributedString alloc] initWithString:NSString.dt_login_privacy_policy];
    attrStr_3.yy_lineSpacing = 6;
    attrStr_3.yy_font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    attrStr_3.yy_color = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
    
    NSMutableAttributedString *attrStr_4 = [[NSMutableAttributedString alloc] initWithString:NSString.dt_login_click_agree_agreement];
    attrStr_4.yy_lineSpacing = 6;
    attrStr_4.yy_font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    attrStr_4.yy_color = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
    
    [attrStr_1 yy_setTextHighlightRange:attrStr_1.yy_rangeOfAll color:[UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1] backgroundColor:UIColor.clearColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        DTWebViewController *web = DTWebViewController.new;
        web.url = [SettingsService appProtocolURL].absoluteString;
        web.isPresent = true;
        BaseNavigationViewController *nv = [[BaseNavigationViewController alloc] initWithRootViewController:web];
        nv.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nv animated:YES completion:nil];
    }];
    [attrStr_3 yy_setTextHighlightRange:attrStr_3.yy_rangeOfAll color:[UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1] backgroundColor:UIColor.clearColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        DTWebViewController *web = DTWebViewController.new;
        web.url = [SettingsService appPrivacyURL].absoluteString;
        web.isPresent = true;
        BaseNavigationViewController *nv = [[BaseNavigationViewController alloc] initWithRootViewController:web];
        nv.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nv animated:YES completion:nil];
    }];
    
    [attrTitle appendAttributedString:attrStr_0];
    [attrTitle appendAttributedString:attrStr_1];
    [attrTitle appendAttributedString:attrStr_2];
    [attrTitle appendAttributedString:attrStr_3];
    [attrTitle appendAttributedString:attrStr_4];
    
    [DTAlertView showAttrTextAlert:attrTitle sureText:NSString.dt_common_agree cancelText:NSString.dt_common_not_agree rootView:self.view onSureCallback:^{
        [DTAlertView close];
        [AppService.shared saveAgreement];
    } onCloseCallback:^{
        SweetPromptView *promptView = [[SweetPromptView alloc] init];
        [DTAlertView show:promptView rootView:AppUtil.currentWindow clickToClose:false showDefaultBackground:YES onCloseCallback:^{
        }];
        promptView.agreeTapBlock = ^(UIButton *sender) {
            [DTAlertView close];
        };
        promptView.exitTapBlock = ^(UIButton *sender) {
            exit(0);
        };
    }];
}

- (void)dtLayoutViews {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(126);
        make.leading.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(68, 22));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(30);
        make.trailing.mas_equalTo(-30);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(32);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.nameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(30);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(24);
        make.height.with.mas_greaterThanOrEqualTo(0);
    }];
    [self.fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(30);
        make.top.mas_equalTo(self.nameTitleLabel.mas_bottom).offset(8);
        make.trailing.mas_equalTo(-30);
        make.height.mas_equalTo(48);
    }];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 16, 0, 50));
    }];
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-4);
        make.centerY.mas_equalTo(self.fieldView);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(30);
        make.trailing.mas_equalTo(-30);
        make.top.mas_equalTo(self.changeBtn.mas_bottom).offset(190);
        make.height.mas_equalTo(44);
    }];
}

@end

@implementation LoginViewController (LAZY)

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"login_sud_icon"];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSString.dt_login_welcome;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor dt_colorWithHexString:@"#13141A" alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
    }
    return _titleLabel;
}

- (UILabel *)nameTitleLabel {
    if (!_nameTitleLabel) {
        _nameTitleLabel = [[UILabel alloc] init];
        _nameTitleLabel.text = NSString.dt_login_your_nickname;
        _nameTitleLabel.textColor = [UIColor dt_colorWithHexString:@"#13141A" alpha:1];
        _nameTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    }
    return _nameTitleLabel;
}

- (UIView *)fieldView {
    if (!_fieldView) {
        _fieldView = [[UIView alloc] init];
        _fieldView.layer.borderWidth = 1;
        _fieldView.layer.borderColor = UIColor.blackColor.CGColor;
        _fieldView.layer.masksToBounds = true;
    }
    return _fieldView;
}

- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.text = @"";
        _nameTextField.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _nameTextField.textColor = UIColor.blackColor;
        [_nameTextField setUserInteractionEnabled:false];
    }
    return _nameTextField;
}

- (UIButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = [[UIButton alloc] init];
        [_changeBtn setImage:[UIImage imageNamed:@"login_change"] forState:UIControlStateNormal];
        [_changeBtn addTarget:self action:@selector(changeNodeEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeBtn;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn setTitle:NSString.dt_login_experience_immediately forState:normal];
        _loginBtn.backgroundColor = UIColor.blackColor;
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_loginBtn setTitleColor:UIColor.whiteColor forState:normal];
        [_loginBtn addTarget:self action:@selector(loginNodeEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}
@end
