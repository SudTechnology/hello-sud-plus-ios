//
//  GameItemCollectionViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "GameItemCollectionViewCell.h"

@interface GameItemCollectionViewCell ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
/// 加入
@property (nonatomic, strong) UILabel *enterLabel;

@end

@implementation GameItemCollectionViewCell

- (void)setModel:(BaseModel *)model {
    HSGameItem *m = (HSGameItem *) model;
    self.nameLabel.text = m.gameName;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:m.gamePic]];
    self.enterLabel.hidden = m.isBlank;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    NSInteger v = indexPath.row % 3;

    [self.iconImageView dt_cornerRadius:8];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        if (v == 0) {
            make.left.mas_equalTo(13);
        } else if (v == 1) {
            make.centerX.equalTo(self.containerView);
        } else {
            make.right.mas_equalTo(-13);
        }
        make.size.mas_equalTo(CGSizeMake(100, 52));
    }];
}

- (void)hsAddViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.iconImageView];
    [self.containerView addSubview:self.nameLabel];
    [self.containerView addSubview:self.inGameLabel];
}

- (void)hsLayoutViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 52));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView).offset(8);
        make.top.equalTo(self.iconImageView).offset(12);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.inGameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.iconImageView);
        make.size.mas_equalTo(CGSizeMake(40, 16));
    }];
}

- (void)hsConfigUI {
    self.backgroundColor = UIColor.whiteColor;
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

- (UILabel *)enterLabel {
    if (!_enterLabel) {
        _enterLabel = [[UILabel alloc] init];
        _enterLabel.text = NSString.dt_home_join;
        _enterLabel.textColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        _enterLabel.font = UIFONT_BOLD(12);
        _enterLabel.layer.borderColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1].CGColor;
        _enterLabel.layer.borderWidth = 1;
        _enterLabel.layer.cornerRadius = 14;
        _enterLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _enterLabel;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textColor = UIColor.whiteColor;
        _nameLabel.font = UIFONT_MEDIUM(14);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)inGameLabel {
    if (!_inGameLabel) {
        _inGameLabel = [[UILabel alloc] init];
        _inGameLabel.text = NSString.dt_home_in_game;
        _inGameLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
        _inGameLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        _inGameLabel.textAlignment = NSTextAlignmentCenter;
        _inGameLabel.backgroundColor = [UIColor dt_colorWithHexString:@"#000000" alpha:0.8];
        [_inGameLabel setHidden:true];
    }
    return _inGameLabel;
}

@end
