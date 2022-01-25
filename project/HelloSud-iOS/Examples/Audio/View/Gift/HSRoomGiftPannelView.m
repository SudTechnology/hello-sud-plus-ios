//
//  HSRoomGiftPannelView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSRoomGiftPannelView.h"
#import "HSGiftUserCollectionViewCell.h"
#import "HSRoomGiftContentView.h"

@interface HSRoomGiftPannelView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *sendToLabel;
@property (nonatomic, strong) UIButton *checkAllBtn;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) HSRoomGiftContentView *giftContentView;


@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *userDataList;
@end

@implementation HSRoomGiftPannelView

- (void)hsConfigUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.6];
}

- (void)hsAddViews {
    self.userDataList = @[@(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1), @(1)];
    [self addSubview:self.sendToLabel];
    [self addSubview:self.checkAllBtn];
    [self addSubview:self.lineView];
    [self addSubview:self.collectionView];
    [self addSubview:self.giftContentView];
    [self addSubview:self.sendBtn];
}

- (void)hsLayoutViews {
    [self.sendToLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(28);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sendToLabel.mas_right).offset(10);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(72);
        make.width.mas_greaterThanOrEqualTo(0);
        make.right.mas_equalTo(self.checkAllBtn.mas_left).offset(-16);
    }];
    [self.checkAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(42, 22));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    [self.giftContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(10);
        make.height.mas_equalTo(110);
    }];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.giftContentView.mas_bottom).offset(24);
        make.right.mas_equalTo(-16);
        make.size.mas_equalTo(CGSizeMake(56, 32));
        make.bottom.mas_equalTo(-kAppSafeBottom - 8);
    }];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userDataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HSGiftUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSGiftUserCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"选中cell: %ld", indexPath.row);
}


#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(32, 72);
        flowLayout.minimumLineSpacing = 8;
        flowLayout.minimumInteritemSpacing = 10;
//        flowLayout.sectionInset = UIEdgeInsetsMake(20, 16, 16, 20);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[HSGiftUserCollectionViewCell class] forCellWithReuseIdentifier:@"HSGiftUserCollectionViewCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)userDataList {
    if (!_userDataList) {
        _userDataList = [NSMutableArray array];
    }
    return _userDataList;
}

- (UILabel *)sendToLabel {
    if (!_sendToLabel) {
        _sendToLabel = [[UILabel alloc] init];
        _sendToLabel.text = @"送给";
        _sendToLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        _sendToLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    }
    return _sendToLabel;
}

- (UIButton *)checkAllBtn {
    if (!_checkAllBtn) {
        _checkAllBtn = [[UIButton alloc] init];
        [_checkAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_checkAllBtn setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
        _checkAllBtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        _checkAllBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    }
    return _checkAllBtn;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setTitle:@"赠送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _sendBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    }
    return _sendBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.1];
    }
    return _lineView;
}

- (HSRoomGiftContentView *)giftContentView {
    if (!_giftContentView) {
        _giftContentView = [[HSRoomGiftContentView alloc] init];
    }
    return _giftContentView;
}

@end
