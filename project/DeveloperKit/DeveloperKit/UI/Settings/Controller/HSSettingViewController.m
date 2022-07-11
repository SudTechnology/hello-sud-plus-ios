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
#import "VersionInfoViewController.h"
#import "SwitchLanguageViewController.h"
#import "MoreSettingViewController.h"
#import "SwitchAppIdViewController.h"

#define AppIdTitleName @"切换应用"

@interface HSSettingViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *contactUsView;
/// 页面数据
@property(nonatomic, strong) NSArray <NSArray <HSSettingModel *> *> *arrData;
/// 是否展示更多设置
@property(nonatomic, assign) BOOL showMoreSetting;
@end

@implementation HSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSString.dt_tab_setting;
    self.navigationItem.leftBarButtonItem = nil;
    // Do any additional setup after loading the view.
    [self configData];
}


/// 配置页面数据
- (void)configData {
    //    HSSettingModel *verModel = [HSSettingModel new];
    //    verModel.title = NSString.dt_settings_version_info;
    //    verModel.isMore = YES;
    //    verModel.pageURL = @"";
    //
    //    HSSettingModel *rtcModel = [HSSettingModel new];
    //    rtcModel.title = NSString.dt_settings_more_set;
    //    rtcModel.isMore = YES;
    //    rtcModel.pageURL = @"";
    
    HSSettingModel *languageModel = [HSSettingModel new];
    languageModel.title = NSString.dt_settings_switch_language;
    languageModel.isMore = YES;
    languageModel.pageURL = @"";
    
    HSSettingModel *appIdModel = [HSSettingModel new];
    appIdModel.title = AppIdTitleName;
    appIdModel.isMore = YES;
    appIdModel.pageURL = @"";
    
    
    //    HSSettingModel *gitHubModel = [HSSettingModel new];
    //    gitHubModel.title = @"GitHub";
    //    gitHubModel.subTitle = @"hello-sud";
    //    gitHubModel.isMore = YES;
    //    gitHubModel.pageURL = @"https://github.com/SudTechnology/hello-sud-ios";
    //    HSSettingModel *oProtocolModel = [HSSettingModel new];
    //    oProtocolModel.title = NSString.dt_settings_open_source;
    //    oProtocolModel.isMore = YES;
    //    oProtocolModel.pageURL = [SettingsService appLicenseURL].absoluteString;
    //    HSSettingModel *userProtocolModel = [HSSettingModel new];
    //    userProtocolModel.title = NSString.dt_settings_user_agreement;
    //    userProtocolModel.isMore = YES;
    //    userProtocolModel.pageURL = [SettingsService appProtocolURL].absoluteString;
    //    HSSettingModel *privacyModel = [HSSettingModel new];
    //    privacyModel.title = NSString.dt_settings_privacy_policy;
    //    privacyModel.isMore = YES;
    //    privacyModel.pageURL = [SettingsService appPrivacyURL].absoluteString;
    
    //    if (self.showMoreSetting) {
    //        self.arrData = @[@[verModel], @[languageModel, rtcModel], @[gitHubModel, oProtocolModel, userProtocolModel, privacyModel]];
    //    } else {
    //        self.arrData = @[@[verModel], @[languageModel], @[gitHubModel, oProtocolModel, userProtocolModel, privacyModel]];
    //    }
    self.arrData = @[@[languageModel, appIdModel]];
    
    WeakSelf
    HSSetingHeadView *header = HSSetingHeadView.new;
    header.tapCallback = ^{
        weakSelf.showMoreSetting = YES;
        [weakSelf configData];
    };
    header.frame = CGRectMake(0, 0, kScreenWidth, 217);
    [header dtUpdateUI];
    self.tableView.tableHeaderView = header;
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(0);
        make.height.mas_equalTo(217);
        make.width.mas_equalTo(kScreenWidth - 32);
    }];
    CGSize size = [self.contactUsView systemLayoutSizeFittingSize:CGSizeMake(kScreenWidth, 10000)];
    CGRect targetFrame = CGRectMake(0, 0, kScreenWidth, size.height);
    self.contactUsView.frame = targetFrame;
    self.tableView.tableFooterView = self.contactUsView;
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
        [_tableView registerClass:[HSSettingCell class] forCellReuseIdentifier:@"HSSettingCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEX_COLOR(@"#F5F6FB");
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        
        
    }
    return _tableView;
}

- (UIView *)contactUsView {
    if (_contactUsView == nil) {
        _contactUsView = UIView.new;
        UILabel *usLabel = UILabel.new;
        usLabel.numberOfLines = 0;
        usLabel.text = NSString.dt_settings_contact_us;
        usLabel.textColor = HEX_COLOR(@"#8A8A8E");
        usLabel.font = UIFONT_REGULAR(12);
        usLabel.textAlignment = NSTextAlignmentCenter;
        usLabel.numberOfLines = 0;
        [_contactUsView addSubview:usLabel];
        usLabel.preferredMaxLayoutWidth = kScreenWidth - 34;
        [usLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(17);
            make.top.mas_equalTo(0);
            make.width.height.mas_greaterThanOrEqualTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _contactUsView;
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSSettingCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    HSSettingCell *c = (HSSettingCell *) cell;
    c.isShowTopLine = indexPath.row > 0;
    c.model = self.arrData[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0) {
        c.isShowTopLine = true;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HSSettingModel *model = self.arrData[indexPath.section][indexPath.row];
    if ([model.title isEqualToString:NSString.dt_settings_version_info]) {
        VersionInfoViewController *vc = VersionInfoViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.title isEqualToString:NSString.dt_settings_more_set]) {
        MoreSettingViewController *vc = MoreSettingViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.title isEqualToString:NSString.dt_settings_switch_language]) {
        SwitchLanguageViewController *vc = SwitchLanguageViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.title isEqualToString:@"GitHub"]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.pageURL] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.pageURL]];
        }
    } else if ([model.title isEqualToString:AppIdTitleName]){
        // 切换应用
        SwitchAppIdViewController *vc = SwitchAppIdViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
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
