//
//  HomeViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "SQSCnNFTListViewController.h"
#import "SQSNFTColCell.h"
#import "SQSCnNFTDetailViewController.h"

@interface SQSCnNFTListViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray<SQSNFTListCellModel *> *dataList;
@property(nonatomic, strong) NSString *pageKey;
@property(nonatomic, assign) NSInteger page;
@end

@implementation SQSCnNFTListViewController


- (void)dtConfigUI {
    self.view.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
}

- (void)dtConfigEvents {
    WeakSelf
    [[NSNotificationCenter defaultCenter] addObserverForName:MY_NFT_WEAR_CHANGE_NTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
        [weakSelf resortNFTList];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRefreshHeader];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

        [weakSelf reqData:NO];
    }];
    header.lastUpdatedTimeLabel.hidden = true;
    header.stateLabel.hidden = true;

    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf reqData:YES];
    }];
    self.collectionView.mj_header = header;
    self.collectionView.mj_footer = footer;
}

- (void)updateNFTList:(NSArray<SQSNFTListCellModel *> *)list add:(BOOL)add {
    if (add) {
        [self.dataList addObjectsFromArray:list];
    } else {
        [self.dataList setArray:list];
    }
    [self resortNFTList];
}

- (void)resortNFTList {
    NSArray *temp = self.dataList.copy;
    NSMutableArray *sortList = [[NSMutableArray alloc] init];
    for (SQSNFTListCellModel *m in temp) {
        BOOL isAlreadyUser = NO;
//        if (SudNFTQSAppPreferences.shared.isBindCNWallet) {
//            isAlreadyUser = [HSAppPreferences.shared isNFTAlreadyUsed:m.cardModel.cardHash tokenId:m.cardModel.chainAddr];
//        } else {
//            isAlreadyUser = [HSAppPreferences.shared isNFTAlreadyUsed:m.nftModel.contractAddress tokenId:m.nftModel.tokenId];
//        }
        if (isAlreadyUser) {
            [sortList insertObject:m atIndex:0];
        } else {
            [sortList addObject:m];
        }
    }
    [self.dataList setArray:sortList];
    [self.collectionView reloadData];
}

#pragma mark - requst Data

- (void)reqData:(BOOL)isMore {
    [self requestCardListData:isMore];
}

- (void)requestCardListData:(BOOL)isMore {
    WeakSelf
    // 拉取藏品列表
    SudNFTGetCnNFTListParamModel *paramModel = SudNFTGetCnNFTListParamModel.new;
    paramModel.walletType = SQSAppPreferences.shared.currentSelectedWalletType;
    paramModel.walletToken = [SQSAppPreferences.shared getBindUserTokenByWalletType:paramModel.walletType];
    self.page = isMore ? self.page + 1 : 0;
    paramModel.pageNumber = self.page;
    paramModel.pageSize = 20;
    [SudNFT getCnNFTList:paramModel listener:^(NSInteger errCode, NSString *errMsg, SudNFTGetCnNFTListModel *resp) {
        if (isMore) {
            if (resp.list.count == 0) {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.collectionView.mj_footer endRefreshing];
            }
        } else {
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer resetNoMoreData];
        }
        if (errCode != 0) {
            NSString *msg = [NSString stringWithFormat:@"%@(%@)", errMsg, @(errCode)];
            [ToastUtil show:msg];
            if (errCode == 1008) {
                [[NSNotificationCenter defaultCenter] postNotificationName:WALLET_BIND_TOKEN_EXPIRED_NTF object:nil userInfo:nil];
            }
            return;
        }

        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (SudNFTCnInfoModel *m in resp.list) {
            SQSNFTListCellModel *cellModel = [[SQSNFTListCellModel alloc] init];
            cellModel.cardModel = m;
            cellModel.coverURL = m.coverUrl;
            cellModel.name = m.name;

            [arr addObject:cellModel];
        }
        [weakSelf updateNFTList:arr add:isMore];
        if (!isMore) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NFT_REFRESH_NFT object:nil userInfo:@{@"card": resp}];
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SQSNFTColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyNFTColCell" forIndexPath:indexPath];
    SQSNFTColCell *c = (SQSNFTColCell *) cell;
    c.model = self.dataList[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    SQSCnNFTDetailViewController *vc = [[SQSCnNFTDetailViewController alloc] init];
    vc.cellModel = self.dataList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
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
        flowLayout.sectionInset = UIEdgeInsetsMake(20, 16, kAppSafeBottom, 16);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
        [_collectionView registerClass:[SQSNFTColCell class] forCellWithReuseIdentifier:@"MyNFTColCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}
@end
