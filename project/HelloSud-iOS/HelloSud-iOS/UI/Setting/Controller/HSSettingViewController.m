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
@property(nonatomic, strong)NSArray <HSSettingModel *> *arrData;
@end

@implementation HSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.navigationItem.leftBarButtonItem = nil;
    // Do any additional setup after loading the view.
    [self configData];
}


/// 配置页面数据
- (void)configData {
    HSSettingModel *sdkModel = [HSSettingModel new];
    sdkModel.title = @"SDK版本号";
    sdkModel.subTitle = [NSString stringWithFormat:@"v%@",GameSudManager.sudSDKVersion];
    sdkModel.isMore = NO;
    sdkModel.pageURL = @"";
    
    HSSettingModel *appModel = [HSSettingModel new];
    appModel.title = @"App版本号";
    appModel.subTitle = [NSString stringWithFormat:@"v%@.%@", DeviceUtil.getAppVersion, DeviceUtil.getAppBuildCode];
    appModel.isMore = NO;
    appModel.pageURL = @"";
    
    HSSettingModel *userProtocolModel = [HSSettingModel new];
    userProtocolModel.title = @"用户协议";
    userProtocolModel.isMore = YES;
    userProtocolModel.pageURL = AppManager.shared.appProtocolURL.absoluteString;
    
    HSSettingModel *privacyModel = [HSSettingModel new];
    privacyModel.title = @"隐私政策";
    privacyModel.isMore = YES;
    privacyModel.pageURL = AppManager.shared.appPrivacyURL.absoluteString;
    
    HSSettingModel *contactModel = [HSSettingModel new];
    contactModel.title = @"联系我们";
    contactModel.isMore = YES;
    contactModel.pageURL = @"";
    
    self.arrData = @[sdkModel, appModel, userProtocolModel, privacyModel, contactModel];
    HSSetingHeadView *header = HSSetingHeadView.new;
    header.frame = CGRectMake(0, 0, kScreenWidth, 104);
    [header hsUpdateUI];
    self.tableView.tableHeaderView = header;
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
    c.model = self.arrData[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HSSettingModel *model = self.arrData[indexPath.row];
    if ([model.title isEqualToString:@"联系我们"]) {
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:@"如需了解更多资讯或反馈问题，可联系："];
        attrTitle.yy_lineSpacing = 8;
        attrTitle.yy_font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        attrTitle.yy_color = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
        attrTitle.yy_alignment = NSTextAlignmentCenter;
        
        NSMutableAttributedString *attrStr_0 = [[NSMutableAttributedString alloc] initWithString:@"help@sud.tech"];
        attrStr_0.yy_lineSpacing = 8;
        attrStr_0.yy_font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        attrStr_0.yy_color = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
        
        [attrTitle appendAttributedString:attrStr_0];
        
        [HSAlertView showAttrTextAlert:attrTitle sureText:@"好的" cancelText:@"" onSureCallback:^{
        } onCloseCallback:^{
        }];
    } else {
        if (model.isMore) {
            HSWebViewController *web = HSWebViewController.new;
            web.url = model.pageURL;
            [self.navigationController pushViewController:web animated:YES];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    HSSettingModel *model = self.arrData[indexPath.row];
    return model.isMore;
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
    return 0.01;
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
