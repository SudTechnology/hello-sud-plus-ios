//
//  VersionInfoViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/15.
//

#import "VersionInfoViewController.h"
#import "VersionInfoCell.h"
#import "VersionInfoModel.h"

@interface VersionInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray <VersionInfoModel *>*arrData;

@end

@implementation VersionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSString.dt_settings_version_info;
    [self configData];
}

/// 配置页面数据
- (void)configData {
    
    VersionInfoModel *m0 = [VersionInfoModel new];
    m0.title = @"HelloSud App";
    m0.subTitle = [NSString stringWithFormat:@"V%@.%@", [DeviceUtil getAppVersion], [DeviceUtil getAppBuildCode]];
    
    VersionInfoModel *m1 = [VersionInfoModel new];
    m1.title = @"SudMGP SDK";
    m1.subTitle = [NSString stringWithFormat:@"V%@", [SudGIP getVersion]];
    
//    VersionInfoModel *m2 = [VersionInfoModel new];
//    m2.title = @"Zego SDK";
//    m2.subTitle = @"V2.15.0";
//
//    VersionInfoModel *m3 = [VersionInfoModel new];
//    m3.title = @"Agora SDK";
//    m3.subTitle = @"V3.6.1.1";
    
    self.arrData = @[m0, m1];
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
        [_tableView registerClass:[VersionInfoCell class] forCellReuseIdentifier:@"VersionInfoCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEX_COLOR(@"#F5F6FB");
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VersionInfoCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    VersionInfoCell *c = (VersionInfoCell *)cell;
    c.isShowTopLine = indexPath.row > 0;
    c.model = self.arrData[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
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
    return 0;
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
