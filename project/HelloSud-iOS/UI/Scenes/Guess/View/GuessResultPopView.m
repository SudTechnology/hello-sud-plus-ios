//
//  GuessResultPopView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GuessResultPopView.h"
#import "GuessResultTableViewCell.h"

@interface GuessResultPopView () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) BaseView *contentView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) YYLabel *coinLabel;
@property(nonatomic, strong) UIButton *confirmBtn;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UILabel *emptyLabel;
@property(nonatomic, strong) NSArray <GuessPlayerModel *> *dataList;
@property(nonatomic, assign) NSInteger betCoin;
@property(nonatomic, assign) GuessResultPopViewType resultStateType;
@end

@implementation GuessResultPopView


- (void)dtAddViews {

    [self addSubview:self.bgImageView];
    [self addSubview:self.contentView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.coinLabel];
    [self addSubview:self.confirmBtn];
    [self addSubview:self.tableView];
    [self addSubview:self.emptyLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@260);
    }];
    [self.contentView dt_cornerRadius:12];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView).offset(103);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@417);
        make.bottom.equalTo(@0);
    }];


    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@28);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(14);
        make.leading.trailing.equalTo(@0);
        make.bottom.equalTo(self.confirmBtn.mas_top);
    }];
    [self.coinLabel dt_cornerRadius:12];
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.height.equalTo(@24);
        make.width.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.confirmBtn);

    }];
    CGFloat bottom = kAppSafeBottom + 12;
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-16);
        make.height.equalTo(@36);
        make.width.equalTo(@180);
        make.bottom.equalTo(@(-bottom));
    }];
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.tableView);
    }];


}

- (void)dtConfigUI {
    [super dtConfigUI];
    [self updateCoin:0];
    [self updateConfirmBtn];
    [self reqData];

    NSDictionary *dic = @{NSFontAttributeName: UIFONT_BOLD(24), NSForegroundColorAttributeName: HEX_COLOR(@"#000000")};
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"选择你支持的玩家\n" attributes:dic];
    dic = @{NSFontAttributeName: UIFONT_BOLD(30), NSForegroundColorAttributeName: HEX_COLOR(@"#000000")};
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:@"猜对得5倍奖励！" attributes:dic];
    [attr appendAttributedString:attr2];
    self.titleLabel.attributedText = attr;
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    self.emptyLabel.hidden = self.dataList.count > 0;
}

- (void)reqData {
    WeakSelf
    [UserService.shared reqUserCoinDetail:^(int64_t i) {
        [weakSelf updateCoin:i];
    }                                fail:^(NSString *errStr) {
        [ToastUtil show:errStr];
    }];
    NSArray *playerUserIdList = kGuessService.currentRoomVC.sudFSMMGDecorator.onlineUserIdList;
    NSString *roomId = kGuessService.currentRoomVC.roomID;
    [GuessService reqGuessPlayerList:playerUserIdList roomId:roomId finished:^(RespGuessPlayerListModel *model) {
        weakSelf.betCoin = model.betCoin;
        weakSelf.dataList = model.playerList;
        [weakSelf.tableView reloadData];
        [weakSelf dtUpdateUI];
    }];
}

- (void)updateCoin:(NSInteger)coin {
    NSMutableAttributedString *full = [[NSMutableAttributedString alloc] init];
    full.yy_alignment = NSTextAlignmentCenter;


    UIImage *iconImage = [UIImage imageNamed:@"guess_award_coin"];
    NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(14, 14) alignToFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
    attrIcon.yy_firstLineHeadIndent = 8;
    [full appendAttributedString:attrIcon];

    NSMutableAttributedString *attrAwardValue = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@  ", @(coin)]];
    attrAwardValue.yy_font = UIFONT_MEDIUM(14);
    attrAwardValue.yy_color = HEX_COLOR(@"#F6A209");
    [full appendAttributedString:attrAwardValue];

    self.coinLabel.attributedText = full;
}

- (void)dtConfigEvents {
    [super dtConfigEvents];

    [self.confirmBtn addTarget:self action:@selector(onConfirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)onConfirmBtnClick:(id)sender {

    NSMutableArray *selectedUserIdList = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataList.count; ++i) {
        if (self.dataList[i].isSelected) {
            [selectedUserIdList addObject:@(self.dataList[i].userId)];
        }
    }
    [GuessService reqBet:2 coin:self.betCoin userList:selectedUserIdList finished:^{
        [DTSheetView close];
        [ToastUtil show:@"已投注，等待游戏结果公布"];
    }];
}

/// 更新确认按钮值
- (void)updateConfirmBtn {
    /// 游戏开始后不能下注
    if (kGuessService.currentRoomVC.sudFSMMGDecorator.gameStateType == GameStateTypePlaying) {
        [self.confirmBtn setTitle:@"已截止" forState:UIControlStateDisabled];
        self.confirmBtn.enabled = NO;
        [self.tableView reloadData];
        return;
    }
    NSInteger selectedCount = 0;
    for (int i = 0; i < self.dataList.count; ++i) {
        if (self.dataList[i].isSelected) {
            selectedCount++;
        }
    }
    NSString *totalCoinStr = [NSString stringWithFormat:@"确认(%@金币)", @(selectedCount * self.betCoin)];
    [self.confirmBtn setTitle:totalCoinStr forState:UIControlStateNormal];
    self.confirmBtn.enabled = selectedCount > 0;
    if (self.confirmBtn.enabled) {
        _confirmBtn.layer.borderColor = HEX_COLOR(@"#FFBF3A").CGColor;
    } else {
        _confirmBtn.layer.borderColor = HEX_COLOR(@"#FFE8B9").CGColor;
    }

}

#pragma mark - UITableViewDelegate || UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GuessResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuessResultTableViewCell"];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 134;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
        [_tableView registerClass:[GuessResultTableViewCell class] forCellReuseIdentifier:@"GuessResultTableViewCell"];
    }
    return _tableView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
        _bgImageView.image = [UIImage imageNamed:@"guess_result_bg"];
    }
    return _bgImageView;
}

- (BaseView *)contentView {
    if (!_contentView) {
        _contentView = [[BaseView alloc] init];
        _contentView.backgroundColor = HEX_COLOR(@"#FCF4D2");
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFONT_BOLD(30);
        _titleLabel.textColor = HEX_COLOR(@"#000000");
        _titleLabel.shadowColor = HEX_COLOR(@"#FFDE00");
        _titleLabel.shadowOffset = CGSizeMake(1, 2);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)emptyLabel {
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] init];
        _emptyLabel.font = UIFONT_REGULAR(14);
        _emptyLabel.textColor = HEX_COLOR_A(@"#000000", 0.4);
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.numberOfLines = 0;
        _emptyLabel.text = @"暂无玩家游戏中，请稍候再来";
        _emptyLabel.hidden = YES;
    }
    return _emptyLabel;
}

- (YYLabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[YYLabel alloc] init];
        _coinLabel.textAlignment = NSTextAlignmentCenter;
        _coinLabel.numberOfLines = 0;
        _coinLabel.backgroundColor = UIColor.whiteColor;
    }
    return _coinLabel;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitle:@"确认(200金币)" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:HEX_COLOR(@"#6C3800") forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:HEX_COLOR_A(@"#6C3800", 0.3) forState:UIControlStateDisabled];
        [_confirmBtn setBackgroundImage:HEX_COLOR(@"#FFE373").dt_toImage forState:UIControlStateNormal];
        [_confirmBtn setBackgroundImage:HEX_COLOR(@"#FBF2D0").dt_toImage forState:UIControlStateDisabled];
        _confirmBtn.enabled = NO;
        _confirmBtn.layer.borderWidth = 1;
        _confirmBtn.layer.borderColor = HEX_COLOR(@"#FFBF3A").CGColor;
        _confirmBtn.titleLabel.font = UIFONT_BOLD(14);
    }
    return _confirmBtn;
}

@end
