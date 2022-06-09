//
//  RankNumItemView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RankNumItemView.h"

@interface RankNumItemView ()

@property(nonatomic, strong) UILabel *tagLabel;
@end

@implementation RankNumItemView


- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.tagLabel];
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
    NSDictionary *dic = @{NSFontAttributeName: UIFONT_REGULAR(10), NSForegroundColorAttributeName: HEX_COLOR_A(@"#000000", 0.6)};
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"胜利(场)\n"
                                                                             attributes:dic];
    NSDictionary *dic2 = @{NSFontAttributeName: UIFONT_BOLD(24), NSForegroundColorAttributeName: HEX_COLOR(@"#5C3B20")};
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", @(self.count)]
                                                                              attributes:dic2];
    [attr appendAttributedString:attr2];
    self.tagLabel.attributedText = attr;

    [self.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.greaterThanOrEqualTo(@0);
        make.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self);
        switch (self.rank) {
            case 1:
                make.centerX.equalTo(self);
                break;
            case 2:
                make.leading.equalTo(@26);
                break;
            case 3:
                make.trailing.equalTo(@-26);
                break;
        }
    }];
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = UIFONT_REGULAR(10);
        _tagLabel.textColor = UIColor.whiteColor;
        _tagLabel.numberOfLines = 0;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel;
}
@end
