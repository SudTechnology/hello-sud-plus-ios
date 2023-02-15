//
// Created by kaniel on 2022/5/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "CrossRoomGameCell.h"
#import "QSGameItemModel.h"

@interface CrossRoomGameCell ()
@property(nonatomic, strong) UIView *idBgView;
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *roomLabel;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *numLabel;

@end

@implementation CrossRoomGameCell

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setModel:(BaseModel *)model {
    CrossRoomModel *m = (CrossRoomModel *) model;
    HSGameItem *gameItem = [AppService.shared getSceneGameInfo:m.mgId];
    self.roomLabel.text = [NSString stringWithFormat:@"ID %@(%@)", m.localRoomNumber, [m.roomId substringFromIndex:m.roomId.length - 4 > 0 ? m.roomId.length - 4 : 0]];
    self.numLabel.attributedText = [self shadowText:[NSString stringWithFormat:@"%@ 人在玩", m.playerTotal] font:UIFONT_SEMI_BOLD(16)];
    if (gameItem) {
        [self.iconImageView sd_setImageWithURL:gameItem.gamePic.dt_toURL];
        self.nameLabel.attributedText = [self shadowText:gameItem.gameName font:UIFONT_REGULAR(16)];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"default_game_bg"];
    }

}

- (NSAttributedString *)shadowText:(NSString *)text font:(UIFont *)font {
    // shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 3;
    shadow.shadowColor = HEX_COLOR_A(@"#000000", 0.4);
    shadow.shadowOffset = CGSizeMake(0, 0);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text ?: @"" attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor, NSShadowAttributeName: shadow}];
    return string;
}

- (void)dtAddViews {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.idBgView];
    [self.idBgView addSubview:self.roomLabel];
    [self.contentView addSubview:self.numLabel];
    [self.contentView addSubview:self.nameLabel];

}

- (void)dtLayoutViews {
    [self.idBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(@0);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.roomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@4);
        make.bottom.equalTo(@-3);
        make.leading.mas_equalTo(10);
        make.trailing.mas_equalTo(-10);
        make.height.mas_greaterThanOrEqualTo(0);
        make.width.greaterThanOrEqualTo(@0);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.numLabel.mas_top);
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

- (UILabel *)roomLabel {
    if (!_roomLabel) {
        _roomLabel = [[UILabel alloc] init];
        _roomLabel.text = @"";
        _roomLabel.textColor = UIColor.whiteColor;
        _roomLabel.font = UIFONT_REGULAR(12);
        _roomLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _roomLabel;
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
