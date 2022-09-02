//
//  GuessResultPopView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "MyEthereumChainsSelectPopView.h"
#import "MyEthereumChainsSelectCell.h"
#import "MyEthereumChainsCellModel.h"

@interface MyEthereumChainsSelectPopView () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *sureBtn;
@property(nonatomic, strong) NSArray<MyEthereumChainsCellModel *> *dataList;
@end

@implementation MyEthereumChainsSelectPopView

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

//    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.tableView.mas_bottom).offset(30);
//        make.height.equalTo(@36);
//        make.width.equalTo(@140);
//        make.bottom.equalTo(@-20);
//        make.centerX.equalTo(self);
//    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.titleLabel.text = @"网络";
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

- (void)updateChains:(NSArray<SudNFTChainInfoModel *> *)chains {
    NSMutableArray *arrList = [[NSMutableArray alloc] init];
    for (SudNFTChainInfoModel *m in chains) {
        MyEthereumChainsCellModel *cellModel = [[MyEthereumChainsCellModel alloc] init];
        cellModel.chainsModel = m;
        [arrList addObject:cellModel];
    }
    self.dataList = arrList;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate || UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyEthereumChainsSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyEthereumChainsSelectCell"];
    MyEthereumChainsCellModel *m = self.dataList[indexPath.row];
    if (m.chainsModel.type == SudNFTQSAppPreferences.shared.selectedEthereumChainType) {
        m.isSelected = YES;
    }
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyEthereumChainsCellModel *m = self.dataList[indexPath.row];
    SudNFTQSAppPreferences.shared.selectedEthereumChainType = m.chainsModel.type;
    [self onCloseBtnClick:nil];
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
        [_tableView registerClass:[MyEthereumChainsSelectCell class] forCellReuseIdentifier:@"MyEthereumChainsSelectCell"];
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
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEX_COLOR(@"#ffffff") forState:UIControlStateNormal];
        _sureBtn.backgroundColor = HEX_COLOR(@"#000000");
        _sureBtn.titleLabel.font = UIFONT_MEDIUM(14);
    }
    return _sureBtn;
}


@end
