//
//  HomeViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "MyNFTDetailViewController.h"

@interface MyNFTDetailViewController ()
@property(nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contractAddressLabel;
@property (nonatomic, strong) UILabel *tokenIDLabel;
@property (nonatomic, strong) UILabel *tokenStandLabel;
@property (nonatomic, strong) UIButton *copyBtn;
@property (nonatomic, strong) BaseView *topView;
@property (nonatomic, strong) BaseView *bottomView;
@property (nonatomic, strong) UIButton *wearBtn;
@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation MyNFTDetailViewController
- (BOOL)dtIsHiddenNavigationBar {
    return YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)dtConfigUI {
    self.iconImageView.backgroundColor = UIColor.orangeColor;
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)dtConfigEvents {
    WeakSelf

}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dtAddViews {
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.contractAddressLabel];
    [self.view addSubview:self.tokenIDLabel];
    [self.view addSubview:self.tokenStandLabel];
    [self.view addSubview:self.copyBtn];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.wearBtn];
    [self.view addSubview:self.backBtn];
}

- (void)dtLayoutViews {

    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.height.equalTo(@(kScreenWidth));
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.height.equalTo(@(30));
        make.bottom.equalTo(self.iconImageView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.height.equalTo(@22);
        make.top.equalTo(self.iconImageView.mas_bottom);
    }];
    [self.contractAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.equalTo(self.copyBtn.mas_leading);
        make.height.greaterThanOrEqualTo(@0);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(28);
    }];
    [self.copyBtn setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.contractAddressLabel.mas_bottom);
    }];
    [self.tokenIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.equalTo(self.copyBtn.mas_leading);
        make.height.greaterThanOrEqualTo(@0);
        make.top.equalTo(self.contractAddressLabel.mas_bottom).offset(14);
    }];
    [self.tokenStandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.equalTo(self.copyBtn.mas_leading);
        make.height.greaterThanOrEqualTo(@0);
        make.top.equalTo(self.tokenIDLabel.mas_bottom).offset(14);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@102);
        make.bottom.equalTo(@0);
    }];
    [self.wearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.equalTo(@-16);
        make.height.equalTo(@44);
        make.top.equalTo(self.bottomView).offset(12);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(54);
        make.width.height.equalTo(@(24));
    }];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    self.nameLabel.text = @"一只小猴猴";

    self.contractAddressLabel.attributedText = [self generate:@"Contract Address\n" subtitle:@"0x3u2e3u20ur3u432" subColor:UIColor.blackColor];
    self.tokenIDLabel.attributedText = [self generate:@"Token ID\n" subtitle:@"12345" subColor:UIColor.blackColor];
    self.tokenStandLabel.attributedText = [self generate:@"Token Standard\n" subtitle:@"ERC-877" subColor:UIColor.blackColor];
}

- (NSAttributedString *)generate:(NSString *)title subtitle:(NSString *)subtitle subColor:(UIColor *)subColor {
    NSMutableAttributedString *fullAttr = [[NSMutableAttributedString alloc] initWithString:title];
    fullAttr.yy_font = UIFONT_REGULAR(14);
    fullAttr.yy_color = HEX_COLOR(@"#8A8A8E");

    NSMutableAttributedString *subtitleAttr = [[NSMutableAttributedString alloc] initWithString:subtitle];
    subtitleAttr.yy_font = UIFONT_REGULAR(14);
    subtitleAttr.yy_color = subColor;
    [fullAttr appendAttributedString:subtitleAttr];
    return fullAttr;
}

#pragma mark - requst Data

- (void)requestData {
    WeakSelf

}

#pragma mark - 懒加载

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textColor = HEX_COLOR(@"#1A1A1A");
        _nameLabel.font = UIFONT_MEDIUM(16);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)contractAddressLabel {
    if (!_contractAddressLabel) {
        _contractAddressLabel = [[UILabel alloc] init];
        _contractAddressLabel.text = @"";
        _contractAddressLabel.textColor = UIColor.blackColor;
        _contractAddressLabel.font = UIFONT_BOLD(16);
        _contractAddressLabel.textAlignment = NSTextAlignmentLeft;
        _contractAddressLabel.numberOfLines = 0;
    }
    return _contractAddressLabel;
}

- (UILabel *)tokenIDLabel {
    if (!_tokenIDLabel) {
        _tokenIDLabel = [[UILabel alloc] init];
        _tokenIDLabel.text = @"";
        _tokenIDLabel.textColor = UIColor.blackColor;
        _tokenIDLabel.font = UIFONT_BOLD(16);
        _tokenIDLabel.textAlignment = NSTextAlignmentLeft;
        _tokenIDLabel.numberOfLines = 0;
    }
    return _tokenIDLabel;
}

- (UILabel *)tokenStandLabel {
    if (!_tokenStandLabel) {
        _tokenStandLabel = [[UILabel alloc] init];
        _tokenStandLabel.text = @"";
        _tokenStandLabel.textColor = UIColor.blackColor;
        _tokenStandLabel.font = UIFONT_BOLD(16);
        _tokenStandLabel.textAlignment = NSTextAlignmentLeft;
        _tokenStandLabel.numberOfLines = 0;
    }
    return _tokenStandLabel;
}

- (UIButton *)copyBtn {
    if (!_copyBtn) {
        _copyBtn = [[UIButton alloc] init];
        [_copyBtn setTitle:@"复制" forState:UIControlStateNormal];
        [_copyBtn setTitleColor:HEX_COLOR(@"#0053FF") forState:UIControlStateNormal];
        _copyBtn.titleLabel.font = UIFONT_BOLD(16);
    }
    return _copyBtn;
}

- (UIButton *)wearBtn {
    if (!_wearBtn) {
        _wearBtn = [[UIButton alloc] init];
        [_wearBtn setTitle:@"穿戴" forState:UIControlStateNormal];
        [_wearBtn setTitleColor:HEX_COLOR(@"#ffffff") forState:UIControlStateNormal];
        _wearBtn.titleLabel.font = UIFONT_BOLD(14);
        _wearBtn.backgroundColor = UIColor.blackColor;
    }
    return _wearBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[[UIImage imageNamed:@"navi_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_backBtn setTintColor:UIColor.whiteColor];
        [_backBtn addTarget:self action:@selector(dtNavigationBackClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (BaseView *)topView {
    if (!_topView) {
        _topView = [[BaseView alloc] init];
        _topView.backgroundColor = UIColor.whiteColor;
        [_topView setPartRoundCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:20];
    }
    return _topView;
}

- (BaseView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[BaseView alloc] init];
        _bottomView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0800].CGColor;
        _bottomView.layer.shadowOffset = CGSizeMake(0,0);
        _bottomView.layer.shadowOpacity = 1;
        _bottomView.layer.shadowRadius = 10;
        _bottomView.backgroundColor = UIColor.whiteColor;
    }
    return _bottomView;
}
@end
