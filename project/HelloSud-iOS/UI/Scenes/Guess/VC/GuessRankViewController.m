//
//  GuessRankViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/8.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GuessRankViewController.h"
#import "GuessRankContentView.h"

@interface GuessRankViewController () <JXCategoryViewDelegate>
@property(nonatomic, strong) BaseView *bgView;
@property(nonatomic, strong) JXCategoryTitleView *titleCategoryView;
@property(nonatomic, strong) JXCategoryTitleView *subTitleCategoryView;
@property(nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property(nonatomic, strong) NSArray<NSString *> *subTitles;
@property(nonatomic, assign) NSInteger titleIndex;
@property(nonatomic, strong) UIButton *backBtn;
@property(nonatomic, strong) NSMutableDictionary *dicSelected;
@end

@implementation GuessRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dicSelected = [[NSMutableDictionary alloc]init];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)dtIsHiddenNavigationBar {
    return YES;
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.titleCategoryView];
    [self.view addSubview:self.subTitleCategoryView];
    [self.view addSubview:self.listContainerView];
    [self.view addSubview:self.backBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@375);
    }];
    [self.titleCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kAppSafeTop));
        make.height.equalTo(@36);
        make.width.greaterThanOrEqualTo(@152);
        make.centerX.equalTo(self.view);
    }];
    [self.subTitleCategoryView dt_cornerRadius:10];
    [self.subTitleCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleCategoryView.mas_bottom).offset(10);
        make.height.equalTo(@20);
        make.width.equalTo(@116);
        make.centerX.equalTo(self.view);
    }];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleCategoryView.mas_bottom).offset(0);
        make.leading.trailing.bottom.equalTo(@0);
    }];

    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@24);
        make.leading.equalTo(@16);
        make.centerY.equalTo(self.titleCategoryView);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.view.backgroundColor = UIColor.whiteColor;
    self.subTitleCategoryView.listContainer = self.listContainerView;
}


- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.tintColor = UIColor.whiteColor;
        [_backBtn setImage:[[UIImage imageNamed:@"navi_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(dtNavigationBackClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (BaseView *)bgView {
    if (!_bgView) {
        _bgView = [[BaseView alloc] init];
        [_bgView dtAddGradientLayer:@[@0, @1] colors:@[(id) HEX_COLOR(@"#000000").CGColor, (id) HEX_COLOR(@"#63401E").CGColor] startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1) cornerRadius:0];
    }
    return _bgView;
}

- (JXCategoryTitleView *)titleCategoryView {
    if (!_titleCategoryView) {
        _titleCategoryView = [[JXCategoryTitleView alloc] init];
        _titleCategoryView.delegate = self;
        _titleCategoryView.titleColor = HEX_COLOR_A(@"#ffffff", 0.7);
        _titleCategoryView.titleSelectedColor = HEX_COLOR(@"#ffffff");
        _titleCategoryView.titleFont = UIFONT_REGULAR(18);
        _titleCategoryView.titleSelectedFont = UIFONT_BOLD(18);
        _titleCategoryView.titles = @[@"竞猜王", @"大神榜"];
        _titleCategoryView.contentEdgeInsetLeft = 0;
        _titleCategoryView.contentEdgeInsetRight = 0;

        JXCategoryIndicatorLineView *lineIndicator = [[JXCategoryIndicatorLineView alloc] init];
        // 设置指示器固定宽度
        lineIndicator.indicatorColor = HEX_COLOR(@"#ffffff");
        lineIndicator.indicatorWidth = 20;
        lineIndicator.indicatorHeight = 2;
        _titleCategoryView.indicators = @[lineIndicator];

    }
    return _titleCategoryView;
}

- (JXCategoryTitleView *)subTitleCategoryView {
    if (!_subTitleCategoryView) {
        _subTitleCategoryView = [[JXCategoryTitleView alloc] init];
        _subTitleCategoryView.delegate = self;
        _subTitleCategoryView.titleColor = HEX_COLOR_A(@"#ffffff", 0.8);
        _subTitleCategoryView.titleSelectedColor = HEX_COLOR(@"#3F3228");
        _subTitleCategoryView.titleFont = UIFONT_REGULAR(12);
        _subTitleCategoryView.titleSelectedFont = UIFONT_MEDIUM(12);
        _subTitleCategoryView.titles = @[@"日榜", @"周榜"];
        _subTitleCategoryView.backgroundColor = HEX_COLOR_A(@"#C0A48F", 0.3);
        _subTitleCategoryView.contentEdgeInsetLeft = 15;
        _subTitleCategoryView.contentEdgeInsetRight = 15;
        _subTitleCategoryView.titleColorGradientEnabled = YES;
        _subTitleCategoryView.titleLabelZoomScrollGradientEnabled = NO;
        self.subTitles = @[@"日榜", @"周榜"];
        JXCategoryIndicatorBackgroundView *backgroundIndicator = [[JXCategoryIndicatorBackgroundView alloc] init];
        backgroundIndicator.indicatorColor = HEX_COLOR(@"#FFF2E3");
        backgroundIndicator.indicatorWidth = 54;
        _subTitleCategoryView.indicators = @[backgroundIndicator];
    }
    return _subTitleCategoryView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        // 列表容器视图
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _listContainerView;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if (self.titleCategoryView == categoryView) {
        self.titleIndex = index;
        NSString *key = [NSString stringWithFormat:@"%@", @(self.titleIndex)];
        if (self.dicSelected[key]) {
            self.subTitleCategoryView.defaultSelectedIndex = [self.dicSelected[key] integerValue];
        } else {
            self.subTitleCategoryView.defaultSelectedIndex = 0;
        }
        [self.subTitleCategoryView reloadData];
    } else if (self.subTitleCategoryView == categoryView) {
        NSString *key = [NSString stringWithFormat:@"%@", @(self.titleIndex)];
        self.dicSelected[key] = @(index);
    }

}

#pragma mark - JXCategoryListContainerViewDelegate

// 返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.subTitles.count;
}

// 返回各个列表菜单下的实例，该实例需要遵守并实现 <JXCategoryListContentViewDelegate> 协议
- (id <JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    GuessRankContentView *listView = [[GuessRankContentView alloc] init];
    listView.dataList = [self createDataList];
    if (self.titleIndex == 0) {
        NSString *subTitle = @"竞猜王者";
        listView.firstModel = [GuessRankModel createModel:1 count:8763 name:@"盛世红盛" avatar:@"ic_avatar_1" tip:@"胜利(场)" subTitle:subTitle];
        listView.secondModel = [GuessRankModel createModel:2 count:8598 name:@"念念不忘" avatar:@"ic_avatar_2" tip:@"胜利(场)" subTitle:subTitle];
        listView.thirdModel = [GuessRankModel createModel:3 count:8267 name:@"杏岛绮月" avatar:@"ic_avatar_3" tip:@"胜利(场)" subTitle:subTitle];
    } else {
        NSString *subTitle = @"游戏高手";
        listView.firstModel = [GuessRankModel createModel:1 count:8763 name:@"满馨" avatar:@"ic_avatar_10" tip:@"胜利(场)" subTitle:subTitle];
        listView.secondModel = [GuessRankModel createModel:2 count:8598 name:@"贝茗" avatar:@"ic_avatar_9" tip:@"胜利(场)" subTitle:subTitle];
        listView.thirdModel = [GuessRankModel createModel:3 count:8267 name:@"庹启黛" avatar:@"ic_avatar_8" tip:@"胜利(场)" subTitle:subTitle];
    }

    [listView dtUpdateUI];
    return listView;
}

#pragma mark - private

- (NSArray *)createDataList {
    NSMutableArray *arr = [[NSMutableArray alloc] init];

    if (self.titleIndex == 0) {
        NSString *subTitle = @"竞猜王者";
        [arr addObject:[GuessRankModel createModel:4 count:7862 name:@"娜以香" avatar:@"ic_avatar_4" tip:@"竞猜获胜" subTitle:subTitle]];
        [arr addObject:[GuessRankModel createModel:5 count:7623 name:@"大真蓓" avatar:@"ic_avatar_5" tip:@"竞猜获胜" subTitle:subTitle]];
        [arr addObject:[GuessRankModel createModel:6 count:6592 name:@"宦滢" avatar:@"ic_avatar_6" tip:@"竞猜获胜" subTitle:subTitle]];
        [arr addObject:[GuessRankModel createModel:7 count:5689 name:@"易宁" avatar:@"ic_avatar_7" tip:@"竞猜获胜" subTitle:subTitle]];
        [arr addObject:[GuessRankModel createModel:8 count:4369 name:@"庹启黛" avatar:@"ic_avatar_8" tip:@"竞猜获胜" subTitle:subTitle]];
        [arr addObject:[GuessRankModel createModel:9 count:3321 name:@"贝茗" avatar:@"ic_avatar_9" tip:@"竞猜获胜" subTitle:subTitle]];
        [arr addObject:[GuessRankModel createModel:10 count:3114 name:@"满馨" avatar:@"ic_avatar_10" tip:@"竞猜获胜" subTitle:subTitle]];
    } else {
        NSString *subTitle = @"游戏高手";
        [arr addObject:[GuessRankModel createModel:4 count:7862 name:@"满馨" avatar:@"ic_avatar_10" tip:@"获胜" subTitle:subTitle]];
        [arr addObject:[GuessRankModel createModel:5 count:7623 name:@"贝茗" avatar:@"ic_avatar_9" tip:@"获胜" subTitle:subTitle]];
        [arr addObject:[GuessRankModel createModel:6 count:6592 name:@"庹启黛" avatar:@"ic_avatar_8" tip:@"获胜" subTitle:subTitle]];
        [arr addObject:[GuessRankModel createModel:7 count:5689 name:@"易宁" avatar:@"ic_avatar_7" tip:@"获胜" subTitle:subTitle]];
        [arr addObject:[GuessRankModel createModel:8 count:4369 name:@"宦滢" avatar:@"ic_avatar_6" tip:@"获胜" subTitle:subTitle]];
        [arr addObject:[GuessRankModel createModel:9 count:3321 name:@"大真蓓" avatar:@"ic_avatar_5" tip:@"获胜" subTitle:subTitle]];
        [arr addObject:[GuessRankModel createModel:10 count:3114 name:@"娜以香" avatar:@"ic_avatar_4" tip:@"获胜" subTitle:subTitle]];
    }
    return arr;
}
@end
