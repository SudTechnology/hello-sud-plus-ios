//
//  GuessRankContentView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/8.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RoomListContentView.h"
#import "GameListTableViewCell.h"
#import "PKRoomListCell.h"
#import "AudioRoomViewController.h"
#import "CrossAppRoomListCell.h"

@interface RoomListContentView () <JXCategoryListContentViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray <HSRoomInfoList *> *dataList;
@property(nonatomic, strong) UILabel *noDataLabel;
@end

@implementation RoomListContentView

- (UIView *)listView {
    return self;
}

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.tableView];
    [self addSubview:self.noDataLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.bottom.mas_equalTo(-kTabBarHeight);
    }];
    [self.noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@109);
        make.centerX.mas_equalTo(self);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    [self addRefreshHeader];
    self.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
}

- (void)dtConfigEvents {
    WeakSelf
    [[NSNotificationCenter defaultCenter] addObserverForName:TOKEN_REFRESH_SUCCESS_NTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *_Nonnull note) {
        if (AppService.shared.login.isRefreshedToken) {
            [weakSelf requestData];
        } else {
            [weakSelf.tableView.mj_header endRefreshing];
        }
    }];
    if (AppService.shared.login.isRefreshedToken) {
        [self requestData];
    }
}

// 添加下来刷新
- (void)addRefreshHeader {
    WeakSelf
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!AppService.shared.login.isRefreshedToken) {
            [AppService.shared.login checkToken];
            return;
        }
        [weakSelf requestData];
    }];
    header.lastUpdatedTimeLabel.hidden = true;
    header.stateLabel.hidden = true;
    self.tableView.mj_header = header;
    self.tableView.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
}

#pragma mark - requst Data

- (void)requestData {
    WeakSelf
    [HSHttpService postRequestWithURL:kINTERACTURL(@"room/list/v1") param:nil respClass:RoomListModel.class showErrorToast:false success:^(BaseRespModel *resp) {
        [weakSelf.tableView.mj_header endRefreshing];
        RoomListModel *model = (RoomListModel *) resp;
        [weakSelf.dataList removeAllObjects];
        [weakSelf.dataList addObjectsFromArray:model.roomInfoList];
        [weakSelf.tableView reloadData];
        weakSelf.noDataLabel.hidden = weakSelf.dataList.count != 0;
    }                         failure:^(NSError *error) {
        [ToastUtil show:error.dt_errMsg];
        [weakSelf.tableView.mj_header endRefreshing];
    }];

}

#pragma mark - UITableViewDelegate || UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSRoomInfoList *m = self.dataList[indexPath.row];
    GameListTableViewCell *cell = nil;
    if (m.sceneType == SceneTypeCrossApp) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CrossAppRoomListCell"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PKRoomListCell"];
    }
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HSRoomInfoList *m = self.dataList[indexPath.row];
    if (m.sceneType == SceneTypeDanmaku && ![AppService.shared isSameRtc:AppService.shared.configModel.zegoCfg rtcType:AppService.shared.rtcType]) {
        [ToastUtil show:NSString.dt_home_coming_soon];
        return;
    }
    [AudioRoomService reqEnterRoom:m.roomId isFromCreate:NO extData:nil success:nil fail:nil];
}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 90;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
        [_tableView registerClass:[PKRoomListCell class] forCellReuseIdentifier:@"PKRoomListCell"];
        [_tableView registerClass:[CrossAppRoomListCell class] forCellReuseIdentifier:@"CrossAppRoomListCell"];

        UIView *headerNode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        headerNode.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
        UIView *tailNode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 12)];
        tailNode.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
        _tableView.tableHeaderView = headerNode;
        _tableView.tableFooterView = tailNode;
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UILabel *)noDataLabel {
    if (!_noDataLabel) {
        _noDataLabel = UILabel.new;
        _noDataLabel.text = NSString.dt_room_list_no_room_available;
        _noDataLabel.textColor = [UIColor dt_colorWithHexString:@"#8A8A8E" alpha:1];
        _noDataLabel.font = UIFONT_REGULAR(14);
        _noDataLabel.numberOfLines = 0;
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.hidden = true;
    }
    return _noDataLabel;
}
@end
