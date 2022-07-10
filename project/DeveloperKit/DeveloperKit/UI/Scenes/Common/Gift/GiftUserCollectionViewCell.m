//
//  GiftUserCollectionViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "GiftUserCollectionViewCell.h"

@interface GiftUserCollectionViewCell ()
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *micNumLabel;
@property (nonatomic, strong) UIImageView *selectView;
@end

@implementation GiftUserCollectionViewCell

- (void)dtAddViews {
    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.micNumLabel];
    [self.contentView addSubview:self.selectView];
}

- (void)dtLayoutViews {

    [self.headerView dt_cornerRadius:16];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17);
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.centerX.mas_equalTo(self.contentView);
    }];
    [self.micNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_top).offset(26);
        make.size.mas_equalTo(CGSizeMake(26, 12));
        make.centerX.mas_equalTo(self.contentView);
    }];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_top).offset(-3);
        make.trailing.mas_equalTo(self.headerView.mas_trailing).offset(3);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
}

- (void)dtUpdateUI {
    if ([self.model isKindOfClass:AudioRoomMicModel.class]) {
        AudioRoomMicModel *m = (AudioRoomMicModel *)self.model;
        if (m.user.icon) {
            [self.headerView sd_setImageWithURL:[NSURL URLWithString:m.user.icon]];
        }
        self.micNumLabel.text = m.user.roleType == 1 ? NSString.dt_room_owner : [NSString stringWithFormat:NSString.dt_mic_index, m.micIndex + 1];
        self.selectView.image = m.isSelected ? [UIImage imageNamed:@"room_gift_user_select"] : nil;
        
        
        self.headerView.layer.borderWidth = m.isSelected ? 1 : 0;
        self.headerView.layer.borderColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1].CGColor;
        
        self.micNumLabel.layer.borderColor = [UIColor dt_colorWithHexString:m.isSelected ? @"#FFFFFF" : @"#666666" alpha:1].CGColor;
    }
}

#pragma mark lazy

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.layer.masksToBounds = true;
    }
    return _headerView;
}

- (UIImageView *)selectView {
    if (!_selectView) {
        _selectView = [[UIImageView alloc] init];
    }
    return _selectView;
}

- (UILabel *)micNumLabel {
    if (!_micNumLabel) {
        _micNumLabel = [[UILabel alloc] init];
        _micNumLabel.text =  [NSString stringWithFormat:@"1%@", NSString.dt_mic_name];
        _micNumLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
        _micNumLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
        _micNumLabel.backgroundColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1];
        _micNumLabel.layer.borderWidth = 1;
        _micNumLabel.layer.borderColor = [UIColor dt_colorWithHexString:@"#666666" alpha:1].CGColor;
        _micNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _micNumLabel;
}

@end
