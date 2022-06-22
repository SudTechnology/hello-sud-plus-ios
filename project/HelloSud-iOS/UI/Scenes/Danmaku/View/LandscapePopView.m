//
//  LandscapePopView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/21.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "LandscapePopView.h"

@interface LandscapePopView ()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *tipLabel;
@property(nonatomic, strong) UIImageView *landscapeImageView;
@property(nonatomic, strong) UIButton *enterBtn;
@property(nonatomic, strong) UIButton *closeBtn;
@property(nonatomic, strong) DTTimer *timer;
@property(nonatomic, assign) NSInteger countdown;

@end

@implementation LandscapePopView

- (void)dealloc {
    [self endCountdown];
}

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.titleLabel];
    [self addSubview:self.tipLabel];
    [self addSubview:self.landscapeImageView];
    [self addSubview:self.enterBtn];
    [self addSubview:self.closeBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.trailing.equalTo(@-10);
        make.width.equalTo(@24);
        make.height.equalTo(@24);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@44);
        make.leading.trailing.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(9);
        make.leading.trailing.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.landscapeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).offset(17);
        make.width.equalTo(@91);
        make.height.equalTo(@100);
        make.centerX.equalTo(self);
    }];
    [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.landscapeImageView.mas_bottom).offset(21);
        make.width.equalTo(@160);
        make.height.equalTo(@36);
        make.centerX.equalTo(self);
        make.bottom.equalTo(@-24);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = UIColor.orangeColor;
    [self dtAddGradientLayer:@[@0, @1] colors:@[(id) HEX_COLOR(@"#2EE1FF").CGColor, (id) HEX_COLOR(@"#FF9393").CGColor] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1) cornerRadius:8];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.enterBtn addTarget:self action:@selector(onEnterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn addTarget:self action:@selector(onCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)beginCountdown {
    WeakSelf
    if (!self.timer) {
        // 倒计时秒数
        self.countdown = 5;
        [self updateCountdown];
        self.timer = [DTTimer timerWithTimeInterval:1 repeats:YES block:^(DTTimer *timer) {
            weakSelf.countdown--;
            [weakSelf updateCountdown];
        }];
    }
}

- (void)endCountdown {
    [self.timer stopTimer];
    self.timer = nil;
}

- (void)updateCountdown {
    if (self.countdown <= 0) {
        [self endCountdown];
        // 自动进入横屏
        if (self.enterBlock) {
            self.enterBlock();
        }
        return;
    }
    _tipLabel.text = [NSString stringWithFormat:@"%@秒后会自动进入全屏", @(self.countdown)];
}

- (void)onEnterBtn:(id)sender {
    [self endCountdown];
    if (self.enterBlock) {
        self.enterBlock();
    }
}

- (void)onCloseBtn:(id)sender {
    [self endCountdown];
    [DTAlertView close];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"游戏激战中，横屏体验更佳";
        _titleLabel.font = UIFONT_MEDIUM(16);
        _titleLabel.textColor = HEX_COLOR(@"#000000");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"3秒后会自动进入全屏";
        _tipLabel.font = UIFONT_REGULAR(12);
        _tipLabel.textColor = HEX_COLOR(@"#000000");
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (UIImageView *)landscapeImageView {
    if (!_landscapeImageView) {
        _landscapeImageView = [[UIImageView alloc] init];
        _landscapeImageView.image = [UIImage imageNamed:@"dm_landscape"];
    }
    return _landscapeImageView;
}

- (UIButton *)enterBtn {
    if (!_enterBtn) {
        _enterBtn = [[UIButton alloc] init];
        [_enterBtn setTitle:@"马上进入" forState:UIControlStateNormal];
        _enterBtn.titleLabel.font = UIFONT_MEDIUM(14);
        [_enterBtn setTitleColor:HEX_COLOR(@"#ffffff") forState:UIControlStateNormal];
        _enterBtn.backgroundColor = HEX_COLOR(@"#000000");
    }
    return _enterBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"dm_landscape_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}
@end
