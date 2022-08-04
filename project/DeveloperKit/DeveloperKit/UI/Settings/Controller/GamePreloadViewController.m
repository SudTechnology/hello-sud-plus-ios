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
#import <SudMGP/SudInitSDKParamModel.h>
#import <SudMGP/PkgDownloadStatus.h>

@interface GamePreloadViewController ()<UITableViewDelegate, UITableViewDataSource, ISudListenerPreloadMGPkg>
@property(nonatomic, strong) NSArray <QSGameItemModel *> *dataList;
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)UIButton *startBtn;
@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)UIButton *startAllGameBtn;
@property (nonatomic, strong)UIButton *cancelAllGameBtn;
@property(nonatomic, strong)NSMutableDictionary<NSString *, GamePreloadCell *> *cellMap;
@property(nonatomic, strong)NSMutableDictionary<NSString *, QSGameItemModel *> *modelMap;
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
    self.modelMap = [[NSMutableDictionary alloc]init];
    // Do any additional setup after loading the view.
    self.title = @"预加载";
    [self loadGameList];
    [self initSudMGP];
}

- (void)dtAddViews {
    [super dtAddViews];
    self.view.backgroundColor = HEX_COLOR(@"#F5F6FB");
    [self.view addSubview:self.startBtn];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.startAllGameBtn];
    [self.view addSubview:self.cancelAllGameBtn];
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
    [self.startAllGameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.top.equalTo(self.startBtn.mas_bottom).offset(5);
        make.height.equalTo(@44);
    }];
    [self.cancelAllGameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.startAllGameBtn.mas_trailing).offset(20);
        make.top.equalTo(self.startBtn.mas_bottom).offset(5);
        make.trailing.equalTo(@-16);
        make.width.height.equalTo(self.startBtn);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(@0);
        make.top.equalTo(self.startAllGameBtn.mas_bottom);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
}

- (void)initSudMGP {

    [self configGameEnv];
    NSString *appID = AppService.shared.currentAppIdModel.app_id; //AppService.shared.configModel.sudCfg.appId;
    NSString *appKey = AppService.shared.currentAppIdModel.app_key;//AppService.shared.configModel.sudCfg.appKey;
    if (appID.length == 0 || appKey.length == 0) {
        [ToastUtil show:@"Game appID or appKey is empty"];
        return;
    }
    SudInitSDKParamModel *model = [[SudInitSDKParamModel alloc]init];
    model.appId = appID;
    model.appKey = appKey;
    model.isTestEnv = NO;
    if (AppService.shared.gameEnvType != GameEnvTypePro) {
        model.isTestEnv = GAME_TEST_ENV;
    }
    [SudMGP initSDK:model listener:^(int retCode, const NSString * _Nonnull retMsg) {

        if (retCode == 0) {
            DDLogInfo(@"ISudFSMMG:initGameSDKWithAppID:初始化游戏SDK成功");
        } else {
            /// 初始化失败, 可根据业务重试
            DDLogError(@"ISudFSMMG:initGameSDKWithAppID:初始化sdk失败 :%@",retMsg);
        }
    }];
}

/// 加载游戏列表
- (void)loadGameList {

    //TODO: 开发者由SudMGP提供的游戏列表
    NSArray *arrGame = [QSAppPreferences.shared readGameList];
    self.dataList = arrGame;
    for (QSGameItemModel *m in self.dataList) {
        NSString *key = [NSString stringWithFormat:@"%@", @(m.gameId)];
        m.success = NO;
        m.errCode = 0;
        m.errMsg = nil;
        m.totalSize = 0;
        m.downloadedSize = 0;
        self.modelMap[key] = m;
    }
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

- (void)onStartAllBtnClick:(UIButton *)sender {
    // 下载所有游戏
    NSMutableArray<NSNumber *> *mgIdList = [NSMutableArray new];
    for (QSGameItemModel *m in self.dataList) {
        [mgIdList addObject:@(m.gameId)];
    }
    [SudMGP preloadMGPkgList:mgIdList listener:self];
    [ToastUtil show:@"已执行所有下载"];
}

- (void)onCancelAllBtnClick:(UIButton *)sender {
    // 取消所有游戏
    NSMutableArray<NSNumber *> *mgIdList = [NSMutableArray new];
    for (QSGameItemModel *m in self.dataList) {
        [mgIdList addObject:@(m.gameId)];
    }
    [SudMGP cancelPreloadMGPkgList:mgIdList];
    [ToastUtil show:@"已取消所有下载"];
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

- (UIButton *)startAllGameBtn {
    if (!_startAllGameBtn) {
        _startAllGameBtn = [[UIButton alloc]init];
        [_startAllGameBtn setTitle:@"下载所有" forState:UIControlStateNormal];
        [_startAllGameBtn setTitle:@"下载所有" forState:UIControlStateSelected];
        _startAllGameBtn.titleLabel.font = UIFONT_REGULAR(14);
        _startAllGameBtn.layer.borderWidth = 2;
        _startAllGameBtn.layer.borderColor = UIColor.orangeColor.CGColor;
        [_startAllGameBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_startAllGameBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [_startAllGameBtn addTarget:self action:@selector(onStartAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _startAllGameBtn.backgroundColor = UIColor.whiteColor;
    }
    return  _startAllGameBtn;
}

- (UIButton *)cancelAllGameBtn {
    if (!_cancelAllGameBtn) {
        _cancelAllGameBtn = [[UIButton alloc]init];
        [_cancelAllGameBtn setTitle:@"取消所有" forState:UIControlStateNormal];
        _cancelAllGameBtn.titleLabel.font = UIFONT_REGULAR(14);
        _cancelAllGameBtn.layer.borderWidth = 2;
        _cancelAllGameBtn.layer.borderColor = UIColor.orangeColor.CGColor;
        [_cancelAllGameBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_cancelAllGameBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [_cancelAllGameBtn addTarget:self action:@selector(onCancelAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _cancelAllGameBtn.backgroundColor = UIColor.whiteColor;
    }
    return  _cancelAllGameBtn;
}


#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GamePreloadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GamePreloadCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    GamePreloadCell *c = (GamePreloadCell *) cell;
    c.isShowTopLine = indexPath.row > 0;
    QSGameItemModel *model = self.dataList[indexPath.row];
    NSString *key = [NSString stringWithFormat:@"%@", @(model.gameId)];
    c.model = self.dataList[indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0) {
        c.isShowTopLine = true;
    }
    self.cellMap[key] = cell;
    NSMutableArray<NSNumber *> *mgIdList = [NSMutableArray new];
    [mgIdList addObject:[NSNumber numberWithLongLong:model.gameId]];
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
        [SudMGP preloadMGPkgList:mgIdList listener:weakSelf];
    };
    c.cancelDownloadBlock = ^{
        /// 取消下载
        [SudMGP cancelPreloadMGPkgList:mgIdList];
    };
    c.pauseDownloadBlock = ^{
        /// 暂停下载
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
    NSString *key = [NSString stringWithFormat:@"%@", @(mgId)];
    GamePreloadCell *cell = self.cellMap[key];
    QSGameItemModel *model = self.modelMap[key];
    if (model) {
        model.success = YES;
        model.errCode = 0;
        model.errMsg = nil;
    }
    if (cell) {
        [cell dtUpdateUI];
    }
}

-(void) onPreloadFailure:(int64_t) mgId errCode:(int) errCode errMsg:(NSString *) errMsg {
    DDLogDebug(@"onPreloadFailure mgId:%@, error:%@(%@)", @(mgId), errMsg, @(errCode));
    NSString *key = [NSString stringWithFormat:@"%@", @(mgId)];
    QSGameItemModel *model = self.modelMap[key];
    if (model) {
        model.success = NO;
        model.errCode = errCode;
        model.errMsg = errMsg;
    }
    GamePreloadCell *cell = self.cellMap[key];
    if (cell) {
        [cell dtUpdateUI];
    }
}

-(void) onPreloadStatus:(int64_t) mgId downloadedSize:(long) downloadedSize totalSize:(long) totalSize status:(PkgDownloadStatus) status {
    DDLogDebug(@"onPreloadStatus mgId:%@, downloadedSize:%@, totalSize:(%@)", @(mgId), @(downloadedSize), @(totalSize));
    NSString *key = [NSString stringWithFormat:@"%@", @(mgId)];
    QSGameItemModel *model = self.modelMap[key];
    if (PKG_DOWNLOAD_STARTED == status) {
        model.success = NO;
        model.errCode = 0;
        model.errMsg = nil;
        model.totalSize = totalSize;
        model.downloadedSize = downloadedSize;
    } else if (PKG_DOWNLOAD_DOWNLOADING == status) {

        if (model) {
            model.success = NO;
            model.downloadedSize = downloadedSize;
            model.totalSize = totalSize;
        }
        GamePreloadCell *cell = self.cellMap[key];
        if (cell) {
            [cell dtUpdateUI];
        }
    }
}

@end
