//
//  SwitchAppIdViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/23.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SwitchGameEnvViewController.h"
#import "MainTabBarController.h"
#import "SwitchGameEnvTableViewCell.h"
#import "SuspendRoomView.h"
#import "SwitchGameEnvModel.h"

@interface SwitchGameEnvViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIView *contactUsView;
/// 页面数据
@property(nonatomic, strong)NSArray <SwitchGameEnvModel *>*arrData;
@end

@implementation SwitchGameEnvViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"切换游戏环境";
    [self loadData];
}


/// 配置页面数据
- (void)loadData {
    
    SwitchGameEnvModel *devModel = [SwitchGameEnvModel alloc];
    devModel.title = [AppService.shared gameEnvTypeName: GameEnvTypeDev];
    devModel.envType = GameEnvTypeDev;

    SwitchGameEnvModel *simModel = [SwitchGameEnvModel alloc];
    simModel.title = [AppService.shared gameEnvTypeName: GameEnvTypeSim];
    simModel.envType = GameEnvTypeSim;

    SwitchGameEnvModel *fatModel = [SwitchGameEnvModel alloc];
    fatModel.title = [AppService.shared gameEnvTypeName: GameEnvTypeFat];
    fatModel.envType = GameEnvTypeFat;

    SwitchGameEnvModel *proModel = [SwitchGameEnvModel alloc];
    proModel.title = [AppService.shared gameEnvTypeName: GameEnvTypePro];
    proModel.envType = GameEnvTypePro;
    NSArray *arr = @[devModel, simModel, fatModel, proModel];
    [self handleData:arr];
}

- (void)handleData:(NSArray<SwitchGameEnvModel *> *)list {
    
    GameEnvType currentGameEnvType = AppService.shared.gameEnvType;
    for (SwitchGameEnvModel *m in list) {
        if (m.envType == currentGameEnvType) {
            m.isSelect = YES;
            break;
        }
    }
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView registerClass:[SwitchGameEnvTableViewCell class] forCellReuseIdentifier:@"SwitchGameEnvTableViewCell"];
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
    SwitchGameEnvModel *model = self.arrData[indexPath.row];
    if (model.isSelect) {
        return;
    }
    for (SwitchGameEnvModel *model in self.arrData) {
        model.isSelect = NO;
    }
    model.isSelect = !model.isSelect;
    [AppService.shared updateGameEnvType:model.envType];
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchGameEnvTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SwitchGameEnvTableViewCell *c = (SwitchGameEnvTableViewCell *)cell;
    c.model = self.arrData[indexPath.row];
    c.isShowTopLine = indexPath.row > 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [SuspendRoomView exitRoom:^{
        [self changeSelectedModel:indexPath];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return UIView.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return UIView.new;
}

@end
