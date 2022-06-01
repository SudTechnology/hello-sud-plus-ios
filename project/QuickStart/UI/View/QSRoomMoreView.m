//
// Created by kaniel on 2022/4/18.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "QSRoomMoreView.h"

@interface QSRoomMoreView ()
/// 退出按钮
@property(nonatomic, strong) UIButton *exitBtn;
@property(nonatomic, strong) UILabel *exitLabel;
@end

@implementation QSRoomMoreView {

}

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.exitBtn];
    [self addSubview:self.exitLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    CGFloat top = kStatusBarHeight + 23;

    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.width.height.mas_equalTo(56);
        make.trailing.equalTo(@(-kScaleByW_375(84)));
        make.centerX.equalTo(self);
    }];
    [self.exitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.exitBtn.mas_bottom).offset(4);
        make.width.mas_greaterThanOrEqualTo(0);
        make.centerX.equalTo(self.exitBtn);
        make.height.mas_equalTo(17);
        make.bottom.equalTo(@(-34));
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

- (UIButton *)exitBtn {
    if (!_exitBtn) {
        _exitBtn = [[UIButton alloc] init];
        [_exitBtn setImage:[UIImage imageNamed:@"room_exit"] forState:UIControlStateNormal];
        [_exitBtn addTarget:self action:@selector(onExitClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
}

- (UILabel *)exitLabel {
    if (!_exitLabel) {
        _exitLabel = [[UILabel alloc] init];
        _exitLabel.font = UIFONT_REGULAR(12);
        _exitLabel.textColor = UIColor.whiteColor;
        _exitLabel.text = @"退出房间";
    }
    return _exitLabel;
}
@end
