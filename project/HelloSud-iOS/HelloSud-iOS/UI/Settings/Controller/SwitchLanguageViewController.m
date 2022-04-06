//
//  SwitchLanguageViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/23.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SwitchLanguageViewController.h"
#import "MainTabBarController.h"
#import "SwitchLangTableViewCell.h"
#import "SwitchLangModel.h"

@interface SwitchLanguageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIView *contactUsView;
/// 页面数据
@property(nonatomic, strong)NSArray <SwitchLangModel *>*arrData;
@end

@implementation SwitchLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSString.dt_settings_switch_language;
    [self configData];
}


/// 配置页面数据
- (void)configData {
    SwitchLangModel *m_0 = [SwitchLangModel new];
    m_0.title = NSString.dt_follow_system;
    m_0.language = nil;
    m_0.isSelect = YES;
    
    SwitchLangModel *m_1 = [SwitchLangModel new];
    m_1.title = @"简体中文";
    m_1.language = @"zh-Hans";
    
    SwitchLangModel *m_2 = [SwitchLangModel new];
    m_2.title = @"繁體中文";
    m_2.language = @"zh-Hant";
    
    SwitchLangModel *m_3 = [SwitchLangModel new];
    m_3.title = @"English";
    m_3.language = @"en";
    
    SwitchLangModel *m_4 = [SwitchLangModel new];
    m_4.title = @"لغة عربية";
    m_4.language = @"ar";
    
    SwitchLangModel *m_5 = [SwitchLangModel new];
    m_5.title = @"Bahasa Indonesia";
    m_5.language = @"id";
    
    SwitchLangModel *m_6 = [SwitchLangModel new];
    m_6.title = @"Bahasa Melayu";
    m_6.language = @"ms";
    
    SwitchLangModel *m_7 = [SwitchLangModel new];
    m_7.title = @"ภาษาไทย";
    m_7.language = @"th";
    
    SwitchLangModel *m_8 = [SwitchLangModel new];
    m_8.title = @"Tiếng Việt";
    m_8.language = @"vi";
    
    SwitchLangModel *m_9 = [SwitchLangModel new];
    m_9.title = @"한국어";
    m_9.language = @"ko";
    
    SwitchLangModel *m_10 = [SwitchLangModel new];
    m_10.title = @"Español";
    m_10.language = @"es";
    
    SwitchLangModel *m_11 = [SwitchLangModel new];
    m_11.title = @"日本語";
    m_11.language = @"ja";
    
    
    NSArray <SwitchLangModel *>*dataArray = @[m_0, m_1, m_2, m_3, m_4, m_5, m_6, m_7, m_8, m_9, m_10, m_11];
    
    if (LanguageUtil.userLanguage.length > 0) {
        NSString *str = [NSBundle currentLanguage];
        for (NSInteger i = 0; i < dataArray.count; i++) {
            SwitchLangModel *model = dataArray[i];
            model.isSelect = [model.language isEqualToString:str];
        }
    }
    self.arrData = dataArray;
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
        [_tableView registerClass:[SwitchLangTableViewCell class] forCellReuseIdentifier:@"SwitchLangTableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEX_COLOR(@"#F5F6FB");
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        
    }
    return _tableView;
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchLangTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SwitchLangTableViewCell *c = (SwitchLangTableViewCell *)cell;
    c.model = self.arrData[indexPath.row];
    c.isShowTopLine = indexPath.row > 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SwitchLangModel *model = self.arrData[indexPath.row];
    if (model.isSelect) {
        return;
    }
    for (SwitchLangModel *model in self.arrData) {
        model.isSelect = NO;
    }
    model.isSelect = !model.isSelect;
    [tableView reloadData];
    
    LanguageUtil.userLanguage = model.language;
    
    //创建新的UITabbarController
    MainTabBarController *tabbar = [MainTabBarController new];
    //找到对应的nav
    tabbar.selectedIndex = 2;
    BaseNavigationViewController *nav = tabbar.selectedViewController;
    NSMutableArray *navVCs = nav.viewControllers.mutableCopy;
    
    //添加指定vc到nav栈中
    SwitchLanguageViewController *vc = [SwitchLanguageViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [navVCs addObject:vc];
    
    //主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].delegate.window.rootViewController = tabbar;
        nav.viewControllers = navVCs;
        NSLog(@"当前语言 %@", [NSBundle currentLanguage]);
    });
}

//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//    SwitchLangModel *model = self.arrData[indexPath.row];
//    return model.isMore;
//}

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
