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
#import "ChangeRTCViewController.h"
#import "VersionInfoViewController.h"
#import "MoreSettingViewController.h"

@interface HSSettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIView *contactUsView;
/// 页面数据
@property(nonatomic, strong)NSArray <NSArray <HSSettingModel *>*>*arrData;
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
    HSSettingModel *verModel = [HSSettingModel new];
    verModel.title = @"版本信息";
    verModel.isMore = YES;
    verModel.pageURL = @"";
    
    HSSettingModel *rtcModel = [HSSettingModel new];
    rtcModel.title = @"更多设置";
    rtcModel.isMore = YES;
    rtcModel.pageURL = @"";
    HSSettingModel *languageModel = [HSSettingModel new];
    languageModel.title = @"切换语言";
    languageModel.isMore = YES;
    languageModel.pageURL = @"";
    
    
    HSSettingModel *gitHubModel = [HSSettingModel new];
    gitHubModel.title = @"GitHub";
    gitHubModel.subTitle = @"hello-sud";
    gitHubModel.isMore = YES;
    gitHubModel.pageURL = @"https://github.com/SudTechnology/hello-sud-ios";
    HSSettingModel *oProtocolModel = [HSSettingModel new];
    oProtocolModel.title = @"开源协议";
    oProtocolModel.isMore = YES;
    oProtocolModel.pageURL = [SettingsService appLicenseURL].absoluteString;
    HSSettingModel *userProtocolModel = [HSSettingModel new];
    userProtocolModel.title = @"用户协议";
    userProtocolModel.isMore = YES;
    userProtocolModel.pageURL = [SettingsService appProtocolURL].absoluteString;
    HSSettingModel *privacyModel = [HSSettingModel new];
    privacyModel.title = @"隐私政策";
    privacyModel.isMore = YES;
    privacyModel.pageURL = [SettingsService appPrivacyURL].absoluteString;
    
    self.arrData = @[@[verModel], @[rtcModel, languageModel], @[gitHubModel, oProtocolModel, userProtocolModel, privacyModel]];
    
    HSSetingHeadView *header = HSSetingHeadView.new;
    header.frame = CGRectMake(0, 0, kScreenWidth, 247);
    [header dtUpdateUI];
    self.tableView.tableHeaderView = header;
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
        [_tableView registerClass:[HSSettingCell class] forCellReuseIdentifier:@"HSSettingCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEX_COLOR(@"#F5F6FB");
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = self.contactUsView;
        
    }
    return _tableView;
}

- (UIView *)contactUsView {
    if (_contactUsView == nil) {
        _contactUsView = UIView.new;
        _contactUsView.frame = CGRectMake(0, 0, kScreenWidth, 50);
        UILabel *usLabel = UILabel.new;
        usLabel.numberOfLines = 0;
        usLabel.text = @"如需要了解更多资讯或反馈问题，可通过邮箱联系我们：\nhelp@sud.tech";
        usLabel.textColor = HEX_COLOR(@"#8A8A8E");
        usLabel.font = UIFONT_REGULAR(12);
        usLabel.textAlignment = NSTextAlignmentCenter;
        usLabel.frame = CGRectMake(17, 0, kScreenWidth-34, 34);
        [_contactUsView addSubview:usLabel];
    }
    return _contactUsView;
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        c.isShowTopLine = true;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HSSettingModel *model = self.arrData[indexPath.section][indexPath.row];
    if ([model.title isEqualToString:@"版本信息"]) {
        VersionInfoViewController *vc = VersionInfoViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.title isEqualToString:@"更多设置"]) {
        MoreSettingViewController *vc = MoreSettingViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.title isEqualToString:@"切换语言"]) {
        [ToastUtil show:@"正在制作中, 敬请期待!"];
    } else if ([model.title isEqualToString:@"GitHub"]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.pageURL] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.pageURL]];
        }
    } else {
        if (model.isMore) {
            DTWebViewController *web = DTWebViewController.new;
            web.url = model.pageURL;
            [self.navigationController pushViewController:web animated:YES];
        }
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
