//
//  HSHomeViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "HSHomeViewController.h"
#import "HSSearchHeaderView.h"
#import "HSGameItemCollectionViewCell.h"
#import "HSHomeHeaderReusableView.h"
#import "HSHomeFooterReusableView.h"
#import "HSAudioRoomViewController.h"

@interface HSHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataList;
/// 头部数据源
@property (nonatomic, strong) NSMutableArray <HSSceneList *> *headerSceneList;
@property (nonatomic, strong) NSMutableArray *headerGameList;
@property (nonatomic, strong) HSSearchHeaderView *searchHeaderView;
@property (nonatomic, assign) CGFloat itemW;
@property (nonatomic, assign) CGFloat itemH;

@end

@implementation HSHomeViewController

- (BOOL)hsIsHidenNavigationBar {
    return YES;
}

- (void)hsConfigUI {
    self.itemW = (kScreenWidth - 32 - 24 - 24 )/4;
    self.itemH = self.itemW + 32;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F6FB" alpha:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [RequestService postRequestWithApi:kINTERACTURL(@"game/list/v1") param:@{} success:^(NSDictionary *rootDict) {
        HSGameListModel *model = [HSGameListModel mj_objectWithKeyValues:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.retMsg];
            return;
        }
        [weakSelf.headerSceneList removeAllObjects];
        [weakSelf.headerGameList removeAllObjects];
        [weakSelf.dataList removeAllObjects];
        
        /// ap存储 suitId 对应的dataArr
        NSMutableDictionary *dataMap = [NSMutableDictionary dictionary];
        for (HSSceneList *m in model.data.sceneList) {
            NSMutableArray <HSGameList *> *arr = [NSMutableArray array];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@(m.sceneId) forKey:@"suitId"];
            [dic setValue:arr forKey:@"dataArr"];
            [dataMap setValue:dic forKey:[NSString stringWithFormat:@"%ld", m.sceneId]];
        }
        
        /// 非重复游戏列表
        NSMutableArray <HSGameList *> *originalGameArr = [NSMutableArray array];
        /// 遍历gameList 分类 suitId
        for (int i = 0; i < model.data.gameList.count; i++) {
            [originalGameArr addObject:model.data.gameList[i]];
            for (NSNumber *value in model.data.gameList[i].suitScene) {
                int suitId = value.intValue;
                NSDictionary *dic = dataMap[[NSString stringWithFormat:@"%d", suitId]];
                NSMutableArray <HSGameList *> *arr = [dic objectForKey:@"dataArr"];
                [arr addObject:model.data.gameList[i]];
            }
        }
        NSSet *set = [NSSet setWithArray:originalGameArr];
        HSAppManager.shared.gameList = [set allObjects];
        HSAppManager.shared.sceneList = model.data.sceneList;
        
        /// dataList  headerGameList  headerSceneList 业务需求赋值
        for (HSSceneList *m in model.data.sceneList) {
            NSDictionary *dic = dataMap[[NSString stringWithFormat:@"%ld", (long)m.sceneId]];
            NSMutableArray <HSGameList *> *arr = [dic objectForKey:@"dataArr"];
            
            if (arr.count <= 6) {
                [weakSelf.headerGameList addObject:arr];
                [weakSelf.dataList addObject:@[]];
            } else {
                NSMutableArray <HSGameList *> *h_arr = NSMutableArray.new;
                [h_arr setArray:[arr subarrayWithRange:NSMakeRange(0, 6)]];
                [weakSelf.headerGameList addObject:h_arr];
                NSMutableArray <HSGameList *> *cellDataArray = [NSMutableArray arrayWithArray:[arr subarrayWithRange:NSMakeRange(6, arr.count-6)]];
                
                /// 求余 填满整个屏幕
                double fmodCount = fmod(cellDataArray.count, 4);
                if (fmodCount > 0) {
                    for (int i = fmodCount; i < 4; i++) {
                        HSGameList *m = [[HSGameList alloc] init];
                        m.isBlank = true;
                        [cellDataArray addObject:m];
                    }
                }
                
                [weakSelf.dataList addObject:cellDataArray];
            }
        }
        [weakSelf.headerSceneList addObjectsFromArray:model.data.sceneList];
        
        [weakSelf.collectionView reloadData];
    } failure:^(id error) {
        [ToastUtil show:@"网络错误"];
    }];
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
    HSGameItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSGameItemCollectionViewCell" forIndexPath:indexPath];
    NSArray<HSGameList *> *arr = self.dataList[indexPath.section];
    cell.model = arr[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HSGameList *model = self.dataList[indexPath.section][indexPath.row];
    [HSAudioRoomManager.shared reqMatchRoom:model.gameId sceneType:self.headerSceneList[indexPath.section].sceneId];
}

// 设置Header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 84 + self.itemH * 3);
}
 
// 设置Footer的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 12);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *supplementaryView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        HSHomeHeaderReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSHomeHeaderReusableView" forIndexPath:indexPath];
        NSArray<HSGameList *> *arr = self.headerGameList[indexPath.section];
        view.headerGameList = arr;
        view.sceneModel = self.headerSceneList[indexPath.section];
        supplementaryView = view;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        HSHomeFooterReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HSHomeFooterReusableView" forIndexPath:indexPath];
        supplementaryView = view;
    }
    return supplementaryView;
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat itemW = (kScreenWidth -32)/4;
//        CGFloat itemH = itemW + 32 - 8;
        
        CGFloat realitemW = (kScreenWidth - 32 - 24 - 24 )/4;
        CGFloat itemH = realitemW + 24;
        
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
        [_collectionView registerClass:[HSGameItemCollectionViewCell class] forCellWithReuseIdentifier:@"HSGameItemCollectionViewCell"];
        [_collectionView registerClass:[HSHomeHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSHomeHeaderReusableView"];
        [_collectionView registerClass:[HSHomeFooterReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HSHomeFooterReusableView"];
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        v.backgroundColor = [UIColor colorWithHexString:@"#F5F6FB" alpha:1];
        _collectionView.backgroundView = v;
    }
    return _collectionView;
}

- (HSSearchHeaderView *)searchHeaderView {
    if (!_searchHeaderView) {
        _searchHeaderView = [[HSSearchHeaderView alloc] init];
    }
    return _searchHeaderView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray<HSGameList *> *)headerGameList {
    if (!_headerGameList) {
        _headerGameList = [NSMutableArray array];
    }
    return _headerGameList;
}

- (NSMutableArray<HSSceneList *> *)headerSceneList {
    if (!_headerSceneList) {
        _headerSceneList = [NSMutableArray array];
    }
    return _headerSceneList;
}

@end
