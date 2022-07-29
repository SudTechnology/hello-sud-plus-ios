//
//  HomeViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "MyNFTListViewController.h"
#import "MyNFTColCell.h"
#import "MyNFTDetailViewController.h"
#import "HSNFTListCellModel.h"

@interface MyNFTListViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray<HSNFTListCellModel *> *dataList;

@end

@implementation MyNFTListViewController


- (void)dtConfigUI {
    self.view.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
}

- (void)dtConfigEvents {
    WeakSelf

}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addRefreshHeader];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)dtAddViews {
    [self.view addSubview:self.collectionView];
}

- (void)dtLayoutViews {

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
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

- (void)updateNFTListModel:(SudNFTListModel *)nftListModel {

    for (SudNFTModel *m in nftListModel.list) {
        HSNFTListCellModel *cellModel = [[HSNFTListCellModel alloc]init];
        cellModel.nftModel = m;
        [self.dataList addObject:cellModel];
    }
    [self.collectionView reloadData];
}

#pragma mark - requst Data

- (void)requestData {
    WeakSelf

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyNFTColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyNFTColCell" forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    MyNFTColCell *c = (MyNFTColCell *)cell;
    c.model = self.dataList[indexPath.row];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    MyNFTColCell *c = [collectionView cellForItemAtIndexPath:indexPath];
    DDLogDebug(@"cell:%@, model:%@", c, c.model);
    MyNFTDetailViewController *vc = [[MyNFTDetailViewController alloc]init];
    vc.cellModel = self.dataList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemW = (kScreenWidth - 32 - 7) / 2;
    CGFloat itemH = 205;
    return CGSizeMake(itemW, itemH);
}

#pragma mark - 懒加载

- (UICollectionView *)collectionView {
    if (!_collectionView) {

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(20, 16, 0, 16);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[MyNFTColCell class] forCellWithReuseIdentifier:@"MyNFTColCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}
@end
