//
// Created by kaniel on 2022/5/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HomeGameListViewController.h"
#import "QSHomeHeaderView.h"
#import "QSGameListCell.h"
#import "QSGameItemModel.h"


/// 游戏视图列表
@interface HomeGameListViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
/// 游戏数据源
@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, strong) QSHomeHeaderView *searchHeaderView;

@end

@implementation HomeGameListViewController

- (BOOL)dtIsHiddenNavigationBar {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadGameList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchHeaderView dtUpdateUI];
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.view addSubview:self.searchHeaderView];
    [self.view addSubview:self.collectionView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.searchHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchHeaderView.mas_bottom).offset(8);
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.bottom.mas_equalTo(-kTabBarHeight);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    self.searchHeaderView.onSearchEnterBlock = ^(NSString *searchText) {
        [weakSelf enterRoom:searchText gameId :0];
    };
}

#pragma mark - requst Data

/// 加载游戏列表
- (void)loadGameList {

    //TODO: 开发者由SudMGP提供的游戏列表
    NSArray *arrGame = [QSAppPreferences.shared readGameList];
    [self.dataList setArray:arrGame];
}

- (void)enterRoom:(NSString *)roomId gameId:(int64_t)gameId {

    AudioSceneConfigModel *config = [[AudioSceneConfigModel alloc] init];
    config.gameId = gameId;
    config.roomID = roomId;//[NSString stringWithFormat:@"%ld", model.roomId];
    config.roomNumber = roomId;//[NSString stringWithFormat:@"%ld", model.roomNumber];
    config.roomType = gameId == 0 ? HSAudio : HSGame;
    config.roomName = @"custom";//model.roomName;
    config.roleType = 0;//model.roleType;
    config.enterRoomModel = [[EnterRoomModel alloc] init];
    BaseSceneViewController *vc = [SceneFactory createSceneVC:SceneTypeCustom configModel:config];
    [AppUtil.currentViewController.navigationController pushViewController:vc animated:YES];
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
    QSGameListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QSGameListCell" forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    QSGameItemModel *model = self.dataList[indexPath.row];
    [self enterRoom:@"10000" gameId:model.gameId];
}


// 设置Header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 88 + 10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *supplementaryView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];

        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quick_start"]];
        iconImageView.clipsToBounds = YES;
        iconImageView.layer.cornerRadius = 8;
        [view addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.height.equalTo(@88);
        }];
        supplementaryView = view;
    }
    return supplementaryView;
}

#pragma mark - 懒加载

- (UICollectionView *)collectionView {
    if (!_collectionView) {

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat itemW = floor((kScreenWidth - 32 - 20) / 3);
        CGFloat itemH = 56;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerClass:[QSGameListCell class] forCellWithReuseIdentifier:@"QSGameListCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    }
    return _collectionView;
}

- (QSHomeHeaderView *)searchHeaderView {
    if (!_searchHeaderView) {
        _searchHeaderView = [[QSHomeHeaderView alloc] init];
    }
    return _searchHeaderView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
@end
