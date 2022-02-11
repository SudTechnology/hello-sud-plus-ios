//
//  HSRoomGiftPannelView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSRoomGiftPannelView.h"
#import "HSGiftUserCollectionViewCell.h"
#import "HSRoomGiftContentView.h"
#import "HSAudioRoomViewController+IM.h"

@interface HSRoomGiftPannelView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *sendToLabel;
@property (nonatomic, strong) UIButton *checkAllBtn;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIView *sendView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) HSRoomGiftContentView *giftContentView;
@property (nonatomic, strong) HSBlurEffectView *blurView;
/// 选择用户
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<HSAudioRoomMicModel *> *userDataList;
@end

@implementation HSRoomGiftPannelView

- (void)hsConfigUI {
}

- (void)hsAddViews {
    [self addSubview:self.blurView];
    [self addSubview:self.topView];
    [self.topView addSubview:self.sendToLabel];
    [self.topView addSubview:self.checkAllBtn];
    [self.topView addSubview:self.lineView];
    [self.topView addSubview:self.collectionView];
    [self addSubview:self.giftContentView];
    [self addSubview:self.sendView];
}

- (void)hsLayoutViews {
    [self.blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(0);
    }];
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
        make.top.mas_equalTo(self.topView.mas_bottom).offset(10);
        make.height.mas_equalTo(110);
    }];
    [self.sendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.giftContentView.mas_bottom).offset(24);
        make.right.mas_equalTo(-16);
        make.size.mas_equalTo(CGSizeMake(56 + 56, 32));
        make.bottom.mas_equalTo(-kAppSafeBottom - 8);
    }];
}

- (void)hsConfigEvents {
    [super hsConfigEvents];
}

- (void)hsUpdateUI {
    NSArray *arrModel = HSAudioRoomManager.shared.currentRoomVC.dicMicModel.allValues;
    for (HSAudioRoomMicModel *m in arrModel) {
        if (m.user != nil && ![HSAppManager.shared.loginUserInfo isMeByUserID:m.user.userID]) {
            m.isSelected = NO;
            [self.userDataList addObject:m];
        }
    }
    
    if (self.userDataList.count > 0) {
        self.userDataList[0].isSelected = true;
        [self.topView setHidden:false];
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(72);
        }];
        HSAudioRoomMicModel *m = self.userDataList[0];
        [[NSNotificationCenter defaultCenter]postNotificationName:NTF_SEND_GIFT_USER_CHANGED object:nil userInfo:@{@"micModel":m}];
    } else {
        [self.topView setHidden:true];
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    [self.collectionView reloadData];
}

- (void)onBtnSend:(UIButton *)sender {
    
    NSMutableArray<HSAudioUserModel*> *arrWaitForSend = NSMutableArray.new;
    for (HSAudioRoomMicModel *m in self.userDataList) {
        if (m.isSelected && m.user != nil) {
            [arrWaitForSend addObject:m.user];
        }
    }
    if (arrWaitForSend.count == 0) {
        [ToastUtil show:@"请选择收礼人"];
        return;
    }
    if (!self.giftContentView.didSelectedGift) {
        [ToastUtil show:@"请选择一个礼物"];
        return;
    }
    for (HSAudioUserModel *user in arrWaitForSend) {
        HSGiftModel *giftModel = self.giftContentView.didSelectedGift;
        HSAudioUserModel *toUser = user;//[HSAudioUserModel makeUserWithUserID:@"1231" name:@"3333" icon:@"" sex:1];
        HSAudioMsgGiftModel *giftMsg = [HSAudioMsgGiftModel makeMsgWithGiftID:giftModel.giftID giftCount:1 toUser:toUser];
        [HSAudioRoomManager.shared.currentRoomVC sendMsg:giftMsg isAddToShow:YES];
    }
}

- (void)onCheckAllSelect:(UIButton *)sender {
    [self.checkAllBtn setSelected:!self.checkAllBtn.isSelected];
    for (HSAudioRoomMicModel *m in self.userDataList) {
        m.isSelected = self.checkAllBtn.isSelected ? true : false;
        [[NSNotificationCenter defaultCenter]postNotificationName:NTF_SEND_GIFT_USER_CHANGED object:nil userInfo:@{@"micModel":m}];
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userDataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HSGiftUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSGiftUserCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.userDataList[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.userDataList[indexPath.row].isSelected = !self.userDataList[indexPath.row].isSelected;
    [self.collectionView reloadData];
    HSAudioRoomMicModel *m = self.userDataList[indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:NTF_SEND_GIFT_USER_CHANGED object:nil userInfo:@{@"micModel":m}];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.userDataList[indexPath.row].isSelected = !self.userDataList[indexPath.row].isSelected;
    [self.collectionView reloadData];
    HSAudioRoomMicModel *m = self.userDataList[indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:NTF_SEND_GIFT_USER_CHANGED object:nil userInfo:@{@"micModel":m}];
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

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
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
        [_checkAllBtn setTitle:@"取消全选" forState:UIControlStateSelected];
        [_checkAllBtn setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
        _checkAllBtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        _checkAllBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        [_checkAllBtn addTarget:self action:@selector(onCheckAllSelect:) forControlEvents:UIControlEventTouchUpInside];
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
        [_sendBtn addTarget:self action:@selector(onBtnSend:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (UIView *)sendView {
    if (!_sendView) {
        _sendView = [[UIView alloc] init];
        _sendView.backgroundColor = [UIColor blackColor];
        _sendView.layer.borderWidth = 1;
        _sendView.layer.borderColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1].CGColor;
        _sendView.layer.masksToBounds = true;
        
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.text = @"x1";
        numLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
        numLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_gift_send_num"]];
        [_sendView addSubview:numLabel];
        [_sendView addSubview:iconView];
        [_sendView addSubview:self.sendBtn];
        
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(_sendView);
            make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        }];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(numLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(_sendView);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(54);
            make.top.right.bottom.mas_equalTo(_sendView);
            make.width.mas_equalTo(56);
        }];
    }
    return _sendView;
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

- (HSBlurEffectView *)blurView {
    if (_blurView == nil) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurView = [[HSBlurEffectView alloc]initWithEffect:effect];
        _blurView.blurLevel = 0.35;
        _blurView.backgroundColor =  HEX_COLOR_A(@"#000000", 0.7);
    }
    return _blurView;
}

@end
