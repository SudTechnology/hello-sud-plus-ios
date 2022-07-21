//
//  DiscoMenuView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/7/1.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoGameInteractiveView.h"

@interface DiscoGameInteractiveView()
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) MarqueeLabel *titleLabel;
@end

@implementation DiscoGameInteractiveView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.bgImageView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(@0);
        make.width.equalTo(@72);
        make.height.equalTo(@32);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@7);
        make.width.height.equalTo(@24);
        make.centerY.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(2);
        make.trailing.equalTo(@-2);
        make.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.iconImageView);
    }];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
}

- (void)dtConfigUI {
    [super dtConfigUI];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];

}


- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"disco_conmunicate_icon"];
    }
    return _iconImageView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"disco_conmunicate_bg"];
    }
    return _bgImageView;
}

- (MarqueeLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[MarqueeLabel alloc] init];
        _titleLabel.font = UIFONT_MEDIUM(14);
        _titleLabel.textColor = HEX_COLOR_A(@"#FFF8EE", 1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = NSString.dt_room_disco_interactive;
    }
    return _titleLabel;
}
@end
