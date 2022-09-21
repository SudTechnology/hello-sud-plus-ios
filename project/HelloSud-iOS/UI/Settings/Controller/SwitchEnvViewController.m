//
//  SwitchAppIdViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/23.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SwitchEnvViewController.h"
#import "MainTabBarController.h"
#import "SwitchEnvTableViewCell.h"
#import "SuspendRoomView.h"
#import "SwitchEnvModel.h"

@interface SwitchEnvViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *contactUsView;
/// 页面数据
@property(nonatomic, strong) NSArray <NSArray <SwitchEnvModel *> *> *arrData;
@end

@implementation SwitchEnvViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"切换环境";
    [self loadData];
}


/// 配置页面数据
- (void)loadData {

    SwitchEnvModel *devModel = [SwitchEnvModel alloc];
    devModel.title = @"dev";
    devModel.envType = HsAppEnvTypeDev;

    SwitchEnvModel *simModel = [SwitchEnvModel alloc];
    simModel.title = @"sim";
    simModel.envType = HsAppEnvTypeSim;

    SwitchEnvModel *fatModel = [SwitchEnvModel alloc];
    fatModel.title = @"fat";
    fatModel.envType = HsAppEnvTypeFat;

    SwitchEnvModel *proModel = [SwitchEnvModel alloc];
    proModel.title = @"pro";
    proModel.envType = HsAppEnvTypePro;
    // 游戏
    SwitchEnvModel *gameDevModel = [SwitchEnvModel alloc];
    gameDevModel.title = @"dev";
    gameDevModel.envType = HsGameEnvTypeDev;

    SwitchEnvModel *gameSimModel = [SwitchEnvModel alloc];
    gameSimModel.title = @"sim";
    gameSimModel.envType = HsGameEnvTypeSim;

    SwitchEnvModel *gameFatModel = [SwitchEnvModel alloc];
    gameFatModel.title = @"fat";
    gameFatModel.envType = HsGameEnvTypeFat;

    SwitchEnvModel *gameProModel = [SwitchEnvModel alloc];
    gameProModel.title = @"pro";
    gameProModel.envType = HsGameEnvTypePro;
    // nft
    SwitchEnvModel *nftDevModel = [SwitchEnvModel alloc];
    nftDevModel.title = @"dev";
    nftDevModel.envType = HsNftEnvTypeDev;

    SwitchEnvModel *nftSimModel = [SwitchEnvModel alloc];
    nftSimModel.title = @"sim";
    nftSimModel.envType = HsNftEnvTypeSim;

    SwitchEnvModel *nftFatModel = [SwitchEnvModel alloc];
    nftFatModel.title = @"fat";
    nftFatModel.envType = HsNftEnvTypeFat;

    SwitchEnvModel *nftProModel = [SwitchEnvModel alloc];
    nftProModel.title = @"pro";
    nftProModel.envType = HsNftEnvTypePro;


    NSArray *appEnvArr = @[devModel, simModel, fatModel, proModel];
    NSArray *gameEnvArr = @[gameDevModel, gameSimModel, gameFatModel, gameProModel];
    NSArray *nftEnvArr = @[nftDevModel, nftSimModel, nftFatModel, nftProModel];
    [self handleData:@[appEnvArr, gameEnvArr, nftEnvArr]];
}

- (void)handleData:(NSArray<SwitchEnvModel *> *)list {
    self.arrData = list;
    [self.tableView reloadData];
}

- (void)dtAddViews {
    [super dtAddViews];
    self.view.backgroundColor = HEX_COLOR(@"#F5F6FB");
    [self.view addSubview:self.tableView];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(20, 16, 0, 16));
    }];
}

#pragma makr lazy

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView registerClass:[SwitchEnvTableViewCell class] forCellReuseIdentifier:@"SwitchEnvTableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEX_COLOR(@"#F5F6FB");
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;

    }
    return _tableView;
}

- (void)changeSelectedModel:(NSIndexPath *)indexPath {
    SwitchEnvModel *model = self.arrData[indexPath.section][indexPath.row];
    if (model.isSelect) {
        return;
    }
    switch (indexPath.section) {
        case 0:
            HsAppPreferences.shared.appEnvType = model.envType;
            break;
        case 1:
            HsAppPreferences.shared.gameEnvType = model.envType;
            break;
        case 2:
            HsAppPreferences.shared.nftEnvType = model.envType;
            break;
    }
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchEnvTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SwitchEnvTableViewCell *c = (SwitchEnvTableViewCell *) cell;
    SwitchEnvModel *model = self.arrData[indexPath.section][indexPath.row];
    switch (indexPath.section) {
        case 0:
            model.isSelect = model.envType == HsAppPreferences.shared.appEnvType;
            break;
        case 1:
            model.isSelect = model.envType == HsAppPreferences.shared.gameEnvType;
            break;
        case 2:
            model.isSelect = model.envType == HsAppPreferences.shared.nftEnvType;
            break;
    }
    c.model = model;
    c.isShowTopLine = indexPath.row > 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [SuspendRoomView exitRoom:^{
        [self changeSelectedModel:indexPath];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"App环境设置";
        case 1:
            return @"游戏环境设置";
        case 2:
            return @"NFT环境设置";
    }
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return UIView.new;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return UIView.new;
//}

@end
