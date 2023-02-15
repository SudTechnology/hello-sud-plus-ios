//
//  SwitchRoomCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/16.
//

#import "CrossAppSelectGameCell.h"

@interface CrossAppSelectGameCell ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, assign) CGFloat itemW;
@property (nonatomic, assign) CGFloat itemH;
@end

@implementation CrossAppSelectGameCell

- (void)setModel:(BaseModel *)model {
    HSGameItem *m = (HSGameItem *) model;
    
    if (m.itemType != 0) {
        self.iconImageView.image = [UIImage imageNamed:m.gamePic];
        self.nameLabel.text = m.gameName;
    } else {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:m.gamePic]];
        self.nameLabel.text = m.gameName;
    }

    if (m.isSelect) {
        self.selectImageView.hidden = NO;
        self.iconImageView.layer.borderWidth = 2;
        self.iconImageView.layer.borderColor = [UIColor.blackColor CGColor];
    } else {
        self.selectImageView.hidden = YES;
        self.iconImageView.layer.borderWidth = 0;
        self.iconImageView.layer.borderColor = nil;
    }
}

- (void)dtAddViews {
    self.itemW = (kScreenWidth - 32 - 24 - 24 )/4;
    self.itemH = self.itemW + 32;
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.iconImageView];
    [self.containerView addSubview:self.nameLabel];
    [self.containerView addSubview:self.selectImageView];
}

- (void)dtLayoutViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.iconImageView dt_cornerRadius:12];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView);
        make.centerX.mas_equalTo(self.containerView);
        make.width.mas_equalTo(self.itemW);
        make.height.mas_equalTo(self.itemW);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.containerView);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(6);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView);
        make.trailing.mas_equalTo(self.iconImageView);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
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

- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.image = [UIImage imageNamed:@"cross_app_game_select"];
    }
    return _selectImageView;
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

@end
