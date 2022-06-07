//
// Created by kaniel on 2022/6/2.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "MoreGuessHeaderView.h"
#import "MoreGuessHeaderCell.h"

#define ITEM_WIDTH (kScreenWidth - 32 - 62)

@interface MoreGuessHeaderView ()
@property(nonatomic, strong) UIImageView *bannerImageView;
@property(nonatomic, strong) UILabel *titleOneLabel;
@property(nonatomic, strong) UILabel *titleTwoLabel;
@property(nonatomic, strong) UICollectionView *collectionView;
/// 当前页码
@property(nonatomic, assign) NSInteger currentPage;
@end

@implementation MoreGuessHeaderView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.bannerImageView];
    [self addSubview:self.titleOneLabel];
    [self addSubview:self.titleTwoLabel];
    [self addSubview:self.collectionView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.equalTo(@100);
    }];
    [self.titleOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerImageView.mas_bottom).offset(20);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleOneLabel.mas_bottom).offset(10);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@302);
    }];
    [self.titleTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(20);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.greaterThanOrEqualTo(@0);
        make.bottom.equalTo(@-5);
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
    MoreGuessHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoreGuessHeaderCell" forIndexPath:indexPath];
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
        point.x = self.currentPage * pageWidth - pageWidth;
    } else {
        point.x = self.currentPage * pageWidth;
    }

    [self.collectionView setContentOffset:point animated:YES];
    self.currentPage = point.x / pageWidth;

}

- (UIImageView *)bannerImageView {
    if (!_bannerImageView) {
        _bannerImageView = [[UIImageView alloc] init];
        _bannerImageView.image = [UIImage imageNamed:@"guess_rank"];
        _bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_bannerImageView dt_cornerRadius:8];
    }
    return _bannerImageView;
}

- (UILabel *)titleOneLabel {
    if (!_titleOneLabel) {
        _titleOneLabel = [[UILabel alloc] init];
        _titleOneLabel.font = UIFONT_MEDIUM(22);
        _titleOneLabel.textColor = UIColor.blackColor;
        _titleOneLabel.text = @"跨房玩游戏，猜猜谁最强？";
        _titleOneLabel.numberOfLines = 0;
    }
    return _titleOneLabel;
}

- (UILabel *)titleTwoLabel {
    if (!_titleTwoLabel) {
        _titleTwoLabel = [[UILabel alloc] init];
        _titleTwoLabel.font = UIFONT_MEDIUM(22);
        _titleTwoLabel.textColor = UIColor.blackColor;
        _titleTwoLabel.text = @"限时竞猜活动";
        _titleTwoLabel.numberOfLines = 0;
    }
    return _titleTwoLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat lineSpace = 13;// 行间距
        CGFloat itemW = ITEM_WIDTH;
        CGFloat itemH = 302;

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.minimumLineSpacing = lineSpace;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[MoreGuessHeaderCell class] forCellWithReuseIdentifier:@"MoreGuessHeaderCell"];
    }
    return _collectionView;
}
@end
