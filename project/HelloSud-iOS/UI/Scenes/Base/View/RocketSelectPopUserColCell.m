//
//  GiftUserCollectionViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "RocketSelectPopUserColCell.h"

@interface RocketSelectPopUserColCell ()
@property (nonatomic, strong) SDAnimatedImageView *headerView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *selectView;
@end

@implementation RocketSelectPopUserColCell

- (void)dtAddViews {
    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.selectView];
}

- (void)dtLayoutViews {

    [self.headerView dt_cornerRadius:36];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(72, 72));
        make.centerX.mas_equalTo(self.contentView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(8);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@17);
    }];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_top);
        make.trailing.mas_equalTo(self.headerView.mas_trailing);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
}

- (void)dtUpdateUI {
    if ([self.model isKindOfClass:AudioRoomMicModel.class]) {
        AudioRoomMicModel *m = (AudioRoomMicModel *)self.model;
        if (m.user.icon) {
            [self.headerView sd_setImageWithURL:[NSURL URLWithString:m.user.icon] placeholderImage:[UIImage imageNamed:@"default_head"]];
        }
        self.nameLabel.text = m.user.name;
        self.selectView.image = m.isSelected ? [UIImage imageNamed:@"rocket_select_pop_select"] : nil;

        self.headerView.layer.borderWidth = m.isSelected ? 2 : 0;
        self.headerView.layer.borderColor = m.isSelected ? [UIColor dt_colorWithHexString:@"#9CE9FA" alpha:1].CGColor : nil;
    }
}

#pragma mark lazy

- (SDAnimatedImageView *)headerView {
    if (!_headerView) {
        _headerView = [[SDAnimatedImageView alloc] init];
        _headerView.layer.masksToBounds = true;
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerView;
}

- (UIImageView *)selectView {
    if (!_selectView) {
        _selectView = [[UIImageView alloc] init];
    }
    return _selectView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HEX_COLOR(@"#B5EEFC");
        _nameLabel.font = UIFONT_REGULAR(12);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

@end
