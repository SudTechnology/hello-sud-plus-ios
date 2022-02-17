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
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!AppManager.shared.isAgreement) {
        [self showWelcomeUse];
    }
}

- (void)hsAddViews {
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
    
    [AppManager.shared reqLogin:self.nameTextField.text userID:nil sucess:^{
        /// 切根式图
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = [[MainTabBarController alloc] init];
    }];
}

/// 更换昵称点击事件
- (void)changeNodeEvent {
    NSString *randomUserName = [AppManager.shared randomUserName];
    self.nameTextField.text = randomUserName;
}

- (void)showWelcomeUse {
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:@"欢迎使用HelloSud\n"];
    attrTitle.yy_lineSpacing = 16;
    attrTitle.yy_font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    attrTitle.yy_color = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
    attrTitle.yy_alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *attrStr_0 = [[NSMutableAttributedString alloc] initWithString:@"我们非常重视您的个人信息保护。关于个人信息收集和使用的详细信息，您可以点击"];
    attrStr_0.yy_lineSpacing = 6;
    attrStr_0.yy_font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    attrStr_0.yy_color = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
    
    NSMutableAttributedString *attrStr_1 = [[NSMutableAttributedString alloc] initWithString:@"《用户协议》"];
    attrStr_1.yy_lineSpacing = 6;
    attrStr_1.yy_font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    attrStr_1.yy_color = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
    
    NSMutableAttributedString *attrStr_2 = [[NSMutableAttributedString alloc] initWithString:@"和"];
    attrStr_2.yy_lineSpacing = 6;
    attrStr_2.yy_font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    attrStr_2.yy_color = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
    
    NSMutableAttributedString *attrStr_3 = [[NSMutableAttributedString alloc] initWithString:@"《隐私政策》"];
    attrStr_3.yy_lineSpacing = 6;
    attrStr_3.yy_font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    attrStr_3.yy_color = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
    
    NSMutableAttributedString *attrStr_4 = [[NSMutableAttributedString alloc] initWithString:@"进行了解。点击同意及表示您已阅读并同意全部上述协议"];
    attrStr_4.yy_lineSpacing = 6;
    attrStr_4.yy_font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    attrStr_4.yy_color = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
    
    [attrTitle appendAttributedString:attrStr_0];
    [attrTitle appendAttributedString:attrStr_1];
    [attrTitle appendAttributedString:attrStr_2];
    [attrTitle appendAttributedString:attrStr_3];
    [attrTitle appendAttributedString:attrStr_4];
    
    [DTAlertView showAttrTextAlert:attrTitle sureText:@"同意" cancelText:@"不同意" onSureCallback:^{
        [AppManager.shared saveAgreement];
    } onCloseCallback:^{
        SweetPromptView *promptView = [[SweetPromptView alloc] init];
        [DTAlertView show:promptView rootView:AppUtil.currentWindow isHitTest:false onCloseCallback:^{
        }];
        promptView.agreeTapBlock = ^(UIButton *sender) {
            [DTAlertView close];
        };
        promptView.exitTapBlock = ^(UIButton *sender) {
            exit(0);
        };
    }];
}

- (void)hsLayoutViews {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(126);
        make.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(49, 22));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(32);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.nameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(24);
        make.height.with.mas_greaterThanOrEqualTo(0);
    }];
    [self.fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.nameTitleLabel.mas_bottom).offset(8);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(48);
    }];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 16, 0, 50));
    }];
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-4);
        make.centerY.mas_equalTo(self.fieldView);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
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
        _titleLabel.text = @"欢迎体验\nHelloSud";
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#13141A" alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
    }
    return _titleLabel;
}

- (UILabel *)nameTitleLabel {
    if (!_nameTitleLabel) {
        _nameTitleLabel = [[UILabel alloc] init];
        _nameTitleLabel.text = @"你的昵称";
        _nameTitleLabel.textColor = [UIColor colorWithHexString:@"#13141A" alpha:1];
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
        _nameTextField.text = @"Mary";
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
        [_loginBtn setTitle:@"立即体验" forState:normal];
        _loginBtn.backgroundColor = UIColor.blackColor;
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_loginBtn setTitleColor:UIColor.whiteColor forState:normal];
        [_loginBtn addTarget:self action:@selector(loginNodeEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}
@end
