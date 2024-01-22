//
// Created by kaniel on 2022/5/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "QSGameListCell.h"
#import "QSGameItemModel.h"

@interface QSGameListCell ()
@property (nonatomic, strong) UIView *containerView;
/// 游戏图标
@property (nonatomic, strong) UIImageView *iconImageView;
/// 游戏名称
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation QSGameListCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.nameLabel.text = nil;
    self.iconImageView.image = nil;
}

- (void)setModel:(BaseModel *)model {
    QSGameItemModel *m = (QSGameItemModel *) model;
    self.nameLabel.text = m.gameName;
    self.iconImageView.image = [UIImage imageNamed:m.gamePic];
    
}

- (void)dtAddViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.iconImageView];
    [self.iconImageView addSubview:self.nameLabel];
    
}

- (void)dtLayoutViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.leading.mas_equalTo(8);
        make.trailing.mas_equalTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)dtConfigUI {
    self.backgroundColor = UIColor.whiteColor;
    [self.iconImageView dt_cornerRadius:8];
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
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textColor = UIColor.whiteColor;
        _nameLabel.font = UIFONT_MEDIUM(14);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}
@end
