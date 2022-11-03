//
// Created by kaniel on 2022/11/3.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RocketSelectAnchorView.h"
#import "RocketSelectPopUserColCell.h"
#import "AudioRoomMicModel.h"

@interface RocketSelectAnchorView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong) BaseView *bgView;
@property(nonatomic, strong) UIButton *closeBtn;
@property(nonatomic, strong) UIButton *confirmBtn;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray<AudioRoomMicModel *> *userDataList;
@end

@implementation RocketSelectAnchorView
- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.bgView];
    [self addSubview:self.closeBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.collectionView];
    [self addSubview:self.confirmBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(@0);

    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@9);
        make.trailing.equalTo(@-9);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-23);
        make.centerX.equalTo(self);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@38);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@39);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@22);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        make.leading.trailing.equalTo(@0);
        make.width.equalTo(@296);
        make.height.equalTo(@127);
        make.bottom.equalTo(self.confirmBtn.mas_top).offset(-30);
    }];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    [_confirmBtn setTitle:@"确认发射(8000)金币" forState:UIControlStateNormal];
    [self updateAnchorList];
}

/// 过滤麦位
/// @param micModel
/// @return
- (BOOL)skipMicModel:(AudioRoomMicModel *)micModel {
    if ([AppService.shared.login.loginUserInfo isMeByUserID:micModel.user.userID]) {
        return YES;
    }
    return NO;
}

- (void)updateAnchorList {
    NSArray *arrModel = kAudioRoomService.currentRoomVC.dicMicModel.allValues;
    NSMutableArray<AudioRoomMicModel *> *userList = NSMutableArray.new;
    for (AudioRoomMicModel *m in arrModel) {
        if (m.user != nil) {

            if ([self skipMicModel:m]) {
                continue;
            }
            [userList addObject:m];
            m.isSelected = NO;
        }
    }
    NSArray *sortArr = [userList sortedArrayUsingComparator:^NSComparisonResult(AudioRoomMicModel *_Nonnull obj1, AudioRoomMicModel *_Nonnull obj2) {
        return obj1.micIndex > obj2.micIndex;
    }];
    [self.userDataList setArray:sortArr];

    CGFloat h = ceil(self.userDataList.count / 3.0) * 127;
    if (h > 542) {
        h = 542;
    }

    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(h));
    }];

    [self.collectionView reloadData];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.closeBtn addTarget:self action:@selector(onCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBtn addTarget:self action:@selector(onConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onCloseBtn:(id)sender {
    [DTAlertView close];
}

- (void)onConfirmBtn:(id)sender {
    [DTAlertView close];
    NSMutableArray<AudioRoomMicModel *> *selectList = NSMutableArray.new;
    for (AudioRoomMicModel *m in self.userDataList) {
        if (m.user != nil && m.isSelected) {
            [selectList addObject:m];
        }
    }
    if (self.confirmBlock) self.confirmBlock(selectList);
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userDataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RocketSelectPopUserColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RocketSelectPopUserColCell" forIndexPath:indexPath];
    cell.model = self.userDataList[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.userDataList[indexPath.row].isSelected = !self.userDataList[indexPath.row].isSelected;
    RocketSelectPopUserColCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell dtUpdateUI];
}


#pragma mark - 懒加载

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = UIButton.new;
        [_closeBtn setImage:[UIImage imageNamed:@"rocket_select_pop_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = UIButton.new;
        _confirmBtn.titleLabel.font = UIFONT_MEDIUM(14);
        [_confirmBtn setTitleColor:HEX_COLOR(@"#FFFFFF") forState:UIControlStateNormal];
        [_confirmBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
        [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"rocket_select_pop_confirm"] forState:UIControlStateNormal];
    }
    return _confirmBtn;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEX_COLOR(@"#A5E3F4");
        _titleLabel.font = UIFONT_SEMI_BOLD(16);
        _titleLabel.text = @"选择收礼人";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (BaseView *)bgView {
    if (!_bgView) {
        _bgView = BaseView.new;
        [_bgView dtAddGradientLayer:@[@0, @1] colors:@[(id) HEX_COLOR(@"#1A1C50").CGColor, (id) HEX_COLOR(@"#1C3157").CGColor] startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1) cornerRadius:4];
    }
    return _bgView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat itemW = 296 / 3;
        flowLayout.itemSize = CGSizeMake(itemW, 97);
        flowLayout.minimumLineSpacing = 30;
        flowLayout.minimumInteritemSpacing = 0;
//        flowLayout.sectionInset = UIEdgeInsetsMake(20, 16, 16, 20);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[RocketSelectPopUserColCell class] forCellWithReuseIdentifier:@"RocketSelectPopUserColCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)userDataList {
    if (!_userDataList) {
        _userDataList = [NSMutableArray array];
    }
    return _userDataList;
}
@end
