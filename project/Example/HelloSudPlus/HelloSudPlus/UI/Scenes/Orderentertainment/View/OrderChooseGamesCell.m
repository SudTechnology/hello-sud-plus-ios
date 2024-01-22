//
//  OrderChooseGamesCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/18.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "OrderChooseGamesCell.h"

@interface OrderChooseGamesCell ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *gameImageView;
@property (nonatomic, strong) MarqueeLabel *roomNameLabel;
@property (nonatomic, strong) MarqueeLabel *goldLabel;
@property (nonatomic, strong) UIImageView *goldImgView;

@end

@implementation OrderChooseGamesCell

- (void)setModel:(BaseModel *)model {
    HSGameItem *m = (HSGameItem *) model;
    
    [self.gameImageView sd_setImageWithURL:[NSURL URLWithString:m.gamePic]];
    self.roomNameLabel.text = m.gameName;
    self.containerView.layer.borderColor = m.isSelect ? [UIColor dt_colorWithHexString:@"#000000" alpha:1].CGColor : UIColor.clearColor.CGColor;
    [_goldLabel restartLabel];
}

- (void)dtAddViews {
    [self.contentView addSubview:self.containerView];
    [self.contentView addSubview:self.gameImageView];
    [self.contentView addSubview:self.roomNameLabel];
    [self.contentView addSubview:self.goldLabel];
    [self.contentView addSubview:self.goldImgView];
}

- (void)dtLayoutViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.gameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerX.mas_equalTo(self.contentView);
    }];
    [self.roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gameImageView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.contentView);
        make.leading.trailing.mas_equalTo(self.contentView);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.roomNameLabel.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.contentView.mas_centerX).offset(9);
        make.size.mas_equalTo(CGSizeMake(60, 17));
    }];
    [self.goldImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.goldLabel.mas_leading).offset(-4);
        make.centerY.mas_equalTo(self.goldLabel);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
}

#pragma mark - Lazy

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = UIColor.whiteColor;
        _containerView.layer.cornerRadius = 8;
        _containerView.layer.borderWidth = 1;
    }
    return _containerView;
}

- (UIImageView *)gameImageView {
    if (!_gameImageView) {
        _gameImageView = [[UIImageView alloc] init];
        _gameImageView.contentMode = UIViewContentModeScaleAspectFill;
        _containerView.layer.cornerRadius = 6;
    }
    return _gameImageView;
}

- (MarqueeLabel *)roomNameLabel {
    if (!_roomNameLabel) {
        _roomNameLabel = [[MarqueeLabel alloc] init];
        _roomNameLabel.text = @"";
        _roomNameLabel.fadeLength = 10;
        _roomNameLabel.trailingBuffer = 20;
        _roomNameLabel.textColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1];
        _roomNameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _roomNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _roomNameLabel;
}

- (MarqueeLabel *)goldLabel {
    if (!_goldLabel) {
        _goldLabel = [[MarqueeLabel alloc]init];
        _goldLabel.text = NSString.dt_room_bureau_person;
        _goldLabel.textColor = [UIColor dt_colorWithHexString:@"#F6A209" alpha:1];
        _goldLabel.font = UIFONT_REGULAR(12);
        _goldLabel.trailingBuffer = 10;
    }
    return _goldLabel;
}

- (UIImageView *)goldImgView {
    if (!_goldImgView) {
        _goldImgView = UIImageView.new;
        _goldImgView.image = [UIImage imageNamed:@"order_pop_gold"];
    }
    return _goldImgView;
}

@end
