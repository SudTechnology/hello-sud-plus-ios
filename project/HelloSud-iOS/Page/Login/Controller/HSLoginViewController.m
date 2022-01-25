//
//  HSLoginViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "HSLoginViewController.h"
#import "HSGenderView.h"
#import "HSSweetPromptView.h"

@interface HSLoginViewController ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *fieldView;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) HSGenderView *maleView;
@property (nonatomic, strong) HSGenderView *femaleView;
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation HSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)hsAddViews {
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.fieldView];
    [self.fieldView addSubview:self.nameTextField];
    [self.view addSubview:self.maleView];
    [self.view addSubview:self.femaleView];
    [self.view addSubview:self.loginBtn];
}

- (void)hsConfigEvents {
    WeakSelf
    self.maleView.selectBlock = ^{
        weakSelf.maleView.isSelect = true;
        weakSelf.femaleView.isSelect = false;
    };
    self.femaleView.selectBlock = ^{
        weakSelf.maleView.isSelect = false;
        weakSelf.femaleView.isSelect = true;
    };
}

/// 立即体验点击事件
- (void)loginNodeEvent {
}

- (void)showWelcomeUse {
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:@"欢迎使用HelloSud\n"];
    attrTitle.yy_lineSpacing = 6;
    attrTitle.yy_font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    attrTitle.yy_color = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
    
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
    
    [HSAlertView showAttrTextAlert:attrTitle sureText:@"同意" cancelText:@"不同意" onSureCallback:^{
        
    } onCloseCallback:^{
        
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
    [self.fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(32);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(48);
    }];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
    [self.maleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.nameTextField.mas_bottom).offset(20);
        make.height.mas_equalTo(48);
    }];
    [self.femaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.maleView.mas_right).offset(15);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(self.nameTextField.mas_bottom).offset(20);
        make.width.mas_equalTo(self.maleView.mas_width);
        make.height.mas_equalTo(48);
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(self.maleView.mas_bottom).offset(146);
        make.height.mas_equalTo(44);
    }];
}

@end


@implementation HSLoginViewController (LAZY)

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
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    }
    return _titleLabel;
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
        _nameTextField.placeholder = @"请输入你的昵称";
        _nameTextField.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _nameTextField.textColor = UIColor.blackColor;
    }
    return _nameTextField;
}

- (HSGenderView *)maleView {
    if (!_maleView) {
        _maleView = [[HSGenderView alloc] init];
        _maleView.nameStr = @"男";
        _maleView.iconStr = @"login_sex_male";
        _maleView.isSelect = true;
    }
    return _maleView;
}

- (HSGenderView *)femaleView {
    if (!_femaleView) {
        _femaleView = [[HSGenderView alloc] init];
        _femaleView.nameStr = @"女";
        _femaleView.iconStr = @"login_sex_female";
        _femaleView.isSelect = false;
    }
    return _femaleView;
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
