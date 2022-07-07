//
//  DiscoRankViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/8.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoRankViewController.h"
#import "GuessRankContentView.h"
#import "DiscoRankTipViewController.h"

@interface DiscoRankViewController () <JXCategoryViewDelegate>
@property(nonatomic, strong) BaseView *bgView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) JXCategoryTitleView *subTitleCategoryView;
@property(nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property(nonatomic, strong) NSArray<NSString *> *subTitles;
@property(nonatomic, assign) NSInteger titleIndex;
@property(nonatomic, strong) UIButton *backBtn;
@property(nonatomic, strong) UIButton *tipBtn;
@property(nonatomic, strong) NSMutableDictionary *dicSelected;
@end

@implementation DiscoRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dicSelected = [[NSMutableDictionary alloc] init];
}

- (BOOL)dtIsHiddenNavigationBar {
    return YES;
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.subTitleCategoryView];
    [self.view addSubview:self.listContainerView];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.tipBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@375);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kAppSafeTop + 10));
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@25);
        make.centerX.equalTo(self.view);
    }];
    [self.subTitleCategoryView dt_cornerRadius:10];
    [self.subTitleCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.equalTo(@20);
        make.width.equalTo(@160);
        make.centerX.equalTo(self.view);
    }];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleCategoryView.mas_bottom).offset(0);
        make.leading.trailing.bottom.equalTo(@0);
    }];

    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@24);
        make.leading.equalTo(@16);
        make.centerY.equalTo(self.titleLabel);
    }];

    [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.greaterThanOrEqualTo(@24);
        make.width.greaterThanOrEqualTo(@0);
        make.trailing.equalTo(@-20);
        make.centerY.equalTo(self.backBtn);
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.view.backgroundColor = UIColor.whiteColor;
    self.subTitleCategoryView.listContainer = self.listContainerView;
    self.titleLabel.text = @"蹦迪排行";
}

- (void)onClickTipBtn:(id)sender {
    DiscoRankTipViewController *vc = [[DiscoRankTipViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)tipBtn {
    if (!_tipBtn) {
        _tipBtn = [[UIButton alloc] init];
        _tipBtn.titleLabel.font = UIFONT_REGULAR(12);
        [_tipBtn setTitleColor:HEX_COLOR_A(@"#ffffff", 0.8) forState:UIControlStateNormal];
        [_tipBtn setTitle:@"说明" forState:UIControlStateNormal];
        [_tipBtn addTarget:self action:@selector(onClickTipBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipBtn;
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

- (JXCategoryTitleView *)subTitleCategoryView {
    if (!_subTitleCategoryView) {
        self.subTitles = @[@"焦点王", @"人气主播榜"];
        _subTitleCategoryView = [[JXCategoryTitleView alloc] init];
        _subTitleCategoryView.delegate = self;
        _subTitleCategoryView.titleColor = HEX_COLOR_A(@"#ffffff", 0.8);
        _subTitleCategoryView.titleSelectedColor = HEX_COLOR(@"#3F3228");
        _subTitleCategoryView.titleFont = UIFONT_REGULAR(12);
        _subTitleCategoryView.titleSelectedFont = UIFONT_MEDIUM(12);
        _subTitleCategoryView.titles = self.subTitles;
        _subTitleCategoryView.backgroundColor = HEX_COLOR_A(@"#C0A48F", 0.3);
        _subTitleCategoryView.contentEdgeInsetLeft = 15;
        _subTitleCategoryView.contentEdgeInsetRight = 15;
        _subTitleCategoryView.titleColorGradientEnabled = YES;
        _subTitleCategoryView.titleLabelZoomScrollGradientEnabled = NO;
        JXCategoryIndicatorBackgroundView *backgroundIndicator = [[JXCategoryIndicatorBackgroundView alloc] init];
        backgroundIndicator.indicatorColor = HEX_COLOR(@"#FFF2E3");
        backgroundIndicator.indicatorWidth = 80;
        _subTitleCategoryView.indicators = @[backgroundIndicator];
    }
    return _subTitleCategoryView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFONT_MEDIUM(18);
        _titleLabel.textColor = HEX_COLOR(@"#ffffff");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        // 列表容器视图
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _listContainerView;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {

//    [_listContainerView reloadData];
}

#pragma mark - JXCategoryListContainerViewDelegate

// 返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.subTitles.count;
}

// 返回各个列表菜单下的实例，该实例需要遵守并实现 <JXCategoryListContentViewDelegate> 协议
- (id <JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    GuessRankContentView *listView = [[GuessRankContentView alloc] init];
    [listView updateHeadHeight:240];
    listView.dataList = [self createDataList:index];
    NSString *tip = index == 0 ? @"获得特写(次)" : @"被邀约(次)";
    listView.firstModel = [GuessRankModel createModel:1 count:8763 name:@"盛世红盛" avatar:@"ic_avatar_1" tip:tip subTitle:@""];
    listView.secondModel = [GuessRankModel createModel:2 count:8598 name:@"念念不忘" avatar:@"ic_avatar_2" tip:tip subTitle:@""];
    listView.thirdModel = [GuessRankModel createModel:3 count:8267 name:@"杏岛绮月" avatar:@"ic_avatar_3" tip:tip subTitle:@""];


    [listView dtUpdateUI];
    return listView;
}

#pragma mark - private

- (NSArray *)createDataList:(NSInteger)index {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSString *tip = index == 0 ? @"获得特写(次)" : @"被邀约(次)";
    [arr addObject:[GuessRankModel createModel:4 count:7862 name:@"娜以香" avatar:@"ic_avatar_4" tip:tip subTitle:@""]];
    [arr addObject:[GuessRankModel createModel:5 count:7623 name:@"大真蓓" avatar:@"ic_avatar_5" tip:tip subTitle:@""]];
    [arr addObject:[GuessRankModel createModel:6 count:6592 name:@"宦滢" avatar:@"ic_avatar_6" tip:tip subTitle:@""]];
    [arr addObject:[GuessRankModel createModel:7 count:5689 name:@"易宁" avatar:@"ic_avatar_7" tip:tip subTitle:@""]];
    [arr addObject:[GuessRankModel createModel:8 count:4369 name:@"庹启黛" avatar:@"ic_avatar_8" tip:tip subTitle:@""]];
    [arr addObject:[GuessRankModel createModel:9 count:3321 name:@"贝茗" avatar:@"ic_avatar_9" tip:tip subTitle:@""]];
    [arr addObject:[GuessRankModel createModel:10 count:3114 name:@"满馨" avatar:@"ic_avatar_10" tip:tip subTitle:@""]];

    return arr;
}
@end
