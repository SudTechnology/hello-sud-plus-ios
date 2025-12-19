//
//  SudAdViewController.m
//  HelloSudPlus
//
//  Created by kaniel on 9/16/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SudAdViewController.h"
#import "SudAdCollectionViewCell.h"
#import "SudAdItemModel.h"
#import "SudRtWrapper.h"
#import "HttpRequest.h"
#import "GameEnv.h"

@interface SudAdViewController () <UICollectionViewDelegate, UICollectionViewDataSource, SudRtWrapperCommandListener>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<SudAdItemModel *> *adDataList;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property(nonatomic, assign)NSInteger currentPage;
@property(nonatomic, weak)SudAdCollectionViewCell *currentCell;
@property(nonatomic, strong)UIButton *btnBack;
@property(nonatomic, assign)NSInteger totalCount;
@property(nonatomic, strong)UIView *cacheGameView;
@property(nonatomic, strong)RespGameInfoModel *respGameInfo;
@end

@implementation SudAdViewController

- (void)dealloc {
    DDLogDebug(@"SudAdViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.totalCount = 10000;
    DDLogDebug(@"SudAdViewController viewDidLoad");
    self.view.backgroundColor = [UIColor blackColor];
    
    self.currentPage = 1;
    [self requestData:self.currentPage];
    [self reqRuntimeCode:nil];
}


- (void)reqRuntimeCode:(void(^)(RespGameInfoModel *respGameInfo))success {
    
    if (self.respGameInfo) {
        if (success) {
            success(self.respGameInfo);
        }
        return;
    }
    WeakSelf
    // 请求业务服务器刷新令牌 Code更新
    [GameService.shared reqGameLoginWithAppId:nil success:^(RespGameInfoModel *gameInfo) {
        weakSelf.respGameInfo = gameInfo;
        if (success) {
            success(weakSelf.respGameInfo);
        }
    }                                    fail:^(NSError *error) {
        

    }];
}

- (UIView *)cacheGameView {
    if (!_cacheGameView) {
        _cacheGameView = [[UIView alloc]init];
    }
    return _cacheGameView;
}

- (BOOL)dtIsHiddenNavigationBar {
    return YES;
}

/// 导航栏点击返回，图片
- (NSString *)dtNavigationBackIcon {
    return @"landscape_navi_back";
}

- (void)dtNavigationBackClick {
    [self handleDestroyGame];
    [super dtNavigationBackClick];
    
}

- (BOOL)dtShouldBackGesture {
    if (self.btnBack.hidden) {
        return NO;
    }
    [self handleDestroyGame];
    return [super dtShouldBackGesture];
}

- (void)handleDestroyGame {

    DDLogDebug(@"handleDestroyGame begin");
    NSArray *tempArr = [self.adDataList copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        for (SudAdItemModel *model in tempArr) {
            [model destroyGame];
        }
        DDLogDebug(@"handleDestroyGame finished");
    });
}


- (void)dtAddViews {
    [super dtAddViews];
    
    [self.view addSubview:self.cacheGameView];
    [self.cacheGameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = UIScreen.mainScreen.bounds.size;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[SudAdCollectionViewCell class] forCellWithReuseIdentifier:@"SudAdCollectionViewCell"];
    WeakSelf
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestData:weakSelf.currentPage + 1];
    }];
    self.collectionView.mj_footer = footer;

    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIButton *btnBack = [[UIButton alloc]init];
    self.btnBack = btnBack;
    [btnBack setImage:[UIImage imageNamed:@"landscape_navi_back"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(onBtnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    [btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@48);
        make.leading.equalTo(@8);
        make.top.equalTo(@(kAppSafeTop + 10));
    }];
}

- (void)onBtnBackClick:(UIButton *)sender {
    [self dtNavigationBackClick];
    
}

- (NSMutableArray *)adDataList {
    if (!_adDataList) {
        _adDataList = NSMutableArray.new;
    }
    return _adDataList;
}

- (void)requestData:(NSInteger)page {
    WeakSelf

    NSString *localPath = [NSBundle.mainBundle pathForResource:@"link_clear" ofType:@"cpk"];
//    localPath = [NSBundle.mainBundle pathForResource:@"bobing" ofType:@"cpk"];
//    localPath = [NSBundle.mainBundle pathForResource:@"crazy_fight" ofType:@"cpk"];
//    localPath = [NSBundle.mainBundle pathForResource:@"jump" ofType:@"cpk"];
//    localPath = [NSBundle.mainBundle pathForResource:@"running_giant" ofType:@"cpk"];
//    localPath = [NSBundle.mainBundle pathForResource:@"FlappyBird" ofType:@"cpk"];

    NSString *url = [NSString stringWithFormat:@"https://hello-sud-plus.sudden.ltd/ad/config/ad_list_%@.json?%@", @(page), @(NSDate.date.timeIntervalSince1970)];
    [HttpRequest getRequestWithApi:url param:@{} success:^(NSDictionary *rootDict) {
        DDLogDebug(@"ad rootDict:%@", rootDict);
        if (![rootDict isKindOfClass:NSArray.class]) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        NSArray * jsonArray =  (NSArray *)rootDict;
        NSArray<SudAdItemModel *> *adModels = [SudAdItemModel mj_objectArrayWithKeyVal≤uesArray:jsonArray];
        if (adModels.count <= 0) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        
        [weakSelf reqRuntimeCode:^(RespGameInfoModel *respGameInfo) {
                    
            NSInteger lastCount = self.adDataList.count;
            for (int i = 0; i < adModels.count; ++i) {
                SudAdItemModel *item = adModels[i];
                item.cacheGameView = weakSelf.cacheGameView;
                item.tag = [NSString stringWithFormat:@"page_%@_%@", @(page), @(i)];
                item.index = lastCount + i;
                item.code = respGameInfo.runtimeCode;
                if (i == 0) {
                    [item preLoad];
                }
            }
            weakSelf.currentPage = page;
            [weakSelf.adDataList addObjectsFromArray:adModels];
            [weakSelf.collectionView.mj_footer endRefreshing];
            [weakSelf.collectionView reloadData];
        }];
        
        
        
    } failure:^(NSError * error) {
        [ToastUtil show:error.dt_errMsg];
        [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
    }];

    
}


#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.adDataList.count > 0 ? self.totalCount : 0;// 无线循环 // self.adDataList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SudAdCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SudAdCollectionViewCell" forIndexPath:indexPath];
    if (self.adDataList.count == 0) {
        return cell;
    }
    NSInteger currentIndex = indexPath.row % self.adDataList.count;
    cell.indexPath = indexPath;
    SudAdItemModel *model = self.adDataList[currentIndex];
    model.delegate = cell;
    cell.model = self.adDataList[currentIndex];

    DDLogDebug(@"cellForItemAtIndexPath:%@", indexPath);
    WeakSelf
    cell.onGameStateChangedBlock = ^(SudAdGameState gameState) {
        DDLogDebug(@"onGameStateChangedBlock:%@", @(gameState));
        [weakSelf handleGameState:gameState];
        
    };
    cell.col = self.collectionView;
    [cell handleLoadGame:YES];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SudAdCollectionViewCell *adCell = (SudAdCollectionViewCell *)cell;
    self.currentCell = adCell;
    DDLogDebug(@"scrollViewDidEndDecelerating:%ld, cell:%@", indexPath.row, adCell);
    SudAdItemModel *model = (SudAdItemModel *)adCell.model;
    if (model.adType == 1) {
        // 视频
        // 默认播放第一个
        [adCell play];
    } else if (model.adType == 2) {
        // 游戏，加载游戏
        WeakSelf
        
        [adCell resetGameToFirstState];
        [adCell handleLoadGame:YES];

        [adCell dtUpdateUI];
    }
    [adCell showCell:YES];

}

- (void)handleGameState:(SudAdGameState)gameState {
    switch (gameState) {
        case SudAdGameStatePlaying:
            self.collectionView.scrollEnabled = NO;
            self.btnBack.hidden = YES;
            break;
        case SudAdGameStateFinished:
            self.collectionView.scrollEnabled = YES;
            self.btnBack.hidden = YES;
            break;
        default:
            self.collectionView.scrollEnabled = YES;
            self.btnBack.hidden = NO;
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    SudAdCollectionViewCell *adCell = (SudAdCollectionViewCell *)cell;
    SudAdItemModel *model = (SudAdItemModel *)adCell.model;
    if (model.adType == 1) {
        [adCell pause];
    }
    [adCell showCell:NO];
}

#pragma mark - Scroll control
// 滚动结束时，判断当前页
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 外层 CollectionView 的手势 + 内层 ScrollView 的手势 同时识别
    if (gestureRecognizer == self.collectionView.panGestureRecognizer) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 如果内层是 UIScrollView（比如横向翻页），让它优先
    if (gestureRecognizer == self.collectionView.panGestureRecognizer) {
        return YES;
    }
    return NO;
}

@end
