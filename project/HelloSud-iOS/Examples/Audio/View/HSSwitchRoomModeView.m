//
//  HSSwitchRoomModeView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSSwitchRoomModeView.h"
#import "HSGameItemCollectionViewCell.h"

@interface HSSwitchRoomModeView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *audioTitleLabel;
@property (nonatomic, strong) UIView *audioView;
@property (nonatomic, strong) UILabel *gameTitleLabel;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation HSSwitchRoomModeView

- (void)hsAddViews {
    self.dataList = @[@(1), @(1), @(1), @(1), @(1)];
    [self addSubview:self.audioTitleLabel];
    [self addSubview:self.audioView];
    [self addSubview:self.gameTitleLabel];
    [self addSubview:self.collectionView];
}

- (void)hsLayoutViews {
    [self.audioTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(22);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.audioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.audioTitleLabel.mas_bottom).offset(19);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo((kScreenWidth-32)/2);
    }];
    [self.gameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.audioView.mas_bottom).offset(30);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.gameTitleLabel.mas_bottom).offset(30);
        make.height.mas_equalTo(350);
        make.bottom.mas_equalTo(-kAppSafeBottom);
    }];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HSGameItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSGameItemCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"选中cell: %ld", indexPath.row);
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
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F5F6FB" alpha:1];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[HSGameItemCollectionViewCell class] forCellWithReuseIdentifier:@"HSGameItemCollectionViewCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UILabel *)audioTitleLabel {
    if (!_audioTitleLabel) {
        _audioTitleLabel = [[UILabel alloc] init];
        _audioTitleLabel.text = @"娱乐聊天";
        _audioTitleLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
        _audioTitleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    }
    return _audioTitleLabel;
}

- (UILabel *)gameTitleLabel {
    if (!_gameTitleLabel) {
        _gameTitleLabel = [[UILabel alloc] init];
        _gameTitleLabel.text = @"选择房间模式";
        _gameTitleLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
        _gameTitleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    }
    return _gameTitleLabel;
}

- (UIView *)audioView {
    if (!_audioView) {
        _audioView = [[UIView alloc] init];
        _audioView.backgroundColor = UIColor.blackColor;
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"game_type_header_item_%d", 0]];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"语聊房";
        titleLabel.textColor = UIColor.whiteColor;
        titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
        [self addSubview:_audioView];
        [_audioView addSubview:iconImageView];
        [_audioView addSubview:titleLabel];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(_audioView);
            make.size.mas_equalTo(CGSizeMake(72, 72));
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_audioView);
            make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        }];
    }
    return _audioView;
}

@end
