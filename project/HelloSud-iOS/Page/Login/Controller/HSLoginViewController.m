//
//  HSLoginViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "HSLoginViewController.h"
#import "HSGenderView.h"

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


@implementation HSLoginViewController (SET)

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
