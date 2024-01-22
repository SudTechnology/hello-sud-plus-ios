//
// Created by Mary on 2022/4/15.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "AllCategoryView.h"

@interface AllCategoryView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray <HSSceneModel *> *sceneList;
@end

@implementation AllCategoryView

- (void)configUI:(NSArray <HSSceneModel *> *)sceneList selectSceneID:(NSInteger)sceneId {
    self.sceneList = NSArray.new;
    self.sceneList = sceneList;
    for (UIView *item in self.contentView.subviews) {
        [item removeFromSuperview];
    }
    for (int i = 0; i < sceneList.count; ++i) {
        HSSceneModel *item = sceneList[i];
        UIButton *node = UIButton.new;
        node.tag = 1000 + i;
        [node setTitle:item.sceneName forState:UIControlStateNormal];
        node.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
        [node setTitleColor:[UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1] forState:UIControlStateNormal];
        node.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        [node addTarget:self action:@selector(itemEvent:) forControlEvents:UIControlEventTouchUpInside];
        if (item.sceneId == sceneId) {
            node.layer.borderColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1].CGColor;
            node.layer.borderWidth = 1;
        }
        [self.contentView addSubview:node];
    }
    [self.contentView.subviews dt_mas_distributeSudokuViewsWithFixedItemWidth:0 fixedItemHeight:36 fixedLineSpacing:10 fixedInteritemSpacing:15 warpCount:2 topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];
}

- (void)itemEvent:(UIButton *)btn {
    if (self.selectItemBlock) {
        self.selectItemBlock(self.sceneList[btn.tag - 1000], btn.tag - 1000);
    }
}

- (void)dtAddViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentView];
}

- (void)dtLayoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(8 + kStatusBarHeight);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(46 * 6);
        make.bottom.mas_equalTo(-20);
    }];
}

#pragma mark - Lazy
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSString.dt_home_all_scenes;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        _titleLabel.font = UIFONT_MEDIUM(16);
    }
    return _titleLabel;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = UIView.new;
    }
    return _contentView;
}
@end
