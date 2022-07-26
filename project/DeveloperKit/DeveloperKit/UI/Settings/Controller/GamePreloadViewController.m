//
//  GamePreloadViewController.m
//  DeveloperKit
//
//  Created by kaniel on 2022/7/26.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GamePreloadViewController.h"
#import "GamePreloadCell.h"

@interface GamePreloadViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NSArray <QSGameItemModel *> *dataList;
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation GamePreloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"预加载";
}

- (void)dtAddViews {
    [super dtAddViews];
    self.view.backgroundColor = HEX_COLOR(@"#F5F6FB");
    [self.view addSubview:self.tableView];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    [self loadGameList];
}

/// 加载游戏列表
- (void)loadGameList {

    //TODO: 开发者由SudMGP提供的游戏列表
    NSArray *arrGame = [QSAppPreferences.shared readGameList];
    self.dataList = arrGame;
}

#pragma makr lazy

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView registerClass:[GamePreloadCell class] forCellReuseIdentifier:@"GamePreloadCell"];
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
    GamePreloadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GamePreloadCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    GamePreloadCell *c = (GamePreloadCell *) cell;
    c.isShowTopLine = indexPath.row > 0;
    c.model = self.dataList[indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0) {
        c.isShowTopLine = true;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

@end
