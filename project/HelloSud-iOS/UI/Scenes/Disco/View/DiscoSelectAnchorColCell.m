//
//  DiscoSelectAnchorColCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/10.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoSelectAnchorColCell.h"

@interface DiscoSelectAnchorColCell ()
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UIImageView *selectTagImageView;
@end

@implementation DiscoSelectAnchorColCell
- (void)dtAddViews {

    [super dtAddViews];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.selectTagImageView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.iconImageView dt_cornerRadius:28];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(@56);
    }];
    [self.selectTagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_bottom);
        make.width.height.equalTo(@24);
        make.centerX.equalTo(self.iconImageView);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];

    if (![self.model isKindOfClass:AnchorUserInfoModel.class]) {
        return;
    }
    AnchorUserInfoModel *m = (AnchorUserInfoModel *) self.model;
    if (m.avatar) {
        [self.iconImageView sd_setImageWithURL:[[NSURL alloc] initWithString:m.headImage] placeholderImage:[UIImage imageNamed:@"default_head"]];
    }
    if (m.isSelected) {
        self.selectTagImageView.hidden = NO;
        self.iconImageView.layer.borderColor = UIColor.whiteColor.CGColor;
        self.iconImageView.layer.borderWidth = 1.5;
    } else {
        self.selectTagImageView.hidden = YES;
        self.iconImageView.layer.borderColor = nil;
        self.iconImageView.layer.borderWidth = 0;
    }
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapCallView:)];
    [self.selectTagImageView addGestureRecognizer:tap];
}

- (void)onTapCallView:(id)tap {
    DanmakuCallWarcraftModel *m = (DanmakuCallWarcraftModel *) self.model;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}

- (UIImageView *)selectTagImageView {
    if (!_selectTagImageView) {
        _selectTagImageView = [[UIImageView alloc] init];
        _selectTagImageView.image = [UIImage imageNamed:@"disco_selected_anchor"];
    }
    return _selectTagImageView;
}
@end
