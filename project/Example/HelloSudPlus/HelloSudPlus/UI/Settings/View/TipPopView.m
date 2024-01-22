//
//  GuessResultTableViewCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "TipPopView.h"
#import "WalletAddressSwitchCellModel.h"

@interface TipPopView ()
@property(nonatomic, strong) UIImageView *markImageView;
@property(nonatomic, strong) DTPaddingLabel *titleLabel;

@end

@implementation TipPopView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.markImageView];
    [self addSubview:self.titleLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.titleLabel dt_cornerRadius:11];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.top.equalTo(@0);
        make.trailing.equalTo(@0);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@23);
    }];

    [self.markImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.width.equalTo(@12);
        make.height.equalTo(@6);
        make.bottom.equalTo(@0);
        make.centerX.equalTo(self);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];

}

- (void)dtUpdateUI {
    [super dtUpdateUI];
}

- (void)updateTip:(NSString *)tip {
    self.titleLabel.text = tip;
}

- (UIImageView *)markImageView {
    if (!_markImageView) {
        _markImageView = [[UIImageView alloc] init];
        _markImageView.contentMode = UIViewContentModeScaleAspectFill;
        _markImageView.clipsToBounds = YES;
        _markImageView.image = [UIImage imageNamed:@"tip_down"];
    }
    return _markImageView;
}

- (DTPaddingLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[DTPaddingLabel alloc] init];
        _titleLabel.paddingX = 12;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = UIFONT_REGULAR(12);
        _titleLabel.textColor = HEX_COLOR(@"#ffffff");
        _titleLabel.backgroundColor = HEX_COLOR_A(@"#000000", 0.7);
    }
    return _titleLabel;
}
@end
