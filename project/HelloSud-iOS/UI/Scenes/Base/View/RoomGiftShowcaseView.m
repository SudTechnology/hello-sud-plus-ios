//
//  RoomGiftShowcaseView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2023/10/21.
//  Copyright © 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RoomGiftShowcaseView.h"
#import "RoomGiftcaseColCell.h"
#import "RoomGiftcaseRoleColCell.h"

@class GiftShowCaseFlowLayout;

@protocol GiftShowCaseFlowLayoutDelegate <NSObject>

- (CGSize)flowLayout:(GiftShowCaseFlowLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface GiftShowCaseFlowLayout : UICollectionViewFlowLayout
@property(nonatomic, weak)id<GiftShowCaseFlowLayoutDelegate> delegate;
@property(nonatomic, strong)NSMutableArray<UICollectionViewLayoutAttributes *> *attrList;
@property(nonatomic, assign)NSInteger pageNum;
@end

@implementation GiftShowCaseFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.attrList = NSMutableArray.new;
    CGSize colSize = self.collectionView.bounds.size;
    self.pageNum = 0;
    CGFloat useableWidth = colSize.width - self.sectionInset.left - self.sectionInset.right;
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    CGFloat nextX = self.sectionInset.left;
    CGFloat nextY = self.sectionInset.top;
    CGFloat lineMaxH = 0;
    
    for (int i = 0; i < count; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGSize itemSize = [self.delegate flowLayout:self sizeForItemAtIndexPath:indexPath];
        if (nextX + itemSize.width > self.pageNum * colSize.width + colSize.width - self.sectionInset.right) {
            // 不满足一行了，换下一行
            nextY += lineMaxH + self.minimumLineSpacing;
            nextX = self.pageNum * colSize.width + self.sectionInset.left;
        }
        
        if (nextY + itemSize.height > colSize.height - self.sectionInset.bottom) {
            // 不够一行高度，则换下一页
            self.pageNum++;
            nextX = self.pageNum * colSize.width + self.sectionInset.left;
            nextY = self.sectionInset.top;
        }
        
        CGRect itemFrame = CGRectMake(0, 0, itemSize.width, itemSize.height);
        if (itemSize.width > useableWidth) {
            itemFrame.size.width = useableWidth;
        }
        itemFrame.origin.x = nextX;
        itemFrame.origin.y = nextY;
        if (itemFrame.size.height > lineMaxH) {
            lineMaxH = itemFrame.size.height;
        }
        nextX += itemFrame.size.width + self.minimumInteritemSpacing;
        
        attrs.frame = itemFrame;
        [self.attrList addObject:attrs];
    }
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrList;
}


- (CGSize)collectionViewContentSize {
    CGFloat pageCount = self.pageNum + 1;
    UIEdgeInsets contentInset = self.collectionView.contentInset;
    CGSize size = CGSizeMake(self.collectionView.bounds.size.width * pageCount, CGRectGetHeight(self.collectionView.bounds) - contentInset.top - contentInset.bottom);
    return size;
}

@end

#define MaxListCount 1000000

@interface RoomGiftShowcaseView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)UIView *topView;
@property(nonatomic, strong)UIView *colBgView;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UIImageView *giftIconImageView;
@property(nonatomic, strong)UIButton *foldBtn;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic, strong) DTTimer *timer;
@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, assign) NSInteger roleBeginIndex;
@end

@implementation RoomGiftShowcaseView

- (void)loadData:(NSArray *)dataList danmuListBlock:(void(^)(NSArray<GiftModel *>* danmuList))danmuListBlock; {
    NSMutableArray *danmuList = NSMutableArray.new;
    NSMutableArray *cardTypeList = NSMutableArray.new;
    NSMutableArray *roleTypeList = NSMutableArray.new;
    for (GiftModel *giftModel in dataList) {
        if (!giftModel.details) {
            continue;
        }
        if (giftModel.details.cardType == GiftItemDetailCardTypeRole) {
            [roleTypeList addObject:giftModel];
        } else if (giftModel.details.cardType == GiftItemDetailCardTypeCard){
            [cardTypeList addObject:giftModel];
            
        }
        if (giftModel.details.content.length > 0) {
            // 弹幕
            GiftModel * danmuModel = GiftModel.new;
            danmuModel.isDanmu = YES;
            danmuModel.giftID = giftModel.giftID;
            danmuModel.giftKey = giftModel.giftKey;
            danmuModel.giftName = giftModel.giftName;
            danmuModel.price = giftModel.price;
            danmuModel.type = giftModel.type;
            danmuModel.details = GiftItemDetailModel.new;
            danmuModel.details.title = giftModel.details.title;
            danmuModel.details.textColor = giftModel.details.textColor;
            danmuModel.details.content = giftModel.details.content;
            danmuModel.details.cardType = giftModel.details.cardType;
            [danmuList addObject:danmuModel];
        }
    }
    if (danmuListBlock) {
        danmuListBlock([danmuList copy]);
    }
    if (danmuList.count > 0) {
        [danmuList addObjectsFromArray:cardTypeList];
        [cardTypeList setArray:danmuList];
    }
    NSInteger firstCardPageCount = 8;// 第一行8个
    NSInteger cardPageCount = 10;
    NSInteger rolePageCount = 3;
    NSInteger caculateCardCount = cardTypeList.count;
    if (cardTypeList.count > firstCardPageCount) {
        caculateCardCount = cardTypeList.count - firstCardPageCount;
    }
    NSInteger addCount = cardPageCount - caculateCardCount % cardPageCount;
    if (addCount < cardPageCount){
        
        for (int i = 0; i < addCount; ++i) {
            GiftModel *addTemp = GiftModel.new;
            addTemp.isEmptyModel = YES;
            addTemp.details = GiftItemDetailModel.new;
            addTemp.details.cardType = GiftItemDetailCardTypeCard;
            [cardTypeList addObject:addTemp];
        }
    }
    NSInteger totalCardPageCount = (caculateCardCount + addCount) / cardPageCount;
    
    addCount = rolePageCount - roleTypeList.count % rolePageCount;
    if (addCount < rolePageCount){
        
        for (int i = 0; i < addCount; ++i) {
            GiftModel *addTemp = GiftModel.new;
            addTemp.isEmptyModel = YES;
            addTemp.details = GiftItemDetailModel.new;
            addTemp.details.cardType = GiftItemDetailCardTypeRole;
            [roleTypeList addObject:addTemp];
        }
    }

    [self.dataList setArray:cardTypeList];
    
    [self.dataList addObjectsFromArray:roleTypeList];
    
    if (cardTypeList.count > firstCardPageCount) {
        totalCardPageCount += 1;
    }
    NSInteger pageControlCount = totalCardPageCount + roleTypeList.count / rolePageCount;
    self.pageControl.numberOfPages = pageControlCount;
    self.roleBeginIndex = totalCardPageCount;
    [self.collectionView reloadData];
    [self beginAutoScroll];
}

- (void)handleViewShow:(BOOL)bHidden {
    if (bHidden) {
        self.collectionView.hidden = YES;
        self.pageControl.hidden = YES;
    } else {
        self.collectionView.hidden = NO;
        self.pageControl.hidden = NO;
    }
}

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.topView];
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.giftIconImageView];
    [self.topView addSubview:self.foldBtn];
    [self addSubview:self.colBgView];
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = HEX_COLOR_A(@"#000000", 0.05);
    self.topView.backgroundColor = HEX_COLOR_A(@"#000000", 0.1);
    self.titleLabel.text = @"dt_room_gift_showcase_title".dt_lan;
    self.giftIconImageView.image = [UIImage imageNamed:@"room_giftcase_icon"];
    [self.foldBtn setImage:[UIImage imageNamed:@"more_gift_case_fold"] forState:UIControlStateNormal];
    [self.foldBtn setImage:[UIImage imageNamed:@"more_gift_case_show"] forState:UIControlStateSelected];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(@0);
        make.height.equalTo(@25);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.giftIconImageView.mas_trailing).offset(5);
        make.centerY.equalTo(self.topView);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.giftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@10);
        make.centerY.equalTo(self.topView);
        make.width.equalTo(@12);
        make.height.equalTo(@14);
    }];
    [self.foldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-8);
        make.centerY.equalTo(self.topView);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    [self.colBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.top.equalTo(@25);
        make.bottom.equalTo(self.collectionView);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@7);
        make.trailing.equalTo(@-7);
        make.top.equalTo(@(25 + 7));
        make.bottom.equalTo(@-16);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@16);
        make.bottom.equalTo(@0);
    }];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    [self.foldBtn dt_onClick:^(UIButton *sender) {
        sender.selected = !sender.selected;
        if (weakSelf.onFoldShowcaseViewBlock) {
            weakSelf.onFoldShowcaseViewBlock(sender.selected);
        }
    }];
}

- (UIView *)topView {
    if (!_topView){
        _topView = UIView.new;
    }
    return _topView;
}

- (UIView *)colBgView {
    if (!_colBgView){
        _colBgView = UIView.new;
        _colBgView.backgroundColor = HEX_COLOR_A(@"#000000", 0.05);
    }
    return _colBgView;
}



- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.font = UIFONT_SEMI_BOLD(10);
        _titleLabel.textColor = HEX_COLOR(@"#ffffff");
    }
    return _titleLabel;
}

- (UIImageView *)giftIconImageView {
    if (!_giftIconImageView) {
        _giftIconImageView = UIImageView.new;
    }
    return _giftIconImageView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        GiftShowCaseFlowLayout *flowLayout = [[GiftShowCaseFlowLayout alloc] init];
        flowLayout.delegate = self;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 4;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 7, 0);
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerClass:[RoomGiftcaseColCell class] forCellWithReuseIdentifier:@"RoomGiftcaseColCell"];
        [_collectionView registerClass:[RoomGiftcaseRoleColCell class] forCellWithReuseIdentifier:@"RoomGiftcaseRoleColCell"];
    }
        
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
//        //设置非选中点的大小（宽度和高度）
//        _pageControl.otherPointSize = CGSizeMake(4, 4);
//        //设置选中点的大小（宽度和高度）
//        _pageControl.currentPointSize = CGSizeMake(6, 6);
//        //设置圆角大小
//        _pageControl.pointCornerRadius = 3;
//        //设置两点之间的间隙
//        _pageControl.controlSpacing = 7;
//        //左右间宽,只有在居左居右显示的时候才有用
//        _pageControl.leftAndRightSpacing = 10;
//        //设置样式.默认居中显示
//        _pageControl.pageAliment = PageControlMiddle;
//        //非选中点的颜色
//        _pageControl.otherColor=HEX_COLOR_A(@"#ffffff", 0.5);
//        //选中点的颜色
//        _pageControl.currentColor=HEX_COLOR(@"#ffffff");
//        //当只有一个点的时候是否隐藏,默认隐藏
//        _pageControl.isHidesForSinglePage = YES;
//        //是否可以点击,默认不可以点击
//        _pageControl.isCanClickPoint = YES;
//        //代理
//        _pageControl.delegate = self;

    }
    return _pageControl;
}

- (UIButton *)foldBtn {
    if (!_foldBtn) {
        _foldBtn = UIButton.new;
    }
    return _foldBtn;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = NSMutableArray.new;
    }
    return _dataList;
}

- (void)beginAutoScroll {
    if (self.timer || self.dataList.count <= 1) {
        return;
    }
    WeakSelf
    self.timer = [DTTimer timerWithTimeInterval:3 repeats:YES block:^(DTTimer *timer) {
        [weakSelf scrollPage];
    }];
}

- (void)scrollPage {
    CGFloat w = self.collectionView.bounds.size.width;
    CGPoint offset = self.collectionView.contentOffset;
    offset.x += w;
    NSInteger totalCount = self.pageControl.numberOfPages;
    if (offset.x / w >= totalCount) {
        offset.x = 0;
    }
    
    [self.collectionView setContentOffset:offset animated:YES];
    [self updatePageControl:offset.x];

}

- (void)updatePageControl:(CGFloat)offsetX {
    CGFloat w = self.collectionView.bounds.size.width;
    NSInteger pageIndex = offsetX / w;
    NSInteger count = self.dataList.count;
    if (count <= 0) {
        return;
    }
    self.pageControl.currentPage = pageIndex;
    if (self.pageControl.currentPage >= self.roleBeginIndex) {
        self.titleLabel.text =  @"dt_room_gift_showcase_role_title".dt_lan;
    } else {
        self.titleLabel.text =  @"dt_room_gift_showcase_title".dt_lan;
    }
}

- (void)stopAutoScroll {
    if (_timer) {
        [_timer stopTimer];
        _timer = nil;
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GiftModel *giftModel = self.dataList[indexPath.row];
//    DDLogDebug(@"giftModel:%@, index:%d", giftModel.giftName, indexPath.row);
    if (giftModel.details.cardType == GiftItemDetailCardTypeCard) {
        RoomGiftcaseColCell *c = [collectionView dequeueReusableCellWithReuseIdentifier:@"RoomGiftcaseColCell" forIndexPath:indexPath];
        NSInteger index = indexPath.row % self.dataList.count;
        c.model = self.dataList[index];
        return c;
    }
    
    RoomGiftcaseRoleColCell *c = [collectionView dequeueReusableCellWithReuseIdentifier:@"RoomGiftcaseRoleColCell" forIndexPath:indexPath];
    NSInteger index = indexPath.row % self.dataList.count;
    c.model = self.dataList[index];
    return c;

}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger index = indexPath.row % self.dataList.count;
//    InteractiveGameBannerModel *model = self.dataList[index];
//    if (self.clickBlock) {
//        self.clickBlock(model);
//    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    GiftModel *giftModel = self.dataList[indexPath.row];
    CGSize size = collectionView.bounds.size;
    CGFloat space = 0;
    CGFloat w = (size.width - space) / 2 - 30;
    
    CGFloat h = 20;
    if (giftModel.details && giftModel.details.cardType == GiftItemDetailCardTypeRole) {
        w = size.width;
        h = 40;
        if (indexPath.row == self.dataList.count - 1) {
            h = 32;
        }
    }
    if (indexPath.row < 2) {
        w = size.width;
    }
    CGFloat tempW = floor(w);
//    NSLog(@"tempW=%@, w:%@", @(tempW),@(w));
    return CGSizeMake(w, h);
}

- (CGSize)flowLayout:(GiftShowCaseFlowLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    GiftModel *giftModel = self.dataList[indexPath.row];
    CGSize size = layout.collectionView.bounds.size;
    CGFloat space = 0;
    CGFloat w = (size.width - space) / 2;
    
    CGFloat h = 20;
    if (giftModel.details && giftModel.details.cardType == GiftItemDetailCardTypeRole) {
        w = size.width;
        h = 40;
        if (indexPath.row == self.dataList.count - 1) {
            h = 32;
        }
    }
    if (indexPath.row < 2) {
        w = size.width;
    }
    CGFloat tempW = floor(w);
    NSLog(@"tempW=%@, w:%@", @(tempW),@(w));
    return CGSizeMake(tempW, h);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopAutoScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updatePageControl:self.collectionView.contentOffset.x];
    [self beginAutoScroll];
}

@end
