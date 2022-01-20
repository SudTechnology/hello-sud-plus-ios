//
//  HSGameListViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "HSGameListViewController.h"
#import "HSGameListNaviView.h"
#import "HSGameListHeaderView.h"
#import "HSGameListTableViewCell.h"

@interface HSGameListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) HSGameListNaviView *naviView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation HSGameListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主页";
    // Do any additional setup after loading the view.
}

- (void)hsAddViews {
    self.dataList = @[@(1), @(1), @(1)];
    [self.view addSubview:self.naviView];
    [self.view addSubview:self.tableView];
}

- (void)hsLayoutViews {
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(44 + kStatusBarHeight);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.mas_equalTo(self.naviView.mas_bottom);
    }];
}

#pragma mark - UITableViewDelegate || UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSGameListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSGameListTableViewCell"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataList.count == 0) {
        return  [UIView new];
    }
    UIView *sectionNode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"房间列表";
    titleLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A" alpha:1];
    titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    [sectionNode addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(sectionNode);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    return sectionNode;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.dataList.count == 0 ? 0 : 52;
}

#pragma mark - get
- (HSGameListNaviView *)naviView {
    if (!_naviView) {
        _naviView = [[HSGameListNaviView alloc] init];
    }
    return _naviView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 90;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F6FB" alpha:1];
        [_tableView registerClass:[HSGameListTableViewCell class] forCellReuseIdentifier:@"HSGameListTableViewCell"];
        _tableView.tableHeaderView = [[HSGameListHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 540)];
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
