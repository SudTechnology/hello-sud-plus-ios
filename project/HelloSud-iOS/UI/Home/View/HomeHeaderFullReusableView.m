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
@end

@implementation HomeHeaderFullReusableView

- (void)dtAddViews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];

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
}

- (void)dtConfigUI {
    self.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
}

- (void)setSceneModel:(HSSceneModel *)sceneModel {
    _sceneModel = sceneModel;
    WeakSelf
    self.titleLabel.text = sceneModel.sceneName;

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
@end
