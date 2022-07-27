//
//  HSSettingViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/20.
//

#import "MyViewController.h"
#import "MyCell.h"
#import "HSSettingModel.h"
#import "ChangeRTCViewController.h"
#import "MyHeaderView.h"
#import "HSSettingViewController.h"
#import "AboutViewController.h"

@interface MyViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
/// 页面数据
@property(nonatomic, strong) NSArray <NSArray <HSSettingModel *> *> *arrData;
@property(nonatomic, strong) MyHeaderView *myHeaderView;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configData];
}

- (BOOL)dtIsHiddenNavigationBar {
    return YES;
}

/// 配置页面数据
- (void)configData {

    HSSettingModel *settingModel = [HSSettingModel new];
    settingModel.title = @"设置";
    settingModel.subTitle = nil;
    settingModel.isMore = YES;
    settingModel.pageURL = @"";

    HSSettingModel *aboutModel = [HSSettingModel new];
    aboutModel.title = @"关于我们";
    aboutModel.subTitle = nil;
    aboutModel.isMore = YES;
    aboutModel.pageURL = @"";

    self.arrData = @[@[settingModel], @[aboutModel]];
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

    CGSize size = [self.myHeaderView systemLayoutSizeFittingSize:CGSizeMake(kScreenWidth, 10000)];
    CGRect targetFrame = CGRectMake(0, 0, kScreenWidth, size.height);
    self.myHeaderView.frame = targetFrame;
    self.tableView.tableHeaderView = self.myHeaderView;
}

#pragma makr lazy

- (MyHeaderView *)myHeaderView {
    if (!_myHeaderView) {
        _myHeaderView = [[MyHeaderView alloc] init];
        _myHeaderView.backgroundColor = HEX_COLOR(@"#F5F6FB");
    }
    return _myHeaderView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView registerClass:[MyCell class] forCellReuseIdentifier:@"MyCell"];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCell *c = (MyCell *) cell;
    c.isShowTopLine = indexPath.row > 0;
    c.model = self.arrData[indexPath.section][indexPath.row];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HSSettingModel *model = self.arrData[indexPath.section][indexPath.row];
    if ([model.title isEqualToString:@"设置"]) {
        HSSettingViewController *vc = HSSettingViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.title isEqualToString:@"关于我们"]) {
        AboutViewController *vc = AboutViewController.new;
        vc.title = model.title;
        [self.navigationController pushViewController:vc animated:YES];
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
