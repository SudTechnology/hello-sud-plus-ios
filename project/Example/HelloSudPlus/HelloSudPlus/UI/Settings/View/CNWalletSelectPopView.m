//
//  GuessResultPopView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "CNWalletSelectPopView.h"
#import "CNWalletSelectCell.h"
#import "MyEthereumChainsCellModel.h"

@interface CNWalletSelectPopView () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray<SudNFTWalletInfoModel *> *dataList;
@property(nonatomic, strong) NSArray<SudNFTWalletInfoModel *> *srcList;
@end

@implementation CNWalletSelectPopView

- (void)dealloc {

}


- (void)dtAddViews {

    [self addSubview:self.topView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.tableView];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.topView dt_cornerRadius:3];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.width.equalTo(@56);
        make.height.equalTo(@6);
        make.centerX.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@36);
        make.leading.trailing.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(24);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.equalTo(@436);
        make.bottom.equalTo(@0);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.titleLabel.text = @"绑定你的数字账户";
    [self setPartRoundCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:20];
    self.backgroundColor = HEX_COLOR_A(@"#F5F6FB", 1);
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (self.dataList.count > 0) {
        [self.tableView reloadData];
    }
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
}

- (void)onCloseBtnClick:(id)sender {
    [DTAlertView close];
}

- (void)updateDataList:(NSArray<SudNFTWalletInfoModel *> *)dataList {
    self.srcList = dataList;
    self.dataList = dataList;
    [self resortList];
}

- (void)resortList {
    NSMutableArray *bindList = NSMutableArray.new;
    NSMutableArray *unbindList = NSMutableArray.new;
    for (SudNFTWalletInfoModel *m in self.srcList) {
        if ([HsNFTPreferences.shared isBindWalletWithType:m.type]) {
            [bindList addObject:m];
        } else {
            [unbindList addObject:m];
        }
    }
    [bindList addObjectsFromArray:unbindList];
    self.dataList = bindList;
    [self.tableView reloadData];
}

/*
 * 关闭如果不存在其它绑定账号
 * */
- (void)closeIfNoBindAccount {
    BOOL existAnotherBind = NO;
    for (SudNFTWalletInfoModel *m in self.dataList) {
        if ([HsNFTPreferences.shared isBindWalletWithType:m.type]) {
            existAnotherBind = YES;
            break;
        }
    }
    if (existAnotherBind) {
        [self resortList];
    } else {
        [DTSheetView close];
    }
}

#pragma mark - UITableViewDelegate || UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CNWalletSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CNWalletSelectCell"];
    WeakSelf
    cell.selectedWalletBlock = ^(SudNFTWalletInfoModel *m) {
        if (weakSelf.selectedWalletBlock) {
            weakSelf.selectedWalletBlock(m);
        }
    };
    cell.model = self.dataList[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SudNFTWalletInfoModel *m = self.dataList[indexPath.section];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return UIView.new;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return UIView.new;
}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 64;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColor.clearColor;
        [_tableView registerClass:[CNWalletSelectCell class] forCellReuseIdentifier:@"CNWalletSelectCell"];
    }
    return _tableView;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFONT_MEDIUM(20);
        _titleLabel.textColor = HEX_COLOR(@"#000000");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = UIView.new;
        _topView.backgroundColor = HEX_COLOR(@"#D5D7E0");
    }
    return _topView;
}
@end
