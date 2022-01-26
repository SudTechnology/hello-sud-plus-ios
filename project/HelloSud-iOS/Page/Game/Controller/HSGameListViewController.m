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
    /// 假数据
    HSRoomInfoList *m_0 = [[HSRoomInfoList alloc] init];
    m_0.roomId = 100;
    m_0.roomName = @"房间名字0001";
    m_0.roomPic = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi0.hdslb.com%2Fbfs%2Farticle%2F7af2c723accd90ce5c9e79471a76251ae44f0798.jpg&refer=http%3A%2F%2Fi0.hdslb.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1645674165&t=cb63922664bc54461211e0ae8acd6e95";
    m_0.memberCount = 3;
    m_0.sceneType = 1;
    HSRoomInfoList *m_1 = [[HSRoomInfoList alloc] init];
    m_1.roomId = 101;
    m_1.roomName = @"房间名字0007";
    m_1.roomPic = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi0.hdslb.com%2Fbfs%2Farticle%2F7af2c723accd90ce5c9e79471a76251ae44f0798.jpg&refer=http%3A%2F%2Fi0.hdslb.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1645674165&t=cb63922664bc54461211e0ae8acd6e95";
    m_1.memberCount = 6;
    m_1.sceneType = 1;
    [self.dataList addObject:m_0];
    [self.dataList addObject:m_1];
    [self.tableView reloadData];
    
    WeakSelf
    [RequestService postRequestWithApi:kBASEURL(@"room/list/v1") param:@{} success:^(NSDictionary *rootDict) {
        HSRoomListModel *model = [HSRoomListModel mj_objectWithKeyValues:rootDict];
        if (model.retCode != 0) {
            [SVProgressHUD showErrorWithStatus:model.retMsg];
            return;
        }
        [self.dataList removeAllObjects];
        [weakSelf.dataList addObjectsFromArray:model.data.roomInfoList];
        [weakSelf.tableView reloadData];
    } failure:^(id error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
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
    /// 跳转到Examples中的语音场景样例
    HSAudioRoomViewController *vc = [[HSAudioRoomViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
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
