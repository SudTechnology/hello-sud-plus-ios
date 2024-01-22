//
// Created by kaniel on 2022/4/1.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "AnchorDetailView.h"

@interface AnchorDetailView ()
@property(nonatomic, strong) UIImageView *headerView;
@property(nonatomic, strong) UILabel *userNameLabel;
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UIButton *sendGiftBtn;
@property(nonatomic, strong) HSUserInfoModel *userInfoModel;
@end

@implementation AnchorDetailView

- (void)setUserId:(NSString *)userId {
    _userId = userId;
    [self reqData];
}

- (void)reqData {
    if (!self.userId) {
        return;
    }
    WeakSelf
    [UserService.shared asyncCacheUserInfo:@[self.userId] forceRefresh:NO finished:^{
        weakSelf.userInfoModel = [UserService.shared getCacheUserInfo:self.userId.longLongValue];
        [weakSelf dtUpdateUI];
    }];

}

- (void)dtConfigUI {
    self.backgroundColor = UIColor.clearColor;
    [self dtUpdateUI];
}

- (void)dtAddViews {
    [self addSubview:self.bgView];
    [self addSubview:self.headerView];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.sendGiftBtn];
}

- (void)dtLayoutViews {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(56, 56));
    }];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView);
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(30);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_centerY);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@210);
        make.bottom.mas_equalTo(0);
    }];
    [self.sendGiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(36);
        make.height.mas_equalTo(36);
        make.width.equalTo(@104);
        make.centerX.equalTo(self);
    }];

}

- (void)dtUpdateUI {

    self.userNameLabel.text = self.userInfoModel.nickname;
    if (self.userInfoModel.avatar.length > 0) {
        [self.headerView sd_setImageWithURL:self.userInfoModel.avatar.dt_toURL];
    }
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    [self.sendGiftBtn dt_onClick:^(UIButton *sender) {
        if (weakSelf.clickSendGiftBlock) {
            weakSelf.clickSendGiftBlock();
        }
    }];
}

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.clipsToBounds = true;
        _headerView.layer.cornerRadius = 56 / 2;
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.layer.borderColor = HEX_COLOR(@"#F5F6FB").CGColor;
        _headerView.layer.borderWidth = 2;
    }
    return _headerView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.text = @"";
        _userNameLabel.numberOfLines = 1;
        _userNameLabel.textColor = HEX_COLOR(@"#000000");
        _userNameLabel.font = UIFONT_BOLD(16);
    }
    return _userNameLabel;
}

- (UIButton *)sendGiftBtn {
    if (!_sendGiftBtn) {
        _sendGiftBtn = [[UIButton alloc] init];
        _sendGiftBtn.backgroundColor = HEX_COLOR(@"#000000");
        [_sendGiftBtn setTitle:@"dt_room_send_gift".dt_lan forState:UIControlStateNormal];
        _sendGiftBtn.titleLabel.font = UIFONT_BOLD(14);
    }
    return _sendGiftBtn;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HEX_COLOR(@"#F5F6FB");
    }
    return _bgView;
}

@end
