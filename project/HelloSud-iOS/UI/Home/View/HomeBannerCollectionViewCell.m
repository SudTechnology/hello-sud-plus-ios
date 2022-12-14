//
//  GameItemFullCollectionViewCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/29.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "HomeBannerCollectionViewCell.h"

@interface HomeBannerCollectionViewCell ()
@property(nonatomic, strong) UIImageView *gameImageView;


@end

@implementation HomeBannerCollectionViewCell


- (void)dtAddViews {
    [super dtAddViews];
    [self.contentView addSubview:self.gameImageView];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = UIColor.whiteColor;
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.gameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];

}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
}

- (void)setModel:(BaseModel *)model {
    [super setModel:model];
    WeakSelf
    if ([model isKindOfClass:[RespBannerModel class]]) {
        RespBannerModel *bannerModel = (RespBannerModel *)model;
        [self.gameImageView setImageWithURL:bannerModel.image.dt_toURL];
    }
}

- (UIImageView *)gameImageView {
    if (!_gameImageView) {
        _gameImageView = [[UIImageView alloc] init];
        _gameImageView.contentMode = UIViewContentModeScaleAspectFill;
        _gameImageView.clipsToBounds = YES;
//        [_gameImageView dt_cornerRadius:8];
    }
    return _gameImageView;
}
@end
