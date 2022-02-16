//
//  HomeViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "HomeViewController.h"
#import "SearchHeaderView.h"
#import "GameItemCollectionViewCell.h"
#import "HomeHeaderReusableView.h"
#import "HomeFooterReusableView.h"
#import "AudioRoomViewController.h"

@interface HomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataList;
/// 头部数据源
@property (nonatomic, strong) NSMutableArray <HSSceneModel *> *headerSceneList;
@property (nonatomic, strong) NSMutableArray <NSArray<HSGameItem *>*> *headerGameList;
@property (nonatomic, strong) SearchHeaderView *searchHeaderView;
@property (nonatomic, assign) CGFloat itemW;
@property (nonatomic, assign) CGFloat itemH;

@end

@implementation HomeViewController

- (BOOL)hsIsHidenNavigationBar {
    return YES;
}

- (void)hsConfigUI {
    self.itemW = (kScreenWidth - 32 - 24 - 24 )/4;
    self.itemH = 125 + 12;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F6FB" alpha:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)hsAddViews {
    [self.view addSubview:self.searchHeaderView];
    [self.view addSubview:self.collectionView];
}

- (void)hsLayoutViews {
    [self.searchHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchHeaderView.mas_bottom);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(-kTabBarHeight);
    }];
}

#pragma mark - requst Data
- (void)requestData {
    WeakSelf
    [HttpService postRequestWithApi:kINTERACTURL(@"game/list/v1") param:@{} success:^(NSDictionary *rootDict) {
        GameListModel *model = [GameListModel decodeModel:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.retMsg];
            return;
        }
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
        NSSet *set = [NSSet setWithArray:originalGameArr];
        AppManager.shared.gameList = [set allObjects];
        AppManager.shared.sceneList = model.sceneList;
        
        /// dataList  headerGameList  headerSceneList 业务需求赋值
        for (HSSceneModel *m in model.sceneList) {
            NSDictionary *dic = dataMap[[NSString stringWithFormat:@"%ld", (long)m.sceneId]];
            NSMutableArray <HSGameItem *> *arr = [dic objectForKey:@"dataArr"];
            
            if (arr.count <= 6) {
                if (arr.count == 0) {
                    // 构建敬请期待数据
                    [weakSelf.headerGameList addObject:[self makeGameWaitItems:6]];
                    m.isGameWait = YES;
                } else {
                    [weakSelf.headerGameList addObject:arr];
                }
                [weakSelf.dataList addObject:@[]];

            } else {
                NSMutableArray <HSGameItem *> *h_arr = NSMutableArray.new;
                [h_arr setArray:[arr subarrayWithRange:NSMakeRange(0, 6)]];
                [weakSelf.headerGameList addObject:h_arr];
                NSMutableArray <HSGameItem *> *cellDataArray = [NSMutableArray arrayWithArray:[arr subarrayWithRange:NSMakeRange(6, arr.count-6)]];
                
                /// 求余 填满整个屏幕
                double fmodCount = fmod(cellDataArray.count, 4);
                if (fmodCount > 0) {
                    for (int i = fmodCount; i < 4; i++) {
                        HSGameItem *m = [[HSGameItem alloc] init];
                        m.isBlank = true;
                        [cellDataArray addObject:m];
                    }
                }
                
                [weakSelf.dataList addObject:cellDataArray];
            }
        }
        [weakSelf.headerSceneList addObjectsFromArray:model.sceneList];
        
        [weakSelf.collectionView reloadData];
    } failure:^(id error) {
        [ToastUtil show:@"网络错误"];
    }];
}


/// 构建等待数据
/// @param count count description
- (NSArray *)makeGameWaitItems:(NSInteger)count {
    NSMutableArray *arr = NSMutableArray.new;
    for (int i = 0; i < count; i++) {
        HSGameItem *item = HSGameItem.new;
        item.gameName = @"敬请期待";
        item.isGameWait = YES;
        item.gamePic = @"game_wait";
        [arr addObject:item];
    }
    return arr;
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
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HSGameItem *model = self.dataList[indexPath.section][indexPath.row];
    [AudioRoomManager.shared reqMatchRoom:model.gameId sceneType:self.headerSceneList[indexPath.section].sceneId];
}

// 设置Header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 36 + 20 + self.itemH * 3);
}
 
// 设置Footer的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 12);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *supplementaryView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        HomeHeaderReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHeaderReusableView" forIndexPath:indexPath];
        NSArray<HSGameItem *> *arr = self.headerGameList[indexPath.section];
        view.headerGameList = arr;
        view.sceneModel = self.headerSceneList[indexPath.section];
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
        CGFloat itemW = (kScreenWidth -32)/4;
        CGFloat realitemW = (kScreenWidth - 32 - 24 - 24 )/4;
        CGFloat itemH = 125 + 12;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
//        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[GameItemCollectionViewCell class] forCellWithReuseIdentifier:@"GameItemCollectionViewCell"];
        [_collectionView registerClass:[HomeHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHeaderReusableView"];
        [_collectionView registerClass:[HomeFooterReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeFooterReusableView"];
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        v.backgroundColor = [UIColor colorWithHexString:@"#F5F6FB" alpha:1];
        _collectionView.backgroundView = v;
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
