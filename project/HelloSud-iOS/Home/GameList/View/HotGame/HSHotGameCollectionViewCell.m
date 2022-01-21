//
//  HSHotGameCollectionViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "HSHotGameCollectionViewCell.h"

@interface HSHotGameCollectionViewCell ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation HSHotGameCollectionViewCell

- (void)hsAddViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.iconImageView];
    [self.containerView addSubview:self.nameLabel];
}

- (void)hsLayoutViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(self.containerView.mas_width);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(6);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = UIColor.whiteColor;
    }
    return _containerView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"game_type_header_item_0"];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"飞镖达人";
        _nameLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
        _nameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

@end
