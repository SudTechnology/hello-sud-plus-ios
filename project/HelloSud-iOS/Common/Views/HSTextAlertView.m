//
//  HSTextAlertView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSTextAlertView.h"

@interface HSTextAlertView ()
@property(nonatomic, strong) YYLabel *contentLabel;
@property(nonatomic, strong) UIButton *sureBtn;
@property(nonatomic, strong) UIButton *cancelBtn;

@end

@implementation HSTextAlertView

- (void)hsAddViews {
    [self addSubview:self.contentLabel];
    [self addSubview:self.sureBtn];
    [self addSubview:self.cancelBtn];
}

- (void)hsLayoutViews {
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(24);
        make.height.mas_equalTo(36);
        make.width.mas_greaterThanOrEqualTo(0);
        make.bottom.mas_equalTo(-24);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sureBtn.mas_right).offset(40);
        make.right.mas_equalTo(-24);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(24);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(self.sureBtn.mas_width);
    }];
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
        _contentLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
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
    }
    return _cancelBtn;
}

@end
