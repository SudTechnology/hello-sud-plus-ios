//
//  SwitchRoomModeView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "SwitchRoomModeView.h"
#import "SwitchRoomCell.h"

@interface SwitchRoomModeView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <HSGameItem *> *dataList;
/// 当前是否位语聊房
@property (nonatomic, assign) BOOL isAudioRoom;
@end

@implementation SwitchRoomModeView

- (void)reloadData:(NSInteger)sceneType
            gameID:(NSInteger)gameID
   isShowCloseGame:(BOOL)isShowEndGame {
    NSArray <HSGameItem *> *dataArr = AppService.shared.gameList;
    for (HSGameItem *item in dataArr) {
        for (NSNumber *scene in item.suitScene) {
            if ([scene integerValue] == sceneType) {
                [self.dataList addObject:item];
            }
        }
    }
    HSGameItem *m = HSGameItem.new;
    m.itemType = isShowEndGame ? 2 : 1;
    m.gamePic = isShowEndGame ? @"room_change_cell_close_game" : @"room_change_cell_close_room";
    m.gameName = isShowEndGame ? NSString.dt_room_end_game : NSString.dt_room_close_game;
    [self.dataList insertObject:m atIndex:0];
    
    self.isAudioRoom = gameID == 0;
    [self.collectionView reloadData];
}

- (void)dtAddViews {
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.collectionView];
}

- (void)dtLayoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(22);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(500);
        make.bottom.mas_equalTo(-kAppSafeBottom);
    }];
}

- (void)dtConfigUI {
    self.backgroundColor = UIColor.whiteColor;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SwitchRoomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SwitchRoomCell" forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    if (self.dataList[indexPath.row].gameId == GameService.shared.gameId && self.dataList[indexPath.row].gameId != 0) {
        [cell.inGameLabel setHidden:false];
    } else {
        [cell.inGameLabel setHidden:true];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HSGameItem *model = self.dataList[indexPath.row];
    if (self.isAudioRoom && model.itemType != 0) {
        [DTSheetView close];
        return;
    }
    if (self.onTapGameCallBack) {
        self.onTapGameCallBack(model);
    }
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat itemW = (kScreenWidth - 30 - 32)/4 - 1;
        CGFloat itemH = itemW + 34;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.minimumLineSpacing = 8;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(20, 16, 16, 20);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[SwitchRoomCell class] forCellWithReuseIdentifier:@"SwitchRoomCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSString.dt_room_choose_game;
        _titleLabel.textColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    }
    return _titleLabel;
}

@end
