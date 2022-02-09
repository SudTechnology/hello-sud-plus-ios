//
//  HSMicOperateView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "HSMicOperateView.h"
@interface HSMicOperateView()
@property(nonatomic, strong)UIButton *downMicBtn;
@property(nonatomic, strong)UIButton *cancelBtn;
@end

@implementation HSMicOperateView
- (void)hsAddViews {
    [self addSubview:self.downMicBtn];
    [self addSubview:self.cancelBtn];
}

- (void)hsLayoutViews {
    [self.downMicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(40);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.downMicBtn.mas_bottom).offset(20);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-(kAppSafeBottom + 20));
    }];
}

- (void)hsConfigUI {
    self.backgroundColor = HEX_COLOR_A(@"#F2F2F2", 0.9);
}

- (void)onBtnDown:(UIButton *)sender {
    if (self.downMicCallback) self.downMicCallback(sender);
}

- (void)onBtnCancel:(UIButton *)sender {
    if (self.cancelCallback) self.cancelCallback(sender);
}

- (UIButton *)downMicBtn {
    if (_downMicBtn == nil) {
        _downMicBtn = UIButton.new;
        [_downMicBtn setTitle:@"下麦" forState:UIControlStateNormal];
        _downMicBtn.titleLabel.font = UIFONT_REGULAR(13);
        [_downMicBtn setTitleColor:HEX_COLOR(@"#ffffff") forState:UIControlStateNormal];
        _downMicBtn.backgroundColor = HEX_COLOR(@"#000000");
        [_downMicBtn addTarget:self action:@selector(onBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downMicBtn;
}

- (UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = UIButton.new;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = UIFONT_REGULAR(13);
        [_cancelBtn setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = HEX_COLOR(@"#ffffff");
        [_cancelBtn addTarget:self action:@selector(onBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
@end
