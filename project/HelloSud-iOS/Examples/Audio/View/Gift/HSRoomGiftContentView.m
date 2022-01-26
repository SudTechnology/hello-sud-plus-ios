//
//  HSRoomGiftContentView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSRoomGiftContentView.h"
#import "HSGiftItemCollectionViewCell.h"

@interface HSRoomGiftContentView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<HSGiftModel*> *dataList;
@end

@implementation HSRoomGiftContentView

- (void)hsConfigUI {
    self.backgroundColor = UIColor.clearColor;
}

- (void)hsAddViews {
    
    [self addSubview:self.collectionView];
}

- (void)hsLayoutViews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)hsUpdateUI {
    [self.dataList setArray:HSGiftManager.shared.giftList];
    for (HSGiftModel *m in self.dataList) {
        m.isSelected = NO;
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HSGiftItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSGiftItemCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    HSGiftModel *currentModel = self.dataList[indexPath.row];
    currentModel.isSelected = YES;
    if (self.didSelectedGift != nil && currentModel.giftID != self.didSelectedGift.giftID) {
        self.didSelectedGift.isSelected = NO;
        self.didSelectedGift.selectedChangedCallback();
    }
    currentModel.selectedChangedCallback();
    self.didSelectedGift = currentModel;
    if (self.didSelectedCallback) self.didSelectedCallback(self.didSelectedGift);
}


#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat itemW = (kScreenWidth - 16)/4 - 1;
        CGFloat itemH = 90;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 8, 0, 8);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[HSGiftItemCollectionViewCell class] forCellWithReuseIdentifier:@"HSGiftItemCollectionViewCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
