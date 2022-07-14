//
//  SwitchAutoGuessPopView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/13.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SwitchAutoGuessPopView.h"

@interface SwitchAutoGuessPopView()

@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *tipLabel;
@property(nonatomic, strong) UIButton *openBtn;
@property(nonatomic, strong) UIButton *closeBtn;
@end

@implementation SwitchAutoGuessPopView

- (void)dtAddViews {

    [self addSubview:self.bgImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.tipLabel];
    [self addSubview:self.openBtn];
    [self addSubview:self.closeBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@28);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.greaterThanOrEqualTo(@0);
    }];
    CGFloat bottom = kAppSafeBottom + 12;
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).offset(30);
        make.leading.equalTo(@16);
        make.height.equalTo(@36);
        make.bottom.equalTo(@(-bottom));
    }];
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.closeBtn);
        make.leading.equalTo(self.closeBtn.mas_trailing).offset(19);
        make.trailing.equalTo(@-16);
        make.width.equalTo(self.closeBtn);
        make.height.equalTo(self.closeBtn);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];

}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    self.titleLabel.text = NSString.dt_room_guess_win_me_fmt;
    self.tipLabel.text = [NSString stringWithFormat:NSString.dt_room_guess_guess_self_fmt, @(self.betCoin)];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.closeBtn addTarget:self action:@selector(onCloseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.openBtn addTarget:self action:@selector(onOpenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onCloseBtnClick:(id)sender {
    if (self.onCloseBlock) {
        self.onCloseBlock();
    }
}

- (void)onOpenBtnClick:(id)sender {
    if (self.onOpenBlock) {
        self.onOpenBlock();
    }
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
        _bgImageView.image = [UIImage imageNamed:@"guess_switch_auto_bg"];
    }
    return _bgImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFONT_BOLD(30);
        _titleLabel.textColor = HEX_COLOR(@"#000000");
        _titleLabel.shadowColor = HEX_COLOR(@"#FFDE00");
        _titleLabel.shadowOffset = CGSizeMake(1, 2);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = UIFONT_REGULAR(16);
        _tipLabel.textColor = HEX_COLOR(@"#000000");
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setTitle:NSString.dt_room_guess_not_open forState:UIControlStateNormal];
        [_closeBtn setTitleColor:HEX_COLOR(@"#6C3800") forState:UIControlStateNormal];
        _closeBtn.layer.borderWidth = 1;
        _closeBtn.layer.borderColor = HEX_COLOR(@"#EEE8D0").CGColor;
        _closeBtn.backgroundColor = HEX_COLOR(@"#FFFFFF");
        _closeBtn.titleLabel.font = UIFONT_BOLD(14);
    }
    return _closeBtn;
}

- (UIButton *)openBtn {
    if (!_openBtn) {
        _openBtn = [[UIButton alloc] init];
        [_openBtn setTitle:NSString.dt_room_guess_open_now forState:UIControlStateNormal];
        [_openBtn setTitleColor:HEX_COLOR(@"#6C3800") forState:UIControlStateNormal];
        [_openBtn setBackgroundImage:HEX_COLOR(@"#FFE373").dt_toImage forState:UIControlStateNormal];
        _openBtn.layer.borderWidth = 1;
        _openBtn.layer.borderColor = HEX_COLOR(@"#FFBF3A").CGColor;
        _openBtn.titleLabel.font = UIFONT_BOLD(14);
    }
    return _openBtn;
}
@end
