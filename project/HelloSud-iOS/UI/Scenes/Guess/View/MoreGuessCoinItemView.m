//
// Created by kaniel on 2022/6/8.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "MoreGuessCoinItemView.h"
@interface MoreGuessCoinItemView()
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *coinLabel;
@end

@implementation MoreGuessCoinItemView

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        self.layer.borderWidth = 2;
        self.layer.borderColor = HEX_COLOR(@"#FFBF3A").CGColor;
        self.nameLabel.textColor = HEX_COLOR(@"#F6A209");
        self.coinLabel.textColor = HEX_COLOR(@"#F6A209");
    } else {
        self.layer.borderWidth = 0;
        self.layer.borderColor = nil;
        self.nameLabel.textColor = HEX_COLOR(@"#000000");
        self.coinLabel.textColor = HEX_COLOR(@"#666666");
    }
}

- (void)setCoin:(NSInteger)coin {
    _coin = coin;
    self.nameLabel.text = [NSString stringWithFormat:@"%@", @(coin)];
}

- (void)onTap:(id)sender {
    if (self.isSelected) {
        return;
    }
    self.isSelected = !self.isSelected;
    if (self.onStateChangedBlock) {
        self.onStateChangedBlock(self, self.isSelected);
    }
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = UIColor.whiteColor;
    [self dt_cornerRadius:8];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:tap];
}

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.nameLabel];
    [self addSubview:self.coinLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(@10);
       make.height.equalTo(@42);
       make.width.greaterThanOrEqualTo(@0);
       make.centerX.equalTo(self);
    }];
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.height.equalTo(@20);
        make.width.greaterThanOrEqualTo(@0);
        make.centerX.equalTo(self);
    }];

}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = UIFONT_MEDIUM(30);
        _nameLabel.textColor = HEX_COLOR(@"#000000");
        _nameLabel.text = @"100";
    }
    return _nameLabel;
}

- (UILabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[UILabel alloc] init];
        _coinLabel.font = UIFONT_MEDIUM(14);
        _coinLabel.textColor = HEX_COLOR(@"#666666");
        _coinLabel.text = [NSString stringWithFormat:NSString.dt_room_guess_coin_fmt, @""];
    }
    return _coinLabel;
}
@end
