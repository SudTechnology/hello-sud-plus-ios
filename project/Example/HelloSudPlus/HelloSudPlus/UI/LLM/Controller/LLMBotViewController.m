//
//  LLMBotViewController.m
//  HelloSudPlus
//
//  Created by kaniel on 6/21/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "LLMBotViewController.h"
#import "GameTabHeaderView.h"
#import "HomeCategoryView.h"
#import "GameItemCollectionViewCell.h"
#import "GameItemFullCollectionViewCell.h"
#import "GameTabHeaderReusableView.h"
#import "HomeFooterReusableView.h"
#import "AudioRoomViewController.h"
#import "TicketChooseViewController.h"
#import "AllCategoryView.h"
#import "GameConfigViewController.h"
#import "GuessCategoryView.h"
#import "MoreGuessViewController.h"
#import "DiscoRankViewController.h"
#import "HomeHeaderFullReusableView.h"
#import "DiscoGameInteractivePopView.h"
#import "LeagueEnterViewController.h"
#import "LLMTailFooterReusableView.h"

@interface LLMBotViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *dataList;
/// 头部数据源
@property(nonatomic, strong) NSMutableArray <HSSceneModel *> *headerSceneList;
@property(nonatomic, strong) NSMutableArray <NSArray<HSGameItem *> *> *headerGameList;

@property(nonatomic, assign) CGFloat itemW;
@property(nonatomic, assign) CGFloat itemH;
@property(nonatomic, assign) BOOL isClickSegItem;
/// 竞猜游戏列表
@property(nonatomic, strong) NSArray<MoreGuessGameModel *> *quizGameInfoList;
@property(nonatomic, strong) RespBannerListModel *respBannerListModel;
/// 所有游戏列表
@property(nonatomic, strong) NSArray <HSGameItem *> *gameList;

@property(nonatomic, assign)NSInteger tailH;
@property(nonatomic, strong)UIView *topView;

@end

@implementation LLMBotViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self configNtfOb];
    return self;
}

- (void)configNtfOb {
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
}

- (BOOL)dtIsHiddenNavigationBar {
    return YES;
}

- (void)dtConfigUI {
    self.itemW = (kScreenWidth - 32 - 24 - 24) / 4;
    self.itemH = 125 + 12;
    self.view.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
//    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    [self.collectionView reloadData];
}

- (void)dtConfigEvents {
    if (AppService.shared.login.isRefreshedToken && self.gameList == nil) {
        [self requestData];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tailH = 500;
    [self addRefreshHeader];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dtAddViews {

    [self.view addSubview:self.topView];
    [self.view addSubview:self.collectionView];
}

- (void)dtLayoutViews {

    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(self.view).multipliedBy(0.5);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kAppSafeTop));
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
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
//    self.collectionView.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
    self.collectionView.backgroundColor = UIColor.clearColor;// UIColor.whiteColor;

}

#pragma mark - requst Data

- (void)requestData {
    
    WeakSelf
    [HSHttpService postRequestWithURL:kINTERACTURL(@"game/list/v2") param:@{@"tab":@3} respClass:GameListModel.class showErrorToast:false success:^(BaseRespModel *resp) {
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

            }
        }
        [AppService.shared addGameListToTab:3 gameList:originalGameArr];
        [AppService.shared addSceneCacheList:model.sceneList toTabId:3];

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

                BOOL isNeedToFullRow = m.sceneId != SceneTypeDisco &&
                        m.sceneId != SceneTypeDanmaku &&
                        m.sceneId != SceneTypeLeague &&
                        m.sceneId != SceneTypeAudio3D;

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
        }
        [weakSelf.headerSceneList addObjectsFromArray:model.sceneList];

        [weakSelf.collectionView reloadData];
    }                         failure:^(NSError *error) {
        [ToastUtil show:error.dt_errMsg];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
    
    
    
    
    
    [UserService.shared refreshAiCloneInfo:^(RespAiCloneInfoModel * _Nonnull aiCloneInfoModel) {
        [weakSelf dtUpdateUI];
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

}

/// 是否展示banner
/// @param section
/// @return
- (BOOL)checkIfNeedToShowBanner:(NSInteger)section {
    return section == 0 && self.respBannerListModel.bannerInfoList.count > 0;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.headerSceneList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    HSSceneModel *m = self.headerSceneList[section];
    if (m.sceneId == SceneTypeGuess ||
            m.sceneId == SceneTypeCrossApp ||
            m.sceneId == SceneTypeAudio3D) {
        return 0;
    }
    NSArray *arr = self.dataList[section];
    return arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseCollectionViewCell *cell = nil;
    HSSceneModel *m = self.headerSceneList[indexPath.section];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:m.reuseCell forIndexPath:indexPath];
    if ([cell isKindOfClass:GameItemFullCollectionViewCell.class]) {
        GameItemFullCollectionViewCell *c = (GameItemFullCollectionViewCell *) cell;
        c.sceneId = m.sceneId;
    } else if ([cell isKindOfClass:GameItemCollectionViewCell.class]) {
        GameItemCollectionViewCell *c = (GameItemCollectionViewCell *) cell;
//        c.customImageHeightBlock = ^NSInteger {
//            return (kScreenWidth  - 13 * 2 - 9 * 2) / 3;
//        };
        c.marginLBlock = ^NSInteger {
            return -5;
        };
        c.sceneId = m.sceneId;
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

    if (self.headerSceneList[indexPath.section].sceneId == SceneTypeTicket) {
        TicketChooseViewController *vc = TicketChooseViewController.new;
        vc.gameId = model.gameId;
        vc.sceneId = self.headerSceneList[indexPath.section].sceneId;
        vc.gameName = model.gameName;
        [self.navigationController pushViewController:vc animated:true];
    } else if (self.headerSceneList[indexPath.section].sceneId == SceneTypeLeague) {
        LeagueEnterViewController *vc = LeagueEnterViewController.new;
        vc.gameId = model.gameId;
        vc.sceneId = self.headerSceneList[indexPath.section].sceneId;
        vc.gameName = model.gameName;
        [self.navigationController pushViewController:vc animated:true];
    } else {

        if ((m.sceneId == SceneTypeDanmaku || m.sceneId == SceneTypeVertical) && ![AppService.shared isSameRtc:AppService.shared.configModel.zegoCfg rtcType:AppService.shared.rtcType]) {
            [ToastUtil show:NSString.dt_home_coming_soon];
            return;
        }
        DDLogDebug(@"enter game, gameName:%@, gameId:%@, loadType:%@", model.gameName, @( model.gameId), @(model.loadType));
        ReqMatchRoomParamModel *paramModel = ReqMatchRoomParamModel.new;
        paramModel.gameId = model.gameId;
        paramModel.sceneType = self.headerSceneList[indexPath.section].sceneId;
        paramModel.gameLevel = -1;
        paramModel.tabType = 3;
        paramModel.loadType = model.loadType;
        [AudioRoomService reqMatchRoomWithParamModel:paramModel];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    HSSceneModel *m = self.headerSceneList[indexPath.section];
    CGFloat itemW = (kScreenWidth - 32) / 3;
    CGFloat itemH = 62;
    if (m.sceneId == SceneTypeDisco) {
        itemW = kScreenWidth - 32;
        itemH = 200;

    } else if (m.sceneId == SceneTypeDanmaku) {

        itemW = kScreenWidth - 32;
        itemH = 140;
    } else if (m.sceneId == SceneTypeLeague) {
        itemW = kScreenWidth - 32;
        itemH = 142;
    }

    return CGSizeMake(itemW, itemH);
}

// 设置Header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    HSSceneModel *m = self.headerSceneList[section];
    UIFont *font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    CGRect rect = [m.sceneName boundingRectWithSize:CGSizeMake(kScreenWidth - 62, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    CGFloat baseH = 46;
    CGFloat h = baseH + rect.size.height;

    return CGSizeMake(kScreenWidth, h);
}

// 设置Footer的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (self.headerSceneList.count - 1 == section) {
//        return CGSizeMake(kScreenWidth, 12 + 780);
        return CGSizeMake(kScreenWidth, self.tailH);
    }
    return CGSizeMake(kScreenWidth, 12);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    WeakSelf
    UICollectionReusableView *supplementaryView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HSSceneModel *sceneModel = self.headerSceneList[indexPath.section];
        NSString *headIdentifier = @"HomeHeaderReusableView";// sceneModel.headIdentifier;
        BaseCollectionReusableView *reuseHead = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headIdentifier forIndexPath:indexPath];

        
        GameTabHeaderReusableView *view = (GameTabHeaderReusableView *) reuseHead;
        view.indexPath = indexPath;
        view.isShowBanner = [self checkIfNeedToShowBanner:indexPath.section];
        if (view.isShowBanner) {
            [view showBanner:self.respBannerListModel];
        }
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
        
        // 标题缩进去
        view.marginLBlock = ^NSInteger {
            return 9;
        };
        [view dtLayoutViews];
        view.backgroundColor = UIColor.whiteColor;
        
        
        supplementaryView = view;

    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        LLMTailFooterReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LLMTailFooterReusableView" forIndexPath:indexPath];
//        view.backgroundColor = UIColor.redColor;
        view.colView = self.collectionView;
        [view dtUpdateUI];
        NSInteger currentH = [view perferHeight];
        if (self.tailH != currentH) {
            self.tailH = currentH;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.collectionView reloadData];
            });
        }
        
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
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_collectionView registerClass:[GameItemCollectionViewCell class] forCellWithReuseIdentifier:@"GameItemCollectionViewCell"];
        [_collectionView registerClass:[GameItemFullCollectionViewCell class] forCellWithReuseIdentifier:@"GameItemFullCollectionViewCell"];

        [_collectionView registerClass:[GameTabHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHeaderReusableView"];
        [_collectionView registerClass:[HomeHeaderFullReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHeaderFullReusableView"];
        
        [_collectionView registerClass:[HomeFooterReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeFooterReusableView"];
        [_collectionView registerClass:[LLMTailFooterReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LLMTailFooterReusableView"];

    }
    return _collectionView;
}


- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray <NSArray<HSGameItem *> *> *)headerGameList {
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

- (UIView *)topView {
    if (!_topView) {
        _topView = UIView.new;
        _topView.backgroundColor = UIColor.whiteColor;
    }
    return _topView;
}
@end
