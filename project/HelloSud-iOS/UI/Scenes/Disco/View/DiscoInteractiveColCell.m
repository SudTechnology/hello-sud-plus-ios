//
//  DiscoSelectAnchorColCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/10.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoInteractiveColCell.h"
#import "DiscoInteractiveModel.h"

@interface DiscoInteractiveColCell ()
@property(nonatomic, strong) BaseView *bgView;
@property(nonatomic, strong) MarqueeLabel *titleLabel;
@property(nonatomic, strong) YYLabel *coinLabel;
@end

@implementation DiscoInteractiveColCell
- (void)dtAddViews {

    [super dtAddViews];
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.coinLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(@0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@18);
        make.height.greaterThanOrEqualTo(@0);
        make.leading.trailing.equalTo(@0);
    }];
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
        make.height.greaterThanOrEqualTo(@0);
        make.width.greaterThanOrEqualTo(@0);
        make.centerX.equalTo(self.contentView);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];

    if (![self.model isKindOfClass:DiscoInteractiveModel.class]) {
        return;
    }
    DiscoInteractiveModel *m = (DiscoInteractiveModel *) self.model;
    self.titleLabel.text = m.name;
    if (m.coin < 0) {
        self.coinLabel.hidden = YES;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@18);
        }];
    } else {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@8);
        }];
        [self updateCoin:m.coin];
        self.coinLabel.hidden = NO;
    }
}

- (void)dtConfigEvents {
    [super dtConfigEvents];

}

- (void)updateCoin:(int64_t)coin {

    if (coin > 0) {
        NSMutableAttributedString *full = [[NSMutableAttributedString alloc] init];
        UIImage *iconImage = [UIImage imageNamed:@"guess_award_coin"];
        NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(12, 12) alignToFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
        [full appendAttributedString:attrIcon];
        NSNumber *number = @(coin);
        NSMutableAttributedString *attrAwardValue = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", number]];
        attrAwardValue.yy_font = UIFONT_MEDIUM(12);
        attrAwardValue.yy_color = HEX_COLOR(@"#FFF6E0");
        [full appendAttributedString:attrAwardValue];

        self.coinLabel.attributedText = full;
    } else {
        self.coinLabel.attributedText = nil;
        self.coinLabel.text = NSString.dt_room_guess_fee;
    }
}


- (BaseView *)bgView {
    if (!_bgView) {
        _bgView = [[BaseView alloc] init];
        NSArray *colorArr = @[(id) [UIColor dt_colorWithHexString:@"#FFBF28" alpha:1].CGColor, (id) [UIColor dt_colorWithHexString:@"#FF6D2B" alpha:1].CGColor];
        [_bgView dtAddGradientLayer:@[@(0.0f), @(1)] colors:colorArr startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1) cornerRadius:0];
        [_bgView dt_cornerRadius:4];
    }
    return _bgView;
}

- (MarqueeLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[MarqueeLabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = UIFONT_MEDIUM(14);
        _titleLabel.textColor = HEX_COLOR(@"#712600");
    }
    return _titleLabel;
}

- (YYLabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[YYLabel alloc] init];
        _coinLabel.font = UIFONT_MEDIUM(12);
        _coinLabel.textColor = HEX_COLOR(@"#FFF6E0");
    }
    return _coinLabel;
}
@end
