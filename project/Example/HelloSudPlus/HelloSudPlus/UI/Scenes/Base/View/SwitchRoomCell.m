//
//  SwitchRoomCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/16.
//

#import "SwitchRoomCell.h"

@interface SwitchRoomCell ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, assign) CGFloat itemW;
@property (nonatomic, assign) CGFloat itemH;

@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) UIImageView *tagImageView;
@end

@implementation SwitchRoomCell

- (void)setModel:(BaseModel *)model {
    HSGameItem *m = (HSGameItem *) model;
    
    if (m.itemType != 0) {
        self.iconImageView.image = [UIImage imageNamed:m.gamePic];
        self.nameLabel.text = m.gameName;
    } else {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:m.gamePic]];
        self.nameLabel.text = m.gameName;
    }
    if (m.supportLlm) {
        self.tagView.hidden = NO;
    } else {
        self.tagView.hidden = YES;
    }
}

- (void)dtAddViews {
    self.itemW = (kScreenWidth - 32 - 24 - 24 )/4;
    self.itemH = self.itemW + 32;
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.iconImageView];
    [self.containerView addSubview:self.nameLabel];
    [self.containerView addSubview:self.inGameLabel];
    [self.iconImageView addSubview:self.tagView];
    [self.tagView addSubview:self.tagImageView];
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
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-3);
        make.bottom.equalTo(@-3);
        make.width.equalTo(@32);
        make.height.equalTo(@10);
    }];
    
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tagView);
        make.width.equalTo(@24);
        make.height.equalTo(@6);
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
        _inGameLabel.text = NSString.dt_home_in_game;
        _inGameLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
        _inGameLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        _inGameLabel.textAlignment = NSTextAlignmentCenter;
        _inGameLabel.backgroundColor = [UIColor dt_colorWithHexString:@"#000000" alpha:0.8];
        [_inGameLabel setHidden:true];
    }
    return _inGameLabel;
}


- (UIView *)tagView {
    if (!_tagView) {
        _tagView = [[UIView alloc] init];
        [_tagView dt_cornerRadius:5];
        _tagView.backgroundColor = HEX_COLOR(@"#000000");

    }
    return _tagView;
}

- (UIImageView *)tagImageView {
    if (!_tagImageView) {
        _tagImageView = [[UIImageView alloc] init];
        _tagImageView.contentMode = UIViewContentModeScaleAspectFill;
        _tagImageView.image = [UIImage imageNamed:@"llm_tag"];
    }
    return _tagImageView;
}

@end
