//
//  GuessMineView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/13.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GuessMineView.h"
#import "SwitchAutoGuessPopView.h"

@interface GuessMineView()
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UILabel *coinLabel;
@property(nonatomic, strong) MarqueeLabel *tipLabel;
@end

@implementation GuessMineView

- (void)dtAddViews {

    [self addSubview:self.bgImageView];
    [self addSubview:self.coinLabel];
    [self addSubview:self.tipLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-27));
        make.width.height.greaterThanOrEqualTo(@0);
        make.centerX.equalTo(self);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
        make.bottom.equalTo(@-4);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];

}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    self.coinLabel.text = @"x200";
    self.tipLabel.text = @"猜自己赢";
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
        _bgImageView.image = [UIImage imageNamed:@"guess_mine_bg"];
    }
    return _bgImageView;
}

- (UILabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[UILabel alloc] init];
        _coinLabel.font = UIFONT_MEDIUM(14);
        _coinLabel.textColor = HEX_COLOR(@"#482500");
    }
    return _coinLabel;
}

- (MarqueeLabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[MarqueeLabel alloc] init];
        _tipLabel.text = @"UMO";
        _tipLabel.font = UIFONT_MEDIUM(12);
        _tipLabel.textColor = HEX_COLOR(@"#482500");
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}
@end
