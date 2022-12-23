//
// Created by kaniel on 2022/11/7.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "InteractiveGameLoadingView.h"

@interface InteractiveGameLoadingView ()
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIImageView *loadingImageView;
@property(nonatomic, strong) UILabel *loadingLabel;
@end

@implementation InteractiveGameLoadingView

- (void)dtConfigUI {
    [self dtUpdateUI];
}

- (void)dtAddViews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.loadingImageView];
    [self.contentView addSubview:self.loadingLabel];
}

- (void)dtLayoutViews {

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(128);
        make.width.mas_equalTo(160);
        make.center.equalTo(self);
    }];
    [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@28);
        make.centerX.equalTo(self.contentView);
        make.width.height.mas_equalTo(56);
    }];
    [self.loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loadingImageView.mas_bottom).offset(14);
        make.leading.trailing.equalTo(@0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)dtUpdateUI {

}

- (void)showWithTitle:(NSString *)title {
    self.loadingLabel.text = title;
    [self showLoadingAnimate:YES];
}

- (void)close {
    [self showLoadingAnimate:NO];
}

- (void)showLoadingAnimate:(BOOL)show {
    if (!show) {
        [self.loadingImageView.layer removeAllAnimations];
        return;
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = @(0);
    animation.toValue = @(M_PI * 2.0);
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]; // 动画效果慢进慢出
    animation.duration = 1.5; //动画持续时间
    animation.repeatCount = HUGE_VALF; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    animation.removedOnCompletion = NO; //动画后是否回到最初状态（配合kCAFillModeForwards使用）
    animation.fillMode = kCAFillModeForwards;
    [self.loadingImageView.layer addAnimation:animation forKey:@"rotation"];

}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.clipsToBounds = true;
        _contentView.backgroundColor = HEX_COLOR_A(@"#000000", 0.75);
        [_contentView dt_cornerRadius:8];
    }
    return _contentView;
}

- (UIImageView *)loadingImageView {
    if (!_loadingImageView) {
        _loadingImageView = [[UIImageView alloc] init];
        _loadingImageView.image = [UIImage imageNamed:@"gift_rocket_loading"];
    }
    return _loadingImageView;
}

- (UILabel *)loadingLabel {
    if (!_loadingLabel) {
        _loadingLabel = [[UILabel alloc] init];
        _loadingLabel.text = @"正在前往火箭台...";
        _loadingLabel.numberOfLines = 1;
        _loadingLabel.textColor = UIColor.whiteColor;
        _loadingLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _loadingLabel;
}
@end
