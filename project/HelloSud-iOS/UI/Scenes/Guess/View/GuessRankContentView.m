//
//  GuessRankContentView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/8.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GuessRankContentView.h"
#import "GuessRankHeaderView.h"
#import "GuessRankTableViewCell.h"



@interface GuessRankContentView () <JXCategoryListContentViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) GuessRankHeaderView *headerView;
@end

@implementation GuessRankContentView

- (void)updateHeadHeight:(CGFloat)headHeight {
    self.headerView.mj_h = headHeight;
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.backgroundColor = UIColor.clearColor;
}

- (UIView *)listView {
    return self;
}

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.tableView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];

    self.tableView.backgroundColor = UIColor.clearColor;
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    self.headerView.firstModel = self.firstModel;
    self.headerView.secondModel = self.secondModel;
    self.headerView.thirdModel = self.thirdModel;
    [self.headerView dtUpdateUI];
}


#pragma mark - UITableViewDelegate || UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GuessRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuessRankTableViewCell"];
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
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
        [_tableView registerClass:[GuessRankTableViewCell class] forCellReuseIdentifier:@"GuessRankTableViewCell"];
    }
    return _tableView;
}

- (GuessRankHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[GuessRankHeaderView alloc] init];
    }
    return _headerView;
}
@end
