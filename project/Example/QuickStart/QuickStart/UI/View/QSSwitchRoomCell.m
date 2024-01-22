//
//  QSSwitchRoomCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/16.
//

#import "QSSwitchRoomCell.h"

@interface QSSwitchRoomCell ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, assign) CGFloat itemW;
@property (nonatomic, assign) CGFloat itemH;
@end

@implementation QSSwitchRoomCell

- (void)setModel:(BaseModel *)model {
    QSGameItemModel *m = (QSGameItemModel *) model;
    self.iconImageView.image = [UIImage imageNamed:m.gameRoomPic];
    self.nameLabel.text = m.gameName;
}

- (void)dtAddViews {
    self.itemW = (kScreenWidth - 32 - 24 - 24 )/4;
    self.itemH = self.itemW + 32;
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.iconImageView];
    [self.containerView addSubview:self.nameLabel];
    [self.containerView addSubview:self.inGameLabel];
}

- (void)dtLayoutViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.centerX.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.itemW);
        make.height.mas_equalTo(self.itemW);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.containerView);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(3);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.inGameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(self.iconImageView);
        make.size.mas_equalTo(CGSizeMake(40, 16));
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
        _nameLabel.textColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        _nameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)inGameLabel {
    if (!_inGameLabel) {
        _inGameLabel = [[UILabel alloc] init];
        _inGameLabel.text = @"游戏中";
        _inGameLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
        _inGameLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        _inGameLabel.textAlignment = NSTextAlignmentCenter;
        _inGameLabel.backgroundColor = [UIColor dt_colorWithHexString:@"#000000" alpha:0.8];
        [_inGameLabel setHidden:true];
    }
    return _inGameLabel;
}

@end
