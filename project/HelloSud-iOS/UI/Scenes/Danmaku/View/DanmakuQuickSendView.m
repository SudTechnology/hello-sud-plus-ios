//
//  DanmakuQuickSendView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DanmakuQuickSendView.h"
#import "QuickSendEffectColCell.h"
#import "QuickSendJoinColCell.h"

@interface DanmakuQuickSendView()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UIButton *showBtn;
@property (nonatomic, strong)UIButton *closeBtn;
@property (nonatomic, strong)UICollectionView *collectionView;

@end

@implementation DanmakuQuickSendView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.closeBtn];
    [self addSubview:self.collectionView];
    [self addSubview:self.showBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@24);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.trailing.equalTo(@0);
        make.bottom.equalTo(self.closeBtn.mas_top).offset(0);
    }];

    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.width.equalTo(@90);
        make.height.equalTo(@24);
        make.centerX.equalTo(self);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.collectionView.backgroundColor = HEX_COLOR_A(@"#000000", 0.9);
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    [self.collectionView reloadData];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.showBtn addTarget:self action:@selector(onShowBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onShowBtn:(id)sender {

    if (self.onOpenBlock) {
        self.onOpenBlock(YES);
    }
}

- (void)closeBtn:(id)sender {
    if (self.onOpenBlock) {
        self.onOpenBlock(NO);
    }
}

/// 调整是否展开状态
/// @param isOpen YES 开 NO关
- (void)showOpen:(BOOL)isOpen {
    if (isOpen) {
        self.showBtn.hidden = YES;
        self.closeBtn.hidden = NO;
    } else {
        self.showBtn.hidden = NO;
        self.closeBtn.hidden = YES;
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
    DanmakuCallWarcraftModel *m = self.dataList[indexPath.row];
    BaseCollectionViewCell *cell = nil;
    if (m.effectShowType == DanmakuEffectModelShowTypeJoin) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QuickSendJoinColCell" forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QuickSendEffectColCell" forIndexPath:indexPath];
    }
    cell.backgroundColor = UIColor.clearColor;
    cell.model = self.dataList[indexPath.row];
    return cell;
}



#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = 112;
    DanmakuCallWarcraftModel *m = self.dataList[indexPath.row];
    if (m.effectShowType == DanmakuEffectModelShowTypeCall) {
        width = m.cellWidth;
    }
    return CGSizeMake(width, 100);
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat lineSpace = 0;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = lineSpace;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[QuickSendEffectColCell class] forCellWithReuseIdentifier:@"QuickSendEffectColCell"];
        [_collectionView registerClass:[QuickSendJoinColCell class] forCellWithReuseIdentifier:@"QuickSendJoinColCell"];

    }
    return _collectionView;
}

- (UIButton *)showBtn {
    if (!_showBtn) {
        _showBtn = [[UIButton alloc]init];
        [_showBtn setImage:[UIImage imageNamed:@"dm_show"] forState:UIControlStateNormal];
    }
    return _showBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        [_closeBtn setImage:[UIImage imageNamed:@"dm_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

@end
