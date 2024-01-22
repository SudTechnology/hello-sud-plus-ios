//
//  DiscoRankHeadView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/30.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoRankHeadView.h"

@interface DiscoRankHeadView ()
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) DTPaddingLabel *rankLabel;
@end

@implementation DiscoRankHeadView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.iconImageView];
    [self addSubview:self.rankLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.iconImageView dt_cornerRadius:12];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.width.height.equalTo(@24);
        make.centerX.equalTo(self);
    }];
    [self.rankLabel dt_cornerRadius:3];
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView).offset(1);
        make.centerX.equalTo(self);
        make.height.equalTo(@6);
        make.width.greaterThanOrEqualTo(@0);
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
    self.iconImageView.layer.borderColor = self.borderColor.CGColor;
    self.iconImageView.layer.borderWidth = 1;
    self.rankLabel.backgroundColor = self.borderColor;
    self.rankLabel.text = [NSString stringWithFormat:@"%@", @(self.rank)];
    if (self.imageURL) {
        [self.iconImageView sd_setImageWithURL:[[NSURL alloc] initWithString:self.imageURL] placeholderImage:[UIImage imageNamed:@"room_mic_up"]];
    }
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"room_mic_up"];
    }
    return _iconImageView;
}

- (DTPaddingLabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = [[DTPaddingLabel alloc] init];
        _rankLabel.font = UIFONT_REGULAR(6);
        _rankLabel.paddingX = 4;
        _rankLabel.textColor = HEX_COLOR_A(@"#000000", 1);
        _rankLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rankLabel;
}

@end
