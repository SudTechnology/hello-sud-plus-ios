//
//  GameItemFullReusableView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/30.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HomeHeaderFullReusableView.h"

@interface HomeHeaderFullReusableView()
@property(nonatomic, strong) BaseView *contentView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *customView;
@end

@implementation HomeHeaderFullReusableView

- (void)dtAddViews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.customView];

}

- (void)dtLayoutViews {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
        make.top.mas_equalTo(16);
        make.height.mas_greaterThanOrEqualTo(0);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-14);
        make.centerY.mas_equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
}

- (void)dtConfigUI {
    self.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
}

- (void)setSceneModel:(HSSceneModel *)sceneModel {
    _sceneModel = sceneModel;
    WeakSelf
    self.titleLabel.text = sceneModel.sceneName;
    if (sceneModel.sceneId == SceneTypeDisco) {
        // 蹦迪
        [self.customView setImage:[UIImage imageNamed:@"disco_rank"] forState:UIControlStateNormal];
        [self.customView setHidden:NO];
        [self.customView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
    } else {
        [self.customView setHidden:YES];
    }
}

- (void)customBtnEvent:(UIButton *)btn {
    if (self.customBlock) {
        self.customBlock(btn);
    }
}

- (BaseView *)contentView {
    if (!_contentView) {
        _contentView = [[BaseView alloc] init];
        _contentView.backgroundColor = UIColor.whiteColor;
        [_contentView setPartRoundCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:8];
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    }
    return _titleLabel;
}

- (UIButton *)customView {
    if (!_customView) {
        _customView = [[UIButton alloc] init];
        [_customView setImage:[UIImage imageNamed:@"home_section_custom_icon"] forState:UIControlStateNormal];
        [_customView setHidden:true];
        [_customView addTarget:self action:@selector(customBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customView;
}
@end
