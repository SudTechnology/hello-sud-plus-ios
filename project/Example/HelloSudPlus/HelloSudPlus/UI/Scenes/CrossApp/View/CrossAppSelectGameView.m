//
//  SwitchRoomModeView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "CrossAppSelectGameView.h"
#import "CrossAppSelectGameCell.h"
#import "CrossAppSelectGameModel.h"

@interface CrossAppSelectGameView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray <CrossAppSelectGameModel *> *dataList;
@property(nonatomic, strong) UIButton *singleBtn;
@property(nonatomic, strong) UIButton *teamBtn;
/// 当前是否位语聊房
@property(nonatomic, assign) BOOL isAudioRoom;
@property(nonatomic, strong) HSGameItem *lastSelectedItem;
@end

@implementation CrossAppSelectGameView

- (void)reloadData:(NSInteger)sceneType
            gameID:(NSInteger)gameID
   isShowCloseGame:(BOOL)isShowEndGame {

    [CrossAppRoomService reqGameListWithFinished:^(RespGameListModel *model) {

        CrossAppSelectGameModel *recommendModel = CrossAppSelectGameModel.new;
        recommendModel.list = model.hotGameList;
        recommendModel.title = @"热门推荐";
        CrossAppSelectGameModel *normalModel = CrossAppSelectGameModel.new;
        normalModel.list = model.allGameList;
        normalModel.title = @"更多";
        if (self.isSwitchGameMode) {
            // 房间内部切换游戏，选中当前游戏
            for (HSGameItem *gameItem in model.hotGameList) {
                if (gameItem.gameId == gameID) {
                    gameItem.isSelect = YES;
                    break;
                }
            }
            for (HSGameItem *gameItem in model.allGameList) {
                if (gameItem.gameId == gameID) {
                    gameItem.isSelect = YES;
                    break;
                }
            }
        } else {
            // 首页选中第一个默认
            if (recommendModel.list.count > 0) {
                recommendModel.list[0].isSelect = YES;
                self.lastSelectedItem = recommendModel.list[0];
            }
        }

        [self.dataList addObject:recommendModel];
        [self.dataList addObject:normalModel];

        self.isAudioRoom = gameID == 0;
        [self.collectionView reloadData];
    }];


}

- (void)dtAddViews {

    [self addSubview:self.collectionView];
    [self addSubview:self.singleBtn];
    [self addSubview:self.teamBtn];
}

- (void)dtLayoutViews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(500);
    }];
    [self.singleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.equalTo(self.collectionView.mas_bottom).offset(40);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(-kAppSafeBottom);
    }];
    [self.teamBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.singleBtn.mas_trailing).offset(19);
        make.top.width.height.equalTo(self.singleBtn);
        make.trailing.equalTo(@-16);
    }];
}

- (void)dtConfigUI {
    self.backgroundColor = UIColor.whiteColor;
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.singleBtn addTarget:self action:@selector(onSingleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.teamBtn addTarget:self action:@selector(onTeamBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setIsSwitchGameMode:(BOOL)isSwitchGameMode {
    _isSwitchGameMode = isSwitchGameMode;
    if (isSwitchGameMode) {
        self.singleBtn.hidden = YES;
        self.teamBtn.hidden = YES;
    }
}

- (void)onSingleBtn:(id)sender {
    if (!self.lastSelectedItem) {
        [ToastUtil show:@"请选择游戏"];
        return;
    }
    [DTSheetView close];
    if (self.matchClickCallback) {
        self.matchClickCallback(self.lastSelectedItem, 1);
    }
}

- (void)onTeamBtn:(id)sender {
    if (!self.lastSelectedItem) {
        [ToastUtil show:@"请选择游戏"];
        return;
    }
    [DTSheetView close];
    if (self.matchClickCallback) {
        self.matchClickCallback(self.lastSelectedItem, 2);
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList[section].list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CrossAppSelectGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CrossAppSelectGameCell" forIndexPath:indexPath];
    NSArray *gameList = self.dataList[indexPath.section].list;
    HSGameItem *gameItem = gameList[indexPath.row];
    cell.model = gameItem;
    if (gameItem.gameId == GameService.shared.gameId && gameItem.gameId != 0) {
        [cell.inGameLabel setHidden:false];
    } else {
        [cell.inGameLabel setHidden:true];
    }
    return cell;
}


- (UIView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    UILabel *titleLabel = [view viewWithTag:100];
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 100;
        titleLabel.text = NSString.dt_room_choose_game;
        titleLabel.textColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@16);
            make.width.height.greaterThanOrEqualTo(@0);
            make.centerY.equalTo(view);
        }];
    }
    CrossAppSelectGameModel *appSelectGameModel = self.dataList[indexPath.section];
    titleLabel.text = appSelectGameModel.title;
    return view;
}

// 设置Header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 44);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *gameList = self.dataList[indexPath.section].list;
    HSGameItem *model = gameList[indexPath.row];
    if (self.isSwitchGameMode && self.matchClickCallback) {
        self.matchClickCallback(model, 0);
        return;
    }
    if (self.lastSelectedItem) {
        self.lastSelectedItem.isSelect = NO;
        self.lastSelectedItem = nil;
    }

    model.isSelect = !model.isSelect;
    if (model.isSelect) {
        self.lastSelectedItem = model;
    }
    CrossAppSelectGameCell *c = [collectionView cellForItemAtIndexPath:indexPath];
    c.model = model;
    [collectionView reloadData];
}

#pragma mark - 懒加载

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat itemW = (kScreenWidth - 30 - 32) / 4 - 1;
        CGFloat itemH = itemW + 34;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.minimumLineSpacing = 8;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 16, 16, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[CrossAppSelectGameCell class] forCellWithReuseIdentifier:@"CrossAppSelectGameCell"];
        [_collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    }
    return _collectionView;
}

- (NSMutableArray <CrossAppSelectGameModel *> *)dataList {
    if (!_dataList) {
        _dataList = NSMutableArray.new;
    }
    return _dataList;
}

- (UIButton *)singleBtn {
    if (!_singleBtn) {
        _singleBtn = UIButton.new;
        _singleBtn.titleLabel.font = UIFONT_REGULAR(16);
        [_singleBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_singleBtn setTitle:@"单人一键速配" forState:UIControlStateNormal];
        _singleBtn.backgroundColor = UIColor.blackColor;
    }
    return _singleBtn;
}

- (UIButton *)teamBtn {
    if (!_teamBtn) {
        _teamBtn = UIButton.new;
        _teamBtn.titleLabel.font = UIFONT_REGULAR(16);
        [_teamBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_teamBtn setTitle:@"组队匹配" forState:UIControlStateNormal];
        _teamBtn.backgroundColor = UIColor.blackColor;
    }
    return _teamBtn;
}

@end
