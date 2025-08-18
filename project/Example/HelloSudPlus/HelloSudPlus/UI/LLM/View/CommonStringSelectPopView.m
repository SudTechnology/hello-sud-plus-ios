//
//  GuessResultPopView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "CommonStringSelectPopView.h"
#import "CommonListStringCell.h"

@interface CommonStringSelectPopView () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *sureBtn;
@property(nonatomic, strong) NSArray<CommonListStringCellModel *> *dataList;
@property(nonatomic, assign)NSInteger selectedIndex;
@end

@implementation CommonStringSelectPopView

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

- (void)setText:(NSString *)text {
    _text = text;
    [self dtUpdateUI];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.titleLabel.text = nil;
    self.backgroundColor = HEX_COLOR(@"#FFFFFF");
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    
    self.titleLabel.text = self.text;
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.sureBtn addTarget:self action:@selector(onCloseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onCloseBtnClick:(id)sender {
    [DTAlertView close];
}

- (void)updateCellModelList:(NSArray<CommonListStringCellModel *> *)cellModelList selectedIndex:(NSInteger)selectedIndex; {

    self.dataList = cellModelList;
    self.selectedIndex = selectedIndex;
    CGFloat h = cellModelList.count * 56;
    if (h > 280) {
        h = 280;
    }
    if (self.text.length == 0) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.leading.trailing.equalTo(@0);
            make.height.equalTo(@0);
        }];
    } else {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@24);
            make.leading.trailing.equalTo(@0);
            make.height.greaterThanOrEqualTo(@0);
        }];
    }
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@(h));
        make.bottom.equalTo(@-20);
    }];
    [self.tableView layoutIfNeeded];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate || UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonListStringCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonListStringCell"];
    CommonListStringCellModel *m = self.dataList[indexPath.row];
    m.isSelected = indexPath.row == self.selectedIndex;
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self onCloseBtnClick:nil];
    if (self.selectedBlock) {
        self.selectedBlock(indexPath.row);
    }

}


#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 56;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColor.clearColor;
        [_tableView registerClass:[CommonListStringCell class] forCellReuseIdentifier:@"CommonListStringCell"];
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
