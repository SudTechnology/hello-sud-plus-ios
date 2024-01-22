//
//  DanmakuQuickSendView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DanmakuVerticalSendView.h"
#import "VerticalSendEffectColCell.h"

@interface DanmakuVerticalSendView()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UICollectionView *collectionView;
@end

@implementation DanmakuVerticalSendView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.collectionView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@62);
        make.bottom.equalTo(@0);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.clipsToBounds = YES;

}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    [self.collectionView reloadData];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];

}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DanmakuCallWarcraftModel *m = self.dataList[indexPath.row];
    BaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VerticalSendEffectColCell" forIndexPath:indexPath];

    cell.backgroundColor = UIColor.clearColor;
    cell.model = self.dataList[indexPath.row];
    return cell;
}



#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (kScreenWidth - 30) / 6;
    return CGSizeMake(width, 62);
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat lineSpace = 0;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = lineSpace;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[VerticalSendEffectColCell class] forCellWithReuseIdentifier:@"VerticalSendEffectColCell"];

    }
    return _collectionView;
}

@end
