//
//  DiscoMenuView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/7/1.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoMenuView.h"

@interface DiscoMenuView()
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) MarqueeLabel *titleLabel;
@end

@implementation DiscoMenuView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.bgImageView];
    [self addSubview:self.titleLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(@0);
        make.width.equalTo(@122);
        make.height.equalTo(@45);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(@10);
        make.trailing.equalTo(@-10);
        make.height.greaterThanOrEqualTo(@0);
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

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"disco_menu_bg"];
    }
    return _bgImageView;
}

- (MarqueeLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[MarqueeLabel alloc] init];
        _titleLabel.font = UIFONT_BOLD(14);
        _titleLabel.textColor = HEX_COLOR_A(@"#ffffff", 1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = NSString.dt_room_disco_menu_name;
    }
    return _titleLabel;
}
@end
