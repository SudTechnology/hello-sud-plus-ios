//
// Created by kaniel on 2022/4/1.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "UserWearNftDetailView.h"

@interface UserWearNftDetailView ()
@property(nonatomic, strong) UIImageView *headerView;
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *userNameLabel;
@property(nonatomic, strong) UILabel *userIdLabel;
@property(nonatomic, strong) UIView *coinContentView;
@property(nonatomic, strong) UIImageView *coinImageView;
@property(nonatomic, strong) UILabel *coinLabel;

@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *descLabel;
@property(nonatomic, strong) UILabel *contractAddressLabel;
@property(nonatomic, strong) UILabel *tokenIDLabel;
@property(nonatomic, strong) UILabel *tokenStandLabel;
@end

@implementation UserWearNftDetailView

- (void)reqData {
    WeakSelf
    [UserService.shared reqUserCoinDetail:^(int64_t i) {
        [weakSelf dtUpdateUI];
        weakSelf.coinLabel.text = [NSString stringWithFormat:@"%lld", i];
    }                                fail:^(NSString *errStr) {
        [ToastUtil show:errStr];
    }];
}

- (void)dtConfigUI {
    self.backgroundColor = UIColor.whiteColor;
    [self reqData];
    [self dtUpdateUI];
}

- (void)dtAddViews {
    [self addSubview:self.headerView];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.userIdLabel];
    [self addSubview:self.coinContentView];
    [self.coinContentView addSubview:self.coinImageView];
    [self.coinContentView addSubview:self.coinLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.contractAddressLabel];
    [self addSubview:self.tokenIDLabel];
    [self addSubview:self.tokenStandLabel];
}

- (void)dtLayoutViews {

    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.top.mas_equalTo(24);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.userNameLabel);
        make.top.mas_equalTo(self.userNameLabel.mas_bottom).offset(4);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.coinContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@30);
        make.height.mas_equalTo(30);
        make.width.mas_greaterThanOrEqualTo(0);
        make.trailing.equalTo(@-16);
    }];
    [self.coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(14);
        make.leading.mas_equalTo(18);
        make.centerY.equalTo(self.coinContentView);
    }];
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_greaterThanOrEqualTo(0);
        make.leading.equalTo(self.coinImageView.mas_trailing).offset(3);
        make.centerY.equalTo(self.coinContentView);
        make.trailing.mas_equalTo(-19);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.top.equalTo(self.userIdLabel.mas_bottom).offset(19);
        make.height.equalTo(@0.5);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.top.equalTo(self.lineView.mas_bottom).offset(12);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.height.equalTo(@22);
        make.top.equalTo(self.headerView.mas_bottom).offset(24);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.height.greaterThanOrEqualTo(@0);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(18);
    }];

    [self.contractAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.equalTo(@-118);
        make.height.greaterThanOrEqualTo(@0);
        make.top.equalTo(self.descLabel.mas_bottom).offset(14);
    }];

    [self.tokenIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.width.equalTo(self.contractAddressLabel);
        make.height.greaterThanOrEqualTo(@0);
        make.top.equalTo(self.contractAddressLabel.mas_bottom).offset(14);
    }];

    CGFloat b = kAppSafeBottom + 14;
    [self.tokenStandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.equalTo(@-16);
        make.height.greaterThanOrEqualTo(@0);
        make.top.equalTo(self.tokenIDLabel.mas_bottom).offset(14);
        make.bottom.equalTo(@(-b));
    }];
}

- (void)dtUpdateUI {
    AccountUserModel *userInfo = AppService.shared.login.loginUserInfo;
    self.userNameLabel.text = userInfo.name;
    self.userIdLabel.text = [NSString stringWithFormat:@"%@ %@", NSString.dt_home_user_id, userInfo.userID];
    if (userInfo.icon.length > 0) {
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:userInfo.icon]];
    }
    self.titleLabel.text = @"NFT详情";

    WeakSelf

    BOOL isCNBind = HsNFTPreferences.shared.isBindCNWallet;
    NSString *contractTitle = @"Contract Address\n";
    NSString *tokenIDTitle = @"Token ID\n";
    NSString *contractAddress = @"";
    NSString *tokenId = @"";
    NSString *tokenType = @"";
    NSString *name = @"";
    NSString *descTitle = @"Description\n";
    NSString *desc = @"";
    if (isCNBind) {
        contractTitle = @"地址\n";
        tokenIDTitle = @"令牌ID\n";
        descTitle = @"作品描述\n";
        SudNFTCnInfoModel *cardModel = HsNFTPreferences.shared.wearCnNftModel;
        contractAddress = cardModel.cardHash;
        tokenId = cardModel.chainAddr;
        name = cardModel.name;
        desc = cardModel.desc;
    } else {
        SudNFTInfoModel *nftModel = HsNFTPreferences.shared.wearNftModel;
        contractAddress = nftModel.contractAddress;
        tokenId = nftModel.tokenId;
        tokenType = nftModel.tokenType;
        name = nftModel.name;
        desc = nftModel.desc;
    }
    self.nameLabel.text = name;
    self.descLabel.attributedText = [self generate:descTitle subtitle:desc subColor:HEX_COLOR(@"#8A8A8E") tailImageName:nil];
    self.contractAddressLabel.attributedText = [self generate:contractTitle subtitle:contractAddress subColor:HEX_COLOR(@"#8A8A8E") tailImageName:@"nft_detail_copy"];
    self.tokenIDLabel.attributedText = [self generate:tokenIDTitle subtitle:tokenId subColor:HEX_COLOR(@"#8A8A8E") tailImageName:@"nft_detail_copy"];
    self.tokenStandLabel.attributedText = [self generate:@"Token Standard\n" subtitle:tokenType subColor:HEX_COLOR(@"#8A8A8E") tailImageName:nil];
    self.tokenStandLabel.hidden = tokenType.length == 0;
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    UITapGestureRecognizer *addrTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAddrTap:)];
    [self.contractAddressLabel addGestureRecognizer:addrTap];
    UITapGestureRecognizer *tokenTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTokenTap:)];
    [self.tokenIDLabel addGestureRecognizer:tokenTap];
}

- (void)onAddrTap:(id)sender {
    NSString *contractAddress = @"";
    if (HsNFTPreferences.shared.isBindCNWallet) {
        SudNFTCnInfoModel *cardModel = HsNFTPreferences.shared.wearCnNftModel;
        contractAddress = cardModel.cardHash;
    } else if (HsNFTPreferences.shared.isBindForeignWallet) {
        SudNFTInfoModel *nftModel = HsNFTPreferences.shared.wearNftModel;
        contractAddress = nftModel.contractAddress;
    }
    [AppUtil copyToPasteProcess:contractAddress toast:@"复制成功"];
}

- (void)onTokenTap:(id)sender {
    NSString *tokenId = @"";
    if (HsNFTPreferences.shared.isBindCNWallet) {
        SudNFTCnInfoModel *cardModel = HsNFTPreferences.shared.wearCnNftModel;
        tokenId = cardModel.chainAddr;
    } else if (HsNFTPreferences.shared.isBindForeignWallet) {
        SudNFTInfoModel *nftModel = HsNFTPreferences.shared.wearNftModel;
        tokenId = nftModel.tokenId;
    }
    [AppUtil copyToPasteProcess:tokenId toast:@"复制成功"];
}

- (void)showLoadAnimate {

    [self closeLoadAnimate];
    CGColorRef whiteBegin = HEX_COLOR_A(@"#000000", 0.05).CGColor;
    CGColorRef whiteEnd = HEX_COLOR_A(@"#000000", 0.1).CGColor;
    CGFloat duration = 0.6;
    CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    anim1.duration = duration;
    anim1.fromValue = (__bridge id) whiteBegin;
    anim1.toValue = (__bridge id) whiteEnd;

    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    anim2.beginTime = duration;
    anim2.duration = duration;
    anim2.fromValue = (__bridge id) whiteEnd;
    anim2.toValue = (__bridge id) whiteBegin;

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = duration * 2;
    group.animations = @[anim1, anim2];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.repeatCount = 10000000;

    [self.headerView.layer addAnimation:group forKey:@"animate_background"];
}

- (void)closeLoadAnimate {
    [self.headerView.layer removeAllAnimations];
}

- (NSAttributedString *)generate:(NSString *)title subtitle:(NSString *)subtitle subColor:(UIColor *)subColor tailImageName:(NSString *)imageName {
    NSMutableAttributedString *fullAttr = [[NSMutableAttributedString alloc] initWithString:title];
    fullAttr.yy_font = UIFONT_REGULAR(14);
    fullAttr.yy_color = HEX_COLOR(@"#000000");

    subtitle = subtitle ? subtitle : @"";
    subtitle = [NSString stringWithFormat:@"%@ ", subtitle];
    NSMutableAttributedString *subtitleAttr = [[NSMutableAttributedString alloc] initWithString:subtitle];
    subtitleAttr.yy_font = UIFONT_REGULAR(14);
    subtitleAttr.yy_color = subColor;
    subtitleAttr.yy_lineBreakMode = NSLineBreakByTruncatingMiddle;
    [fullAttr appendAttributedString:subtitleAttr];
    if (imageName) {
        NSAttributedString *iconAttr = [NSAttributedString dt_attrWithImage:[UIImage imageNamed:imageName] size:CGSizeMake(16, 17) offsetY:-3];
        [fullAttr appendAttributedString:iconAttr];
    }
    return fullAttr;
}

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.clipsToBounds = true;
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.text = @"";
        _userNameLabel.numberOfLines = 1;
        _userNameLabel.textColor = [UIColor dt_colorWithHexString:@"#13141A" alpha:1];
        _userNameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    }
    return _userNameLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEX_COLOR(@"#D1D1D1");
    }
    return _lineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.numberOfLines = 1;
        _titleLabel.textColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        _titleLabel.font = UIFONT_MEDIUM(16);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)userIdLabel {
    if (!_userIdLabel) {
        _userIdLabel = [[UILabel alloc] init];
        _userIdLabel.numberOfLines = 1;
        _userIdLabel.textColor = [UIColor dt_colorWithHexString:@"#13141A" alpha:1];
        _userIdLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    }
    return _userIdLabel;
}

- (UIView *)coinContentView {
    if (!_coinContentView) {
        _coinContentView = [[UIView alloc] init];
        _coinContentView.clipsToBounds = true;
        _coinContentView.backgroundColor = HEX_COLOR_A(@"#000000", 0.04);
        [_coinContentView dt_cornerRadius:15];
    }
    return _coinContentView;
}

- (UIImageView *)coinImageView {
    if (!_coinImageView) {
        _coinImageView = [[UIImageView alloc] init];
        _coinImageView.image = [UIImage imageNamed:@"coin"];
    }
    return _coinImageView;
}

- (UILabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[UILabel alloc] init];
        _coinLabel.text = @"0";
        _coinLabel.numberOfLines = 1;
        _coinLabel.textColor = [UIColor dt_colorWithHexString:@"#F6A209" alpha:1];
        _coinLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    }
    return _coinLabel;
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

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.text = @"";
        _descLabel.textColor = HEX_COLOR(@"#0053FF");
        _descLabel.font = UIFONT_BOLD(16);
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.numberOfLines = 0;
        _descLabel.userInteractionEnabled = YES;
    }
    return _descLabel;
}


- (UILabel *)contractAddressLabel {
    if (!_contractAddressLabel) {
        _contractAddressLabel = [[UILabel alloc] init];
        _contractAddressLabel.text = @"";
        _contractAddressLabel.textColor = HEX_COLOR(@"#0053FF");
        _contractAddressLabel.font = UIFONT_BOLD(16);
        _contractAddressLabel.textAlignment = NSTextAlignmentLeft;
        _contractAddressLabel.numberOfLines = 2;
        _contractAddressLabel.userInteractionEnabled = YES;
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
        _tokenIDLabel.numberOfLines = 2;
        _tokenIDLabel.userInteractionEnabled = YES;
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
@end