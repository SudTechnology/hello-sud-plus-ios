//
//  MicOperateView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "MicOperateView.h"
@interface MicOperateView()
@property(nonatomic, strong)UIButton *downMicBtn;
@property(nonatomic, strong)UIButton *cancelBtn;
@property(nonatomic, strong)UIView *lineView;
@end

@implementation MicOperateView
- (void)dtAddViews {
    [self addSubview:self.downMicBtn];
    [self addSubview:self.lineView];
    [self addSubview:self.cancelBtn];
}

- (void)dtLayoutViews {
    [self.downMicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(56);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.downMicBtn.mas_bottom);
    }];
    CGFloat bottom = kAppSafeBottom;
    if (bottom == 0) {
        bottom = 20;
    }
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(56);
        make.bottom.mas_equalTo(-bottom);
    }];
}

- (void)dtConfigUI {
    self.backgroundColor = HEX_COLOR(@"#F2F2F2");
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
        [_downMicBtn setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
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
        [_cancelBtn addTarget:self action:@selector(onBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HEX_COLOR(@"#D1D2D8");
    }
    return _lineView;
}
@end
