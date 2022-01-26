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
@property (nonatomic, strong) NSMutableArray <HSGameList *> *dataList;
/// 头部数据源
@property (nonatomic, strong) NSMutableArray <HSSceneList *> *headerSceneList;
@property (nonatomic, strong) NSMutableArray <HSGameList *> *headerGameList;
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
    /// 假数据
    HSSceneList *m_0 = [[HSSceneList alloc] init];
    m_0.sceneId = 100;
    m_0.sceneName = @"语音场景DDD";
    m_0.sceneImage = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi0.hdslb.com%2Fbfs%2Farticle%2F7af2c723accd90ce5c9e79471a76251ae44f0798.jpg&refer=http%3A%2F%2Fi0.hdslb.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1645674165&t=cb63922664bc54461211e0ae8acd6e95";
    [self.headerSceneList addObject:m_0];
    [self.headerSceneList addObject:m_0];
    [self.headerSceneList addObject:m_0];
    [self.headerSceneList addObject:m_0];
    
    
    HSGameList *m1 = [[HSGameList alloc] init];
    m1.gameId = 10002;
    m1.gameName = @"游戏名";
    m1.gamePic = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi0.hdslb.com%2Fbfs%2Farticle%2F7af2c723accd90ce5c9e79471a76251ae44f0798.jpg&refer=http%3A%2F%2Fi0.hdslb.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1645674165&t=cb63922664bc54461211e0ae8acd6e95";
    [self.headerGameList addObject:m1];
    [self.headerGameList addObject:m1];
    [self.headerGameList addObject:m1];
    [self.headerGameList addObject:m1];
    [self.headerGameList addObject:m1];
    [self.headerGameList addObject:m1];
    
    
    [self.dataList addObject:m1];
    [self.dataList addObject:m1];
    [self.dataList addObject:m1];
    [self.dataList addObject:m1];
    [self.collectionView reloadData];
    
    WeakSelf
    [RequestService postRequestWithApi:kBASEURL(@"game/list/v1") param:@{} success:^(NSDictionary *rootDict) {
        HSGameListModel *model = [HSGameListModel mj_objectWithKeyValues:rootDict];
        if (model.retCode != 0) {
            [SVProgressHUD showErrorWithStatus:model.retMsg];
            return;
        }
        [self.headerSceneList removeAllObjects];
        [self.headerGameList removeAllObjects];
        [self.dataList removeAllObjects];
        
        [weakSelf.headerSceneList addObjectsFromArray:model.data.sceneList];
        if (model.data.sceneList.count <= 6) {
            [weakSelf.headerGameList addObjectsFromArray:model.data.gameList];
        } else {
            [weakSelf.headerGameList subarrayWithRange:NSMakeRange(0, 6)];
            [self.dataList subarrayWithRange:NSMakeRange(6, model.data.gameList.count)];
            
            /// 求余 填满整个屏幕
            double fmodCount = fmod(model.data.gameList.count, 4);
            for (int i = 0; i < fmodCount; i++) {
                HSGameList *m = [[HSGameList alloc] init];
                m.isBlank = true;
                [self.dataList addObject:m];
            }
        }
        [self.collectionView reloadData];
    } failure:^(id error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HSGameItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSGameItemCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    HSAudioRoomViewController *vc = [[HSAudioRoomViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
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
        view.headerGameList = self.headerGameList;
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
