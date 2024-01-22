//
//  DiscoRankPopView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/30.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "InviteAnchorPopView.h"
#import "Audio3dInviteAnchorCell.h"


@interface InviteAnchorPopView () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray <Audio3dInviteAnchorModel *> *dataList;
@end

@implementation InviteAnchorPopView
- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.tableView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    CGFloat b = kAppSafeBottom + 20;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@0);
        make.top.equalTo(@10);
        make.bottom.equalTo(@(-b));
    }];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = UIColor.whiteColor;

}

- (void)dtUpdateUI {
    [super dtUpdateUI];
}

- (void)showList:(NSArray<Audio3dInviteAnchorModel *> *)dataList {
    [self.dataList setArray:dataList];
    NSInteger h = dataList.count * 60;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(h));
    }];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate || UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Audio3dInviteAnchorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Audio3dInviteAnchorCell"];
    WeakSelf
    cell.inviteClickBlock = ^(Audio3dInviteAnchorModel *anchorModel) {
        if (weakSelf.inviteClickBlock) {
            weakSelf.inviteClickBlock(anchorModel);
        }
    };
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
        _tableView.rowHeight = 60;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.whiteColor;
        [_tableView registerClass:[Audio3dInviteAnchorCell class] forCellReuseIdentifier:@"Audio3dInviteAnchorCell"];
    }
    return _tableView;
}

- (NSMutableArray <DiscoRankModel *> *)dataList {
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}
@end
