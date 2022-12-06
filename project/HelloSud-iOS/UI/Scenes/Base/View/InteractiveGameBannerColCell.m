//
//  GameItemFullCollectionViewCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/29.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "InteractiveGameBannerColCell.h"
#import "InteractiveGameBannerModel.h"

@interface InteractiveGameBannerColCell ()
@property(nonatomic, strong) UIImageView *gameImageView;


@end

@implementation InteractiveGameBannerColCell


- (void)dtAddViews {
    [super dtAddViews];
    [self.contentView addSubview:self.gameImageView];
}

- (void)dtConfigUI {
    [super dtConfigUI];
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
    if ([model isKindOfClass:[InteractiveGameBannerModel class]]) {
        InteractiveGameBannerModel *bannerModel = (InteractiveGameBannerModel *)model;
        self.gameImageView.image = [UIImage imageNamed:bannerModel.image];
    }
}

- (UIImageView *)gameImageView {
    if (!_gameImageView) {
        _gameImageView = [[UIImageView alloc] init];
        _gameImageView.contentMode = UIViewContentModeScaleAspectFill;
        _gameImageView.clipsToBounds = YES;
        _gameImageView.userInteractionEnabled = YES;
//        [_gameImageView dt_cornerRadius:8];
    }
    return _gameImageView;
}
@end
