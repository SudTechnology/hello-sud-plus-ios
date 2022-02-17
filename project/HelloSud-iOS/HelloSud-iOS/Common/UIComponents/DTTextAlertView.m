//
//  DTTextAlertView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "DTTextAlertView.h"

@interface DTTextAlertView ()
@property(nonatomic, strong) YYLabel *contentLabel;
@property(nonatomic, strong) UIButton *sureBtn;
@property(nonatomic, strong) UIButton *cancelBtn;

@end

@implementation DTTextAlertView

/// 文本alert初始化
/// @param msg content
/// @param sureText 确定按钮文字
/// @param cancelText 取消按钮文字 传空则没有取消按钮
/// @param isClickClose 点击背景是否关闭
/// @param sureCb 确定item回调
/// @param closeCb 取消item回调
- (void)config:(NSString *)msg sureText:(NSString *)sureText cancelText:(NSString *)cancelText isClickClose:(BOOL)isClickClose onSureCallback:(void(^)(void))sureCb onCloseCallback:(void(^)(void))closeCb {
    self.onSureItemCallBack = sureCb;
    self.onCancelItemlCallBack = closeCb;
    self.isClickClose = isClickClose;
    self.alertType = cancelText.length == 0 ? HSTypeOnlySure : HSTypeAll;
    self.contentLabel.text = msg;
    [self.sureBtn setTitle:sureText forState:UIControlStateNormal];
    [self.cancelBtn setTitle:cancelText forState:UIControlStateNormal];
}

/// 文本alert初始化
/// @param msg content
/// @param sureText 确定按钮文字
/// @param cancelText 取消按钮文字 传空则没有取消按钮
/// @param isClickClose 点击背景是否关闭
/// @param sureCb 确定item回调
/// @param closeCb 取消item回调
- (void)configAttr:(NSAttributedString *)msg sureText:(NSString *)sureText cancelText:(NSString *)cancelText isClickClose:(BOOL)isClickClose onSureCallback:(void(^)(void))sureCb onCloseCallback:(void(^)(void))closeCb {
    self.onSureItemCallBack = sureCb;
    self.onCancelItemlCallBack = closeCb;
    self.isClickClose = isClickClose;
    self.alertType = cancelText.length == 0 ? HSTypeOnlySure : HSTypeAll;
    self.contentLabel.attributedText = msg;
    [self.sureBtn setTitle:sureText forState:UIControlStateNormal];
    [self.cancelBtn setTitle:cancelText forState:UIControlStateNormal];
}

- (void)dtAddViews {
    [self addSubview:self.contentLabel];
    [self addSubview:self.sureBtn];
    [self addSubview:self.cancelBtn];
}

- (void)dtLayoutViews {
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(24);
        make.height.mas_equalTo(36);
        make.width.mas_greaterThanOrEqualTo(0);
        make.bottom.mas_equalTo(-24);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cancelBtn.mas_right).offset(40);
        make.right.mas_equalTo(-24);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(24);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(self.cancelBtn.mas_width);
    }];
}

- (void)itemUpdateLayout {
    if (self.alertType == HSTypeOnlySure) {
        [self.sureBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(40);
            make.size.mas_equalTo(CGSizeMake(140, 36));
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(-24);
        }];
        [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
        [self.cancelBtn setHidden:true];;
    }
}

- (void)onSureItemEvent {
    if (self.onSureItemCallBack) {
        [DTAlertView close];
        self.onSureItemCallBack();
    }
}

- (void)onCancelItemEvent {
    [DTAlertView close];
    if (self.onCancelItemlCallBack) {
        self.onCancelItemlCallBack();
    }
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
        _contentLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.preferredMaxLayoutWidth = 296 - 48;
    }
    return _contentLabel;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _sureBtn.backgroundColor = UIColor.blackColor;
        [_sureBtn addTarget:self action:@selector(onSureItemEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _cancelBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        [_cancelBtn addTarget:self action:@selector(onCancelItemEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (void)setAlertType:(AlertType)alertType {
    _alertType = alertType;
    [self itemUpdateLayout];
}

@end
