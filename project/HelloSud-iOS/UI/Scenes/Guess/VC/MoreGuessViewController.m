//
// Created by kaniel on 2022/6/6.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "MoreGuessViewController.h"
#import "MoreGuessHeaderView.h"
#import "MoreGuessTableViewCell.h"

@interface MoreGuessViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray <MoreGuessGameModel *> *dataList;
@property(nonatomic, strong) MoreGuessHeaderView *headerView;
@end

@implementation MoreGuessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSString.dt_room_guess_activity;
    [self reqData];
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.tableView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.view);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.view.backgroundColor = UIColor.whiteColor;
    CGFloat h = [self.headerView systemLayoutSizeFittingSize:CGSizeMake(kScreenWidth, kScreenHeight)].height;
    self.headerView.mj_h = h;
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.backgroundColor = UIColor.clearColor;
    self.tableView.backgroundColor = UIColor.clearColor;
}

- (void)dtUpdateUI {

}

- (void)reqData {

    WeakSelf
    [GuessRoomService reqGuessListWithFinished:^(RespMoreGuessModel *model) {
        weakSelf.dataList = model.quizGameInfoList;
        weakSelf.headerView.duration = model.pkCountDownCycle;
        [weakSelf.headerView dtUpdateUI];
        CGFloat h = [weakSelf.headerView systemLayoutSizeFittingSize:CGSizeMake(kScreenWidth, kScreenHeight)].height;
        weakSelf.headerView.mj_h = h;
        weakSelf.tableView.tableHeaderView = weakSelf.headerView;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate || UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoreGuessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreGuessTableViewCell"];
    cell.sceneId = self.sceneId;
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 134;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
        [_tableView registerClass:[MoreGuessTableViewCell class] forCellReuseIdentifier:@"MoreGuessTableViewCell"];
    }
    return _tableView;
}

- (MoreGuessHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MoreGuessHeaderView alloc] init];
    }
    return _headerView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more_guess_bg"]];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
}

@end
