//
// Created by kaniel on 2022/6/8.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoGameInteractivePopView.h"
#import "MoreGuessCoinItemView.h"
#import "DiscoSelectAnchorColCell.h"
#import "DiscoInteractiveModel.h"
#import "DiscoInteractiveColCell.h"

#define refreshAnchorNTF = @"refreshAnchorNTF"

@interface DiscoCategoryContentView : BaseView <JXCategoryListContentViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray <BaseModel *> *dataList;
@property(nonatomic, assign) NSInteger index;
@end

@implementation DiscoCategoryContentView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.collectionView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(@0);
    }];
}

- (void)handleSelected:(DiscoInteractiveModel *)model {

    NSString *content = nil;
    for (NSNumber *n in model.actionKeyList) {
        NSInteger actionType = n.integerValue;
        switch (actionType) {
            case DiscoActionTypeJoinAnchorPosition:
                if (kDiscoRoomService.isAnchor) {
                    [kDiscoRoomService leaveAnchorPositionWithPlayerId:AppService.shared.loginUserID];
                } else {
                    [kDiscoRoomService joinAnchorField1:nil field2:nil];
                }
                [self reloadData];
                break;
            case DiscoActionTypeUpDJ:
                [kDiscoRoomService upToDJ:0];
                content = @"上DJ台";
                break;
            case DiscoActionTypeMoveRole:
                [kDiscoRoomService movePosition:0 field1:nil];
                content = NSString.dt_room_disco_keyword_move;
                break;
            case DiscoActionTypeFlyRole:
                [kDiscoRoomService flySky:0];
                content = @"飞天";
                break;
            case DiscoActionTypeBiggerRole:
                [kDiscoRoomService scaleBiggerRole:0 field1:nil];
                content = @"变大";
                break;
            case DiscoActionTypeChangeRole:
                [kDiscoRoomService switchRole:nil];
                content = NSString.dt_room_disco_keyword_witch_role;
                break;
            case DiscoActionTypeSpecialRole:
                [kDiscoRoomService specialRole:0 isTop:NO];
                content = NSString.dt_room_disco_tag_special;
                break;
            case DiscoActionTypeNamedRole:
                [kDiscoRoomService switchRoleName:60 field1:nil field2:nil];
                content = @"称号";
                break;
            case DiscoActionTypeEffectRole:
                [kDiscoRoomService switchEffectRole:0 field1:nil];
                content = NSString.dt_room_disco_tag_effect;
                break;
            case DiscoActionTypeMsgPop:
                [kDiscoRoomService showMsgPop:0 field1:NSString.dt_room_disco_dance_name];
                break;
            default:
                break;
        }
    }

    if (model.actionKeyList.count > 1) {
        // 组合的不发送公屏消息，只展示气泡
        content = NSString.dt_room_disco_dance_name;
        [kDiscoRoomService showMsgPop:0 field1:content];
    } else {
        if (content.length > 0) {
            RoomCmdChatTextModel *m = [RoomCmdChatTextModel makeMsg:content];
            m.skipParseGameKey = YES;
            [kDiscoRoomService.currentRoomVC sendMsg:m isAddToShow:YES finished:nil];
            [kDiscoRoomService showMsgPop:0 field1:content];
        }
    }

}

- (void)reloadData {
    self.dataList = [self createListForIndex:self.index];
    [self.collectionView reloadData];
}

- (NSArray *)createListForIndex:(NSInteger)index {
    if (index == 0) {
        DiscoInteractiveModel *m1 = [[DiscoInteractiveModel alloc] init];
        m1.name = kDiscoRoomService.isAnchor ? @"下主播位" : @"上主播位";
        m1.coin = -1;
        m1.actionKeyList = @[@(DiscoActionTypeJoinAnchorPosition)];

        DiscoInteractiveModel *m2 = [[DiscoInteractiveModel alloc] init];
        m2.name = @"上DJ台";
        m2.coin = 200;
        m2.actionKeyList = @[@(DiscoActionTypeUpDJ)];

        DiscoInteractiveModel *m3 = [[DiscoInteractiveModel alloc] init];
        m3.name = NSString.dt_room_disco_keyword_move;
        m3.coin = 0;
        m3.actionKeyList = @[@(DiscoActionTypeMoveRole)];

        DiscoInteractiveModel *m4 = [[DiscoInteractiveModel alloc] init];
        m4.name = NSString.dt_room_disco_keyword_up_sky;
        m4.coin = 1;
        m4.actionKeyList = @[@(DiscoActionTypeFlyRole)];

        DiscoInteractiveModel *m5 = [[DiscoInteractiveModel alloc] init];
        m5.name = @"变大";
        m5.coin = 5;
        m5.actionKeyList = @[@(DiscoActionTypeBiggerRole)];

        DiscoInteractiveModel *m6 = [[DiscoInteractiveModel alloc] init];
        m6.name = @"更换角色";
        m6.coin = 6;
        m6.actionKeyList = @[@(DiscoActionTypeChangeRole)];

        DiscoInteractiveModel *m7 = [[DiscoInteractiveModel alloc] init];
        m7.name = NSString.dt_room_disco_tag_special;
        m7.coin = 10;
        m7.actionKeyList = @[@(DiscoActionTypeSpecialRole)];

        DiscoInteractiveModel *m8 = [[DiscoInteractiveModel alloc] init];
        m8.name = @"称号";
        m8.coin = 30;
        m8.actionKeyList = @[@(DiscoActionTypeNamedRole)];

        DiscoInteractiveModel *m9 = [[DiscoInteractiveModel alloc] init];
        m9.name = NSString.dt_room_disco_tag_effect;
        m9.coin = 50;
        m9.actionKeyList = @[@(DiscoActionTypeEffectRole)];
        return @[m1, m2, m3, m4, m5, m6, m7, m8, m9];
    } else {
        DiscoInteractiveModel *m1 = [[DiscoInteractiveModel alloc] init];
        m1.name = [NSString stringWithFormat:@"%@+%@+%@", @"气泡", @"变大", @"特写"];
        m1.coin = 1000;
        m1.actionKeyList = @[@(DiscoActionTypeMsgPop), @(DiscoActionTypeBiggerRole), @(DiscoActionTypeSpecialRole)];

        DiscoInteractiveModel *m2 = [[DiscoInteractiveModel alloc] init];
        m2.name = [NSString stringWithFormat:@"%@+%@+%@+%@", @"气泡", @"变大", @"特写", @"特效"];
        m2.coin = 10000;
        m2.actionKeyList = @[@(DiscoActionTypeMsgPop), @(DiscoActionTypeBiggerRole), @(DiscoActionTypeSpecialRole), @(DiscoActionTypeEffectRole)];
        return @[m1, m2];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DiscoInteractiveColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DiscoInteractiveColCell" forIndexPath:indexPath];
    WeakSelf;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    DiscoInteractiveColCell *c = (DiscoInteractiveColCell *) cell;
    c.model = self.dataList[indexPath.row];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DiscoInteractiveColCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    DiscoInteractiveModel *m = self.dataList[indexPath.row];
    WeakSelf
    if (m.coin > 0) {
        [DiscoRoomService reqPayCoin:m.coin success:^{
            RespDiscoPayCoinModel *cmdModel = [[RespDiscoPayCoinModel alloc] init];
            cmdModel.price = m.coin;
            [cmdModel configBaseInfoWithCmd:CMD_ROOM_DISCO_ACTION_PAY];
            [kDiscoRoomService.currentRoomVC sendMsg:cmdModel isAddToShow:NO finished:nil];
            [weakSelf handleSelected:m];
        }                    failure:nil];
    } else {
        [self handleSelected:m];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = (kScreenWidth - 32 - 30) / 4;
    CGFloat h = 56;
    if (self.index == 1) {
        w = (kScreenWidth - 32 - 10) / 2;
    }
    return CGSizeMake(w, h);
}

- (UIView *)listView {
    return self;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = YES;
        [_collectionView registerClass:[DiscoInteractiveColCell class] forCellWithReuseIdentifier:@"DiscoInteractiveColCell"];
    }
    return _collectionView;
}
@end


#pragma mark DiscoGameInteractivePopView

@interface DiscoGameInteractivePopView ()
@property(nonatomic, strong) JXCategoryTitleView *titleCategoryView;
@property(nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property(nonatomic, strong) NSArray<NSString *> *subTitles;

@end

@implementation DiscoGameInteractivePopView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.titleCategoryView];
    [self addSubview:self.listContainerView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    CGFloat w = 20;
    for (int i = 0; i < self.titleCategoryView.titles.count; ++i) {
        NSString *title = self.titleCategoryView.titles[i];
        CGRect rect = [title boundingRectWithSize:CGSizeMake(kScreenWidth - 100, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: UIFONT_MEDIUM(16)} context:nil];
        w += rect.size.width;
    }
    [self.titleCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(11));
        make.leading.equalTo(@16);
        make.height.equalTo(@36);
        make.width.equalTo(@(w));
    }];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleCategoryView.mas_bottom).offset(11);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.equalTo(@257);
        make.bottom.equalTo(@0);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = HEX_COLOR_A(@"#000000", 0.8);
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
}

#pragma mark - JXCategoryListContainerViewDelegate

// 返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.subTitles.count;
}

// 返回各个列表菜单下的实例，该实例需要遵守并实现 <JXCategoryListContentViewDelegate> 协议
- (id <JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    DiscoCategoryContentView *v = [[DiscoCategoryContentView alloc] init];
    v.index = index;
    [v reloadData];
    return v;
}

- (JXCategoryTitleView *)titleCategoryView {
    if (!_titleCategoryView) {
        _titleCategoryView = [[JXCategoryTitleView alloc] init];
        _titleCategoryView.delegate = self;
        _titleCategoryView.titleColor = HEX_COLOR_A(@"#ffffff", 0.5);
        _titleCategoryView.titleSelectedColor = HEX_COLOR(@"#ffffff");
        _titleCategoryView.titleFont = UIFONT_MEDIUM(16);
        _titleCategoryView.titleSelectedFont = UIFONT_MEDIUM(16);
        self.subTitles = @[NSString.dt_room_disco_category_one, NSString.dt_room_disco_category_twn];
        _titleCategoryView.titles = self.subTitles;
        _titleCategoryView.contentEdgeInsetLeft = 0;
        _titleCategoryView.contentEdgeInsetRight = 0;

        JXCategoryIndicatorLineView *lineIndicator = [[JXCategoryIndicatorLineView alloc] init];
        // 设置指示器固定宽度
        lineIndicator.indicatorColor = HEX_COLOR(@"#ffffff");
        lineIndicator.indicatorWidth = 20;
        lineIndicator.indicatorHeight = 2;
        _titleCategoryView.indicators = @[lineIndicator];
        _titleCategoryView.listContainer = self.listContainerView;
    }
    return _titleCategoryView;
}


- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        // 列表容器视图
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _listContainerView;
}

@end



