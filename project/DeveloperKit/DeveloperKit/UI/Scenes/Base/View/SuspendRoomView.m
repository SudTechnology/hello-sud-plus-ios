//
// Created by kaniel on 2022/4/19.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SuspendRoomView.h"
#import "BaseSceneViewController.h"

@interface SuspendRoomView ()
@property(nonatomic, strong) UIButton *exitBtn;
@property(nonatomic, strong)UIButton *closeVideoBtn;
@property(nonatomic, strong) MarqueeLabel *nameLabel;
@property(nonatomic, strong)BaseSceneViewController *vc;
@end

@implementation SuspendRoomView

static SuspendRoomView *g_suspendView = nil;

+ (void)show:(BaseSceneViewController *)vc {
    if (!g_suspendView) {
        g_suspendView = [[SuspendRoomView alloc] init];
        UIWindow *win = AppUtil.currentWindow;
        if (win) {
            [win addSubview:g_suspendView];
            g_suspendView.layer.cornerRadius = 8;
            [g_suspendView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(146);
                make.height.mas_equalTo(44);
                make.trailing.mas_equalTo(-16);
                make.bottom.mas_equalTo(-155);
            }];
        }
    }
    g_suspendView.vc = vc;
    [g_suspendView showName:vc.configModel.roomName];
}

+ (void)close {
    [g_suspendView removeFromSuperview];
    g_suspendView = nil;
}

+ (void)exitRoom:(void (^)(void))finished {
    if (!g_suspendView.vc) {
        [SuspendRoomView close];
        if (finished) {
            finished();
        }
        return;
    }

    [g_suspendView.vc exitRoomFromSuspend:YES finished:^{
        [SuspendRoomView close];
        if (finished) {
            finished();
        }
    }];
}

+ (BOOL)isShowSuspend {
    return g_suspendView != nil;
}

+ (void)enterSceneVC {
    if (g_suspendView == nil) {
        return;
    }
    if (g_suspendView.vc) {
        [AppUtil.currentViewController.navigationController pushViewController:g_suspendView.vc animated:YES];
        [SuspendRoomView close];
    }
}

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.nameLabel];
    [self addSubview:self.exitBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.height.mas_greaterThanOrEqualTo(0);
        make.centerY.equalTo(self);
        make.trailing.equalTo(self.exitBtn.mas_leading).offset(-10);
    }];
    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-6);
        make.width.height.mas_equalTo(34);
        make.centerY.equalTo(self);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.layer.borderColor = HEX_COLOR_A(@"#FFFFFF", 0.75).CGColor;
    self.layer.borderWidth = 1;
    self.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.88].CGColor;
    self.layer.cornerRadius = 8;
    self.layer.shadowColor = HEX_COLOR_A(@"#000000", 0.6).CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 30;
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:pan];
    [self addGestureRecognizer:tap];
}

- (void)onTap:(UITapGestureRecognizer *)tap {
    if (self.vc) {
        if (_closeVideoBtn) {
            [_closeVideoBtn removeFromSuperview];
        }
        [self checkIfNeedToResetVideoView];
        [AppUtil.currentViewController.navigationController pushViewController:self.vc animated:YES];
        [SuspendRoomView close];
    }
}

- (void)checkIfNeedToResetVideoView {
}

- (void)onPan:(UIPanGestureRecognizer *)pan {

    CGPoint point = [pan locationInView:self.superview];
    if (pan.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.1 delay:0 options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut animations:^{
            self.center = point;
        }                completion:nil];
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        [UIView animateWithDuration:0.1 delay:0 options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut animations:^{
            if (point.y < 80) {
                self.center = CGPointMake(point.x, 80);
            } else if (point.y > kScreenHeight - 150) {
                self.center = CGPointMake(point.x, kScreenHeight - 150);
            } else {
                self.center = point;
            }
        }                completion:nil];
    } else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        CGRect frame = self.frame;
        CGFloat roundEntryViewWidth = self.mj_w;
        CGFloat roundEntryViewMargin = 20;
        // 设置横向坐标
        if (point.x > kScreenWidth / 2) {
            frame.origin.x = kScreenWidth - roundEntryViewMargin - roundEntryViewWidth;
        } else {
            frame.origin.x = roundEntryViewMargin;
        }
        // 设置最高点
        if (point.y < 80) {
            frame.origin.y = 80;
        }
        // 设置最低点
        if (point.y > kScreenHeight - 150) {
            frame.origin.y = kScreenHeight - 150;
        }
        [UIView animateWithDuration:0.1 delay:0 options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut animations:^{
            self.frame = frame;
        }                completion:nil];
    }
}

- (void)showName:(NSString *)name {
    self.nameLabel.text = name;
}

- (void)onExit:(UIButton *)btn {
    if (_closeVideoBtn) {
        [_closeVideoBtn removeFromSuperview];
    }
    [SuspendRoomView exitRoom:^{
    }];
}

- (void)onCloseBtnCLick:(UIButton *)btn {
    if (_closeVideoBtn) {
        [_closeVideoBtn removeFromSuperview];
    }
    [SuspendRoomView exitRoom:^{
    }];
}


- (void)showVideo:(UIView *)videoView {
    [self addSubview:videoView];
    [self addSubview:self.closeVideoBtn];
    [videoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(@0);
    }];
    [self.closeVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.trailing.equalTo(@0);
       make.width.height.equalTo(@24);
    }];

}

- (UIButton *)closeVideoBtn {
    if (!_closeVideoBtn) {
        _closeVideoBtn = [[UIButton alloc] init];
        [_closeVideoBtn setImage:[UIImage imageNamed:@"suspend_video_close"] forState:UIControlStateNormal];
        [_closeVideoBtn addTarget:self action:@selector(onCloseBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeVideoBtn;
}

- (UIButton *)exitBtn {
    if (!_exitBtn) {
        _exitBtn = [[UIButton alloc] init];
        [_exitBtn setImage:[UIImage imageNamed:@"room_suspend_icon"] forState:UIControlStateNormal];
        [_exitBtn addTarget:self action:@selector(onExit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
}

- (MarqueeLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[MarqueeLabel alloc] init];
        _nameLabel.font = UIFONT_REGULAR(14);
        _nameLabel.textColor = UIColor.whiteColor;
    }
    return _nameLabel;
}
@end
