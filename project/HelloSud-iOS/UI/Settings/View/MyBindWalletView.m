//
// Created by kaniel on 2022/7/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "MyBindWalletView.h"

@interface BindBtnView : BaseView
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *nameLabel;
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
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
}

- (void)update:(NSString *)name icon:(NSString *)icon {
    self.nameLabel.text = name;
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
        _nameLabel.text = @"连接到你的钱包";
        _nameLabel.numberOfLines = 1;
        _nameLabel.textColor = HEX_COLOR(@"#ffffff");
        _nameLabel.font = UIFONT_MEDIUM(14);
    }
    return _nameLabel;
}
@end

@interface MyBindWalletView ()
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) BindBtnView *metamaskView;
@end

@implementation MyBindWalletView

- (void)dtConfigUI {
}

- (void)dtAddViews {
    [self addSubview:self.nameLabel];
    [self addSubview:self.metamaskView];

}

- (void)dtLayoutViews {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@20);
        make.top.equalTo(@16);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.metamaskView dt_cornerRadius:22];
    [self.metamaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(20);
        make.leading.equalTo(@20);
        make.trailing.equalTo(@-20);
        make.height.equalTo(@44);
        make.bottom.equalTo(@-76);
    }];
}

- (void)dtUpdateUI {
    AccountUserModel *userInfo = AppService.shared.login.loginUserInfo;
    [self.metamaskView update:@"MetaMask" icon:nil];
}

- (BindBtnView *)metamaskView {
    if (!_metamaskView) {
        _metamaskView = [[BindBtnView alloc] init];
        _metamaskView.layer.borderColor = UIColor.whiteColor.CGColor;
        _metamaskView.layer.borderWidth = 1;
    }
    return _metamaskView;
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