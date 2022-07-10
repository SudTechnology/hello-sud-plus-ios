//
// Created by kaniel on 2022/4/18.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RoomMoreView.h"

@interface RoomMoreView ()

/// 挂起按钮
@property(nonatomic, strong) UIButton *suspendBtn;
/// 退出按钮
@property(nonatomic, strong) UIButton *exitBtn;
@property(nonatomic, strong) UILabel *suspendLabel;
@property(nonatomic, strong) UILabel *exitLabel;
@end

@implementation RoomMoreView {

}

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.suspendBtn];
    [self addSubview:self.exitBtn];
    [self addSubview:self.suspendLabel];
    [self addSubview:self.exitLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    CGFloat top = kStatusBarHeight + 23;
    [self.suspendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.width.height.mas_equalTo(56);
        make.leading.equalTo(@(kScaleByW_375(84)));

    }];

    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.width.height.mas_equalTo(56);
        make.trailing.equalTo(@(-kScaleByW_375(84)));
    }];

    [self.suspendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.suspendBtn.mas_bottom).offset(4);
        make.width.mas_greaterThanOrEqualTo(0);
        make.centerX.equalTo(self.suspendBtn);
        make.height.mas_equalTo(17);
        make.bottom.mas_equalTo(-34);
    }];

    [self.exitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.exitBtn.mas_bottom).offset(4);
        make.width.mas_greaterThanOrEqualTo(0);
        make.centerX.equalTo(self.exitBtn);
        make.height.mas_equalTo(17);
        make.bottom.equalTo(self.suspendLabel);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = HEX_COLOR_A(@"#000000", 0.92);
}

- (void)dtConfigEvents {

}

- (void)onSuspendClick:(UIButton *)sender {
    if (self.suspendCallback) {
        self.suspendCallback();
    }
}

- (void)onExitClick:(UIButton *)sender {
    if (self.exitCallback) {
        self.exitCallback();
    }
}

- (UIButton *)suspendBtn {
    if (!_suspendBtn) {
        _suspendBtn = [[UIButton alloc] init];
        [_suspendBtn setImage:[UIImage imageNamed:@"room_suspend"] forState:UIControlStateNormal];
        [_suspendBtn addTarget:self action:@selector(onSuspendClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _suspendBtn;
}

- (UIButton *)exitBtn {
    if (!_exitBtn) {
        _exitBtn = [[UIButton alloc] init];
        [_exitBtn setImage:[UIImage imageNamed:@"room_exit"] forState:UIControlStateNormal];
        [_exitBtn addTarget:self action:@selector(onExitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
}

- (UILabel *)suspendLabel {
    if (!_suspendLabel) {
        _suspendLabel = [[UILabel alloc] init];
        _suspendLabel.font = UIFONT_REGULAR(12);
        _suspendLabel.textColor = UIColor.whiteColor;
        _suspendLabel.text = NSString.dt_room_hang_room;
    }
    return _suspendLabel;
}

- (UILabel *)exitLabel {
    if (!_exitLabel) {
        _exitLabel = [[UILabel alloc] init];
        _exitLabel.font = UIFONT_REGULAR(12);
        _exitLabel.textColor = UIColor.whiteColor;
        _exitLabel.text = NSString.dt_room_exit_room;
    }
    return _exitLabel;
}
@end
