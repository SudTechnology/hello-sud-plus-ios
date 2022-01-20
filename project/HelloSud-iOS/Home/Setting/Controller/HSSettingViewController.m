//
//  HSSettingViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/20.
//

#import "HSSettingViewController.h"
#import "HSSettingCell.h"
#import "HSSettingModel.h"
#import "HSSetingHeadView.h"

@interface HSSettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;

/// 页面数据
@property(nonatomic, strong)NSArray<NSArray<HSSettingModel*> *> *arrData;
@end

@implementation HSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    // Do any additional setup after loading the view.
    [self configData];
}


/// 配置页面数据
- (void)configData {
    HSSettingModel *sdkModel = [HSSettingModel new];
    sdkModel.title = @"SDK版本号";
    sdkModel.subTitle = @"v1.0.0";
    sdkModel.isMore = NO;
    sdkModel.pageURL = @"";
    
    HSSettingModel *appModel = [HSSettingModel new];
    appModel.title = @"App版本号";
    appModel.subTitle = @"v1.0.0";
    appModel.isMore = NO;
    appModel.pageURL = @"";
    
    HSSettingModel *userProtocolModel = [HSSettingModel new];
    userProtocolModel.title = @"用户协议";
    userProtocolModel.isMore = YES;
    userProtocolModel.pageURL = @"https://www.baidu.com";
    
    HSSettingModel *privacyModel = [HSSettingModel new];
    privacyModel.title = @"隐私政策";
    privacyModel.isMore = YES;
    privacyModel.pageURL = @"https://www.baidu.com";
    self.arrData = @[@[sdkModel, appModel], @[userProtocolModel, privacyModel]];
    [self.tableView reloadData];
}

- (void)hsAddViews {
    [super hsAddViews];
    self.view.backgroundColor = HEX_COLOR(@"#F5F6FB");
    [self.view addSubview:self.tableView];
    
}

- (void)hsLayoutViews {
    [super hsLayoutViews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(20, 16, 0, 16));
    }];
}

#pragma makr lazy
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView registerClass:[HSSettingCell class] forCellReuseIdentifier:@"HSSettingCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEX_COLOR(@"#F5F6FB");
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        HSSetingHeadView *header = HSSetingHeadView.new;
        header.frame = CGRectMake(0, 0, kScreenWidth, 104);
        _tableView.tableHeaderView = header;
    }
    return _tableView;
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSSettingCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    HSSettingCell *c = (HSSettingCell *)cell;
    c.isShowTopLine = indexPath.row > 0;
    c.model = self.arrData[indexPath.section][indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HSSettingModel *model = self.arrData[indexPath.section][indexPath.row];
    if (model.isMore) {
        HSWebViewController *web = HSWebViewController.new;
        web.url = model.pageURL;
        [self.navigationController pushViewController:web animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    HSSettingModel *model = self.arrData[indexPath.section][indexPath.row];
    return model.isMore;
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
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return UIView.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return UIView.new;
}

@end
