//
// Created by kaniel on 2022/5/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "CrossRoomGameCell.h"
#import "QSGameItemModel.h"

@interface CrossRoomGameCell ()
@property (nonatomic, strong) UIView *idBgView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation CrossRoomGameCell

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setModel:(BaseModel *)model {
    CrossRoomModel *m = (CrossRoomModel *) model;
    self.nameLabel.text = [NSString stringWithFormat:@"ID %@", m.room_id];
    self.numLabel.text = [NSString stringWithFormat:@"%@ 人在玩", m.player_total];
    self.iconImageView.image = [UIImage imageNamed:@"default_game_bg"];
}

- (void)dtAddViews {
    [self.idBgView addSubview:self.iconImageView];
    [self.contentView addSubview:self.idBgView];
    [self.idBgView addSubview:self.nameLabel];
    [self.contentView addSubview:self.numLabel];
    
}

- (void)dtLayoutViews {
    [self.idBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(@0);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@4);
        make.bottom.equalTo(@-3);
        make.leading.mas_equalTo(10);
        make.trailing.mas_equalTo(-10);
        make.height.mas_greaterThanOrEqualTo(0);
        make.width.greaterThanOrEqualTo(@0);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-8);
        make.leading.mas_equalTo(10);
        make.trailing.mas_equalTo(-10);
        make.height.mas_greaterThanOrEqualTo(0);
        make.width.greaterThanOrEqualTo(@0);
    }];
}

- (void)dtConfigUI {
    [self.contentView dt_cornerRadius:8];
}

- (UIView *)idBgView {
    if (!_idBgView) {
        _idBgView = [[UIView alloc] init];
        _idBgView.backgroundColor = HEX_COLOR_A(@"#000000", 0.5);
    }
    return _idBgView;
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
        _nameLabel.font = UIFONT_REGULAR(12);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.text = @"";
        _numLabel.textColor = UIColor.whiteColor;
        _numLabel.font = UIFONT_BOLD(16);
        _numLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _numLabel;
}
@end
