//
//  DiscoMenuView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/7/1.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoAnchorDatingView.h"

@interface DiscoAnchorDatingView()
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) MarqueeLabel *titleLabel;
@end

@implementation DiscoAnchorDatingView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.bgImageView];
    [self addSubview:self.titleLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(@0);
        make.width.equalTo(@75);
        make.height.equalTo(@60);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@6);
        make.trailing.equalTo(@-6);
        make.height.greaterThanOrEqualTo(@0);
        make.bottom.equalTo(@-3);
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
        _bgImageView.image = [UIImage imageNamed:@"disco_anchor_dating_bg"];
    }
    return _bgImageView;
}

- (MarqueeLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[MarqueeLabel alloc] init];
        _titleLabel.font = UIFONT_MEDIUM(12);
        _titleLabel.textColor = HEX_COLOR_A(@"#000402", 1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = NSString.dt_room_disco_appointment_dance;
    }
    return _titleLabel;
}
@end
