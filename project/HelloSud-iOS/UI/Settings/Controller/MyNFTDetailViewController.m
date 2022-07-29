//
//  HomeViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "MyNFTDetailViewController.h"

@interface MyNFTDetailViewController ()
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *contractAddressLabel;
@property(nonatomic, strong) UILabel *tokenIDLabel;
@property(nonatomic, strong) UILabel *tokenStandLabel;
@property(nonatomic, strong) UIButton *copyBtn;
@property(nonatomic, strong) BaseView *topView;
@property(nonatomic, strong) BaseView *bottomView;
@property(nonatomic, strong) UIButton *wearBtn;
@property(nonatomic, strong) UIButton *backBtn;

@end

@implementation MyNFTDetailViewController
- (BOOL)dtIsHiddenNavigationBar {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dtConfigUI {
    self.iconImageView.backgroundColor = UIColor.orangeColor;
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)dtConfigEvents {
    WeakSelf
    [_backBtn addTarget:self action:@selector(dtNavigationBackClick) forControlEvents:UIControlEventTouchUpInside];
    [_wearBtn addTarget:self action:@selector(onWearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_copyBtn addTarget:self action:@selector(onCopyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onWearBtnClick:(UIButton *)sender {

    WeakSelf
    sender.enabled = NO;
    [SudNFT generateNFTDetailToken:self.cellModel.nftModel.contractAddress
                           tokenId:self.cellModel.nftModel.tokenId
                         chainType:HSAppPreferences.shared.selectedEthereumChainType
                          listener:^(NSInteger errCode, NSString *errMsg, SudNFTGenerateDetailTokenModel *generateDetailTokenModel) {
                              if (errCode != 0) {
                                  NSString *msg = [NSString stringWithFormat:@"%@(%@)", errMsg, @(errCode)];
                                  [ToastUtil show:msg];
                                  sender.enabled = YES;
                                  return;
                              }
                              [weakSelf handleWearDetailToken:generateDetailTokenModel.nftDetailsToken];
                          }];
}

- (void)onCopyBtnClick:(id)sender {
    [AppUtil copyToPasteProcess:self.cellModel.nftModel.contractAddress toast:@"地址已复制"];
}

/// 上报后台
/// @param nftDetailToken nftDetailToken
- (void)handleWearDetailToken:(NSString *)nftDetailToken {
    WeakSelf
    BOOL isWear = self.wearBtn.selected ? NO : YES;
    [UserService reqWearNFT:nftDetailToken isWear:isWear success:^(BaseRespModel *resp) {
        weakSelf.wearBtn.enabled = YES;
        [AppService.shared useNFT:weakSelf.cellModel.nftModel.contractAddress tokenId:weakSelf.cellModel.nftModel.tokenId add:isWear];
        [weakSelf updateWearBtn];
    }                  fail:^(NSError *error) {
        weakSelf.wearBtn.enabled = YES;
    }];
}

- (void)updateWearBtn {
    BOOL isUsed = [AppService.shared isNFTAlreadyUsed:self.cellModel.nftModel.contractAddress tokenId:self.cellModel.nftModel.tokenId];
    if (isUsed) {
        _wearBtn.selected = YES;
        _wearBtn.layer.borderWidth = 1;
        _wearBtn.layer.borderColor = UIColor.blackColor.CGColor;
        _wearBtn.backgroundColor = UIColor.whiteColor;
    } else {
        _wearBtn.selected = NO;
        _wearBtn.layer.borderWidth = 0;
        _wearBtn.layer.borderColor = nil;
        _wearBtn.backgroundColor = UIColor.blackColor;
    }
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
        make.trailing.equalTo(self.copyBtn.mas_leading).offset(-60);
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
    if (!self.cellModel) {
        return;
    }
    WeakSelf
    [self.cellModel getMetaData:^(HSNFTListCellModel *model, SudNFTMetaDataModel *metaDataModel) {
        [weakSelf updateWithMetadata:metaDataModel];
    }];
    [self updateWearBtn];
}


- (void)updateWithMetadata:(SudNFTMetaDataModel *)metaDataModel {
    self.nameLabel.text = metaDataModel.name;
    self.contractAddressLabel.attributedText = [self generate:@"Contract Address\n" subtitle:metaDataModel.contractAddress subColor:UIColor.blackColor];
    self.tokenIDLabel.attributedText = [self generate:@"Token ID\n" subtitle:metaDataModel.tokenId subColor:UIColor.blackColor];
    self.tokenStandLabel.attributedText = [self generate:@"Token Standard\n" subtitle:metaDataModel.tokenType subColor:UIColor.blackColor];
    if (metaDataModel.image) {
        [self.iconImageView sd_setImageWithURL:[[NSURL alloc] initWithString:metaDataModel.image]];
    }
}

- (NSAttributedString *)generate:(NSString *)title subtitle:(NSString *)subtitle subColor:(UIColor *)subColor {
    NSMutableAttributedString *fullAttr = [[NSMutableAttributedString alloc] initWithString:title];
    fullAttr.yy_font = UIFONT_REGULAR(14);
    fullAttr.yy_color = HEX_COLOR(@"#8A8A8E");

    NSMutableAttributedString *subtitleAttr = [[NSMutableAttributedString alloc] initWithString:subtitle ? subtitle : @""];
    subtitleAttr.yy_font = UIFONT_REGULAR(14);
    subtitleAttr.yy_color = subColor;
    subtitleAttr.yy_lineBreakMode = NSLineBreakByTruncatingMiddle;
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
        _iconImageView = [[UIImageView alloc] init];
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
        _contractAddressLabel.numberOfLines = 2;
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
        [_wearBtn setTitle:@"取消穿戴" forState:UIControlStateSelected];
        [_wearBtn setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateSelected];

        _wearBtn.titleLabel.font = UIFONT_BOLD(14);
    }
    return _wearBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[[UIImage imageNamed:@"navi_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_backBtn setTintColor:UIColor.whiteColor];
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
        _bottomView.layer.shadowColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.0800].CGColor;
        _bottomView.layer.shadowOffset = CGSizeMake(0, 0);
        _bottomView.layer.shadowOpacity = 1;
        _bottomView.layer.shadowRadius = 10;
        _bottomView.backgroundColor = UIColor.whiteColor;
    }
    return _bottomView;
}
@end
