//
//  OrderChooseGamesView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/18.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "OrderChooseGamesView.h"
#import "OrderChooseGamesCell.h"

@interface OrderChooseGamesView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <HSGameItem *> *gamesList;
@end

@implementation OrderChooseGamesView

- (void)configGamesData:(NSArray <HSGameItem *>*)list {
    self.gamesList = [NSMutableArray arrayWithArray:list];
    [self.collectionView reloadData];
}

- (void)dtAddViews {
    [self addSubview:self.collectionView];
}

- (void)dtLayoutViews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(136);
    }];
}

- (NSInteger)usersCount {
    return self.gamesList.count;
}

- (HSGameItem *)getSelectGame {
    for (HSGameItem *item in self.gamesList) {
        if (item.isSelect) {
            return item;
        }
    }
    return nil;
}
#pragma mark - Event

- (void)checkAllBtnBtnEvent:(UIButton *)btn {
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gamesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OrderChooseGamesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OrderChooseGamesCell" forIndexPath:indexPath];
    cell.model = self.gamesList[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isNotSelectedItem) {
        return;
    }
    for (HSGameItem *item in self.gamesList) {
        item.isSelect = NO;
    }
    self.gamesList[indexPath.row].isSelect = true;
    [self.collectionView reloadData];
    
    if (self.completeBlock) {
        self.completeBlock();
    }
}

// 设置Header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

// 设置Footer的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(120, 136);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[OrderChooseGamesCell class] forCellWithReuseIdentifier:@"OrderChooseGamesCell"];
        _collectionView.backgroundColor = UIColor.clearColor;
    }
    return _collectionView;
}

- (NSMutableArray<AudioUserModel *> *)gamesList {
    if (!_gamesList) {
        _gamesList = NSMutableArray.new;
    }
    return _gamesList;
}

@end
