//
// Created by kaniel on 2022/7/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "MyBindWalletView.h"

@interface BindBtnView : BaseView
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) SudNFTWalletModel *model;

@property (nonatomic, strong)void(^clickWalletBlock)(SudNFTWalletModel *wallModel);
@end

@implementation BindBtnView
- (void)dtAddViews {
    [self addSubview:self.iconImageView];
    [self addSubview:self.nameLabel];
}

- (void)dtLayoutViews {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@102);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(8);
        make.centerY.equalTo(self);
        make.height.mas_greaterThanOrEqualTo(CGSizeZero);
        make.width.equalTo(@80);
    }];
}


- (void)update:(SudNFTWalletModel *)model {
    self.model = model;
    self.nameLabel.text = model.name;
    if (model.icon) {
        [self.iconImageView sd_setImageWithURL:[[NSURL alloc] initWithString:model.icon]];
    }
    CGFloat maxWidth = kScreenWidth - 40 - 32;
    CGRect rect = [model.name boundingRectWithSize:CGSizeMake(maxWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.nameLabel.font} context:nil];
    CGFloat labelW = ceil(rect.size.width);
    CGFloat left = (maxWidth - labelW - 28 - 16) / 2;
    [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@(left));
    }];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(labelW));
    }];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:tap];
}

- (void)onTap:(id)tap {
    if (self.clickWalletBlock) {
        self.clickWalletBlock(self.model);
    }
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.clipsToBounds = true;
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.numberOfLines = 1;
        _nameLabel.textColor = HEX_COLOR(@"#ffffff");
        _nameLabel.font = UIFONT_MEDIUM(14);
    }
    return _nameLabel;
}
@end

@interface MyBindWalletView ()
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) NSMutableArray<BindBtnView *> *bindViewList;
@end

@implementation MyBindWalletView

- (void)dtConfigUI {
    [super dtConfigUI];
    self.bindViewList = [[NSMutableArray alloc] init];
}

- (void)dtAddViews {
    [self addSubview:self.nameLabel];
}

- (void)dtLayoutViews {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@20);
        make.top.equalTo(@16);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        make.bottom.equalTo(@-140);
    }];

}

- (void)dtUpdateUI {
    AccountUserModel *userInfo = AppService.shared.login.loginUserInfo;
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
}


- (void)updateSupportWallet:(NSArray<SudNFTWalletModel *> *)walletList {
    for (BindBtnView *v in self.bindViewList) {
        [v removeFromSuperview];
    }
    SudNFTWalletModel *temp = walletList[0];
//    walletList = @[temp, temp, temp, temp];
    [self.bindViewList removeAllObjects];
    BindBtnView *lastView = nil;
    WeakSelf
    for (int i = 0; i < walletList.count; ++i) {
        SudNFTWalletModel *m = walletList[i];
        BindBtnView *bindBtnView = [[BindBtnView alloc] init];
        bindBtnView.layer.borderColor = UIColor.whiteColor.CGColor;
        bindBtnView.layer.borderWidth = 1;
        [self addSubview:bindBtnView];
        [self.bindViewList addObject:bindBtnView];
        bindBtnView.clickWalletBlock = ^(SudNFTWalletModel *wallModel){
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
                if (i == walletList.count - 1) {
                    make.bottom.equalTo(@-20);
                }
            }];
        } else {
            [bindBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).offset(12);
                make.leading.equalTo(@20);
                make.trailing.equalTo(@-20);
                make.height.equalTo(@44);
                if (i == walletList.count - 1) {
                    make.bottom.equalTo(@-20);
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
@end