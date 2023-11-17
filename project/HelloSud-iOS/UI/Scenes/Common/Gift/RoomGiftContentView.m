//
//  RoomGiftContentView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "RoomGiftContentView.h"
#import "GiftItemCollectionViewCell.h"

@interface RoomGiftContentView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<GiftModel*> *dataList;
@end

@implementation RoomGiftContentView

- (void)dtConfigUI {
    self.backgroundColor = UIColor.clearColor;
}

- (void)dtAddViews {
    
    [self addSubview:self.collectionView];
}

- (void)dtLayoutViews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.height.equalTo(@0);
    }];
}

- (void)dtUpdateUI {
    
    NSArray<GiftModel *> *giftList = GiftService.shared.giftList;
    if (!self.showRocket) {
        NSMutableArray *tempList = [[NSMutableArray alloc]initWithArray:giftList];
        for (GiftModel *m in giftList) {
            if (m.giftID == kRocketGiftID) {
                [tempList removeObject:m];
                break;
            }
        }
        giftList = tempList;
    }
    if (self.sceneGiftList.count > 0) {
        if (self.appendSceneGift) {
            [self.dataList setArray:giftList];
            [self.dataList addObjectsFromArray:self.sceneGiftList];
        } else {
            [self.dataList setArray:self.sceneGiftList];
            [self.dataList addObjectsFromArray:giftList];
        }
    } else {
        [self.dataList setArray:giftList];
    }
    [self updateContentLayout];
    for (GiftModel *m in self.dataList) {
        m.isSelected = NO;
    }
    if (self.dataList.count > 0) {
        // 默认选中第一个
        self.dataList[0].isSelected = YES;
        self.didSelectedGift = self.dataList[0];
    }
    [self.collectionView reloadData];
}

- (void)setSceneGiftList:(NSArray<GiftModel *> *)sceneGiftList {
    _sceneGiftList = sceneGiftList;
    [self dtUpdateUI];
}

- (void)updateContentLayout {
    NSInteger count = self.dataList.count;
    NSInteger row = (NSInteger) ceil(count / 4.0);
    CGFloat h = 140;
    if (row > 1) {
        h = 254;
    }
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(h);
    }];
}

// 展示卡片更多信息
- (void)showMoreInfoView:(GiftModel *)giftModel {
    UIView *rootView = self.superview.superview.superview;
    static BaseView *cardInfoView = nil;
    if (cardInfoView){
        [cardInfoView removeFromSuperview];
    }
    NSString *title = giftModel.details.title;
    NSString *textColor = giftModel.details.textColor;
    NSString *bgUrl = giftModel.details.backgroundUrl;
    NSString *desc = giftModel.details.desc;
    
    cardInfoView = BaseView.new;
    cardInfoView.dtNeedAcceptEvent = YES;

    cardInfoView.backgroundColor = HEX_COLOR_A(@"#000000", 0.4);
    UIImageView * bgImageView = UIImageView.new;
    [bgImageView sd_setImageWithURL:bgUrl.dt_toURL];
    
    UILabel *titleLabel = UILabel.new;
    titleLabel.text = title;
    titleLabel.textColor = HEX_COLOR(textColor);
    titleLabel.font = UIFONT_SEMI_BOLD(20);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *descLabel = UILabel.new;
    descLabel.text = desc;
    descLabel.textColor = HEX_COLOR(textColor);
    descLabel.font = UIFONT_MEDIUM(14);
    descLabel.numberOfLines = 0;
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [rootView insertSubview:cardInfoView atIndex:0];
    [cardInfoView addSubview:bgImageView];
    [cardInfoView addSubview:titleLabel];
    [cardInfoView addSubview:descLabel];
    
    [cardInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(@0);
    }];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@175);
        make.height.equalTo(@250);
        make.top.equalTo(@(kAppSafeTop + 88));
        make.centerX.equalTo(cardInfoView);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.top.equalTo(bgImageView.mas_top).offset(49);
        make.leading.trailing.equalTo(bgImageView);
    }];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(0);
        make.leading.equalTo(bgImageView).offset(10);
        make.trailing.equalTo(bgImageView).offset(-10);
        make.bottom.equalTo(bgImageView).offset(-10);
    }];
    
    
    [cardInfoView dt_onTap:^(UITapGestureRecognizer * _Nonnull tap) {
        [cardInfoView removeFromSuperview];
        cardInfoView = nil;
    }];
    
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GiftItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GiftItemCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    WeakSelf
    cell.moreGiftDetailClickBlock = ^(BaseModel * _Nonnull giftModel) {
        [weakSelf showMoreInfoView:(GiftModel *)giftModel];
    };
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    GiftItemCollectionViewCell *c = [collectionView cellForItemAtIndexPath:indexPath];
    
    GiftModel *currentModel = self.dataList[indexPath.row];
    currentModel.isSelected = YES;
    if (self.didSelectedGift != nil && ![currentModel.giftKey isEqualToString:self.didSelectedGift.giftKey]) {
        self.didSelectedGift.isSelected = NO;
        self.didSelectedGift.selectedChangedCallback();
    }
    currentModel.selectedChangedCallback();
    self.didSelectedGift = currentModel;
    if (self.didSelectedCallback) self.didSelectedCallback(self.didSelectedGift);
}


#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat itemW = (kScreenWidth - 16)/4 - 1;
        CGFloat itemH = 120;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 8, 0, 8);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[GiftItemCollectionViewCell class] forCellWithReuseIdentifier:@"GiftItemCollectionViewCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
