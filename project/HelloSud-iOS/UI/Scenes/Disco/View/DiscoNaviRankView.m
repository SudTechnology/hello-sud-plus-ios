//
//  DiscoNaviRankView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/30.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoNaviRankView.h"
#import "DiscoRankHeadView.h"


@interface DiscoNaviRankView()
@property (nonatomic, strong)NSMutableArray<DiscoRankHeadView *> *arrViews;
@end

@implementation DiscoNaviRankView


- (void)dtAddViews {
    [super dtAddViews];

    for (int i = 0; i < 3; ++i) {
        DiscoRankHeadView *v = [[DiscoRankHeadView alloc]init];
        v.rank = i + 1;
        [self.arrViews addObject:v];
    }
}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.arrViews[0] mas_makeConstraints:^(MASConstraintMaker *make) {
       make.leading.equalTo(@0);
       make.width.equalTo(@24);
       make.height.equalTo(@25);
    }];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
}

- (void)dtConfigUI {
    [super dtConfigUI];
}

- (NSMutableArray<DiscoRankHeadView *> *)arrViews {
    if (!_arrViews) {
        _arrViews = [[NSMutableArray alloc]init];
    }
    return _arrViews;
}
@end
