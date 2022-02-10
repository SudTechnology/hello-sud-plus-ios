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
@property (nonatomic, strong) NSMutableArray <HSRoomInfoList *> *dataList;
@end

@implementation HSGameListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

- (BOOL)hsIsHidenNavigationBar {
    return YES;
}

- (void)hsConfigUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F6FB" alpha:1];
}

- (void)hsAddViews {
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

#pragma mark - requst Data
- (void)requestData {
    WeakSelf
    [RequestService postRequestWithApi:kINTERACTURL(@"room/list/v1") param:nil success:^(NSDictionary *rootDict) {
        HSRoomListModel *model = [HSRoomListModel mj_objectWithKeyValues:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.retMsg];
            return;
        }
        [self.dataList removeAllObjects];
        [weakSelf.dataList addObjectsFromArray:model.data.roomInfoList];
        [weakSelf.tableView reloadData];
    } failure:^(id error) {
        [ToastUtil show:@"网络错误"];
    }];
}

#pragma mark - UITableViewDelegate || UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSGameListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSGameListTableViewCell"];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HSRoomInfoList *m = self.dataList[indexPath.row];
    [HSAudioRoomManager.shared reqEnterRoom:m.roomId];
}

#pragma mark - lazy

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
