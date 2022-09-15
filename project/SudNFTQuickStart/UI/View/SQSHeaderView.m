//
// Created by kaniel on 2022/7/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SQSHeaderView.h"
//#import "UserDetailView.h"
#import "SQSBindWalletView.h"
#import "SQSNFTView.h"

@interface SQSHeaderView ()
@property(nonatomic, strong) SDAnimatedImageView *headerView;
@property(nonatomic, strong) UILabel *userNameLabel;
@property(nonatomic, strong) UILabel *userIdLabel;
@property(nonatomic, strong) DTPaddingLabel *walletAddressLabel;
@property(nonatomic, strong) UIView *nftView;
@property(nonatomic, strong) UIImageView *nftBgView;
@property(nonatomic, strong) SQSBindWalletView *bindView;
@property(nonatomic, strong) SQSNFTView *myNFTView;

@end

@implementation SQSHeaderView

- (void)dtConfigUI {
    self.backgroundColor = UIColor.whiteColor;
}

- (void)dtAddViews {
    [self addSubview:self.headerView];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.userIdLabel];
    [self addSubview:self.walletAddressLabel];
    [self addSubview:self.deleteBtn];
    [self addSubview:self.nftView];
    [self.nftView addSubview:self.nftBgView];
}

- (void)dtLayoutViews {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7 + kAppSafeTop);
        make.leading.mas_equalTo(8);
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
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-18);
        make.centerY.equalTo(self.headerView);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    [self.nftBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(@0);
    }];
    [self.nftView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.headerView.mas_bottom).offset(20);
        make.top.equalTo(@20);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
        make.bottom.equalTo(@-24);
    }];


}

- (void)dtUpdateUI {
//    AccountUserModel *userInfo = AppService.shared.login.loginUserInfo;
//    self.userNameLabel.text = userInfo.name;
//    self.userIdLabel.text = [NSString stringWithFormat:@"%@ %@", NSString.dt_home_user_id, userInfo.userID];
//    if (userInfo.icon.length > 0) {
//        SDWebImageContext *context = nil;
//        NSURL *url = [[NSURL alloc] initWithString:userInfo.icon];
//        if ([url.pathExtension caseInsensitiveCompare:@"svg"] == NSOrderedSame){
//            context = @{SDWebImageContextImageThumbnailPixelSize: @(CGSizeMake(200, 200))};
//        }
//        [self.headerView  sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed context:context progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        }];
//    }

    BOOL isBindWallet = SQSAppPreferences.shared.isBindWallet;
    if (isBindWallet) {
        // 绑定过了钱包
        if (SQSAppPreferences.shared.isBindForeignWallet) {
            self.walletAddressLabel.text = SQSAppPreferences.shared.walletAddress;
            self.walletAddressLabel.hidden = NO;
            self.userIdLabel.hidden = YES;
        } else {
            self.walletAddressLabel.hidden = YES;
            self.userIdLabel.hidden = NO;
        }
        self.deleteBtn.hidden = NO;
        self.deleteBtn.selected = SQSAppPreferences.shared.bindZoneType == 1;
        if (_bindView) {
            [_bindView removeFromSuperview];
            _bindView = nil;
        }
        if (!_myNFTView) {
            [self.nftView addSubview:self.myNFTView];
            [self.myNFTView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.trailing.bottom.equalTo(@0);
                make.height.greaterThanOrEqualTo(@0);
            }];
        }


    } else {
        // 未绑定钱包
        self.walletAddressLabel.hidden = YES;
        self.userIdLabel.hidden = NO;
        self.deleteBtn.hidden = YES;
        if (_myNFTView) {
            [_myNFTView removeFromSuperview];
            _myNFTView = nil;
        }
        if (!_bindView) {
            [self.nftView addSubview:self.bindView];
            [self.bindView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.trailing.bottom.equalTo(@0);
                make.height.greaterThanOrEqualTo(@0);
            }];
        }
        WeakSelf
        self.bindView.clickWalletBlock = ^(SudNFTWalletInfoModel *m) {
            if (weakSelf.clickWalletBlock) {
                weakSelf.clickWalletBlock(m);
            }
        };
    }
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    self.headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapHead:)];
    [self.headerView addGestureRecognizer:tap];
    [self.deleteBtn addTarget:self action:@selector(onDeleteWalletClick:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *walletTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapWalletAddressLabel:)];
    [self.walletAddressLabel addGestureRecognizer:walletTap];

}

- (void)onTapWalletAddressLabel:(id)tap {
    [AppUtil copyToPasteProcess:self.walletAddressLabel.text toast:@"复制成功"];
}

- (void)onTapHead:(id)tap {
    /// 展示用户金币信息
//    UserDetailView *v = [[UserDetailView alloc] init];
//    [DTAlertView show:v rootView:AppUtil.currentWindow clickToClose:YES showDefaultBackground:YES onCloseCallback:^{
//
//    }];
}

- (void)onDeleteWalletClick:(id)sender {
    if (self.deleteWalletBlock) {
        self.deleteWalletBlock();
    }
}

- (void)updateSupportWallet:(NSArray<SudNFTWalletModel *> *)walletList {
    [self.bindView updateSupportWallet:walletList];
}

- (void)updateNFTList:(SudNFTGetNFTListModel *)nftListModel {
    [self.myNFTView updateNFTList:nftListModel];
}

/// 更新藏品列表
- (void)updateCardList:(SudNFTGetCnNFTListModel *)cardListModel {
    [self.myNFTView updateCardList:cardListModel];
}

- (void)updateEthereumList:(NSArray<SudNFTChainInfoModel *> *)chains {
    [self.myNFTView updateEthereumList:chains];
}


- (SDAnimatedImageView *)headerView {
    if (!_headerView) {
        _headerView = [[SDAnimatedImageView alloc] init];
        _headerView.shouldCustomLoopCount = YES;
        _headerView.animationRepeatCount = NSIntegerMax;
        _headerView.clipsToBounds = true;
        _headerView.layer.cornerRadius = 56 / 2;
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


- (UIView *)nftView {
    if (!_nftView) {
        _nftView = [[UIView alloc] init];
    }
    return _nftView;
}

- (UIImageView *)nftBgView {
    if (!_nftBgView) {
        _nftBgView = [[UIImageView alloc] init];
        _nftBgView.image = [[UIImage imageNamed:@"nft_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(89, 170, 170, 88) resizingMode:UIImageResizingModeStretch];
        _nftBgView.userInteractionEnabled = YES;
    }
    return _nftBgView;
}



- (SQSBindWalletView *)bindView {
    if (!_bindView) {
        _bindView = [[SQSBindWalletView alloc] init];
    }
    return _bindView;
}

- (SQSNFTView *)myNFTView {
    if (!_myNFTView) {
        _myNFTView = [[SQSNFTView alloc] init];
    }
    return _myNFTView;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setImage:[UIImage imageNamed:@"wallet_delete"] forState:UIControlStateNormal];
        [_deleteBtn setImage:[UIImage imageNamed:@"my_cn_nft_bind"] forState:UIControlStateSelected];
        [_deleteBtn setImage:[UIImage imageNamed:@"my_cn_nft_bind"] forState:UIControlStateSelected | UIControlStateHighlighted];
    }
    return _deleteBtn;
}

@end