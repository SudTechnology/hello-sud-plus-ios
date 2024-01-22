//
//  GameListViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "GameListViewController.h"
#import "SearchHeaderView.h"
#import "../View/RoomListContentView.h"
#import "../View/CrossAppRoomListContentView.h"

@interface GameListViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) SearchHeaderView *searchHeaderView;
@property(nonatomic, strong) JXCategoryTitleView *titleCategoryView;
@property(nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property(nonatomic, strong) NSArray<NSString *> *titles;
@property(nonatomic, assign) NSInteger titleIndex;
@end

@implementation GameListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (BOOL)dtIsHiddenNavigationBar {
    return YES;
}

- (void)dtConfigUI {
    self.view.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
    self.titleCategoryView.listContainer = self.listContainerView;
}


- (void)dtAddViews {
    [self.view addSubview:self.searchHeaderView];
    [self.view addSubview:self.titleCategoryView];
    [self.view addSubview:self.listContainerView];
}

- (void)dtLayoutViews {
    [self.searchHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.titleCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchHeaderView.mas_bottom);
        make.centerX.equalTo(self.view);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@44);
    }];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleCategoryView.mas_bottom).offset(0);
        make.leading.trailing.bottom.equalTo(@0);
    }];
}


#pragma mark - lazy


- (SearchHeaderView *)searchHeaderView {
    if (!_searchHeaderView) {
        _searchHeaderView = [[SearchHeaderView alloc] init];
    }
    return _searchHeaderView;
}


- (JXCategoryTitleView *)titleCategoryView {
    if (!_titleCategoryView) {
        self.titles = @[@"房间列表", @"跨域连接"];
        _titleCategoryView = [[JXCategoryTitleView alloc] init];
        _titleCategoryView.delegate = self;
        _titleCategoryView.titleColor = HEX_COLOR_A(@"#666666", 1);
        _titleCategoryView.titleSelectedColor = HEX_COLOR(@"#1A1A1A");
        _titleCategoryView.titleFont = UIFONT_REGULAR(18);
        _titleCategoryView.titleSelectedFont = UIFONT_MEDIUM(18);
        _titleCategoryView.titles = self.titles;
        _titleCategoryView.backgroundColor = UIColor.whiteColor;


        JXCategoryIndicatorLineView *lineIndicator = [[JXCategoryIndicatorLineView alloc] init];
        // 设置指示器固定宽度
        lineIndicator.indicatorColor = HEX_COLOR(@"#000000");
        lineIndicator.indicatorWidth = 18;
        lineIndicator.indicatorHeight = 4;
        _titleCategoryView.indicators = @[lineIndicator];

    }
    return _titleCategoryView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        // 列表容器视图
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _listContainerView;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {

}

#pragma mark - JXCategoryListContainerViewDelegate

// 返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

// 返回各个列表菜单下的实例，该实例需要遵守并实现 <JXCategoryListContentViewDelegate> 协议
- (id <JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    switch (index){
        case 0:{
            RoomListContentView *listView = [[RoomListContentView alloc] init];
            return listView;
        }
        break;
        default:{
            CrossAppRoomListContentView *listView = [[CrossAppRoomListContentView alloc] init];
            return listView;
        }
    }
}
@end
