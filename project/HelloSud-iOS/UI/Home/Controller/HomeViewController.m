//
//  HomeViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "HomeViewController.h"
#import "SearchHeaderView.h"
#import "HomeCategoryView.h"
#import "GameItemCollectionViewCell.h"
#import "HomeHeaderReusableView.h"
#import "HomeFooterReusableView.h"
#import "AudioRoomViewController.h"
#import "TicketChooseViewController.h"
#import "AllCategoryView.h"
#import "GameConfigViewController.h"

@interface HomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataList;
/// 头部数据源
@property (nonatomic, strong) NSMutableArray <HSSceneModel *> *headerSceneList;
@property (nonatomic, strong) NSMutableArray <NSArray<HSGameItem *>*> *headerGameList;
@property (nonatomic, strong) SearchHeaderView *searchHeaderView;
@property (nonatomic, strong) HomeCategoryView *homeCategoryView;
@property (nonatomic, assign) CGFloat itemW;
@property (nonatomic, assign) CGFloat itemH;
@property (nonatomic, assign) BOOL isClickSegItem;

@end

@implementation HomeViewController

- (BOOL)dtIsHiddenNavigationBar {
    return YES;
}

- (void)dtConfigUI {
    self.itemW = (kScreenWidth - 32 - 24 - 24 )/4;
    self.itemH = 125 + 12;
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
    self.homeCategoryView.selectSectionBlock = ^(NSInteger section) {
        weakSelf.isClickSegItem = true;
        UICollectionViewLayoutAttributes *attributes = [weakSelf.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        CGRect rect = attributes.frame;
        CGFloat bottomY = weakSelf.collectionView.contentSize.height - weakSelf.collectionView.mj_h;
        [weakSelf.collectionView setContentOffset:CGPointMake(weakSelf.collectionView.bounds.origin.x, rect.origin.y - 150 > bottomY ? bottomY : rect.origin.y - 150) animated:true];
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRefreshHeader];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dtAddViews {
    [self.view addSubview:self.searchHeaderView];
    [self.view addSubview:self.homeCategoryView];
    [self.view addSubview:self.collectionView];
}

- (void)dtLayoutViews {
    [self.searchHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.homeCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchHeaderView.mas_bottom);
        make.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.homeCategoryView.mas_bottom);
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.bottom.mas_equalTo(-kTabBarHeight);
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
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = UIColor.redColor;
    [self.collectionView addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.bottom.equalTo(header.mas_top);
        make.height.mas_equalTo(100);
    }];
}

#pragma mark - requst Data
- (void)requestData {
    WeakSelf
    [HSHttpService postRequestWithURL:kINTERACTURL(@"game/list/v1") param:@{} respClass:GameListModel.class showErrorToast:false success:^(BaseRespModel *resp) {
        [weakSelf.collectionView.mj_header endRefreshing];
        GameListModel *model = (GameListModel *)resp;
        [weakSelf.headerSceneList removeAllObjects];
        [weakSelf.headerGameList removeAllObjects];
        [weakSelf.dataList removeAllObjects];

        /// ap存储 suitId 对应的dataArr
        NSMutableDictionary *dataMap = [NSMutableDictionary dictionary];
        for (HSSceneModel *m in model.sceneList) {
            NSMutableArray <HSGameItem *> *arr = [NSMutableArray array];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@(m.sceneId) forKey:@"suitId"];
            [dic setValue:arr forKey:@"dataArr"];
            [dataMap setValue:dic forKey:[NSString stringWithFormat:@"%ld", m.sceneId]];
        }

        /// 非重复游戏列表
        NSMutableArray <HSGameItem *> *originalGameArr = [NSMutableArray array];
        /// 遍历gameList 分类 suitId
        for (int i = 0; i < model.gameList.count; i++) {
            [originalGameArr addObject:model.gameList[i]];
            for (NSNumber *value in model.gameList[i].suitScene) {
                int suitId = value.intValue;
                NSDictionary *dic = dataMap[[NSString stringWithFormat:@"%d", suitId]];
                NSMutableArray <HSGameItem *> *arr = [dic objectForKey:@"dataArr"];
                [arr addObject:model.gameList[i]];
            }
        }
        AppService.shared.gameList = originalGameArr;
        AppService.shared.sceneList = model.sceneList;

        /// dataList  headerGameList  headerSceneList 业务需求赋值
        for (HSSceneModel *m in model.sceneList) {
            NSDictionary *dic = dataMap[[NSString stringWithFormat:@"%ld", (long)m.sceneId]];
            NSMutableArray <HSGameItem *> *arr = [dic objectForKey:@"dataArr"];
            if (arr.count == 0) {
                NSArray *waitArr = [self makeGameWaitItems:3];
                m.isGameWait = YES;
                [arr setArray:waitArr];
            } else {

                /// 求余 填满整个屏幕
                int row = 3;
                double fmodCount = fmod(arr.count, row);
                if (fmodCount > 0) {
                    for (int i = fmodCount; i < row; i++) {
                        HSGameItem *m = [[HSGameItem alloc] init];
                        m.isBlank = true;
                        [arr addObject:m];
                    }
                }
            }

            [weakSelf.dataList addObject:arr];
        }
        [weakSelf.headerSceneList addObjectsFromArray:model.sceneList];

        [weakSelf.collectionView reloadData];
        weakSelf.homeCategoryView.sceneList = weakSelf.headerSceneList;
    } failure: ^(NSError *error){
        [ToastUtil show:error.dt_errMsg];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
    [self.searchHeaderView dtUpdateUI];
}

/// 构建等待数据
/// @param count count description
- (NSArray *)makeGameWaitItems:(NSInteger)count {
    NSMutableArray *arr = NSMutableArray.new;
    for (int i = 0; i < count; i++) {
        HSGameItem *item = HSGameItem.new;
        item.gameName = NSString.dt_home_coming_soon;
        item.isGameWait = YES;
        item.gamePic = @"wait_game_icon";
        [arr addObject:item];
    }
    return arr;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isClickSegItem = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isClickSegItem) {
        return;
    }
    NSArray *visibleCellIndex = self.collectionView.indexPathsForVisibleItems;
    NSArray *sortedIndexPaths = [visibleCellIndex sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSIndexPath *path1 = (NSIndexPath *)obj1;
        NSIndexPath *path2 = (NSIndexPath *)obj2;
        return [path1 compare:path2];
    }];
    NSIndexPath *indexPath = [sortedIndexPaths firstObject];
    [self.homeCategoryView selectedIndex:indexPath.section];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.headerSceneList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *arr = self.dataList[section];
    return arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GameItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GameItemCollectionViewCell" forIndexPath:indexPath];
    NSArray<HSGameItem *> *arr = self.dataList[indexPath.section];
    cell.model = arr[indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HSGameItem *model = self.dataList[indexPath.section][indexPath.row];
    return (model.isBlank || model.isGameWait) ? NO : YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HSGameItem *model = self.dataList[indexPath.section][indexPath.row];
    if (self.headerSceneList[indexPath.section].sceneId == SceneTypeTicket) {
        TicketChooseViewController *vc = TicketChooseViewController.new;
        vc.gameId = model.gameId;
        vc.sceneId = self.headerSceneList[indexPath.section].sceneId;
        vc.gameName = model.gameName;
        [self.navigationController pushViewController:vc animated:true];
    } else {
        [AudioRoomService reqMatchRoom:model.gameId sceneType:self.headerSceneList[indexPath.section].sceneId gameLevel:-1];
    }
}

// 设置Header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    HSSceneModel *m = self.headerSceneList[section];
    UIFont *font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    CGRect rect = [m.sceneName boundingRectWithSize:CGSizeMake(kScreenWidth - 62, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return CGSizeMake(kScreenWidth, 140 + rect.size.height);
}

// 设置Footer的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 12);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    WeakSelf
    UICollectionReusableView *supplementaryView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        HomeHeaderReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHeaderReusableView" forIndexPath:indexPath];
        view.sceneModel = self.headerSceneList[indexPath.section];
        view.customBlock = ^(UIButton *sender) {
            GameConfigViewController *vc = GameConfigViewController.new;
            [weakSelf.navigationController pushViewController:vc animated:true];
        };
        supplementaryView = view;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        HomeFooterReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeFooterReusableView" forIndexPath:indexPath];
        supplementaryView = view;
    }
    return supplementaryView;
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat itemW = (kScreenWidth - 32) / 3;
        CGFloat itemH = 62;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[GameItemCollectionViewCell class] forCellWithReuseIdentifier:@"GameItemCollectionViewCell"];
        [_collectionView registerClass:[HomeHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHeaderReusableView"];
        [_collectionView registerClass:[HomeFooterReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeFooterReusableView"];
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        v.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
        //        _collectionView.backgroundView = v;
    }
    return _collectionView;
}

- (SearchHeaderView *)searchHeaderView {
    if (!_searchHeaderView) {
        _searchHeaderView = [[SearchHeaderView alloc] init];
    }
    return _searchHeaderView;
}

- (HomeCategoryView *)homeCategoryView {
    if (!_homeCategoryView) {
        _homeCategoryView = HomeCategoryView.new;
    }
    return _homeCategoryView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray<HSGameItem *> *)headerGameList {
    if (!_headerGameList) {
        _headerGameList = [NSMutableArray array];
    }
    return _headerGameList;
}

- (NSMutableArray<HSSceneModel *> *)headerSceneList {
    if (!_headerSceneList) {
        _headerSceneList = [NSMutableArray array];
    }
    return _headerSceneList;
}

@end
