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
#import "HSRoomViewController.h"

@interface HSHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataList;
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
    // Do any additional setup after loading the view.
    
    self.dataList = @[@(1), @(1), @(1), @(1)];
    
    [self.collectionView reloadData];
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HSGameItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSGameItemCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    HSRoomViewController *vc = [[HSRoomViewController alloc] init];
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
        CGFloat itemH = itemW + 32;
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

@end
