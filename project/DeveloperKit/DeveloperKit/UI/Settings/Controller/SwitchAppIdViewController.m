//
//  SwitchAppIdViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/23.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SwitchAppIdViewController.h"
#import "MainTabBarController.h"
#import "SwitchAppIdTableViewCell.h"
#import "SwitchLangModel.h"
#import "SuspendRoomView.h"

@interface SwitchAppIdViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIView *contactUsView;
/// 页面数据
@property(nonatomic, strong)NSArray <AppIDInfoModel *>*arrData;
@end

@implementation SwitchAppIdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSString.dt_settings_switch_language;
    [self loadData];
}


/// 配置页面数据
- (void)loadData {
    WeakSelf
    if (AppService.shared.appIdList.count > 0) {
        [self handleData:AppService.shared.appIdList];
    } else {
        [SettingsService reqAppIdListWithSuccess:^(NSArray<AppIDInfoModel *> *appIdList) {
            [weakSelf handleData:appIdList];
        } fail:nil];
    }


//    NSArray <SwitchLangModel *>*dataArray = [SettingsService getLanguageArr];
//
//    BOOL isNotSupportLanguage = [SettingsService isNotSupportLanguage];
//    if (LanguageUtil.userLanguage.length > 0) {
//        NSString *str = [[NSBundle currentLanguage] languageCountryCode];
//        for (NSInteger i = 0; i < dataArray.count; i++) {
//            SwitchLangModel *model = dataArray[i];
//            if (isNotSupportLanguage) {
//                model.isSelect = i == 0;
//            } else {
//                model.isSelect = [model.language isEqualToString:str];
//            }
//        }
//    }

}

- (void)handleData:(NSArray<AppIDInfoModel *> *)appIdList {
    self.arrData = appIdList;
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
        [_tableView registerClass:[SwitchAppIdTableViewCell class] forCellReuseIdentifier:@"SwitchAppIdTableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEX_COLOR(@"#F5F6FB");
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        
    }
    return _tableView;
}

- (void)changeLanguage:(NSIndexPath *)indexPath {
    AppIDInfoModel *model = self.arrData[indexPath.row];
    if (model.isSelect) {
        return;
    }
    for (AppIDInfoModel *model in self.arrData) {
        model.isSelect = NO;
    }
    model.isSelect = !model.isSelect;
    [self.tableView reloadData];

}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchAppIdTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SwitchAppIdTableViewCell *c = (SwitchAppIdTableViewCell *)cell;
    c.model = self.arrData[indexPath.row];
    c.isShowTopLine = indexPath.row > 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [SuspendRoomView exitRoom:^{
        [self changeLanguage:indexPath];
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
