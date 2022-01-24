//
//  HSGameListViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "HSGameListViewController.h"
#import "HSSearchHeaderView.h"
#import "HSGameListTableViewCell.h"
#import "HSAudioRoomViewController.h"

@interface HSGameListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) HSSearchHeaderView *searchHeaderView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation HSGameListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)hsIsHidenNavigationBar {
    return YES;
}

- (void)hsConfigUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F6FB" alpha:1];
}

- (void)hsAddViews {
    self.dataList = @[@(1), @(1), @(1), @(1), @(1)];
    [self.view addSubview:self.searchHeaderView];
    [self.view addSubview:self.tableView];
}

- (void)hsLayoutViews {
    [self.searchHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchHeaderView.mas_bottom);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(-kTabBarHeight);
    }];
}

#pragma mark - UITableViewDelegate || UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSGameListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSGameListTableViewCell"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    HSHotGameViewController *vc = [[HSHotGameViewController alloc] init];
    HSAudioRoomViewController *vc = [[HSAudioRoomViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 90;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F6FB" alpha:1];
        [_tableView registerClass:[HSGameListTableViewCell class] forCellReuseIdentifier:@"HSGameListTableViewCell"];
        UIView *headerNode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        headerNode.backgroundColor = [UIColor colorWithHexString:@"#F5F6FB" alpha:1];
        _tableView.tableHeaderView = headerNode;
    }
    return _tableView;
}

- (HSSearchHeaderView *)searchHeaderView {
    if (!_searchHeaderView) {
        _searchHeaderView = [[HSSearchHeaderView alloc] init];
    }
    return _searchHeaderView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
