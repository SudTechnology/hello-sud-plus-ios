//
//  HSHotGamesHeaderView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "HSHotGamesHeaderView.h"

@interface HSHotGamesHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *gameNumLabel;
@property (nonatomic, strong) UILabel *moreLabel;
@property (nonatomic, strong) UIImageView *moreArrowNode;
@property (nonatomic, strong) UIView *containerView;
@end

@implementation HSHotGamesHeaderView

- (void)hsConfigUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F5F6FB" alpha:1];
}

- (void)reloadData {
    for (UIView * v in self.containerView.subviews) {
        [v removeFromSuperview];
    }
    for (int i = 0; i < 8; i++) {
        UIView *contenView = [[UIView alloc] init];
        contenView.backgroundColor = UIColor.whiteColor;
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"game_type_header_item_%d", 0]];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"飞镖达人";
        titleLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        [self.containerView addSubview:contenView];
        [contenView addSubview:iconImageView];
        [contenView addSubview:titleLabel];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(contenView);
            make.height.mas_equalTo(contenView.mas_width);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(contenView);
            make.top.mas_equalTo(iconImageView.mas_bottom).offset(6);
            make.size.mas_greaterThanOrEqualTo(CGSizeZero);
            make.bottom.mas_equalTo(-8);
        }];
    }
    [self.containerView.subviews hs_mas_distributeSudokuViewsWithFixedItemWidth:0 fixedItemHeight:0
                                                fixedLineSpacing:8 fixedInteritemSpacing:10
                                                       warpCount:4
                                                      topSpacing:0
                                                   bottomSpacing:12 leadSpacing:16 tailSpacing:16];
}

- (void)hsAddViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.gameNumLabel];
    [self addSubview:self.moreLabel];
    [self addSubview:self.moreArrowNode];
    [self addSubview:self.containerView];
    [self reloadData];
}

- (void)hsLayoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.gameNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right);
        make.bottom.mas_equalTo(self.titleLabel);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.moreArrowNode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(9);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.moreArrowNode.mas_left);
        make.centerY.mas_equalTo(self.moreArrowNode);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(12);
        make.left.right.equalTo(self);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"热门游戏";
        _titleLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    }
    return _titleLabel;
}

- (UILabel *)gameNumLabel {
    if (!_gameNumLabel) {
        _gameNumLabel = [[UILabel alloc] init];
        _gameNumLabel.text = @"(0)";
        _gameNumLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
        _gameNumLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    }
    return _gameNumLabel;
}

- (UIImageView *)moreArrowNode {
    if (!_moreArrowNode) {
        _moreArrowNode = [[UIImageView alloc] init];
        _moreArrowNode.image = [UIImage imageNamed:@"game_home_more_arrow"];
    }
    return _moreArrowNode;
}

- (UILabel *)moreLabel {
    if (!_moreLabel) {
        _moreLabel = [[UILabel alloc] init];
        _moreLabel.text = @"更多游戏";
        _moreLabel.textColor = [UIColor colorWithHexString:@"#8A8A8E" alpha:1];
        _moreLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    }
    return _moreLabel;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

@end
