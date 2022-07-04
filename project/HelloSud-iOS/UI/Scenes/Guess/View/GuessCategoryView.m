//
// Created by kaniel on 2022/6/2.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GuessCategoryView.h"
#import "HomeGuessCell.h"

#define ITEM_WIDTH (kScreenWidth - 32 - 62)

@interface GuessCategoryView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
/// 当前页码
@property (nonatomic, assign)NSInteger currentPage;
@end

@implementation GuessCategoryView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.collectionView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.leading.trailing.top.bottom.equalTo(@0);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gameList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeGuessCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeGuessCell" forIndexPath:indexPath];
    WeakSelf;
    cell.onEnterRoomBlock = ^(MoreGuessGameModel *m) {
        [AudioRoomService reqMatchRoom:m.gameId sceneType:weakSelf.sceneModel.sceneId gameLevel:-1];
    };
    [cell dt_cornerRadius:8];
    cell.model = self.gameList[indexPath.row];
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint point = *targetContentOffset;
    *targetContentOffset = scrollView.contentOffset;
    CGFloat lineSpace = 13;// 行间距
    CGFloat itemW = ITEM_WIDTH;
    float pageWidth = itemW + lineSpace;
    if (velocity.x > 0) {
        point.x = self.currentPage * pageWidth + pageWidth;
    } else if (velocity.x < 0) {
        point.x = self.currentPage * pageWidth  - pageWidth;
    } else {
        point.x = self.currentPage * pageWidth;
    }

    [self.collectionView setContentOffset:point animated:YES];
    self.currentPage = point.x / pageWidth;

}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat lineSpace = 13;// 行间距
        CGFloat itemW = ITEM_WIDTH;
        CGFloat itemH = 290;

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.minimumLineSpacing = lineSpace;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[HomeGuessCell class] forCellWithReuseIdentifier:@"HomeGuessCell"];
    }
    return _collectionView;
}
@end
