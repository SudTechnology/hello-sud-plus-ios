//
//  TicketChooseViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "TicketChooseViewController.h"
#import "TicketChooseItemView.h"
#import "TocketChooseModel.h"
#import "DTRollTableView.h"
#import "TicketJoinPopView.h"

@interface TicketChooseViewController ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) DTRollTableView *noticeView;
@end

@implementation TicketChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (BOOL)dtIsHiddenNavigationBar {
    return true;
}

- (void)dtAddViews {
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.noticeView];
    [self setupContentItems];
    
    NSMutableArray <NSAttributedString *> *dataArr = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"恭喜沐辰在高级场赢得1000金币！%d", i]];
        attrStr.yy_lineSpacing = 6;
        attrStr.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        attrStr.yy_color = [UIColor dt_colorWithHexString:@"#FFE77D" alpha:1];
        [dataArr addObject:attrStr];
    }
    self.noticeView.dataArray = dataArr;
    [self.noticeView reloadData];
}

- (void)dtLayoutViews {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kAppSafeTop + 10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kAppSafeTop);
        make.left.mas_equalTo(6);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(19);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 30));
    }];
}

- (void)setupContentItems {
    for (int i = 0; i < 3; i++) {
        TicketChooseItemView *item = TicketChooseItemView.new;
        TocketChooseModel *model = TocketChooseModel.new;
        model.bgImgStr = [NSString stringWithFormat:@"tickets_item_%d_bg", i];
        model.goldImgStr = [NSString stringWithFormat:@"tickets_item_%d_gold", i];
        model.btnImgStr = [NSString stringWithFormat:@"tickets_item_%d_btn", i];
        model.rewardStr = @"赢10倍奖励";
        model.isHiddenHot = i == 0;
        item.model = model;
        item.tag = 1000 + i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickItemsEvent:)];
        [item addGestureRecognizer:tap];
        [self.view addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kStatusBarHeight + 44 + 85 + i * 187);
            make.left.mas_equalTo(14);
            make.right.mas_equalTo(-14);
            make.height.mas_equalTo(154);
        }];
    }
}

- (void)clickItemsEvent:(UITapGestureRecognizer *)tap {
    NSInteger tag = tap.view.tag - 1000;
    if (tag == 0) {
        [DTSheetView show:TicketJoinPopView.new rootView:AppUtil.currentWindow hiddenBackCover:false onCloseCallback:^{
                    
        }];
    }
}

- (void)backEvent {
    [self.navigationController popViewControllerAnimated:true];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tickets_bg"]];
    }
    return _bgImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.text = @"狼人杀";
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.font = UIFONT_MEDIUM(18);
    }
    return _titleLabel;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = UIButton.new;
        [_backBtn setImage:[UIImage imageNamed:@"tickets_navi_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (DTRollTableView *)noticeView {
    if (!_noticeView) {
        _noticeView = DTRollTableView.new;
    }
    return _noticeView;
}

@end
