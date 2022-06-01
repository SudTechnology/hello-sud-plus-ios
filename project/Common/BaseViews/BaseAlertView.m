//
//  BaseAlertView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseAlertView.h"

@interface BaseAlertView ()

@end

@implementation BaseAlertView

static BaseAlertView *h_alertView = nil;

/// 展示弹窗
- (void)hs_show {
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
        if (!self.hiddeBackCover) {
            self.backView.alpha = 0.4;
        }
    }];
}

/// 关闭弹窗
- (void)hs_close {
    if (h_alertView != nil) {
        [h_alertView closeNode];
    }
}

- (void)closeNode {
    self.backView.alpha = 0;
    if (self.onCloseViewCallBack) {
        self.onCloseViewCallBack();
    }
    if (h_alertView != nil) {
        h_alertView.alpha = 0;
        [h_alertView removeFromSuperview];
        h_alertView = nil;
    }
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColor.blackColor;
        _backView.alpha = 0;
    }
    return _backView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UIView *)customView {
    if (!_customView) {
        _customView = [[UIView alloc] init];
    }
    return _customView;
}

+ (BaseAlertView *)getAlert {
    return  h_alertView;
}

+ (void)setAlert: (BaseAlertView *)alert {
    h_alertView = alert;
}


@end
