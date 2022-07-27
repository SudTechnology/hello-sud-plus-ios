//
//  GamePreloadViewController.m
//  DeveloperKit
//
//  Created by kaniel on 2022/7/26.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GamePreloadViewController.h"
#import "GamePreloadCell.h"
#import <SudMGP/SudMGP.h>
#import <SudMGP/ISudListenerGamePkgPreload.h>

@interface GamePreloadViewController ()<UITableViewDelegate, UITableViewDataSource, ISudListenerGamePkgPreload>
@property(nonatomic, strong) NSArray <QSGameItemModel *> *dataList;
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)UIButton *startBtn;
@property (nonatomic, strong)UIButton *cancelBtn;
@property(nonatomic, strong)NSMutableDictionary<NSString *, GamePreloadCell *> *cellMap;
@end

@implementation GamePreloadViewController

/// 是否需要RTC功能
- (BOOL)isNeedToRTC {
    return NO;
}

- (BOOL)dtIsHiddenNavigationBar {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sceneView.hidden = YES;
    self.bgImageView.hidden = YES;
    self.cellMap = [[NSMutableDictionary alloc]init];
    // Do any additional setup after loading the view.
    self.title = @"预加载";
}

- (void)dtAddViews {
    [super dtAddViews];
    self.view.backgroundColor = HEX_COLOR(@"#F5F6FB");
    [self.view addSubview:self.startBtn];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.tableView];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.top.equalTo(@0);
        make.height.equalTo(@44);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.startBtn.mas_trailing).offset(20);
        make.top.equalTo(@0);
        make.trailing.equalTo(@-16);
        make.width.height.equalTo(self.startBtn);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(@0);
        make.top.equalTo(self.startBtn.mas_bottom);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    [self loadGameList];
}

/// 加载游戏列表
- (void)loadGameList {

    //TODO: 开发者由SudMGP提供的游戏列表
    NSArray *arrGame = [QSAppPreferences.shared readGameList];
    self.dataList = arrGame;
}

- (void)onHiddenTableClick:(UIButton *)sender {
    if (sender.selected) {
        self.tableView.hidden = NO;
    } else {
        self.tableView.hidden = YES;
    }
    sender.selected = !sender.selected;
}

- (void)onCloseGameClick:(UIButton *)sender {
    [self logoutGame];
}

#pragma makr lazy

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView registerClass:[GamePreloadCell class] forCellReuseIdentifier:@"GamePreloadCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [[UIButton alloc]init];
        [_startBtn setTitle:@"隐藏列表" forState:UIControlStateNormal];
        [_startBtn setTitle:@"展示列表" forState:UIControlStateSelected];
        _startBtn.titleLabel.font = UIFONT_REGULAR(14);
        _startBtn.layer.borderWidth = 2;
        _startBtn.layer.borderColor = UIColor.orangeColor.CGColor;
        [_startBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_startBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [_startBtn addTarget:self action:@selector(onHiddenTableClick:) forControlEvents:UIControlEventTouchUpInside];
        _startBtn.backgroundColor = UIColor.whiteColor;
    }
    return  _startBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        [_cancelBtn setTitle:@"关闭游戏" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = UIFONT_REGULAR(14);
        _cancelBtn.layer.borderWidth = 2;
        _cancelBtn.layer.borderColor = UIColor.orangeColor.CGColor;
        [_cancelBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_cancelBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [_cancelBtn addTarget:self action:@selector(onCloseGameClick:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.backgroundColor = UIColor.whiteColor;
    }
    return  _cancelBtn;
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GamePreloadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GamePreloadCell" forIndexPath:indexPath];
    QSGameItemModel *model = self.dataList[indexPath.row];
    NSString *key = [NSString stringWithFormat:@"%@", @(model.gameId)];
    self.cellMap[key] = cell;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    GamePreloadCell *c = (GamePreloadCell *) cell;
    c.isShowTopLine = indexPath.row > 0;
    c.model = self.dataList[indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0) {
        c.isShowTopLine = true;
    }
    QSGameItemModel *model = self.dataList[indexPath.row];
    WeakSelf
    c.loadGameBlock = ^{
        /// 加载游戏
        weakSelf.gameId = model.gameId;
        weakSelf.roomID = @"10000";
        weakSelf.gameRoomID = @"10000";
        [weakSelf loginGame];
    };
    c.startDownloadBlock = ^{
        /// 开始下载
        [SudMGP preloadGamePkg:model.gameId listener:weakSelf];
    };
    c.cancelDownloadBlock = ^{
        /// 取消下载
        [SudMGP cancelPreloadGamePkg:model.gameId];
    };
    c.pauseDownloadBlock = ^{
        /// 暂停下载
        [SudMGP pausePreloadGamePkg:model.gameId];
    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

-(void) onPreloadSuccess:(int64_t) mgId {
    DDLogDebug(@"onPreloadSuccess mgId:%@", @(mgId));
}

-(void) onPreloadFailure:(int64_t) mgId errCode:(int) errCode errMsg:(NSString *) errMsg {
    DDLogDebug(@"onPreloadFailure mgId:%@, error:%@(%@)", @(mgId), errMsg, @(errCode));
}

-(void) onPreloadStatus:(int64_t) mgId downloadedSize:(long) downloadedSize totalSize:(long) totalSize status:(PkgPreloadStatus) status {
    DDLogDebug(@"onPreloadStatus mgId:%@, downloadedSize:%@, totalSize:(%@)", @(mgId), @(downloadedSize), @(totalSize));
    NSString *key = [NSString stringWithFormat:@"%@", @(mgId)];
    GamePreloadCell *cell = self.cellMap[key];
    if (cell) {
        [cell updateDownloadedSize:downloadedSize totalSize:totalSize];
    }
}

@end
