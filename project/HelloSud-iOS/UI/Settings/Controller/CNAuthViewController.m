//
//  LoginViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "CNAuthViewController.h"
#import "MainTabBarController.h"
#import "SweetPromptView.h"
#import "AppDelegate.h"

@interface CNAuthViewController ()
@property(nonatomic, strong) UIImageView *leftImageView;
@property(nonatomic, strong) UIImageView *middleImageView;
@property(nonatomic, strong) UIImageView *rightImageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITextField *phoneTextField;
@property(nonatomic, strong) UIView *fieldView;
@property(nonatomic, strong) UITextField *codeTextField;
@property(nonatomic, strong) UIButton *getCodeBtn;
@property(nonatomic, strong) UILabel *registerTipTitleLabel;
@property(nonatomic, strong) UIButton *loginBtn;
@property(nonatomic, strong) YYLabel *protocolLabel;

@property(nonatomic, strong) UILabel *authTitleLabel;
@property(nonatomic, strong) UIImageView *authOneImageView;
@property(nonatomic, strong) UILabel *authOneTipLabel;
@property(nonatomic, strong) UIImageView *authTwoImageView;
@property(nonatomic, strong) UILabel *authTwoTipLabel;

@property(nonatomic, strong) DTTimer *countdownTimer;

@end

@implementation CNAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dtAddViews {
    [self.view addSubview:self.leftImageView];
    [self.view addSubview:self.middleImageView];
    [self.view addSubview:self.rightImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.fieldView];
    [self.fieldView addSubview:self.codeTextField];
    [self.fieldView addSubview:self.getCodeBtn];
    [self.view addSubview:self.registerTipTitleLabel];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.protocolLabel];
    [self.view addSubview:self.authTitleLabel];
    [self.view addSubview:self.authOneImageView];
    [self.view addSubview:self.authOneTipLabel];
    [self.view addSubview:self.authTwoImageView];
    [self.view addSubview:self.authTwoTipLabel];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    self.view.backgroundColor = HEX_COLOR(@"#F5F6FB");
    if (!self.walletInfoModel) {
        return;
    }
    self.title = [NSString stringWithFormat:@"%@账号授权", self.walletInfoModel.name];
    self.titleLabel.text = [NSString stringWithFormat:@"授权%@账号", self.walletInfoModel.name];
    self.registerTipTitleLabel.text = [NSString stringWithFormat:@"未注册%@的手机号，授权后将自动注册", self.walletInfoModel.name];
    if (self.walletInfoModel.icon) {
        [self.leftImageView sd_setImageWithURL:[[NSURL alloc] initWithString:self.walletInfoModel.icon]];
    }
    self.authTitleLabel.text = @"授权后应用将获取以下权限";
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:@"基础信息\n"];
    attrTitle.yy_font = UIFONT_MEDIUM(14);
    attrTitle.yy_color = HEX_COLOR(@"#1A1A1A");
    attrTitle.yy_lineSpacing = 10;
    NSMutableAttributedString *sudAttrTitle = [[NSMutableAttributedString alloc] initWithString:@"获得您的公开信息，以授权绑定第三方应用"];
    sudAttrTitle.yy_font = UIFONT_REGULAR(12);
    sudAttrTitle.yy_color = HEX_COLOR(@"#666666");
    [attrTitle appendAttributedString:sudAttrTitle];
    self.authOneTipLabel.attributedText = attrTitle;

    NSMutableAttributedString *attrTitle2 = [[NSMutableAttributedString alloc] initWithString:@"数字藏品信息\n"];
    attrTitle2.yy_font = UIFONT_MEDIUM(14);
    attrTitle2.yy_color = HEX_COLOR(@"#1A1A1A");
    attrTitle2.yy_lineSpacing = 10;
    NSMutableAttributedString *sudAttrTitle2 = [[NSMutableAttributedString alloc] initWithString:@"获得您的数字藏品信息，以展示在第三方应用"];
    sudAttrTitle2.yy_font = UIFONT_REGULAR(12);
    sudAttrTitle2.yy_color = HEX_COLOR(@"#666666");
    [attrTitle2 appendAttributedString:sudAttrTitle2];
    self.authTwoTipLabel.attributedText = attrTitle2;
    [self showProtocol];
}

/// 立即体验点击事件
- (void)onAuthClick {
    SudNFTBindUserParamModel *paramModel = SudNFTBindUserParamModel.new;
    paramModel.userId = AppService.shared.loginUserID;
    paramModel.walletType = self.walletInfoModel.type;
    paramModel.phoneCode = self.codeTextField.text;
    paramModel.phone = self.phoneTextField.text;
    [SudNFT bindUser:paramModel listener:^(NSInteger errCode, NSString *errMsg, SudNFTBindUserModel *resp) {
        if (errCode != 0) {
            NSString *msg = [NSString stringWithFormat:@"%@(%@)", errMsg, @(errCode)];
            [ToastUtil show:msg];
            return;
        }
        HSAppPreferences.shared.currentSelectedWalletType = paramModel.walletType;
        HSAppPreferences.shared.bindWalletType = paramModel.walletType;
        HSAppPreferences.shared.bindZoneType = self.walletInfoModel.zoneType;
        [HSAppPreferences.shared saveWalletTokenWithBindUserModel:resp walletType:paramModel.walletType phone:paramModel.phone];
        [ToastUtil show:@"授权成功"];
        if (self.bindSuccessBlock) {
            self.bindSuccessBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

/// 更换昵称点击事件
- (void)onGetCodeClick {
    WeakSelf
    self.getCodeBtn.enabled = NO;
    SudNFTSendVerifyCodeParamModel *paramModel = SudNFTSendVerifyCodeParamModel.new;
    paramModel.phone = self.phoneTextField.text;
    paramModel.walletType = self.walletInfoModel.type;
    [SudNFT sendPhoneCode:paramModel listener:^(NSInteger errCode, NSString *errMsg) {
        if (errCode != 0) {
            NSString *msg = [NSString stringWithFormat:@"%@(%@)", errMsg, @(errCode)];
            [ToastUtil show:msg];
            weakSelf.getCodeBtn.enabled = NO;
            return;
        }
        [weakSelf showCountdown];
    }];
}

- (void)showCountdown {
    WeakSelf
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@s", @(60)] forState:UIControlStateDisabled];
    self.countdownTimer = [DTTimer timerWithTimeCountdown:60
                                            progressBlock:^(DTTimer *timer, NSInteger currentCountdown) {
                                                [weakSelf.getCodeBtn setTitle:[NSString stringWithFormat:@"%@s", @(currentCountdown)] forState:UIControlStateDisabled];
                                            }
                                                 endBlock:^(DTTimer *timer) {
                                                     weakSelf.getCodeBtn.enabled = YES;
                                                 }];
}

- (void)showProtocol {
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:@"授权即代表您同意"];
    attrTitle.yy_font = UIFONT_REGULAR(12);
    attrTitle.yy_color = HEX_COLOR(@"#666666");
    attrTitle.yy_alignment = NSTextAlignmentCenter;

    NSString *protocolStr = [NSString stringWithFormat:@"%@用户协议、", self.walletInfoModel.name];
    NSString *privacyStr = [NSString stringWithFormat:@"%@隐私政策", self.walletInfoModel.name];

    NSMutableAttributedString *attrStr_1 = [[NSMutableAttributedString alloc] initWithString:protocolStr];
    attrStr_1.yy_lineSpacing = 6;
    attrStr_1.yy_font = UIFONT_MEDIUM(12);
    attrStr_1.yy_color = HEX_COLOR(@"#147AF9");

    NSMutableAttributedString *attrStr_3 = [[NSMutableAttributedString alloc] initWithString:privacyStr];
    attrStr_3.yy_lineSpacing = 6;
    attrStr_3.yy_font = UIFONT_MEDIUM(12);
    attrStr_3.yy_color = HEX_COLOR(@"#147AF9");
    WeakSelf
    [attrStr_1 yy_setTextHighlightRange:attrStr_1.yy_rangeOfAll color:[UIColor dt_colorWithHexString:@"#147AF9" alpha:1] backgroundColor:UIColor.clearColor tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
        DTWebViewController *web = DTWebViewController.new;
        web.url = weakSelf.walletInfoModel.servicePolicyURL;
        web.isPresent = true;
        BaseNavigationViewController *nv = [[BaseNavigationViewController alloc] initWithRootViewController:web];
        nv.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nv animated:YES completion:nil];
    }];
    [attrStr_3 yy_setTextHighlightRange:attrStr_3.yy_rangeOfAll color:[UIColor dt_colorWithHexString:@"#147AF9" alpha:1] backgroundColor:UIColor.clearColor tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
        DTWebViewController *web = DTWebViewController.new;
        web.url = weakSelf.walletInfoModel.privacyPolicyURL;
        web.isPresent = true;
        BaseNavigationViewController *nv = [[BaseNavigationViewController alloc] initWithRootViewController:web];
        nv.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nv animated:YES completion:nil];
    }];

    [attrTitle appendAttributedString:attrStr_1];
    [attrTitle appendAttributedString:attrStr_3];
    self.protocolLabel.attributedText = attrTitle;
}

- (void)dtLayoutViews {
    [self.leftImageView dt_cornerRadius:10];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.middleImageView.mas_leading).offset(-29);
        make.centerY.equalTo(self.middleImageView);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    [self.middleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(59);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(34, 24));
    }];
    [self.rightImageView dt_cornerRadius:10];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.middleImageView.mas_trailing).offset(29);
        make.centerY.equalTo(self.middleImageView);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(30);
        make.trailing.mas_equalTo(-30);
        make.top.mas_equalTo(self.leftImageView.mas_bottom).offset(60);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];

    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(30);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
        make.trailing.mas_equalTo(-30);
        make.height.mas_equalTo(48);
    }];
    [self.fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(30);
        make.top.mas_equalTo(self.phoneTextField.mas_bottom).offset(20);
        make.trailing.mas_equalTo(-30);
        make.height.mas_equalTo(48);
    }];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.top.bottom.equalTo(@0);
        make.trailing.equalTo(self.getCodeBtn.mas_leading);
    }];
    [self.getCodeBtn setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.fieldView);
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(48, 48));
    }];
    [self.registerTipTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(30);
        make.top.mas_equalTo(self.fieldView.mas_bottom).offset(12);
        make.height.with.mas_greaterThanOrEqualTo(0);
    }];

    [self.authTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(30);
        make.top.mas_equalTo(self.registerTipTitleLabel.mas_bottom).offset(30);
        make.height.with.mas_greaterThanOrEqualTo(0);
    }];

    [self.authOneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(30);
        make.top.mas_equalTo(self.authTitleLabel.mas_bottom).offset(15);
        make.height.with.equalTo(@16);
    }];

    [self.authOneTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.authOneImageView.mas_trailing).offset(9);
        make.top.mas_equalTo(self.authOneImageView);
        make.height.with.mas_greaterThanOrEqualTo(0);
    }];

    [self.authTwoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(30);
        make.top.mas_equalTo(self.authOneTipLabel.mas_bottom).offset(20);
        make.height.with.equalTo(@16);
    }];

    [self.authTwoTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.authTwoImageView.mas_trailing).offset(9);
        make.top.mas_equalTo(self.authTwoImageView);
        make.height.with.mas_greaterThanOrEqualTo(0);
    }];

    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(30);
        make.trailing.mas_equalTo(-30);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(-(kAppSafeBottom + 82));
    }];
    [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.mas_bottom).offset(12);
        make.leading.mas_equalTo(30);
        make.trailing.mas_equalTo(-30);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

@end

@implementation CNAuthViewController (LAZY)

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftImageView;
}

- (UIImageView *)middleImageView {
    if (!_middleImageView) {
        _middleImageView = [[UIImageView alloc] init];
        _middleImageView.image = [UIImage imageNamed:@"my_cn_nft_auth"];
    }
    return _middleImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = [UIImage imageNamed:@"my_cn_nft_auth_sud"];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = HEX_COLOR(@"#1A1A1A");
        _titleLabel.font = UIFONT_MEDIUM(14);
    }
    return _titleLabel;
}

- (YYLabel *)protocolLabel {
    if (!_protocolLabel) {
        _protocolLabel = [[YYLabel alloc] init];
        _protocolLabel.numberOfLines = 0;
    }
    return _protocolLabel;
}


- (UILabel *)registerTipTitleLabel {
    if (!_registerTipTitleLabel) {
        _registerTipTitleLabel = [[UILabel alloc] init];
        _registerTipTitleLabel.textColor = HEX_COLOR(@"#666666");
        _registerTipTitleLabel.font = UIFONT_REGULAR(12);
    }
    return _registerTipTitleLabel;
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

- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] init];
        _phoneTextField.text = @"";
        _phoneTextField.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _phoneTextField.textColor = HEX_COLOR(@"#1A1A1A");
        _phoneTextField.placeholder = @"请输入手机号";
        _phoneTextField.layer.borderWidth = 1;
        _phoneTextField.layer.borderColor = HEX_COLOR(@"#000000").CGColor;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 48)];
        _phoneTextField.leftView = leftView;
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
//        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 24)];
        [clearBtn setImage:[UIImage imageNamed:@"my_cn_nft_auth_close"] forState:UIControlStateNormal];
        clearBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 16);
        [clearBtn addTarget:self action:@selector(onClearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _phoneTextField.rightView = clearBtn;
        _phoneTextField.rightViewMode = UITextFieldViewModeWhileEditing;

    }
    return _phoneTextField;
}

- (void)onClearBtnClick:(id)sender {
    self.phoneTextField.text = nil;
}

- (UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc] init];
        _codeTextField.text = @"";
        _codeTextField.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _codeTextField.textColor = HEX_COLOR(@"#1A1A1A");
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _codeTextField;
}

- (UIButton *)getCodeBtn {
    if (!_getCodeBtn) {
        _getCodeBtn = [[UIButton alloc] init];
        _getCodeBtn.titleLabel.font = UIFONT_MEDIUM(16);
        [_getCodeBtn setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
        [_getCodeBtn setTitleColor:HEX_COLOR(@"#AAAAAA") forState:UIControlStateDisabled];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCodeBtn addTarget:self action:@selector(onGetCodeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getCodeBtn;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn setTitle:@"确认授权" forState:normal];
        _loginBtn.backgroundColor = UIColor.blackColor;
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_loginBtn setTitleColor:UIColor.whiteColor forState:normal];
        [_loginBtn addTarget:self action:@selector(onAuthClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UILabel *)authTitleLabel {
    if (!_authTitleLabel) {
        _authTitleLabel = [[UILabel alloc] init];
        _authTitleLabel.numberOfLines = 0;
        _authTitleLabel.textColor = HEX_COLOR(@"#1A1A1A");
        _authTitleLabel.font = UIFONT_MEDIUM(14);
    }
    return _authTitleLabel;
}

- (UIImageView *)authOneImageView {
    if (!_authOneImageView) {
        _authOneImageView = [[UIImageView alloc] init];
        _authOneImageView.image = [UIImage imageNamed:@"my_cn_nft_auth_tip_icon"];
    }
    return _authOneImageView;
}

- (UILabel *)authOneTipLabel {
    if (!_authOneTipLabel) {
        _authOneTipLabel = [[UILabel alloc] init];
        _authOneTipLabel.numberOfLines = 0;
        _authOneTipLabel.textColor = HEX_COLOR(@"#1A1A1A");
        _authOneTipLabel.font = UIFONT_MEDIUM(14);
    }
    return _authOneTipLabel;
}

- (UIImageView *)authTwoImageView {
    if (!_authTwoImageView) {
        _authTwoImageView = [[UIImageView alloc] init];
        _authTwoImageView.image = [UIImage imageNamed:@"my_cn_nft_auth_tip_icon"];
    }
    return _authTwoImageView;
}

- (UILabel *)authTwoTipLabel {
    if (!_authTwoTipLabel) {
        _authTwoTipLabel = [[UILabel alloc] init];
        _authTwoTipLabel.numberOfLines = 0;
        _authTwoTipLabel.textColor = HEX_COLOR(@"#1A1A1A");
        _authTwoTipLabel.font = UIFONT_MEDIUM(14);
    }
    return _authTwoTipLabel;
}

@end
