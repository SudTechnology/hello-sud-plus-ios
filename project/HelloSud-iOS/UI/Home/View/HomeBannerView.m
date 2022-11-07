//
// Created by kaniel on 2022/11/3.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HomeBannerView.h"
#import "DTWebViewController.h"
#import "HomeBannerCollectionViewCell.h"

@interface HomeBannerView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, strong) DTTimer *timer;
@end

@implementation HomeBannerView {

}

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.collectionView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(@0);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = UIColor.redColor;
}

- (void)showBanner:(NSArray <BaseModel *> *)bannerList {
    if (!bannerList) {
        return;
    }
    [self.dataList setArray:bannerList];
    [self.collectionView reloadData];
    [self beginAutoScroll];
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
    offset.x += self.mj_w;
    [self.collectionView setContentOffset:offset animated:YES];
}

- (void)stopAutoScroll {
    if (_timer) {
        [_timer stopTimer];
        _timer = nil;
    }
}

/// 调整URL
/// @param jumpURL
- (void)handleClick:(NSString *)jumpURL {
    if ([jumpURL hasPrefix:@"http"]) {
        DTWebViewController *web = DTWebViewController.new;
        web.url = jumpURL;
        [AppUtil.currentViewController.navigationController pushViewController:web animated:YES];
        return;
    } else if ([jumpURL hasPrefix:@""]) {
        [AudioRoomService reqMatchRoom:0 sceneType:SceneTypeAudio gameLevel:-1];
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
        [_collectionView registerClass:[HomeBannerCollectionViewCell class] forCellWithReuseIdentifier:@"HomeBannerCollectionViewCell"];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count > 1 ? 1000000 : self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeBannerCollectionViewCell *c = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBannerCollectionViewCell" forIndexPath:indexPath];
    NSInteger index = indexPath.row % self.dataList.count;
    c.model = self.dataList[index];
    return c;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row % self.dataList.count;
    RespBannerModel * model = self.dataList[index];
    [self handleClick:model.jumpUrl];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth, 104);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopAutoScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self beginAutoScroll];
}

@end
