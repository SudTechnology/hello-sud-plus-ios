//
//  OrderChooseView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/18.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "OrderChooseView.h"

@interface OrderChooseView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *goldLabel;
@property (nonatomic, strong) UIImageView *goldImgView;

@property (nonatomic, strong) UILabel *expendGoldLabel;
@property (nonatomic, strong) UIImageView *expendGoldImgView;
@property (nonatomic, strong) UILabel *chooseUsersNumLabel;
@property (nonatomic, strong) UIButton *orderBtn;

@end

@implementation OrderChooseView

- (void)dtAddViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.goldLabel];
    [self addSubview:self.goldImgView];
    [self addSubview:self.usersView];
    [self addSubview:self.gamesView];
    [self addSubview:self.expendGoldLabel];
    [self addSubview:self.expendGoldImgView];
    [self addSubview:self.chooseUsersNumLabel];
    [self addSubview:self.orderBtn];
    self.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
}

- (void)dtLayoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(24);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(6);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.titleLabel);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.goldImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.goldLabel.mas_leading).offset(-6);
        make.centerY.mas_equalTo(self.goldLabel);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    [self.usersView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(16);
        make.height.mas_equalTo(37);
    }];
    [self.gamesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(self.usersView.mas_bottom).offset(24);
        make.height.mas_equalTo(136);
    }];
    [self.expendGoldImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(self.gamesView.mas_bottom).offset(37);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    [self.expendGoldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.expendGoldImgView.mas_trailing).offset(6);
        make.centerY.mas_equalTo(self.expendGoldImgView);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.chooseUsersNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.expendGoldLabel.mas_trailing).offset(12);
        make.centerY.mas_equalTo(self.expendGoldImgView);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.expendGoldImgView);
        make.size.mas_equalTo(CGSizeMake(110, 36));
        make.bottom.mas_equalTo(-kAppSafeBottom - 12);
    }];
}

#pragma Event

- (void)dtConfigEvents {
    WeakSelf
    [UserService.shared reqUserCoinDetail:^(int64_t i) {
        weakSelf.goldLabel.text = [NSString stringWithFormat:@"%lld", i];
    } fail:^(NSString *errStr) {
        [ToastUtil show:errStr];
    }];
    [self.usersView setCompleteBlock:^{
        [weakSelf calculateExpendGold];
    }];
    [self.gamesView setCompleteBlock:^{
        [weakSelf calculateExpendGold];
    }];
}

- (void)orderBtnEvent:(UIButton *)btn {
    if (self.usersView.usersCount == 0) {
        [ToastUtil show:NSString.dt_room_select_anchor];
        return;
    }
    if ([self.gamesView getSelectGame] == nil) {
        [ToastUtil show:NSString.dt_room_select_game];
        return;
    }
    
    if (self.enterOrderBlock) {

        NSMutableArray *userIdList = NSMutableArray.new;
        NSMutableArray *userNameList = NSMutableArray.new;
        NSArray<AudioRoomMicModel *> *arr = [self.usersView selectedUserList];
        for (int i = 0; i < arr.count; ++i) {
            [userIdList addObject:arr[i].user.userID];
            [userNameList addObject:arr[i].user.name];
        }

        self.enterOrderBlock(userIdList, userNameList, [self.gamesView getSelectGame]);
    }
}

- (void)calculateExpendGold {
    self.chooseUsersNumLabel.text = [NSString stringWithFormat:NSString.dt_room_seleted_people, self.usersView.usersCount];
    if ([self.gamesView getSelectGame] == nil) {
        self.expendGoldLabel.text = @"0";
    } else {
        self.expendGoldLabel.text = [NSString stringWithFormat:@"%ld", self.usersView.usersCount * 200];
    }
}

- (void)configOrderBtnNotClick {
    [self.orderBtn setUserInteractionEnabled:false];
    self.orderBtn.backgroundColor = [UIColor dt_colorWithHexString:@"#000000" alpha:0.2];
    [self.orderBtn setTitleColor:[UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1] forState:UIControlStateNormal];
}

#pragma mark - Lazy

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.text = NSString.dt_room_select_mic_users;
        _titleLabel.textColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1];
        _titleLabel.font = UIFONT_MEDIUM(14);
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = UILabel.new;
        _subTitleLabel.text = NSString.dt_room_designate_mc_anchor;
        _subTitleLabel.textColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1];
        _subTitleLabel.font = UIFONT_REGULAR(12);
    }
    return _subTitleLabel;
}

- (UILabel *)goldLabel {
    if (!_goldLabel) {
        _goldLabel = UILabel.new;
        _goldLabel.text = @"10,000,000";
        _goldLabel.textColor = [UIColor dt_colorWithHexString:@"#F6A209" alpha:1];
        _goldLabel.font = UIFONT_MEDIUM(14);
    }
    return _goldLabel;
}

- (UIImageView *)goldImgView {
    if (!_goldImgView) {
        _goldImgView = UIImageView.new;
        _goldImgView.image = [UIImage imageNamed:@"order_pop_gold"];
    }
    return _goldImgView;
}

- (UILabel *)expendGoldLabel {
    if (!_expendGoldLabel) {
        _expendGoldLabel = UILabel.new;
        _expendGoldLabel.text = @"0";
        _expendGoldLabel.textColor = [UIColor dt_colorWithHexString:@"#F6A209" alpha:1];
        _expendGoldLabel.font = UIFONT_MEDIUM(14);
    }
    return _expendGoldLabel;
}

- (UIImageView *)expendGoldImgView {
    if (!_expendGoldImgView) {
        _expendGoldImgView = UIImageView.new;
        _expendGoldImgView.image = [UIImage imageNamed:@"order_pop_gold"];
    }
    return _expendGoldImgView;
}

- (UILabel *)chooseUsersNumLabel {
    if (!_chooseUsersNumLabel) {
        _chooseUsersNumLabel = UILabel.new;
        _chooseUsersNumLabel.textColor = [UIColor dt_colorWithHexString:@"#666666" alpha:1];
        _chooseUsersNumLabel.font = UIFONT_MEDIUM(12);
        _chooseUsersNumLabel.text = [NSString stringWithFormat:NSString.dt_room_seleted_people, 0];
    }
    return _chooseUsersNumLabel;
}

- (UIButton *)orderBtn {
    if (!_orderBtn) {
        _orderBtn = UIButton.new;
        [_orderBtn setTitle:NSString.dt_room_place_order_play forState:UIControlStateNormal];
        _orderBtn.backgroundColor = UIColor.blackColor;
        _orderBtn.titleLabel.font = UIFONT_BOLD(14);
        [_orderBtn setTitleColor:[UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1] forState:UIControlStateNormal];
        [_orderBtn addTarget:self action:@selector(orderBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderBtn;
}

- (OrderChooseUsersView *)usersView {
    if (!_usersView) {
        _usersView = OrderChooseUsersView.new;
    }
    return _usersView;
}

- (OrderChooseGamesView *)gamesView {
    if (!_gamesView) {
        _gamesView = OrderChooseGamesView.new;
    }
    return _gamesView;
}

@end
