//
//  GuessResultTableViewCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "CommonListStringCell.h"
#import "CommonListStringCellModel.h"
@interface CommonListStringCell ()
@property(nonatomic, strong) UIView *topLineView;
@property(nonatomic, strong) UILabel *typeLabel;
@property(nonatomic, strong) UIImageView *markImageView;
@property(nonatomic, strong) UILabel *titleLabel;

@end

@implementation CommonListStringCell

- (void)dtAddViews {
    [super dtAddViews];
    [self.contentView addSubview:self.topLineView];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.markImageView];
    [self.contentView addSubview:self.titleLabel];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@36);
        make.trailing.equalTo(self.markImageView.mas_leading).offset(-8);
        make.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(@0);
    }];


    [self.markImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-14);
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.contentView);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = UIColor.clearColor;
    self.topLineView.hidden = YES;
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (![self.model isKindOfClass:CommonListStringCellModel.class]) {
        return;
    }
    CommonListStringCellModel *m = (CommonListStringCellModel *) self.model;
    self.markImageView.hidden = m.isSelected ? NO : YES;
    self.titleLabel.text = m.title;

}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = UIView.new;
        _topLineView.backgroundColor = HEX_COLOR(@"#D1D1D1");
    }
    return _topLineView;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textAlignment = NSTextAlignmentLeft;

        _typeLabel.font = UIFONT_REGULAR(14);
        _typeLabel.textColor = HEX_COLOR(@"#8A8A8E");
    }
    return _typeLabel;
}

- (UIImageView *)markImageView {
    if (!_markImageView) {
        _markImageView = [[UIImageView alloc] init];
        _markImageView.contentMode = UIViewContentModeScaleAspectFill;
        _markImageView.clipsToBounds = YES;
        _markImageView.image = [UIImage imageNamed:@"my_ethereum_chains_selected"];
    }
    return _markImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = UIFONT_REGULAR(16);
        _titleLabel.textColor = HEX_COLOR(@"#1A1A1A");
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _titleLabel;
}
@end
