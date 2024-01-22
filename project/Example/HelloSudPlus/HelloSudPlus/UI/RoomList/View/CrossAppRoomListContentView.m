//
//  GuessRankContentView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/8.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "CrossAppRoomListContentView.h"
#import "GameListTableViewCell.h"
#import "CrossRoomGameCell.h"
#import "AudioRoomViewController.h"
#import "CrossAppRoomListCell.h"

@interface CrossAppRoomListContentView () <JXCategoryListContentViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray <CrossRoomModel *> *dataList;
@property(nonatomic, strong) UILabel *noDataLabel;
@end

@implementation CrossAppRoomListContentView

- (UIView *)listView {
    return self;
}

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.collectionView];
    [self addSubview:self.noDataLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.bottom.mas_equalTo(-kTabBarHeight);
    }];
    [self.noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@109);
        make.centerX.mas_equalTo(self);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    [self addRefreshHeader];
    self.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
}

- (void)dtConfigEvents {
    WeakSelf
    [[NSNotificationCenter defaultCenter] addObserverForName:TOKEN_REFRESH_SUCCESS_NTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *_Nonnull note) {
        if (AppService.shared.login.isRefreshedToken) {
            [weakSelf requestData];
        } else {
            [weakSelf.collectionView.mj_header endRefreshing];
        }
    }];
    if (AppService.shared.login.isRefreshedToken) {
        [self requestData];
    }
}

// 添加下来刷新
- (void)addRefreshHeader {
    WeakSelf
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
    header.lastUpdatedTimeLabel.hidden = true;
    header.stateLabel.hidden = true;
    self.collectionView.mj_header = header;
    self.collectionView.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
}

#pragma mark - requst Data

- (void)requestData {
    WeakSelf
    [CrossAppRoomService reqCrossRoomList:nil pageNumber:1 success:^(NSArray<CrossRoomModel *> *_Nonnull roomList) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.dataList setArray:roomList];
        [weakSelf.collectionView reloadData];
        weakSelf.noDataLabel.hidden = weakSelf.dataList.count != 0;
    }                                fail:^(NSError *error) {
        [ToastUtil show:error.dt_errMsg];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *arr = self.dataList;
    return arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CrossRoomGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CrossRoomGameCell" forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CrossRoomModel *m = self.dataList[indexPath.row];
    NSString *crossSecret = m.authSecret ?: @"d6089222f1db75211712efec6d87f9cf";
    [CrossAppRoomService reqEnterRoom:[m.localRoomId longLongValue] isFromCreate:NO extData:@{@"isFromCrossRoom": @(YES)} success:nil fail:nil];
}

#pragma mark - lazy

- (UICollectionView *)collectionView {
    if (!_collectionView) {

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat itemW = floor((kScreenWidth - 32 - 7) / 2);
        CGFloat itemH = 168;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.minimumLineSpacing = 7;
        flowLayout.minimumInteritemSpacing = 7;
        flowLayout.sectionInset = UIEdgeInsetsMake(20, 0, 0, 0);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerClass:[CrossRoomGameCell class] forCellWithReuseIdentifier:@"CrossRoomGameCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UILabel *)noDataLabel {
    if (!_noDataLabel) {
        _noDataLabel = UILabel.new;
        _noDataLabel.text = NSString.dt_room_list_no_room_available;
        _noDataLabel.textColor = [UIColor dt_colorWithHexString:@"#8A8A8E" alpha:1];
        _noDataLabel.font = UIFONT_REGULAR(14);
        _noDataLabel.numberOfLines = 0;
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.hidden = true;
    }
    return _noDataLabel;
}
@end
