//
//  GameListViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "CrossRoomListViewController.h"
#import "SearchHeaderView.h"
#import "CrossRoomGameCell.h"
#import "AudioRoomViewController.h"

@interface CrossRoomListViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SearchHeaderView *searchHeaderView;
@property (nonatomic, strong) NSMutableArray <CrossRoomModel *> *dataList;
@property (nonatomic, strong) UILabel *noDataLabel;
@end

@implementation CrossRoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRefreshHeader];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

- (BOOL)dtIsHiddenNavigationBar {
    return YES;
}

- (void)dtConfigUI {
    self.view.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
}

- (void)dtConfigEvents {
    WeakSelf
    [[NSNotificationCenter defaultCenter] addObserverForName:TOKEN_REFRESH_SUCCESS_NTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
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

- (void)dtAddViews {
    [self.view addSubview:self.searchHeaderView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.noDataLabel];
}

- (void)dtLayoutViews {
    [self.searchHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchHeaderView.mas_bottom).offset(20);
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.bottom.mas_equalTo(-kTabBarHeight);
    }];
    [self.noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchHeaderView.mas_bottom).offset(109);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
}

// 添加下来刷新
- (void)addRefreshHeader {
    WeakSelf
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!AppService.shared.login.isRefreshedToken) {
            [AppService.shared.login checkToken];
            return;
        }
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
    [AudioRoomService reqCrossRoomList:nil pageNumber:1 success:^(NSArray<CrossRoomModel *> * _Nonnull roomList) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.dataList setArray:roomList];
        [weakSelf.collectionView reloadData];
        weakSelf.noDataLabel.hidden = weakSelf.dataList.count != 0;
    } fail:^(NSError *error) {
        [ToastUtil show:error.dt_errMsg];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
    [self.searchHeaderView dtUpdateUI];
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
    NSString *crossSecret = @"d6089222f1db75211712efec6d87f9cf";
    AudioSceneConfigModel *config = [[AudioSceneConfigModel alloc] init];
    config.gameId = m.mg_id;
    config.roomID = @"10000";
    config.roomNumber = @"10000";
    config.roomType = HSGame;
    config.roomName = @"custom";
    config.roleType = 0;
    config.enterRoomModel = [[EnterRoomModel alloc]init];
    config.enterRoomModel.crossSecret = crossSecret;
    BaseSceneViewController *vc = [SceneFactory createSceneVC:SceneTypeCustom configModel:config];
    [AppUtil.currentViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 懒加载

- (UICollectionView *)collectionView {
    if (!_collectionView) {

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat itemW = floor((kScreenWidth - 32 - 20) / 2);
        CGFloat itemH = 168;
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
        [_collectionView registerClass:[CrossRoomGameCell class] forCellWithReuseIdentifier:@"CrossRoomGameCell"];
    }
    return _collectionView;
}

- (SearchHeaderView *)searchHeaderView {
    if (!_searchHeaderView) {
        _searchHeaderView = [[SearchHeaderView alloc] init];
    }
    return _searchHeaderView;
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
