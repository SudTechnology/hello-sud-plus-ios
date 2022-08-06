//
// Created by kaniel on 2022/7/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "MyBindWalletView.h"
#import "BindBtnView.h"
#import "MyViewController.h"

@interface MyBindWalletView ()
@property(nonatomic, strong) UILabel *nameLabel;

@property(nonatomic, strong) UIView *moreView;
@property(nonatomic, strong) UIImageView *moreIconImageView;
@property(nonatomic, strong) UILabel *moreTitleLabel;
@property(nonatomic, strong) NSMutableArray<BindBtnView *> *bindViewList;
/// 是否更多处于打开状态
@property(nonatomic, assign) BOOL isMoreOpened;
@property(nonatomic, strong) NSArray<SudNFTWalletModel *> *walletList;
@end

@implementation MyBindWalletView

- (void)dtConfigUI {
    [super dtConfigUI];
    self.bindViewList = [[NSMutableArray alloc] init];
}

- (void)dtAddViews {
    [self addSubview:self.nameLabel];
    [self addSubview:self.moreView];
    [self.moreView addSubview:self.moreTitleLabel];
    [self.moreView addSubview:self.moreIconImageView];
}

- (void)dtLayoutViews {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@20);
        make.top.equalTo(@16);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        make.bottom.equalTo(@-140);
    }];
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-10);
        make.height.equalTo(@44);
        make.leading.equalTo(@20);
        make.trailing.equalTo(@-20);
    }];
    [self.moreTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.greaterThanOrEqualTo(@0);
        make.centerX.equalTo(self.moreView).offset(-7);
        make.centerY.equalTo(self.moreView);
    }];
    [self.moreIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moreView);
        make.height.equalTo(@4);
        make.width.equalTo(@8);
        make.leading.equalTo(self.moreTitleLabel.mas_trailing).offset(6);
    }];
}

- (void)dtUpdateUI {
    AccountUserModel *userInfo = AppService.shared.login.loginUserInfo;
    [self updateMoreShowState];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    UITapGestureRecognizer *walletTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMoreView:)];
    [self.moreView addGestureRecognizer:walletTap];

}

- (void)onTapMoreView:(id)tap {
    self.isMoreOpened = !self.isMoreOpened;
    [self updateMoreShowState];
    [self updateSupportWallet:self.walletList];
    UIViewController *currentViewController = AppUtil.currentViewController;
    if ([currentViewController isKindOfClass:MyViewController.class]){
        MyViewController *myViewController = (MyViewController *)currentViewController;
        [myViewController reloadHeadView];
    }

}

- (void)updateMoreShowState {
    if (self.isMoreOpened) {
        self.moreTitleLabel.text = @"收起";
        self.moreIconImageView.image = [UIImage imageNamed:@"right_more"];
    } else {
        self.moreTitleLabel.text = @"更多";
        self.moreIconImageView.image = [UIImage imageNamed:@"right_more"];
    }
}

- (void)updateSupportWallet:(NSArray<SudNFTWalletModel *> *)walletList {

    self.walletList = walletList;
    for (BindBtnView *v in self.bindViewList) {
        [v removeFromSuperview];
    }
    NSArray *showWalletList = walletList;
    // 小于5个隐藏
    if (walletList.count < 5) {
        self.moreView.hidden = YES;
    } else {
        self.moreView.hidden = NO;
        if (!self.isMoreOpened) {
            // 展示五个
            showWalletList = [walletList subarrayWithRange:NSMakeRange(0, 5)];
        }
    }

    [self.bindViewList removeAllObjects];
    BindBtnView *lastView = nil;
    WeakSelf
    for (int i = 0; i < showWalletList.count; ++i) {
        SudNFTWalletModel *m = showWalletList[i];
        BindBtnView *bindBtnView = [[BindBtnView alloc] init];
        bindBtnView.layer.borderColor = UIColor.whiteColor.CGColor;
        bindBtnView.layer.borderWidth = 1;
        [self addSubview:bindBtnView];
        [self.bindViewList addObject:bindBtnView];
        bindBtnView.clickWalletBlock = ^(SudNFTWalletModel *wallModel) {
            if (weakSelf.clickWalletBlock) {
                weakSelf.clickWalletBlock(wallModel);
            }
        };

        [bindBtnView update:m];
        [bindBtnView dt_cornerRadius:22];
        if (self.bindViewList.count == 1) {
            [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(@20);
                make.top.equalTo(@16);
                make.size.mas_greaterThanOrEqualTo(CGSizeZero);
            }];
            [bindBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.nameLabel.mas_bottom).offset(20);
                make.leading.equalTo(@20);
                make.trailing.equalTo(@-20);
                make.height.equalTo(@44);
                if (i == showWalletList.count - 1) {
                    make.bottom.equalTo(@(self.moreView.hidden ? -20 : -66));
                }
            }];
        } else {
            [bindBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).offset(12);
                make.leading.equalTo(@20);
                make.trailing.equalTo(@-20);
                make.height.equalTo(@44);
                if (i == showWalletList.count - 1) {
                    make.bottom.equalTo(@(self.moreView.hidden ? -20 : -66));
                }
            }];
        }
        lastView = bindBtnView;
    }
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"连接到你的钱包";
        _nameLabel.numberOfLines = 1;
        _nameLabel.textColor = HEX_COLOR(@"#ffffff");
        _nameLabel.font = UIFONT_MEDIUM(14);
    }
    return _nameLabel;
}

- (UIView *)moreView {
    if (!_moreView) {
        _moreView = [[UIView alloc] init];
        _moreView.hidden = YES;
    }
    return _moreView;
}

- (UIImageView *)moreIconImageView {
    if (!_moreIconImageView) {
        _moreIconImageView = [[UIImageView alloc] init];
        _moreIconImageView.clipsToBounds = true;
    }
    return _moreIconImageView;
}

- (UILabel *)moreTitleLabel {
    if (!_moreTitleLabel) {
        _moreTitleLabel = [[UILabel alloc] init];
        _moreTitleLabel.text = @"";
        _moreTitleLabel.numberOfLines = 1;
        _moreTitleLabel.textColor = HEX_COLOR(@"#ffffff");
        _moreTitleLabel.font = UIFONT_MEDIUM(14);
    }
    return _moreTitleLabel;
}
@end
