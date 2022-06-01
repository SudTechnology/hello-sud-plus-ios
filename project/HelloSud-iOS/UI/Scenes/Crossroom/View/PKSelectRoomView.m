//
// Created by kaniel on 2022/4/22.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "PKSelectRoomView.h"
#import "PKRoomListCell.h"

@interface PKSelectRoomView () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *closeBtn;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray <HSRoomInfoList *> *dataList;
@property(nonatomic, strong) UILabel *noDataLabel;
@end

@implementation PKSelectRoomView

- (void)dtAddViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeBtn];
    [self addSubview:self.tableView];
    [self addSubview:self.noDataLabel];
    [self addRefreshHeader];
}

- (void)dtLayoutViews {

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@22);
        make.leading.equalTo(@16);
        make.width.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.width.height.equalTo(@44);
        make.trailing.equalTo(@(-6));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(9);
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.height.equalTo(@332);
        make.bottom.mas_equalTo(0);
    }];
    [self.noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(109);
        make.centerX.mas_equalTo(self);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
}


- (void)dtConfigUI {
    self.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
    [self requestData];
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
    [self.closeBtn addTarget:self action:@selector(onCloseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onCloseBtnClick:(UIButton *)sender {
    [DTSheetView close];
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
    NSDictionary *dicParam = @{@"sceneType" : @(SceneTypeCross)};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"room/list/v1") param:dicParam respClass:RoomListModel.class showErrorToast:false success:^(BaseRespModel *resp) {
        [weakSelf.tableView.mj_header endRefreshing];
        RoomListModel *model = (RoomListModel *) resp;
        [weakSelf.dataList removeAllObjects];
        [weakSelf.dataList addObjectsFromArray:model.roomInfoList];
        [weakSelf.tableView reloadData];
        weakSelf.noDataLabel.hidden = weakSelf.dataList.count != 0;
    } failure:^(NSError *error) {
        [ToastUtil show:error.dt_errMsg];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate || UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PKRoomListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PKRoomListCell"];
    cell.model = self.dataList[indexPath.row];
    [cell updateEnterTitle:NSString.dt_room_pk_invite];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HSRoomInfoList *m = self.dataList[indexPath.row];
    [kPKService sendCrossPKInviteMsg:[NSString stringWithFormat:@"%@", @(m.roomId)] finished:^(NSInteger errorCode) {
        if (errorCode == 0) {
            [ToastUtil show:NSString.dt_room_invitation_send];
        } else {
            [ToastUtil show:[NSString stringWithFormat:NSString.dt_room_invitation_failed, errorCode]];
        }
        [DTSheetView close];
    }];
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
        UIView *headerNode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        headerNode.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
        _tableView.tableHeaderView = headerNode;
    }
    return _tableView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSString.dt_room_air_room_list;
        _titleLabel.font = UIFONT_MEDIUM(18);
        _titleLabel.textColor = HEX_COLOR(@"#1A1A1A");
    }
    return _titleLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"pk_room_list_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
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
        _noDataLabel.text = NSString.dt_room_pk_no_room_available;
        _noDataLabel.textColor = [UIColor dt_colorWithHexString:@"#8A8A8E" alpha:1];
        _noDataLabel.font = UIFONT_REGULAR(14);
        _noDataLabel.numberOfLines = 0;
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.hidden = true;
    }
    return _noDataLabel;
}
@end
