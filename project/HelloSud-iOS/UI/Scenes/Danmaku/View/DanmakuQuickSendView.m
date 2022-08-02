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
@property (nonatomic, strong)UIImageView *showIconImageView;
@property (nonatomic, strong)BaseView *contentView;
@property (nonatomic, strong)UICollectionView *collectionView;
@end

@implementation DanmakuQuickSendView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.closeBtn];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.collectionView];
    [self addSubview:self.showBtn];
    [self addSubview:self.showIconImageView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@-6);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@24);
    }];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.centerX.equalTo(self);
        make.leading.trailing.equalTo(@0);
        make.bottom.equalTo(self.closeBtn.mas_top).offset(4);
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@100);
    }];

    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@90);
        make.height.equalTo(@24);
        make.centerX.equalTo(self);
        make.bottom.equalTo(@0);
    }];
    [self.showIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showBtn).offset(5);
        make.width.equalTo(@26);
        make.height.equalTo(@16);
        make.centerX.equalTo(self.showBtn);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.clipsToBounds = YES;

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

    self.showBtn.hidden = YES;

    if (self.onOpenBlock) {
        self.onOpenBlock(YES);
    }
}

- (void)closeBtn:(id)sender {
    self.closeBtn.hidden = YES;
//    self.contentView.hidden = YES;
    if (self.onOpenBlock) {
        self.onOpenBlock(NO);
    }
}

/// 调整是否展开状态
/// @param isOpen YES 开 NO关
- (void)showOpen:(BOOL)isOpen {
    if (isOpen) {
        self.showBtn.hidden = YES;
        self.showIconImageView.alpha = 0;
        self.closeBtn.hidden = NO;
        self.contentView.alpha = 1;
        self.isOpen = YES;
    } else {
        self.showBtn.hidden = NO;
        self.showIconImageView.alpha = 1;
        self.closeBtn.hidden = YES;
        self.contentView.alpha = 0;
        self.isOpen = NO;
    }
}

/// 切换到打开状态
/// @param open 打开
- (void)switchToOpen:(BOOL)open {
    if (self.onOpenBlock) {
        self.onOpenBlock(open);
    }
}

/// 更新方向
/// @param isLandscape 是否横屏
- (void)updateOrientation:(BOOL)isLandscape {
    if (isLandscape) {
        // 横屏
        self.showIconImageView.hidden = NO;
        [self.closeBtn setImage:[UIImage imageNamed:@"dm_landscape_close-1"] forState:UIControlStateNormal];
        [self.showBtn setImage:[UIImage imageNamed:@"dm_landscape_show_bg"] forState:UIControlStateNormal];
        [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@120);
            make.height.equalTo(@24);
            make.centerX.equalTo(self);
            make.top.equalTo(@0);
        }];

        CGFloat w = kScreenWidth;
        if (w < kScreenHeight) {
            w = kScreenHeight;
        }
        CGFloat marginX = (w - 568) / 2;
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.closeBtn.mas_bottom).offset(-2);
//            make.leading.equalTo(@(marginX));
//            make.trailing.equalTo(@(-marginX));
            make.width.equalTo(@568);
            make.centerX.equalTo(self);
            make.bottom.equalTo(@0);
        }];
        [self.showBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.height.equalTo(@47);
            make.bottom.equalTo(@0);
        }];
        [self beginShowAnimate];

    } else {
        // 竖屏
        self.showIconImageView.hidden = YES;
        [self.closeBtn setImage:[UIImage imageNamed:@"dm_close"] forState:UIControlStateNormal];
        [self.showBtn setImage:[UIImage imageNamed:@"dm_show"] forState:UIControlStateNormal];
        [self.showBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@-6);
            make.leading.trailing.equalTo(@0);
            make.height.equalTo(@24);
        }];
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.leading.trailing.equalTo(@0);
            make.bottom.equalTo(self.closeBtn.mas_top).offset(4);
        }];

        [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@90);
            make.height.equalTo(@24);
            make.centerX.equalTo(self);
            make.bottom.equalTo(@0);
        }];
    }
}

- (void)beginShowAnimate {

    [self layoutIfNeeded];
    [self.showIconImageView.layer removeAllAnimations];
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.duration = 1.6;
    group.repeatCount = CGFLOAT_MAX;
    group.removedOnCompletion = YES;
    group.fillMode = kCAFillModeRemoved;

    CABasicAnimation *moveDown = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    // 设置运动形式
    [moveDown setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    // 设置开始位置
    moveDown.fromValue = @(0);
    moveDown.toValue = @(6);
    moveDown.removedOnCompletion = NO;
    moveDown.duration = 0.8;
    moveDown.repeatCount = 1;
    moveDown.fillMode = kCAFillModeForwards;

    CABasicAnimation *moveUp = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    // 设置运动形式
    [moveUp setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    moveUp.fromValue = @(6);
    moveUp.toValue = @(0);
    moveUp.duration = 0.8;
    moveUp.beginTime = 0.8;
    moveUp.repeatCount = 1;
    moveUp.removedOnCompletion = NO;
    moveUp.fillMode = kCAFillModeForwards;

    group.animations = @[moveDown, moveUp];
    [self.showIconImageView.layer addAnimation:group forKey:@"moveAnimate"];
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
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[QuickSendEffectColCell class] forCellWithReuseIdentifier:@"QuickSendEffectColCell"];
        [_collectionView registerClass:[QuickSendJoinColCell class] forCellWithReuseIdentifier:@"QuickSendJoinColCell"];

    }
    return _collectionView;
}

-(BaseView *)contentView {
    if (!_contentView) {
        _contentView = [[BaseView alloc] init];
        _contentView.backgroundColor = HEX_COLOR_A(@"#000000", 0.9);
    }
    return _contentView;
}

- (UIButton *)showBtn {
    if (!_showBtn) {
        _showBtn = [[UIButton alloc]init];
        [_showBtn setImage:[UIImage imageNamed:@"dm_show"] forState:UIControlStateNormal];
    }
    return _showBtn;
}

- (UIImageView *)showIconImageView {
    if (!_showIconImageView) {
        _showIconImageView = [[UIImageView alloc]init];
        _showIconImageView.image = [UIImage imageNamed:@"dm_landscape_show_icon"];
        _showIconImageView.hidden = YES;
    }
    return _showIconImageView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        [_closeBtn setImage:[UIImage imageNamed:@"dm_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

@end
