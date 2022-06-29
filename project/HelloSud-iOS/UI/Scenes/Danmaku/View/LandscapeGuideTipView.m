//
//  LandscapeGuideTipView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/23.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "LandscapeGuideTipView.h"
@interface LandscapeGuideTipView()
@property(nonatomic, strong) UILabel *tipLabel;
@property(nonatomic, strong) UIImageView *landscapeImageView;
@property(nonatomic, strong) DTTimer *timer;
@property(nonatomic, assign) NSInteger countdown;
@end

@implementation LandscapeGuideTipView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.landscapeImageView];
    [self addSubview:self.tipLabel];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@6);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.bottom.equalTo(@-14);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.landscapeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(@0);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];

}

- (void)beginCountdown:(void(^)(void))finished  {
    WeakSelf
    if (!self.timer) {
        // 倒计时秒数
        self.countdown = 3;
        self.timer = [DTTimer timerWithTimeInterval:1 repeats:YES block:^(DTTimer *timer) {
            weakSelf.countdown--;
            if (weakSelf.countdown <= 0) {
                [weakSelf endCountdown];
                weakSelf.hidden = NO;
                if (finished) finished();
            }
        }];
    }
}

- (void)endCountdown {
    [self.timer stopTimer];
    self.timer = nil;
}

- (void)show:(void(^)(void))finished {
    [self beginCountdown:finished];
}

- (void)close {
    [self endCountdown];
    [self removeFromSuperview];
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"点击按钮即可快速发出弹幕或送礼召唤魔兽";
        _tipLabel.font = UIFONT_BOLD(12);
        _tipLabel.textColor = HEX_COLOR(@"#ffffff");
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (UIImageView *)landscapeImageView {
    if (!_landscapeImageView) {
        _landscapeImageView = [[UIImageView alloc] init];
        UIImage *image = [[UIImage imageNamed:@"dm_landscape_tip_guide_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(19, 12, 18, 36) resizingMode:UIImageResizingModeStretch];
        _landscapeImageView.image = image;
    }
    return _landscapeImageView;
}
@end
