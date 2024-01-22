//
//  TicketChooseItemView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "TicketChooseItemView.h"

@interface TicketChooseItemView ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *goldImageView;
@property (nonatomic, strong) UIImageView *hotImageView;
@property (nonatomic, strong) UIImageView *btnImageView;
@property (nonatomic, strong) UILabel *rewardLabel;
@property (nonatomic, strong) UILabel *enterLabel;
@property (nonatomic, strong) UILabel *onlineLabel;
@property (nonatomic, strong) UIView *usersView;
@end

@implementation TicketChooseItemView

- (void)dtUpdateUI {
    if (self.model == nil) {
        return;
    }
    self.bgImageView.image = [UIImage imageNamed:self.model.bgImgStr];
    self.goldImageView.image = [UIImage imageNamed:self.model.goldImgStr];
    self.btnImageView.image = [UIImage imageNamed:self.model.btnImgStr];
    self.rewardLabel.text = self.model.rewardStr;
    [self.hotImageView setHidden:self.model.isHiddenHot];
}

- (void)dtAddViews {
    [self setUserInteractionEnabled:true];
    [self addSubview:self.bgImageView];
    [self addSubview:self.goldImageView];
    [self addSubview:self.hotImageView];
    [self addSubview:self.btnImageView];
    [self addSubview:self.rewardLabel];
    [self.btnImageView addSubview:self.enterLabel];
    [self addSubview:self.onlineLabel];
    [self addSubview:self.usersView];
    
    [self animaEnterNode];
}

- (void)dealloc {
    NSLog(@"");
}

- (void)animaEnterNode {
    WeakSelf
    [UIView animateWithDuration:1 animations:^{
        weakSelf.btnImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.btnImageView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            [weakSelf animaEnterNode];
        }];
    }];
}

- (void)dtLayoutViews {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.goldImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(-24);
        make.size.mas_equalTo(CGSizeMake(105, 105));
    }];
    [self.hotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(-14);
        make.top.mas_equalTo(self.mas_top).offset(-23);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.btnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-20);
        make.bottom.mas_equalTo(-18);
        make.height.mas_equalTo(30);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    [self.rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(22);
        make.trailing.mas_equalTo(-22);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.enterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.btnImageView);
        make.leading.mas_equalTo(18);
        make.trailing.mas_equalTo(-18);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.usersView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(17);
        make.bottom.mas_equalTo(-21);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.usersView.mas_trailing).offset(10);
        make.centerY.mas_equalTo(self.usersView);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
}

- (void)dtConfigUI {
    for (int i = 0; i < 4; i++) {
        UIImageView *node = UIImageView.new;
        node.image = [UIImage imageNamed:[NSString stringWithFormat:@"tickets_icon_%d", i]];
        node.layer.cornerRadius = 24/2;
        node.layer.masksToBounds = true;
        [self.usersView addSubview:node];
        [node mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-17 * i);
            make.centerY.mas_equalTo(self.usersView);
            make.size.mas_equalTo(CGSizeMake(24, 24));
            if (i == 3) {
                make.leading.mas_equalTo(self.usersView);
            }
        }];
    }
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = UIImageView.new;
        _bgImageView.image = [UIImage imageNamed:@"tickets_item_0_bg"];
    }
    return _bgImageView;
}

- (UIImageView *)goldImageView {
    if (!_goldImageView) {
        _goldImageView = UIImageView.new;
        _goldImageView.image = [UIImage imageNamed:@"tickets_item_0_gold"];
    }
    return _goldImageView;
}

- (UIImageView *)hotImageView {
    if (!_hotImageView) {
        _hotImageView = UIImageView.new;
        _hotImageView.image = [UIImage imageNamed:@"tickets_item_hot"];
    }
    return _hotImageView;
}

- (UIImageView *)btnImageView {
    if (!_btnImageView) {
        _btnImageView = UIImageView.new;
        _btnImageView.image = [UIImage imageNamed:@"tickets_item_0_btn"];
    }
    return _btnImageView;
}

- (UILabel *)rewardLabel {
    if (!_rewardLabel) {
        _rewardLabel = UILabel.new;
        _rewardLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFCAB" alpha:1];
        _rewardLabel.font = UIFONT_BOLD(30);
        _rewardLabel.numberOfLines = 0;
        _rewardLabel.textAlignment = [LanguageUtil isLanguageRTL] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    }
    return _rewardLabel;
}

- (UILabel *)enterLabel {
    if (!_enterLabel) {
        _enterLabel = UILabel.new;
        _enterLabel.text = NSString.dt_ticket_choose_item_join;
        _enterLabel.textColor = [UIColor dt_colorWithHexString:@"#FFF19A" alpha:1];
        _enterLabel.font = UIFONT_MEDIUM(14);
    }
    return _enterLabel;
}

- (UILabel *)onlineLabel {
    if (!_onlineLabel) {
        _onlineLabel = UILabel.new;
        _onlineLabel.text = [NSString stringWithFormat:NSString.dt_ticket_choose_play_user_num, 87367];
        _onlineLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:0.7];
        _onlineLabel.font = UIFONT_REGULAR(12);
    }
    return _onlineLabel;
}

- (UIView *)usersView {
    if (!_usersView) {
        _usersView = UIView.new;
    }
    return _usersView;
}

- (void)setModel:(TocketChooseModel *)model {
    _model = model;
    [self dtUpdateUI];
}

@end
