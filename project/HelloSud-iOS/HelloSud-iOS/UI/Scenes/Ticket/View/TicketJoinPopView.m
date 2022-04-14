//
//  TicketJoinPopView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "TicketJoinPopView.h"

@interface TicketJoinPopView ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *topGoldView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *desTitleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIView *goldBgView;
@property (nonatomic, strong) UIImageView *goldImgView;
@property (nonatomic, strong) UILabel *goldNumLabel;

@property (nonatomic, strong) UIView *remindView;
@property (nonatomic, strong) UIButton *remindImgView;
@property (nonatomic, strong) UILabel *remindLabel;

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation TicketJoinPopView


- (void)clickRemindViewEvent:(UITapGestureRecognizer *)tap {
    [self.remindImgView setSelected:!self.remindImgView.isSelected];
}

- (void)cancelEvent:(UIButton *)btn {
    [DTSheetView close];
}

- (void)joinEvent:(UIButton *)btn {
    if (self.onJoinCallBack) {
        if (self.remindImgView.isSelected) {
            [AppService.shared.ticket savePopTicketJoin:true];
        }
        self.onJoinCallBack(btn);
        [DTSheetView close];
    }
}

- (void)dtUpdateUI {
    NSArray <NSString *>*goldArr = @[@"20", @"250", @"900"];
    NSArray <NSString *>*payArr = @[@"2", @"5", @"10"];
    
    switch (self.ticketLevelType) {
        case TicketLevelTypePrimary:
            self.desTitleLabel.text = [NSString stringWithFormat:NSString.dt_ticket_choose_pop_des_title, goldArr[0]];
            self.detailLabel.text = [NSString stringWithFormat:NSString.dt_ticket_choose_pop_des_detail, payArr[0]];
            break;
        case TicketLevelTypeMedia:
            self.desTitleLabel.text = [NSString stringWithFormat:NSString.dt_ticket_choose_pop_des_title, goldArr[1]];
            self.detailLabel.text = [NSString stringWithFormat:NSString.dt_ticket_choose_pop_des_detail, payArr[1]];
            break;
        case TicketLevelTypeSenior:
            self.desTitleLabel.text = [NSString stringWithFormat:NSString.dt_ticket_choose_pop_des_title, goldArr[2]];
            self.detailLabel.text = [NSString stringWithFormat:NSString.dt_ticket_choose_pop_des_detail, payArr[2]];
            break;
        default:
            break;
    }
}

- (void)dtConfigEvents {
    WeakSelf
    [UserService.shared reqUserCoinDetail:^(int64_t i) {
        weakSelf.goldNumLabel.text = [NSString stringWithFormat:@"%lld", i];
    } fail:^(NSString *errStr) {
        [ToastUtil show:errStr];
    }];
}

- (void)dtAddViews {
    [self addSubview:self.bgImageView];
    [self addSubview:self.topGoldView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.desTitleLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.goldBgView];
    [self.goldBgView addSubview:self.goldImgView];
    [self.goldBgView addSubview:self.goldNumLabel];
    [self addSubview:self.remindView];
    [self.remindView addSubview:self.remindImgView];
    [self.remindView addSubview:self.remindLabel];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.sureBtn];
}

- (void)dtLayoutViews {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13);
        make.leading.bottom.trailing.mas_equalTo(self);
    }];
    [self.topGoldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(72, 72));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.topGoldView.mas_trailing);
        make.top.mas_equalTo(self.bgImageView.mas_top).offset(8);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.desTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(2);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.goldBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImageView.mas_top).offset(24);
        make.trailing.mas_equalTo(20);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_equalTo(24);
    }];
    [self.goldImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(8);
        make.centerY.mas_equalTo(self.goldBgView);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    [self.goldNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.goldImgView.mas_trailing).offset(3);
        make.centerY.mas_equalTo(self.goldBgView);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        make.trailing.mas_equalTo(-20 - 16);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topGoldView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
    }];
    [self.remindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(17);
        make.centerX.mas_equalTo(self);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_equalTo(16);
    }];
    [self.remindImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.centerY.mas_equalTo(self.remindView);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.remindImgView.mas_trailing).offset(2);
        make.trailing.centerY.mas_equalTo(self.remindView);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.remindView.mas_centerX).offset(-18);
        make.top.mas_equalTo(self.remindView.mas_bottom).offset(23);
        make.size.mas_equalTo(CGSizeMake(130, 36));
        make.bottom.mas_equalTo(-16 - kAppSafeBottom);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.remindView.mas_centerX).offset(18);
        make.top.mas_equalTo(self.remindView.mas_bottom).offset(23);
        make.size.mas_equalTo(CGSizeMake(130, 36));
    }];
}

- (UIImageView *)topGoldView {
    if (!_topGoldView) {
        _topGoldView = UIImageView.new;
        _topGoldView.image = [UIImage imageNamed:@"ticket_join_top_gold"];
    }
    return _topGoldView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = UIImageView.new;
        _bgImageView.image = [UIImage imageNamed:@"ticket_join_bg"];
    }
    return _bgImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.text = NSString.dt_ticket_choose_pop_title;
        _titleLabel.textColor = [UIColor dt_colorWithHexString:@"#FFE2AD" alpha:1];
        _titleLabel.font = UIFONT_BOLD(16);
    }
    return _titleLabel;
}

- (UILabel *)desTitleLabel {
    if (!_desTitleLabel) {
        _desTitleLabel = UILabel.new;
        _desTitleLabel.textColor = [UIColor dt_colorWithHexString:@"#FFE2AD" alpha:1];
        _desTitleLabel.font = UIFONT_BOLD(16);
    }
    return _desTitleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = UILabel.new;
        _detailLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
        _detailLabel.font = UIFONT_MEDIUM(16);
        _detailLabel.numberOfLines = 0;
        _detailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _detailLabel;
}

- (UIView *)goldBgView {
    if (!_goldBgView) {
        _goldBgView = UIView.new;
        _goldBgView.backgroundColor = [UIColor dt_colorWithHexString:@"#000000" alpha:0.3];
        _goldBgView.layer.cornerRadius = 24/2;
        _goldBgView.layer.masksToBounds = YES;
    }
    return _goldBgView;
}

- (UIImageView *)goldImgView {
    if (!_goldImgView) {
        _goldImgView = UIImageView.new;
        _goldImgView.image = [UIImage imageNamed:@"ticket_join_num_gold"];
    }
    return _goldImgView;
}

- (UILabel *)goldNumLabel {
    if (!_goldNumLabel) {
        _goldNumLabel = UILabel.new;
        _goldNumLabel.text = @"0.00";
        _goldNumLabel.textColor = [UIColor dt_colorWithHexString:@"#FEEFB3" alpha:1];
        _goldNumLabel.font = UIFONT_MEDIUM(14);
    }
    return _goldNumLabel;
}

- (UIView *)remindView {
    if (!_remindView) {
        _remindView = UIView.new;
        [_remindView setUserInteractionEnabled:true];
        [_remindView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickRemindViewEvent:)]];
    }
    return _remindView;
}

- (UIButton *)remindImgView {
    if (!_remindImgView) {
        _remindImgView = UIButton.new;
        [_remindImgView setImage:[UIImage imageNamed:@"ticket_join_check"] forState:UIControlStateNormal];
        [_remindImgView setImage:[UIImage imageNamed:@"ticket_join_check_click"] forState:UIControlStateSelected];
        [_remindImgView setUserInteractionEnabled:false];
    }
    return _remindImgView;
}

- (UILabel *)remindLabel {
    if (!_remindLabel) {
        _remindLabel = UILabel.new;
        _remindLabel.text = NSString.dt_ticket_choose_pop_not_alert;
        _remindLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:0.6];
        _remindLabel.font = UIFONT_REGULAR(12);
    }
    return _remindLabel;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = UIButton.new;
        [_cancelBtn setTitle:NSString.dt_common_cancel forState:UIControlStateNormal];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"tickets_join_cancel"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = UIFONT_MEDIUM(14);
        [_cancelBtn setTitleColor:[UIColor dt_colorWithHexString:@"#C5C1AE" alpha:1] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = UIButton.new;
        [_sureBtn setTitle:NSString.dt_ticket_choose_pop_sure_enter forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"tickets_join_sure"] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = UIFONT_MEDIUM(14);
        [_sureBtn setTitleColor:[UIColor dt_colorWithHexString:@"#FFE88D" alpha:1] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(joinEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (void)setTicketLevelType:(TicketLevelType)ticketLevelType {
    _ticketLevelType = ticketLevelType;
    [self dtUpdateUI];
}

@end

