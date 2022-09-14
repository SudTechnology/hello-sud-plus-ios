//
//  OrderChooseUsersCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/18.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "OrderChooseUsersCell.h"

@interface OrderChooseUsersCell ()
@property (nonatomic, strong) UIImageView *headerImgView;
@property (nonatomic, strong) UIImageView *checkImgView;
@end

@implementation OrderChooseUsersCell

- (void)setModel:(BaseModel *)model {
    AudioRoomMicModel *m = (AudioRoomMicModel *)model;
    
    if (m.isEmpty) {
        self.headerImgView.image = [UIImage imageNamed: @"order_pop_cell_nor"];
        [self.checkImgView setHidden:true];
        self.headerImgView.layer.borderColor = UIColor.clearColor.CGColor;
    } else {
        [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:m.user.icon]];
        self.headerImgView.layer.borderColor = m.isSelected ? [UIColor dt_colorWithHexString:@"#000000" alpha:1].CGColor : UIColor.clearColor.CGColor;
        self.checkImgView.image = [UIImage imageNamed: m.isSelected ? @"order_pop_check_click" : @"order_pop_check_nor"];
    }
}

- (void)dtAddViews {
    [self.contentView addSubview:self.headerImgView];
    [self.contentView addSubview:self.checkImgView];
}

- (void)dtLayoutViews {
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    [self.checkImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(27);
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        [_headerImgView dt_cornerRadius:16];
        _headerImgView.backgroundColor = UIColor.lightGrayColor;
        _headerImgView.layer.borderWidth = 1;
        _headerImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerImgView;
}

- (UIImageView *)checkImgView {
    if (!_checkImgView) {
        _checkImgView = [[UIImageView alloc] init];
        _checkImgView.image = [UIImage imageNamed:@"order_pop_check_nor"];
    }
    return _checkImgView;
}

@end
