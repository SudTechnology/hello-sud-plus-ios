//
//  DiscoRankTipView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/23.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoRankTipView.h"
@interface DiscoRankTipView()
@property(nonatomic, strong) UILabel *tipLabel;
@property(nonatomic, strong) UIImageView *landscapeImageView;
@property(nonatomic, strong) DTTimer *timer;
@property(nonatomic, assign) NSInteger countdown;
@end

@implementation DiscoRankTipView

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
    if (self.timer) {
        // 存在，则重新倒计时
        [self.timer stopTimer];
        self.timer = nil;
    }
    // 倒计时秒数
    self.countdown = 4;
    self.timer = [DTTimer timerWithTimeInterval:1 repeats:YES block:^(DTTimer *timer) {
        weakSelf.countdown--;
        DDLogDebug(@"disco rank tip countdown:%@", @(weakSelf.countdown));
        if (weakSelf.countdown <= 0) {
            [weakSelf endCountdown];
            if (finished) finished();
        }
    }];
}

- (void)endCountdown {
    [self.timer stopTimer];
    self.timer = nil;
}

- (void)show:(void(^)(void))finished {
    DDLogDebug(@"disco rank tip show");
    [self beginCountdown:finished];
}

- (void)close {
    [self endCountdown];
    [self removeFromSuperview];
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"跳舞邀请已发出，请稍等";
        _tipLabel.font = UIFONT_REGULAR(10);
        _tipLabel.textColor = HEX_COLOR(@"#ffffff");
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (UIImageView *)landscapeImageView {
    if (!_landscapeImageView) {
        _landscapeImageView = [[UIImageView alloc] init];
        UIImage *image = [[UIImage imageNamed:@"disco_rank_tip"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 10, 14, 38) resizingMode:UIImageResizingModeStretch];
        _landscapeImageView.image = image;
    }
    return _landscapeImageView;
}
@end
