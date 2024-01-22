//
//  OrderChooseUsersView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/18.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "OrderChooseUsersView.h"
#import "OrderChooseUsersCell.h"

@interface OrderChooseUsersView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <AudioRoomMicModel *> *usersList;
@property (nonatomic, strong) UIButton *checkAllBtn;
@property (nonatomic, strong) DTPaddingLabel *checkAllLabel;
@end

@implementation OrderChooseUsersView

- (void)configUsersData:(NSArray <AudioRoomMicModel *>*)list {
    self.usersList = [NSMutableArray arrayWithArray:list];
    
    if (list.count == 0) {
        for (int i = 0; i < 8; i++) {
            AudioRoomMicModel *m = AudioRoomMicModel.new;
            m.isEmpty = true;
            [self.usersList addObject:m];
        }
        [self.checkAllBtn setHidden:true];
        [self.checkAllLabel setHidden:true];
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(16);
            make.top.mas_equalTo(self);
            make.height.mas_equalTo(37);
            make.trailing.mas_equalTo(-16);
        }];
    }
    
    [self.collectionView reloadData];
}

- (void)dtAddViews {
    [self addSubview:self.collectionView];
    [self addSubview:self.checkAllBtn];
    [self addSubview:self.checkAllLabel];
}

- (void)dtLayoutViews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(37);
        make.trailing.mas_equalTo(self.checkAllBtn.mas_leading).offset(-16);
    }];
    [self.checkAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.checkAllLabel);
    }];
    [self.checkAllLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.centerY.mas_equalTo(self);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_equalTo(30);
    }];
}

- (NSInteger)usersCount {
    NSInteger count = 0;
    for (AudioRoomMicModel *item in self.usersList) {
        if (item.isSelected) {
            ++count;
        }
    }
    return count;
}

- (NSArray<AudioRoomMicModel *> *)selectedUserList {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (AudioRoomMicModel *item in self.usersList) {
        if (item.isSelected) {
            [list addObject:item];
        }
    }
    return list;
}

#pragma mark - Event

- (void)checkAllBtnBtnEvent:(UIButton *)btn {
    BOOL isAllCheck = [self isAllCheck];
    
    for (AudioRoomMicModel *item in self.usersList) {
        item.isSelected = !isAllCheck;
    }
    [self.collectionView reloadData];
    if (self.completeBlock) {
        self.completeBlock();
    }
    [self updateCheckAllBtn];
}

- (BOOL)isAllCheck {
    BOOL isAllCheck = YES;
    for (AudioRoomMicModel *item in self.usersList) {
        if (!item.isSelected) {
            isAllCheck = NO;
        }
    }
    return isAllCheck;
}

- (void)updateCheckAllBtn {
    BOOL isAllCheck = [self isAllCheck];
    self.checkAllLabel.text = isAllCheck ? NSString.dt_common_cancel : NSString.dt_common_select_all;
    self.checkAllLabel.textColor = isAllCheck ? UIColor.whiteColor : UIColor.blackColor;
    self.checkAllBtn.backgroundColor = isAllCheck ? UIColor.blackColor : UIColor.whiteColor;
    self.checkAllBtn.layer.borderColor = isAllCheck ? UIColor.clearColor.CGColor : [UIColor dt_colorWithHexString:@"#000000" alpha:1].CGColor;
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.usersList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OrderChooseUsersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OrderChooseUsersCell" forIndexPath:indexPath];
    cell.model = self.usersList[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.usersList[indexPath.row].isEmpty) {
        return;
    }
    self.usersList[indexPath.row].isSelected = !self.usersList[indexPath.row].isSelected;
    [self.collectionView reloadData];
    [self updateCheckAllBtn];
    if (self.completeBlock) {
        self.completeBlock();
    }
}

// 设置Header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

// 设置Footer的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(32, 37);
        flowLayout.minimumLineSpacing = 12;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[OrderChooseUsersCell class] forCellWithReuseIdentifier:@"OrderChooseUsersCell"];
        _collectionView.backgroundColor = UIColor.clearColor;
    }
    return _collectionView;
}

- (NSMutableArray<AudioUserModel *> *)usersList {
    if (!_usersList) {
        _usersList = NSMutableArray.new;
    }
    return _usersList;
}

- (UIButton *)checkAllBtn {
    if (!_checkAllBtn) {
        _checkAllBtn = UIButton.new;
        [_checkAllBtn setTitle:@"" forState:UIControlStateNormal];
        _checkAllBtn.layer.cornerRadius = 30/2;
        _checkAllBtn.layer.borderColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1].CGColor;
        _checkAllBtn.layer.borderWidth = 1;
        _checkAllBtn.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
        _checkAllBtn.titleLabel.font = UIFONT_MEDIUM(12);
        [_checkAllBtn setTitleColor:[UIColor dt_colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
        [_checkAllBtn addTarget:self action:@selector(checkAllBtnBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkAllBtn;
}

- (DTPaddingLabel *)checkAllLabel {
    if (!_checkAllLabel) {
        _checkAllLabel = [[DTPaddingLabel alloc] init];
        [_checkAllLabel setUserInteractionEnabled:false];
        _checkAllLabel.paddingX = 12;
        _checkAllLabel.text = NSString.dt_common_select_all;
        _checkAllLabel.font = UIFONT_MEDIUM(12);
        _checkAllLabel.textAlignment = NSTextAlignmentCenter;
        _checkAllLabel.textColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1];
    }
    return _checkAllLabel;
}
@end

