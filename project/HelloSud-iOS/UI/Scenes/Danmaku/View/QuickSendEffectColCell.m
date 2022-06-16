//
//  QuickSendColCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/10.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "QuickSendEffectColCell.h"

@interface QuickSendEffectColCell()
@property(nonatomic, strong) MarqueeLabel *titleLabel;
@property(nonatomic, strong) UIView *iconContentView;
@property(nonatomic, strong) BaseView *callView;
@property(nonatomic, strong) MarqueeLabel *callLabel;
@end

@implementation QuickSendEffectColCell
- (void)dtAddViews {

    [super dtAddViews];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.iconContentView];
    [self.contentView addSubview:self.callView];
    [self.callView addSubview:self.callLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@6);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@17);
    }];

    [self.iconContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@30);
    }];
    [self.callView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(@90);
        make.height.equalTo(@20);
    }];
    [self.callLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.callView);
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

- (UIView *)iconContentView {
    if (!_iconContentView) {
        _iconContentView = [[UIView alloc] init];
        _iconContentView.backgroundColor = HEX_COLOR(@"#FF711A");
        [_iconContentView dt_cornerRadius:8];
    }
    return _iconContentView;
}

- (MarqueeLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[MarqueeLabel alloc] init];
        _titleLabel.text = @"弹幕魔兽";
        _titleLabel.font = UIFONT_REGULAR(12);
        _titleLabel.textColor = HEX_COLOR(@"#C0B8A0");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (BaseView *)callView {
    if (!_callView) {
        _callView = [[BaseView alloc] init];
        [_callView dt_cornerRadius:2];
        [_callView dtAddGradientLayer:@[@0, @1] colors:@[(id) HEX_COLOR(@"#F09701").CGColor, (id) HEX_COLOR(@"#FAB300").CGColor] startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1) cornerRadius:0];
    }
    return _callView;
}


- (UIButton *)callLabel {
    if (!_callLabel) {
        _callLabel = [[MarqueeLabel alloc] init];
        _callLabel.text = @"弹幕666";
        _callLabel.font = UIFONT_MEDIUM(10);
        _callLabel.textColor = HEX_COLOR(@"#ffffff");
        _callLabel.textAlignment = NSTextAlignmentCenter;

    }
    return _callLabel;
}
@end
