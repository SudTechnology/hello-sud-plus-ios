//
//  GuessResultPopView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "WalletAddressSwitchPopView.h"
#import "WalletAddressSwitchCell.h"
#import "WalletAddressSwitchCellModel.h"

@interface WalletAddressSwitchPopView () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *sureBtn;
@property(nonatomic, strong) NSArray<WalletAddressSwitchCellModel *> *dataList;
@end

@implementation WalletAddressSwitchPopView

- (void)dealloc {

}


- (void)dtAddViews {

    [self addSubview:self.titleLabel];
    [self addSubview:self.tableView];
//    [self addSubview:self.sureBtn];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@24);
        make.leading.trailing.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@280);
        make.bottom.equalTo(@-20);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.titleLabel.text = @"已绑定的钱包地址";
    self.backgroundColor = HEX_COLOR_A(@"#F2F2F2", 0.9);
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.sureBtn addTarget:self action:@selector(onCloseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onCloseBtnClick:(id)sender {
    [DTAlertView close];
}

- (void)updateCellModelList:(NSArray<WalletAddressSwitchCellModel *> *)cellModelList {

    self.dataList = cellModelList;
    CGFloat h = cellModelList.count * 56;
    if (h > 280) {
        h = 280;
    }
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@(h));
        make.bottom.equalTo(@-20);
    }];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate || UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WalletAddressSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletAddressSwitchCell"];
    WalletAddressSwitchCellModel *m = self.dataList[indexPath.row];
    m.isSelected =  m.walletModel.type == HsNFTPreferences.shared.currentWalletType;
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WalletAddressSwitchCellModel *m = self.dataList[indexPath.row];
    HsNFTPreferences.shared.currentWalletType = m.walletModel.type;
    [self onCloseBtnClick:nil];
    [NSNotificationCenter.defaultCenter postNotificationName:MY_NFT_WALLET_TYPE_CHANGE_NTF object:nil userInfo:nil];
    [NSNotificationCenter.defaultCenter postNotificationName:MY_NFT_BIND_WALLET_CHANGE_NTF object:nil userInfo:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return UIView.new;
}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 56;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.separatorColor = HEX_COLOR(@"#D1D1D1");
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColor.clearColor;
        [_tableView registerClass:[WalletAddressSwitchCell class] forCellReuseIdentifier:@"WalletAddressSwitchCell"];
    }
    return _tableView;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFONT_REGULAR(14);
        _titleLabel.textColor = HEX_COLOR(@"#1A1A1A");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:NSString.dt_common_sure forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEX_COLOR(@"#ffffff") forState:UIControlStateNormal];
        _sureBtn.backgroundColor = HEX_COLOR(@"#000000");
        _sureBtn.titleLabel.font = UIFONT_MEDIUM(14);
    }
    return _sureBtn;
}


@end
