//
//  SearchHeaderView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "SearchHeaderView.h"
#import "UserDetailView.h"

@interface SearchHeaderView () <UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userIdLabel;
@property(nonatomic, strong) DTPaddingLabel *walletAddressLabel;
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
    [self addSubview:self.walletAddressLabel];
    [self addSubview:self.textFieldView];
    [self.textFieldView addSubview:self.searchTextField];
    [self.textFieldView addSubview:self.searchBtn];
}

- (void)dtLayoutViews {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7 + kAppSafeTop);
        make.leading.mas_equalTo(24);
        make.size.mas_equalTo(CGSizeMake(56, 56));
    }];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.headerView.mas_trailing).offset(10);
        make.top.mas_equalTo(self.headerView.mas_top).offset(3);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.headerView.mas_trailing).offset(10);
        make.top.mas_equalTo(self.userNameLabel.mas_bottom).offset(6);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.walletAddressLabel dt_cornerRadius:10];
    [self.walletAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.headerView.mas_trailing).offset(10);
        make.top.mas_equalTo(self.userNameLabel.mas_bottom).offset(6);
        make.width.equalTo(@160);
        make.height.equalTo(@20);
    }];
    [self.textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(24);
        make.trailing.mas_equalTo(-24);
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(15);
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
    AccountUserModel *userInfo = AppService.shared.login.loginUserInfo;
    self.userNameLabel.text = userInfo.name;
    self.userIdLabel.text = [NSString stringWithFormat:@"%@ %@", NSString.dt_home_user_id, userInfo.userID];
    if (userInfo.icon.length > 0) {
        SDWebImageContext *context = nil;
        NSURL *url = [[NSURL alloc] initWithString:userInfo.icon];
        if ([url.pathExtension caseInsensitiveCompare:@"svg"] == NSOrderedSame){
            context = @{SDWebImageContextImageThumbnailPixelSize: @(CGSizeMake(200, 200))};
        }
        [self.headerView  sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed context:context progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
    }
    BOOL isBindWallet = HSAppPreferences.shared.walletAddress.length > 0;
    if (isBindWallet) {
        // 绑定过了钱包
        self.walletAddressLabel.text = HSAppPreferences.shared.walletAddress;
        self.walletAddressLabel.hidden = NO;
        self.userIdLabel.hidden = YES;
    } else {
        // 未绑定钱包
        self.walletAddressLabel.hidden = YES;
        self.userIdLabel.hidden = NO;
    }
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    self.headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapHead:)];
    [self.headerView addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserverForName:MY_NFT_WEAR_CHANGE_NTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
        [weakSelf dtUpdateUI];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:MY_NFT_BIND_WALLET_CHANGE_NTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
        [weakSelf dtUpdateUI];
    }];

    UITapGestureRecognizer *walletTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapWalletAddressLabel:)];
    [self.walletAddressLabel addGestureRecognizer:walletTap];

}

- (void)onTapWalletAddressLabel:(id)tap {
    [AppUtil copyToPasteProcess:self.walletAddressLabel.text toast:@"复制成功"];
}

- (void)onTapHead:(id)tap {
    /// 展示用户金币信息
    UserDetailView *v = [[UserDetailView alloc] init];
    [DTAlertView show:v rootView:AppUtil.currentWindow clickToClose:YES showDefaultBackground:YES onCloseCallback:^{

    }];
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
        _searchTextField.textAlignment = NSTextAlignmentLeft;
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

- (DTPaddingLabel *)walletAddressLabel {
    if (!_walletAddressLabel) {
        _walletAddressLabel = [[DTPaddingLabel alloc] init];
        _walletAddressLabel.paddingX = 8;
        _walletAddressLabel.isPaddingXUseForFixedWidth = YES;
        _walletAddressLabel.textColor = [UIColor dt_colorWithHexString:@"#333333" alpha:1];
        _walletAddressLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _walletAddressLabel.backgroundColor = HEX_COLOR_A(@"#DBDEEC", 0.7);
        _walletAddressLabel.hidden = YES;
        _walletAddressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _walletAddressLabel.textAlignment = NSTextAlignmentCenter;
        _walletAddressLabel.userInteractionEnabled = YES;
    }
    return _walletAddressLabel;
}

- (void)enterEvent {
    [self.searchTextField resignFirstResponder];
    NSString *searchText = self.searchTextField.text;
    WeakSelf
    [AudioRoomService reqEnterRoom:searchText.longLongValue isFromCreate:NO success:^{
        weakSelf.searchTextField.text = nil;
    }                         fail:^(NSError *error) {
        weakSelf.searchTextField.text = @"";
        [weakSelf.searchBtn setHidden:true];
    }];
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
