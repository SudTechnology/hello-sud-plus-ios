//
//  HomeCategoryView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/18.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HomeCategoryView.h"
#import "AllCategoryView.h"

@interface HomeCategoryView () <JXCategoryViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *titleCategoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) BaseView *gradientView;
@end

@implementation HomeCategoryView

- (void)dtAddViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.titleCategoryView];
    [self addSubview:self.gradientView];
    [self addSubview:self.moreBtn];
}

- (void)dtLayoutViews {
    [self.titleCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.mas_equalTo(self);
        make.height.mas_equalTo(44);
        make.trailing.mas_equalTo(self.moreBtn.mas_leading).offset(-16);
    }];
    [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(90, 44));
    }];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
}

- (void)selectedIndex:(NSInteger)idx {
    [self.titleCategoryView selectItemAtIndex:idx];
}

/// 滚动到指定场景
- (void)scrollToDefaultScene:(NSInteger)defaultSceneId {
    NSInteger index = 0;
    NSArray *tempArr = self.sceneList.copy;
    for (int i = 0; i < tempArr.count; ++i) {
        HSSceneModel *item = tempArr[i];
        if (item.sceneId == defaultSceneId) {
            index = i;
            break;
        }
    }
    if (index > 0) {
        [HSThreadUtils dispatchMainAfter:0.25 callback:^{
            [self selectedIndex:index];
            if (self.selectSectionBlock) {
                self.selectSectionBlock(index);
            }
        }];
    }
}

- (void)moreBtnEvent:(UIButton *)btn {
    AllCategoryView *node = AllCategoryView.new;
    [node configUI:self.sceneList selectSceneID:self.sceneList[self.titleCategoryView.selectedIndex].sceneId];
    WeakSelf
    [node setSelectItemBlock:^(HSSceneModel *m, NSInteger idx) {
        [DTSheetView close];
        [weakSelf selectedIndex:idx];
        if (weakSelf.selectSectionBlock) {
            weakSelf.selectSectionBlock(idx);
        }
    }];
    [DTSheetView showTop:node cornerRadius:0 onCloseCallback:^{

    }];
}

#pragma mark - JXCategoryViewDelegate

// 点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    if (self.selectSectionBlock) {
        self.selectSectionBlock(index);
    }
}

#pragma mark - JXCategoryListContainerViewDelegate

// 返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titleArr.count;
}

- (JXCategoryTitleView *)titleCategoryView {
    if (!_titleCategoryView) {
        _titleCategoryView = [[JXCategoryTitleView alloc] init];
        _titleCategoryView.delegate = self;
        _titleCategoryView.titleColorGradientEnabled = YES;
        _titleCategoryView.titleColor = [UIColor dt_colorWithHexString:@"#666666" alpha:1];
        _titleCategoryView.titleSelectedColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        _titleCategoryView.titleFont = UIFONT_REGULAR(18);
        _titleCategoryView.titleSelectedFont = UIFONT_MEDIUM(18);
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        // 设置指示器固定宽度
        lineView.indicatorWidth = 18;
        lineView.indicatorHeight = 3;
        lineView.indicatorColor = UIColor.blackColor;
        _titleCategoryView.indicators = @[lineView];
    }
    return _titleCategoryView;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = UIButton.new;
        [_moreBtn setImage:[UIImage imageNamed:@"home_header_category_more"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (BaseView *)gradientView {
    if (!_gradientView) {
        _gradientView = BaseView.new;
        NSArray *colorArr = @[(id)[UIColor dt_colorWithHexString:@"#FFFFFF" alpha:0].CGColor, (id)[UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1].CGColor];
        [_gradientView dtAddGradientLayer:@[@(0.0f), @(0.5f)] colors:colorArr startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) cornerRadius:0];
    }
    return _gradientView;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = NSArray.new;
    }
    return _titleArr;
}

- (void)setSceneList:(NSArray<HSSceneModel *> *)sceneList {
    _sceneList = sceneList;
    NSMutableArray *titleList = NSMutableArray.new;
    for (HSSceneModel *item in sceneList) {
        [titleList addObject:item.sceneName];
    }
    self.titleArr = titleList;
    self.titleCategoryView.titles = titleList;
    [self.titleCategoryView reloadData];
}

@end
