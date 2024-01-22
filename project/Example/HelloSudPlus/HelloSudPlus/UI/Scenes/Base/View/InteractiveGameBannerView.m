//
// Created by kaniel on 2022/11/3.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "InteractiveGameBannerView.h"
#import "InteractiveGameBannerColCell.h"

#define MaxListCount 1000000

@interface InteractiveGameBannerView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, strong) DTTimer *timer;

@end

@implementation InteractiveGameBannerView {

}

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(@0);
        make.width.equalTo(@80);
        make.height.equalTo(@110);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.greaterThanOrEqualTo(@0);
        make.centerX.equalTo(self);
        make.top.equalTo(self.collectionView.mas_bottom).offset(2);
        make.height.greaterThanOrEqualTo(@0);
        make.bottom.equalTo(@0);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
}

- (void)showBanner:(NSArray <InteractiveGameBannerModel *> *)bannerList {
    if (!bannerList) {
        return;
    }
    [self.dataList setArray:bannerList];
    [self.collectionView reloadData];
    self.pageControl.numberOfPages = bannerList.count;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint offset = self.collectionView.contentOffset;
        offset.x = 0;
        [self.collectionView setContentOffset:offset animated:NO];
        [self beginAutoScroll];
    });
}

- (void)beginAutoScroll {
    if (self.timer || self.dataList.count <= 1) {
        return;
    }
    WeakSelf
    self.timer = [DTTimer timerWithTimeInterval:3 repeats:YES block:^(DTTimer *timer) {
        [weakSelf scrollPage];
    }];
}

- (void)scrollPage {
    CGPoint offset = self.collectionView.contentOffset;
    offset.x += 80;
    NSInteger pageIndex = offset.x / 80;
    if (pageIndex >= MaxListCount) {
        pageIndex = MaxListCount - 1;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:pageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    [self updatePageControl:offset.x];

}

- (void)updatePageControl:(CGFloat)offsetX {
    NSInteger pageIndex = offsetX / 80;
    NSInteger count = self.dataList.count;
    if (count <= 0) {
        return;
    }
    self.pageControl.currentPage = pageIndex % count;
}

- (void)stopAutoScroll {
    if (_timer) {
        [_timer stopTimer];
        _timer = nil;
    }
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = NSMutableArray.new;
    }
    return _dataList;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerClass:[InteractiveGameBannerColCell class] forCellWithReuseIdentifier:@"InteractiveGameBannerColCell"];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.pageIndicatorTintColor = HEX_COLOR_A(@"#ffffff", 0.4);
        _pageControl.currentPageIndicatorTintColor = HEX_COLOR_A(@"#ffffff", 1);
        if (@available(iOS 14.0, *)) {
            _pageControl.allowsContinuousInteraction = NO;
            _pageControl.backgroundStyle = UIPageControlBackgroundStyleMinimal;
        }

    }
    return _pageControl;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count > 1 ? MaxListCount : self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InteractiveGameBannerColCell *c = [collectionView dequeueReusableCellWithReuseIdentifier:@"InteractiveGameBannerColCell" forIndexPath:indexPath];
    NSInteger index = indexPath.row % self.dataList.count;
    c.model = self.dataList[index];
    return c;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row % self.dataList.count;
    InteractiveGameBannerModel *model = self.dataList[index];
    if (self.clickBlock) {
        self.clickBlock(model);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 110);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopAutoScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updatePageControl:self.collectionView.contentOffset.x];
    [self beginAutoScroll];
}

@end
