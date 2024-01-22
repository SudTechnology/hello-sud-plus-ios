//
//  RankNumItemView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RankNumItemView.h"

@interface RankNumItemView ()

@property(nonatomic, strong) MarqueeLabel *titleLabel;
@property(nonatomic, strong) UILabel *numLabel;
@end

@implementation RankNumItemView


- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.titleLabel];
    [self addSubview:self.numLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];



}

- (void)dtConfigUI {
    [super dtConfigUI];
    [self dtAddGradientLayer:@[@0, @1] colors:@[(id) HEX_COLOR(@"#FFF3E3").CGColor, (id) HEX_COLOR(@"#C9AB96").CGColor] startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1) cornerRadius:0];
    [self setPartRoundCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:10];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    self.titleLabel.text = self.tip;
    self.numLabel.text = [NSString stringWithFormat:@"%@", @(self.count)];

    switch (self.rank) {
        case 1:
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            break;
        case 2:
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
            break;
        case 3:
            self.titleLabel.textAlignment = NSTextAlignmentRight;
            break;
    }

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@12);
        make.bottom.equalTo(self.numLabel.mas_top).offset(0);
        switch (self.rank) {
            case 1:
                make.leading.equalTo(@0);
                make.trailing.equalTo(@0);
                break;
            case 2:
                make.leading.equalTo(@16);
                make.trailing.equalTo(@-36);
                break;
            case 3:
                make.leading.equalTo(@36);
                make.trailing.equalTo(@-16);
                break;
        }
    }];
    [self.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.greaterThanOrEqualTo(@0);
        make.top.equalTo(self.mas_centerY).offset(-10);
        switch (self.rank) {
            case 1:
                make.leading.equalTo(@0);
                make.trailing.equalTo(@0);
                break;
            case 2:
                make.leading.equalTo(@16);
                make.trailing.equalTo(@-36);
                break;
            case 3:
                make.leading.equalTo(@36);
                make.trailing.equalTo(@-16);
                break;
        }
    }];


}

- (MarqueeLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[MarqueeLabel alloc] init];
        _titleLabel.font = UIFONT_REGULAR(10);
        _titleLabel.textColor = HEX_COLOR_A(@"#000000", 0.6);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = UIFONT_MEDIUM(24);
        _numLabel.textColor = HEX_COLOR(@"5C3B20");
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}
@end
