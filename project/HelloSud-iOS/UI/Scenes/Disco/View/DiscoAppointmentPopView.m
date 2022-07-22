//
// Created by kaniel on 2022/6/8.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoAppointmentPopView.h"
#import "MoreGuessCoinItemView.h"
#import "DiscoSelectAnchorColCell.h"

@interface DiscoAppointmentPopView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIView *awardBackgroundView;
@property(nonatomic, strong) YYLabel *awardLabel;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subtitleLabel;
@property(nonatomic, strong) UIButton *supportBtn;
@property(nonatomic, strong) UIView *coinContentView;
@property(nonatomic, strong) NSArray<UIButton *> *arrCoinItemView;

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) BaseView *supportView;
@property(nonatomic, strong) NSArray <BaseModel *> *anchorList;

@property(nonatomic, assign) NSInteger selectedMinute;
@property(nonatomic, assign) NSInteger totalCoin;
@property(nonatomic, assign) NSInteger selectedAchorCount;
@end

@implementation DiscoAppointmentPopView

- (void)dtAddViews {
    [super dtAddViews];

    [self addSubview:self.bgImageView];
    [self addSubview:self.awardBackgroundView];
    [self.awardBackgroundView addSubview:self.awardLabel];

    [self addSubview:self.titleLabel];
    [self addSubview:self.collectionView];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.coinContentView];
    [self addSubview:self.supportView];
    [self.supportView addSubview:self.supportBtn];

    NSArray<NSNumber *> *arr = @[@1, @3, @10];
    NSMutableArray *arrBtn = [[NSMutableArray alloc] init];
    for (int i = 0; i < arr.count; ++i) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:[NSString stringWithFormat:NSString.dt_room_minutes, arr[i]] forState:UIControlStateNormal];
        btn.tag = arr[i].integerValue;
        btn.titleLabel.font = UIFONT_REGULAR(14);
        [btn addTarget:self action:@selector(onSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:HEX_COLOR_A(@"#000000", 0.2).dt_toImage forState:UIControlStateNormal];
        [btn setBackgroundImage:HEX_COLOR_A(@"#ffffff", 1).dt_toImage forState:UIControlStateSelected];
        [btn setTitleColor:UIColor.blackColor forState:UIControlStateSelected];
        [btn dt_cornerRadius:4];
        [self.coinContentView addSubview:btn];
        [arrBtn addObject:btn];
        // 默认选中
        if (i == 0) {
            btn.selected = YES;
            self.selectedMinute = arr[i].integerValue;
        }
    }
    self.arrCoinItemView = arrBtn;
}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@22);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@0);
        make.height.equalTo(@68);
    }];

    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(12);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.awardBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@24);
        make.top.equalTo(self.coinContentView.mas_bottom).offset(62);
        make.leading.equalTo(self.titleLabel);
        make.width.greaterThanOrEqualTo(@0);
    }];
    [self.awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@5);
        make.trailing.equalTo(@-5);
        make.centerY.equalTo(self.awardBackgroundView);
        make.height.equalTo(self.awardBackgroundView);
        make.width.greaterThanOrEqualTo(@0);
    }];

    [self.coinContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.top.equalTo(self.subtitleLabel.mas_bottom).offset(12);
        make.height.equalTo(@36);
    }];

    [self.arrCoinItemView dt_mas_distributeSudokuViewsWithFixedLineSpacing:10 fixedInteritemSpacing:12 warpCount:3 topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];

    CGFloat bottom = kAppSafeBottom + 12;
    [self.supportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coinContentView.mas_bottom).offset(46);
        make.height.equalTo(@44);
        make.width.greaterThanOrEqualTo(@167);
        make.trailing.equalTo(@-16);
        make.bottom.equalTo(@(-bottom));
    }];
    [self.supportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.leading.equalTo(@22);
        make.trailing.equalTo(@-22);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    WeakSelf
    [UserService.shared reqUserCoinDetail:^(int64_t i) {
        [weakSelf updateCoin:i];
    }                                fail:^(NSString *errStr) {
        [ToastUtil show:errStr];
    }];
    [DiscoRoomService reqAnchorList:kDiscoRoomService.currentRoomVC.roomID.longLongValue success:^(NSArray<AnchorUserInfoModel *> *robotList) {
        if (robotList.count > 0) {
            robotList[0].isSelected = YES;// 默认选中第一个
        }
        weakSelf.anchorList = robotList;
        [weakSelf.collectionView reloadData];
        [weakSelf updateSelectState];
    }                       failure:nil];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.supportBtn addTarget:self action:@selector(onSupportBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    [self updateSelectState];
}

- (void)onSelectBtnClick:(UIButton *)sender {
    for (int i = 0; i < self.arrCoinItemView.count; ++i) {
        self.arrCoinItemView[i].selected = NO;
    }
    sender.selected = YES;
    self.selectedMinute = sender.tag;
    [self updateSelectState];
}

- (void)onSupportBtnCLick:(id)sender {
    if (self.selectedAchorCount == 0) {
        [ToastUtil show:NSString.dt_room_select_anchor];
        return;
    }
    if (self.selectedAchorCount == 0) {
        [ToastUtil show:NSString.dt_room_disco_select_duration_tip];
        return;
    }
    WeakSelf
    [DiscoRoomService reqPayCoin:self.totalCoin success:^{
        [weakSelf handlePaySuccess];
        RespDiscoPayCoinModel *cmdModel = [[RespDiscoPayCoinModel alloc]init];
        cmdModel.price = weakSelf.totalCoin;
        [cmdModel configBaseInfoWithCmd:CMD_ROOM_DISCO_ACTION_PAY];
        [kDiscoRoomService.currentRoomVC sendMsg:cmdModel isAddToShow:NO finished:nil];
        [DTSheetView close];
    }                    failure:nil];
}

- (void)updateSelectState {

    NSInteger anchorCount = 0;
    for (AnchorUserInfoModel *m in self.anchorList) {
        if (m.isSelected) {
            anchorCount++;
        }
    }
    self.selectedAchorCount = anchorCount;
    self.totalCoin = anchorCount * 50 * self.selectedMinute;
    NSString *title = [NSString stringWithFormat:NSString.dt_room_disco_appointment_coin_fmt, @(self.totalCoin)];
    [self.supportBtn setTitle:title forState:UIControlStateNormal];
}

- (void)updateCoin:(int64_t)coin {
    NSMutableAttributedString *full = [[NSMutableAttributedString alloc] init];
    UIImage *iconImage = [UIImage imageNamed:@"guess_award_coin"];
    NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(14, 14) alignToFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
    [full appendAttributedString:attrIcon];
    NSNumber *number = @(coin);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    formatter.positiveFormat = @"###,###";
    NSString *amountString = [formatter stringFromNumber:number];
    NSMutableAttributedString *attrAwardValue = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", amountString]];
    attrAwardValue.yy_font = UIFONT_MEDIUM(14);
    attrAwardValue.yy_color = HEX_COLOR(@"#F6A209");
    [full appendAttributedString:attrAwardValue];

    _awardLabel.attributedText = full;
}

// 处理支付成功后发送信息
- (void)handlePaySuccess {

    NSMutableArray *arrWaitForSend = [[NSMutableArray alloc] init];
    for (AnchorUserInfoModel *m in self.anchorList) {
        if (!m.isSelected) {
            continue;
        }
        AudioUserModel *user = [[AudioUserModel alloc]init];
        user.userID = [NSString stringWithFormat:@"%@", @(m.userId)];
        user.name = m.nickname;
        user.icon = m.avatar;
        [arrWaitForSend addObject:user];
    }

    // 跳舞一分钟礼物
    GiftModel *giftModel = [GiftService.shared giftByID:5];
    for (AudioUserModel *user in arrWaitForSend) {
        AudioUserModel *toUser = user;
        RoomCmdSendGiftModel *giftMsg = [RoomCmdSendGiftModel makeMsgWithGiftID:giftModel.giftID giftCount:1 * self.selectedMinute toUser:toUser];
        giftMsg.type = giftModel.type;
        giftMsg.giftUrl = giftModel.giftURL;
        giftMsg.animationUrl = giftModel.animateURL;
        giftMsg.giftName = giftModel.giftName;

        [kAudioRoomService.currentRoomVC sendMsg:giftMsg isAddToShow:YES finished:nil];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.anchorList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DiscoSelectAnchorColCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DiscoSelectAnchorColCell" forIndexPath:indexPath];
    WeakSelf;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    DiscoSelectAnchorColCell *c = (DiscoSelectAnchorColCell *) cell;
    c.model = self.anchorList[indexPath.row];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    DiscoSelectAnchorColCell *c = (DiscoSelectAnchorColCell *) [collectionView cellForItemAtIndexPath:indexPath];
    AnchorUserInfoModel *model = self.anchorList[indexPath.row];
    model.isSelected = !model.isSelected;
    c.model = model;
    [self updateSelectState];
}

- (UIView *)awardBackgroundView {
    if (!_awardBackgroundView) {
        _awardBackgroundView = [[UIView alloc] init];
        _awardBackgroundView.backgroundColor = HEX_COLOR_A(@"#000000", 0.1);
        [_awardBackgroundView dt_cornerRadius:12];
    }
    return _awardBackgroundView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disco_appointment_bg"]];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (YYLabel *)awardLabel {
    if (!_awardLabel) {
        _awardLabel = [[YYLabel alloc] init];
    }
    return _awardLabel;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFONT_MEDIUM(14);
        _titleLabel.textColor = HEX_COLOR(@"#ffffff");
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = NSString.dt_room_disco_appointment_dance;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = UIFONT_MEDIUM(14);
        _subtitleLabel.textColor = HEX_COLOR(@"#ffffff");
        _subtitleLabel.text = NSString.dt_room_disco_dance_duration;
    }
    return _subtitleLabel;
}

- (UIButton *)supportBtn {
    if (!_supportBtn) {
        _supportBtn = [[UIButton alloc] init];
        [_supportBtn setTitle:NSString.dt_room_guess_support_now forState:UIControlStateNormal];
        [_supportBtn setTitleColor:HEX_COLOR(@"#000402") forState:UIControlStateNormal];
        _supportBtn.titleLabel.font = UIFONT_BOLD(14);
    }
    return _supportBtn;
}


- (BaseView *)supportView {
    if (!_supportView) {
        _supportView = [[BaseView alloc] init];
        _supportView.layer.borderWidth = 2;
        _supportView.layer.borderColor = HEX_COLOR(@"#FF4E67").CGColor;
        NSArray *colorArr = @[(id) [UIColor dt_colorWithHexString:@"#FFCCF4" alpha:1].CGColor, (id) [UIColor dt_colorWithHexString:@"#FFF6C1" alpha:1].CGColor];
        [_supportView dtAddGradientLayer:@[@(0.0f), @(1)] colors:colorArr startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1) cornerRadius:0];
        [_supportView dt_cornerRadius:4];
    }
    return _supportView;
}

- (UIView *)coinContentView {
    if (!_coinContentView) {
        _coinContentView = [[UIView alloc] init];
    }
    return _coinContentView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat itemW = 56;
        CGFloat itemH = 68;

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = YES;
        [_collectionView registerClass:[DiscoSelectAnchorColCell class] forCellWithReuseIdentifier:@"DiscoSelectAnchorColCell"];
    }
    return _collectionView;
}
@end
