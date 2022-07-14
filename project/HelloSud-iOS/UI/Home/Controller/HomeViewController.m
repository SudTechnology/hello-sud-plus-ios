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
#import "GameItemFullCollectionViewCell.h"
#import "HomeHeaderReusableView.h"
#import "HomeFooterReusableView.h"
#import "AudioRoomViewController.h"
#import "TicketChooseViewController.h"
#import "AllCategoryView.h"
#import "GameConfigViewController.h"
#import "GuessCategoryView.h"
#import "MoreGuessViewController.h"
#import "DiscoRankViewController.h"
#import "HomeHeaderFullReusableView.h"
#import "DiscoPopMenuListView.h"

@interface HomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *dataList;
/// 头部数据源
@property(nonatomic, strong) NSMutableArray <HSSceneModel *> *headerSceneList;
@property(nonatomic, strong) NSMutableArray <NSArray<HSGameItem *> *> *headerGameList;
@property(nonatomic, strong) SearchHeaderView *searchHeaderView;
@property(nonatomic, strong) HomeCategoryView *homeCategoryView;
@property(nonatomic, assign) CGFloat itemW;
@property(nonatomic, assign) CGFloat itemH;
@property(nonatomic, assign) BOOL isClickSegItem;
/// 竞猜游戏列表
@property(nonatomic, strong) NSArray<MoreGuessGameModel *> *quizGameInfoList;

@end

@implementation HomeViewController

- (BOOL)dtIsHiddenNavigationBar {
    return YES;
}

- (void)dtConfigUI {
    self.itemW = (kScreenWidth - 32 - 24 - 24) / 4;
    self.itemH = 125 + 12;
    self.view.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
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
    self.homeCategoryView.selectSectionBlock = ^(NSInteger section) {

        weakSelf.isClickSegItem = true;
        UICollectionViewLayoutAttributes *attributes = [weakSelf.collectionView layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        CGRect rect = attributes.frame;
        CGFloat bottomY = weakSelf.collectionView.contentSize.height - weakSelf.collectionView.mj_h;
        [weakSelf.collectionView setContentOffset:CGPointMake(weakSelf.collectionView.bounds.origin.x, rect.origin.y > bottomY ? bottomY : rect.origin.y) animated:true];
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
        GameListModel *model = (GameListModel *) resp;
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
                [weakSelf checkCacheWebp:model.gameList[i]];

            }
        }
        AppService.shared.gameList = originalGameArr;
        AppService.shared.sceneList = model.sceneList;

        /// dataList  headerGameList  headerSceneList 业务需求赋值
        for (HSSceneModel *m in model.sceneList) {
            NSDictionary *dic = dataMap[[NSString stringWithFormat:@"%ld", (long) m.sceneId]];
            NSMutableArray <HSGameItem *> *arr = [dic objectForKey:@"dataArr"];
            if (arr.count == 0) {
                NSArray *waitArr = [self makeGameWaitItems:3];
                m.isGameWait = YES;
                [arr setArray:waitArr];
            } else {

                // 是否需要满行
                BOOL isNeedToFullRow = m.sceneId != SceneTypeDisco && m.sceneId != SceneTypeDanmaku;
                if (isNeedToFullRow) {
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
            }

            [weakSelf.dataList addObject:arr];
            if (m.sceneId == SceneTypeGuess) {
                // 竞猜
                [weakSelf reqGuessGameList:m];
            }
        }
        [weakSelf.headerSceneList addObjectsFromArray:model.sceneList];

        [weakSelf.collectionView reloadData];
        weakSelf.homeCategoryView.sceneList = weakSelf.headerSceneList;
    }                         failure:^(NSError *error) {
        [ToastUtil show:error.dt_errMsg];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
    [self.searchHeaderView dtUpdateUI];
}

- (void)checkCacheWebp:(HSGameItem *)item {
    if ([item.homeGamePic hasSuffix:@"webp"]) {
        [WebpImageCacheService.shared loadWebp:item.homeGamePic result:nil];
    }
}

- (void)reqGuessGameList:(HSSceneModel *)guessModel {
    WeakSelf
    [GuessRoomService reqGuessListWithFinished:^(RespMoreGuessModel *model) {
        if (model.quizGameInfoList.count > 5) {
            // 取前5个即可
            weakSelf.quizGameInfoList = [model.quizGameInfoList subarrayWithRange:NSMakeRange(0, 5)];
        } else {
            weakSelf.quizGameInfoList = model.quizGameInfoList;
        }
        [weakSelf.collectionView reloadData];
    }];
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
    NSArray *visibleCellIndex = [self.collectionView indexPathsForVisibleSupplementaryElementsOfKind:UICollectionElementKindSectionHeader];
    NSArray *sortedIndexPaths = [visibleCellIndex sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        NSIndexPath *path1 = (NSIndexPath *) obj1;
        NSIndexPath *path2 = (NSIndexPath *) obj2;
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
    HSSceneModel *m = self.headerSceneList[section];
    if (m.sceneId == SceneTypeGuess) {
        return 0;
    }
    NSArray *arr = self.dataList[section];
    return arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseCollectionViewCell *cell = nil;
    HSSceneModel *m = self.headerSceneList[indexPath.section];
    if (m.sceneId == SceneTypeDisco || m.sceneId == SceneTypeDanmaku) {
        GameItemFullCollectionViewCell *c = [collectionView dequeueReusableCellWithReuseIdentifier:@"GameItemFullCollectionViewCell" forIndexPath:indexPath];
        c.sceneId = m.sceneId;
        cell = c;
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GameItemCollectionViewCell" forIndexPath:indexPath];
    }
    NSArray<HSGameItem *> *arr = self.dataList[indexPath.section];
    cell.indexPath = indexPath;
    cell.model = arr[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HSGameItem *model = self.dataList[indexPath.section][indexPath.row];
    return (model.isBlank || model.isGameWait) ? NO : YES;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HSSceneModel *m = self.headerSceneList[indexPath.section];
    HSGameItem *model = self.dataList[indexPath.section][indexPath.row];
//    DiscoPopMenuListView *v = [[DiscoPopMenuListView alloc]init];
//    [DTSheetView show:v onCloseCallback:nil];
//    return;
    if (self.headerSceneList[indexPath.section].sceneId == SceneTypeTicket) {
        TicketChooseViewController *vc = TicketChooseViewController.new;
        vc.gameId = model.gameId;
        vc.sceneId = self.headerSceneList[indexPath.section].sceneId;
        vc.gameName = model.gameName;
        [self.navigationController pushViewController:vc animated:true];
    } else {

        if (m.sceneId == SceneTypeDanmaku && ![AppService.shared isSameRtc:AppService.shared.configModel.zegoCfg rtcType:AppService.shared.rtcType]) {
            [ToastUtil show:NSString.dt_disco_rtc_tip];
            return;
        }
        [AudioRoomService reqMatchRoom:model.gameId sceneType:self.headerSceneList[indexPath.section].sceneId gameLevel:-1];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    HSSceneModel *m = self.headerSceneList[indexPath.section];
    CGFloat itemW = (kScreenWidth - 32) / 3;
    CGFloat itemH = 62;
    if (m.sceneId == SceneTypeDisco) {
        itemW = kScreenWidth - 32;
        itemH = 200;
    } else if (m.sceneId == SceneTypeDanmaku) {
        itemW = kScreenWidth - 32;
        itemH = 140;
    }
    return CGSizeMake(itemW, itemH);
}

// 设置Header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    HSSceneModel *m = self.headerSceneList[section];
    UIFont *font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    CGRect rect = [m.sceneName boundingRectWithSize:CGSizeMake(kScreenWidth - 62, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    CGFloat baseH = 140;
    CGFloat h = baseH + rect.size.height;
    if (m.sceneId == SceneTypeGuess) {
        baseH += 290;
        h = baseH + rect.size.height;
    } else if (m.sceneId == SceneTypeDanmaku || m.sceneId == SceneTypeDisco) {
        baseH = 46;
        h = baseH + rect.size.height;
    }
    return CGSizeMake(kScreenWidth, h);
}

// 设置Footer的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 12);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    WeakSelf
    UICollectionReusableView *supplementaryView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HSSceneModel *sceneModel = self.headerSceneList[indexPath.section];
        if (sceneModel.sceneId == SceneTypeDanmaku || sceneModel.sceneId == SceneTypeDisco) {
            HomeHeaderFullReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHeaderFullReusableView" forIndexPath:indexPath];
            view.sceneModel = sceneModel;
            supplementaryView = view;
            view.customBlock = ^(UIButton *sender) {
                BaseSceneViewController *vc = nil;
                if (sceneModel.sceneId == SceneTypeDisco) {
                    vc = [[DiscoRankViewController alloc] init];
                    [weakSelf.navigationController pushViewController:vc animated:true];
                }
            };
        } else {
            HomeHeaderReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHeaderReusableView" forIndexPath:indexPath];
            view.sceneModel = self.headerSceneList[indexPath.section];
            view.headerGameList = self.dataList[indexPath.section];
            view.quizGameInfoList = self.quizGameInfoList;
            view.customBlock = ^(UIButton *sender) {
                BaseSceneViewController *vc = nil;
                if (sceneModel.sceneId == SceneTypeDisco) {
                    vc = [[DiscoRankViewController alloc] init];
                } else {
                    vc = GameConfigViewController.new;
                }
                [weakSelf.navigationController pushViewController:vc animated:true];
            };
            view.moreGuessBlock = ^(UIButton *sender) {
                MoreGuessViewController *vc = MoreGuessViewController.new;
                vc.sceneId = weakSelf.headerSceneList[indexPath.section].sceneId;
                [weakSelf.navigationController pushViewController:vc animated:true];
            };
            supplementaryView = view;
        }

    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        HomeFooterReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeFooterReusableView" forIndexPath:indexPath];
        supplementaryView = view;
    }
    return supplementaryView;
}

#pragma mark - 懒加载

- (UICollectionView *)collectionView {
    if (!_collectionView) {

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[GameItemCollectionViewCell class] forCellWithReuseIdentifier:@"GameItemCollectionViewCell"];
        [_collectionView registerClass:[GameItemFullCollectionViewCell class] forCellWithReuseIdentifier:@"GameItemFullCollectionViewCell"];

        [_collectionView registerClass:[HomeHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHeaderReusableView"];
        [_collectionView registerClass:[HomeHeaderFullReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHeaderFullReusableView"];
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
