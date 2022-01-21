//
//  HSGiftUserCollectionViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSGiftUserCollectionViewCell.h"

@interface HSGiftUserCollectionViewCell ()
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *micNumLabel;
@property (nonatomic, strong) UIImageView *selectView;
@end

@implementation HSGiftUserCollectionViewCell

- (void)hsAddViews {
    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.micNumLabel];
    [self.contentView addSubview:self.selectView];
}

- (void)hsLayoutViews {
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
        make.top.mas_equalTo(-3);
        make.right.mas_equalTo(3);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
}

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _selectView.image = [UIImage imageNamed:@"room_mic_up"];
        _headerView.layer.masksToBounds = true;
    }
    return _headerView;
}

- (UIImageView *)selectView {
    if (!_selectView) {
        _selectView = [[UIImageView alloc] init];
        _selectView.image = [UIImage imageNamed:@"room_gift_user_select"];
    }
    return _selectView;
}

- (UILabel *)micNumLabel {
    if (!_micNumLabel) {
        _micNumLabel = [[UILabel alloc] init];
        _micNumLabel.text = @"1麦";
        _micNumLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        _micNumLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
        _micNumLabel.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        _micNumLabel.layer.borderWidth = 1;
        _micNumLabel.layer.borderColor = [UIColor colorWithHexString:@"#666666" alpha:1].CGColor;
    }
    return _micNumLabel;
}

@end
