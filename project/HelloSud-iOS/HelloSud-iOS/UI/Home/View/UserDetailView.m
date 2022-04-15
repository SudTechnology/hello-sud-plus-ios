//
// Created by kaniel on 2022/4/1.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "UserDetailView.h"

@interface UserDetailView ()
@property(nonatomic, strong) UIImageView *headerView;
@property(nonatomic, strong) UILabel *userNameLabel;
@property(nonatomic, strong) UILabel *userIdLabel;
@property(nonatomic, strong) UIView *coinContentView;
@property(nonatomic, strong) UIImageView *coinImageView;
@property(nonatomic, strong) UILabel *coinLabel;
@end

@implementation UserDetailView

- (void)reqData {
    WeakSelf
    [UserService.shared reqUserCoinDetail:^(int64_t i) {
        [weakSelf dtUpdateUI];
        weakSelf.coinLabel.text = [NSString stringWithFormat:@"%lld", i];
    } fail:^(NSString *errStr) {
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
}

- (void)dtLayoutViews {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(32);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(56, 56));
    }];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView);
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(8);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView);
        make.top.mas_equalTo(self.userNameLabel.mas_bottom).offset(4);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.coinContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userIdLabel.mas_bottom).offset(19);
        make.height.mas_equalTo(30);
        make.width.mas_greaterThanOrEqualTo(0);
        make.centerX.equalTo(self.headerView);
        make.bottom.mas_equalTo(-31);
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
}

- (void)dtUpdateUI {
    AccountUserModel *userInfo = AppService.shared.login.loginUserInfo;
    self.userNameLabel.text = userInfo.name;
    self.userIdLabel.text = [NSString stringWithFormat:@"%@ %@", NSString.dt_home_user_id, userInfo.userID];
    if (userInfo.icon.length > 0) {
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:userInfo.icon]];
    }
}

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.clipsToBounds = true;
        _headerView.layer.cornerRadius = 56 / 2;
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

- (UILabel *)userIdLabel {
    if (!_userIdLabel) {
        _userIdLabel = [[UILabel alloc] init];
        _userIdLabel.text = @"用户ID 0";
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
@end
