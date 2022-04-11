//
//  GameItemCollectionViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "GameItemCollectionViewCell.h"

@interface GameItemCollectionViewCell ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *gameImageView;
@property (nonatomic, strong) UILabel *nameLabel;
/// 加入
@property (nonatomic, strong) UILabel *enterLabel;

@end

@implementation GameItemCollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.nameLabel.text = nil;
    self.gameImageView.image = nil;
}

- (void)setModel:(BaseModel *)model {
    HSGameItem *m = (HSGameItem *) model;
    self.nameLabel.text = m.gameName;
    if (m.isGameWait) {
        self.nameLabel.textColor = HEX_COLOR(@"#AAAAAA");
        self.gameImageView.image = [UIImage imageNamed:m.gamePic];
    } else if (m.isBlank){
        self.gameImageView.image = nil;
    }  else {
        self.nameLabel.textColor = UIColor.whiteColor;
        [self.gameImageView sd_setImageWithURL:[NSURL URLWithString:m.gamePic] placeholderImage:[UIImage imageNamed:@"default_game_bg"]];
    }
    self.enterLabel.hidden = m.isBlank;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    NSInteger v = indexPath.row % 3;

    [self.gameImageView dt_cornerRadius:8];
    [self.gameImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        if (v == 0) {
            make.leading.mas_equalTo(13);
        } else if (v == 1) {
            make.centerX.equalTo(self.containerView);
        } else {
            make.trailing.mas_equalTo(-13);
        }
        make.size.mas_equalTo(CGSizeMake(100, 52));
    }];
}

- (void)hsAddViews {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.gameImageView];
    [self.containerView addSubview:self.nameLabel];
    [self.containerView addSubview:self.inGameLabel];
}

- (void)hsLayoutViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.gameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 52));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.gameImageView).offset(8);
        make.top.equalTo(self.gameImageView).offset(12);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.inGameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.gameImageView);
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

- (UIImageView *)gameImageView {
    if (!_gameImageView) {
        _gameImageView = [[UIImageView alloc] init];
        _gameImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _gameImageView;
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
