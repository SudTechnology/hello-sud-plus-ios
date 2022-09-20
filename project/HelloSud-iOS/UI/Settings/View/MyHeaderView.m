//
// Created by kaniel on 2022/7/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "MyHeaderView.h"
#import "UserDetailView.h"
#import "MyBindWalletView.h"
#import "MyNFTView.h"
#import "UserWearNftDetailView.h"
#import "WalletAddressSwitchPopView.h"
#import "WalletAddressSwitchCellModel.h"
#import "TipPopView.h"

@interface MyHeaderView ()
@property(nonatomic, strong) SDAnimatedImageView *headerView;
@property(nonatomic, strong) UILabel *userNameLabel;
@property(nonatomic, strong) UILabel *userIdLabel;
@property(nonatomic, strong) DTPaddingLabel *walletAddressLabel;
@property(nonatomic, strong) UIView *nftView;
@property(nonatomic, strong) UIImageView *nftBgView;
@property(nonatomic, strong) MyBindWalletView *bindView;
@property(nonatomic, strong) MyNFTView *myNFTView;
@property(nonatomic, strong) UIButton *deleteBtn;
@property(nonatomic, strong) NSArray <WalletAddressSwitchCellModel *> *walletAddressCellModelList;
@property(nonatomic, strong) NSArray<SudNFTWalletInfoModel *> *walletList;
@property(nonatomic, strong) TipPopView *tipView;
@end

@implementation MyHeaderView

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
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(20);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
        make.bottom.equalTo(@-24);
    }];


}

- (void)dtUpdateUI {
    AccountUserModel *userInfo = AppService.shared.login.loginUserInfo;
    self.userNameLabel.text = userInfo.name;
    self.userIdLabel.text = [NSString stringWithFormat:@"%@ %@", NSString.dt_home_user_id, userInfo.userID];
    if (userInfo.icon.length > 0) {
        SDWebImageContext *context = nil;
        NSURL *url = [[NSURL alloc] initWithString:userInfo.icon];
        if ([url.pathExtension caseInsensitiveCompare:@"svg"] == NSOrderedSame) {
            context = @{SDWebImageContextImageThumbnailPixelSize: @(CGSizeMake(200, 200))};
        }
        [self.headerView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed context:context progress:nil completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
        }];
    }
    [self.headerView viewWithTag:100].hidden = userInfo.isWearNFT ? NO : YES;
    BOOL isBindWallet = HsNFTPreferences.shared.isBindWallet;
    if (isBindWallet) {
        // 绑定过了钱包
        if (HsNFTPreferences.shared.isBindForeignWallet) {
            NSString *str = [NSString stringWithFormat:@"%@ ", HsNFTPreferences.shared.currentWalletAddress];
            NSMutableAttributedString *fullAttr = [[NSMutableAttributedString alloc] initWithString:str];
            fullAttr.yy_font = UIFONT_REGULAR(12);
            fullAttr.yy_color = HEX_COLOR(@"#333333");
            NSAttributedString *iconAttr = [NSAttributedString dt_attrWithImage:[UIImage imageNamed:@"more_address"] size:CGSizeMake(12, 12) offsetY:-2];
            [fullAttr appendAttributedString:iconAttr];

            self.walletAddressLabel.attributedText = fullAttr;
            self.walletAddressLabel.hidden = NO;
            self.userIdLabel.hidden = YES;
        } else {
            self.walletAddressLabel.hidden = YES;
            self.userIdLabel.hidden = NO;
        }
        self.deleteBtn.hidden = NO;
        self.deleteBtn.selected = HsNFTPreferences.shared.bindZoneType == 1;
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
        [self.bindView updateSupportWallet:self.walletList];
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
    WeakSelf
    self.headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapHead:)];
    [self.headerView addGestureRecognizer:tap];
    [self.deleteBtn addTarget:self action:@selector(onDeleteWalletClick:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *walletTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapWalletAddressLabel:)];
    [self.walletAddressLabel addGestureRecognizer:walletTap];
    [[NSNotificationCenter defaultCenter] addObserverForName:MY_NFT_BIND_WALLET_CHANGE_NTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
        [weakSelf dtUpdateUI];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:MY_SWITCH_TIP_STATE_CHANGED_NTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
        [weakSelf showTipIfNeed];
    }];

}

/// 展示提示
- (void)showTipIfNeed {
    
    if (HsNFTPreferences.shared.bindZoneType != 0) {
        if (_tipView) {
            [_tipView removeFromSuperview];
        }
        return;
    }
    
    if (!HsNFTPreferences.shared.isShowedSwitchWalletAddress) {
        [self addSubview:self.tipView];
        [self.tipView updateTip:@"点击切换地址"];
        [self.tipView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.greaterThanOrEqualTo(@0);
            make.bottom.equalTo(self.walletAddressLabel.mas_top);
            make.centerX.equalTo(self.walletAddressLabel.mas_right).offset(-17);
        }];
    } else if (!HsNFTPreferences.shared.isShowedSwitchChain) {
        [self addSubview:self.tipView];
        [self.tipView updateTip:@"点击切换网络"];
        [self.tipView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.greaterThanOrEqualTo(@0);
            make.bottom.equalTo(self.myNFTView.mas_top);
            make.centerX.equalTo(self.myNFTView);
        }];
    } else if (_tipView) {
        [_tipView removeFromSuperview];
    }
}

/// 移除tip提示
- (void)removeTipView {
    [_tipView removeFromSuperview];
}

- (void)onTapWalletAddressLabel:(id)tap {
//    [AppUtil copyToPasteProcess:self.walletAddressLabel.text toast:@"复制成功"];
    [self refreshWalletAddressList];
    HsNFTPreferences.shared.isShowedSwitchWalletAddress = YES;
    WalletAddressSwitchPopView *v = WalletAddressSwitchPopView.new;
    [v updateCellModelList:self.walletAddressCellModelList];
    [DTAlertView show:v rootView:nil clickToClose:YES showDefaultBackground:YES onCloseCallback:nil];
}

- (void)onTapHead:(id)tap {
    AccountUserModel *userInfo = AppService.shared.login.loginUserInfo;
    BOOL isWearNft = userInfo.isWearNFT;
    if (isWearNft) {
        UserWearNftDetailView *v = UserWearNftDetailView.new;
        [DTSheetView show:v rootView:nil hiddenBackCover:NO onCloseCallback:nil];
    } else {
        /// 展示用户金币信息
        UserDetailView *v = [[UserDetailView alloc] init];
        [DTAlertView show:v rootView:AppUtil.currentWindow clickToClose:YES showDefaultBackground:YES onCloseCallback:^{

        }];
    }
}

- (void)onDeleteWalletClick:(id)sender {
    if (self.deleteWalletBlock) {
        self.deleteWalletBlock();
    }
}

- (void)updateSupportWallet:(NSArray<SudNFTWalletInfoModel *> *)walletList {
    self.walletList = walletList;
    [self refreshWalletAddressList];
    [self dtUpdateUI];
}

- (void)refreshWalletAddressList {
    NSMutableArray *arr = NSMutableArray.new;
    for (SudNFTWalletInfoModel *m in self.walletList) {
        if (m.zoneType == 0 && [HsNFTPreferences.shared isBindWalletWithType:m.type]) {
            WalletAddressSwitchCellModel *cellModel = WalletAddressSwitchCellModel.new;
            cellModel.walletModel = m;
            cellModel.walletAddress = [HsNFTPreferences.shared getBindWalletAddressByWalletType:m.type];
            [arr addObject:cellModel];
        }
    }
    self.walletAddressCellModelList = arr;
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
        UIImageView *coverImageView = UIImageView.new;
        coverImageView.tag = 100;
        coverImageView.hidden = YES;
        coverImageView.image = [UIImage imageNamed:@"nft_header_cover"];
        [_headerView addSubview:coverImageView];
        [coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
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


- (MyBindWalletView *)bindView {
    if (!_bindView) {
        _bindView = [[MyBindWalletView alloc] init];
    }
    return _bindView;
}

- (MyNFTView *)myNFTView {
    if (!_myNFTView) {
        _myNFTView = [[MyNFTView alloc] init];
    }
    return _myNFTView;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setImage:[UIImage imageNamed:@"unbind_wallet"] forState:UIControlStateNormal];
        [_deleteBtn setImage:[UIImage imageNamed:@"my_cn_nft_bind"] forState:UIControlStateSelected];
        [_deleteBtn setImage:[UIImage imageNamed:@"my_cn_nft_bind"] forState:UIControlStateSelected | UIControlStateHighlighted];

    }
    return _deleteBtn;
}

- (TipPopView *)tipView {
    if (!_tipView) {
        _tipView = TipPopView.new;
    }
    return _tipView;
}
@end
