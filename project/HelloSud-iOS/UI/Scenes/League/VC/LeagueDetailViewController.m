//
//  LeagueDetailViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/9/27.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "LeagueDetailViewController.h"

@interface LeagueDetailViewController ()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *backBtn;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) DTPaddingLabel *label1;
@property(nonatomic, strong) UIImageView *imageView1;
@property(nonatomic, strong) DTPaddingLabel *label2;
@property(nonatomic, strong) UIImageView *imageView2;
@property(nonatomic, strong) DTPaddingLabel *label3;
@property(nonatomic, strong) UIImageView *imageView3;
@property(nonatomic, strong) DTPaddingLabel *label4;
@property(nonatomic, strong) UIImageView *imageView4;
@property(nonatomic, strong) DTPaddingLabel *label5;
@property(nonatomic, strong) UIImageView *imageView5;
@end

@implementation LeagueDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HEX_COLOR(@"#1D35AB");
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)dtIsHiddenNavigationBar {
    return YES;
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];

    [self.contentView addSubview:self.label1];
    [self.contentView addSubview:self.label2];
    [self.contentView addSubview:self.label3];
    [self.contentView addSubview:self.label4];
    [self.contentView addSubview:self.label5];
    [self.contentView addSubview:self.imageView1];
    [self.contentView addSubview:self.imageView2];
    [self.contentView addSubview:self.imageView3];
    [self.contentView addSubview:self.imageView4];
    [self.contentView addSubview:self.imageView5];
}


- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kAppSafeTop);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.equalTo(@(kScaleByW_375(44)));
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.leading.mas_equalTo(6);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backBtn.mas_bottom);
        make.leading.trailing.bottom.equalTo(@0);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        make.height.greaterThanOrEqualTo(@0);
    }];

    [self.label1 dt_cornerRadius:12];
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@19);
        make.centerX.equalTo(self.contentView);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@25);
    }];

    [self.imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label1.mas_bottom).offset(6);
        make.width.equalTo(@347);
        make.height.equalTo(@143);
        make.centerX.equalTo(self.contentView);
    }];

    [self.label2 dt_cornerRadius:12];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView1.mas_bottom).offset(8);
        make.centerX.equalTo(self.contentView);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@25);
    }];

    [self.imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label2.mas_bottom).offset(10);
        make.width.equalTo(@311);
        make.height.equalTo(@360);
        make.centerX.equalTo(self.contentView);
    }];

    [self.label3 dt_cornerRadius:12];
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView2.mas_bottom).offset(7);
        make.centerX.equalTo(self.contentView);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@25);
    }];

    [self.imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label3.mas_bottom).offset(10);
        make.width.equalTo(@205);
        make.height.equalTo(@530);
        make.centerX.equalTo(self.contentView);
    }];

    [self.label4 dt_cornerRadius:12];
    [self.label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView3.mas_bottom).offset(7);
        make.centerX.equalTo(self.contentView);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@25);
    }];

    [self.imageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label4.mas_bottom).offset(10);
        make.width.equalTo(@311);
        make.height.equalTo(@360);
        make.centerX.equalTo(self.contentView);
    }];

    [self.label5 dt_cornerRadius:12];
    [self.label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView4.mas_bottom).offset(7);
        make.centerX.equalTo(self.contentView);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@25);
    }];

    [self.imageView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label5.mas_bottom).offset(10);
        make.width.equalTo(@205);
        make.height.equalTo(@421);
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(@-94);
    }];

    [self.scrollView layoutIfNeeded];
    CGFloat height = self.contentView.bounds.size.height;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, height);
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [_backBtn addTarget:self action:@selector(onBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.titleLabel.text = @"示例";

    self.label1.text = @"比赛入口";
    self.label2.text = @"第一局淘汰赛";
    self.label3.text = @"进入前三";
    self.label4.text = @"总决赛";
    self.label5.text = @"获得第一名";

    self.imageView1.image = [UIImage imageNamed:@"league_demo_1"];
    self.imageView2.image = [UIImage imageNamed:@"league_demo_2"];
    self.imageView3.image = [UIImage imageNamed:@"league_demo_3"];
    self.imageView4.image = [UIImage imageNamed:@"league_demo_4"];
    self.imageView5.image = [UIImage imageNamed:@"league_demo_5"];
}

- (void)onBackBtnClick:(id)sender {
    [self dtNavigationBackClick];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.font = UIFONT_MEDIUM(18);
    }
    return _titleLabel;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = UIButton.new;
        [_backBtn setImage:[UIImage imageNamed:@"tickets_navi_back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIImageView *)imageView1 {
    if (!_imageView1) {
        _imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"award_bg"]];
        _imageView1.contentMode = UIViewContentModeScaleAspectFill;
        _imageView1.clipsToBounds = YES;
    }
    return _imageView1;
}

- (UIImageView *)imageView2 {
    if (!_imageView2) {
        _imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"award_bg"]];
        _imageView2.contentMode = UIViewContentModeScaleAspectFill;
        _imageView2.clipsToBounds = YES;
    }
    return _imageView2;
}

- (UIImageView *)imageView3 {
    if (!_imageView3) {
        _imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"award_bg"]];
        _imageView3.contentMode = UIViewContentModeScaleAspectFill;
        _imageView3.clipsToBounds = YES;
    }
    return _imageView3;
}

- (UIImageView *)imageView4 {
    if (!_imageView4) {
        _imageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"award_bg"]];
        _imageView4.contentMode = UIViewContentModeScaleAspectFill;
        _imageView4.clipsToBounds = YES;
    }
    return _imageView4;
}

- (UIImageView *)imageView5 {
    if (!_imageView5) {
        _imageView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"award_bg"]];
        _imageView5.contentMode = UIViewContentModeScaleAspectFill;
        _imageView5.clipsToBounds = YES;
    }
    return _imageView5;
}

- (DTPaddingLabel *)label1 {
    if (!_label1) {
        _label1 = DTPaddingLabel.new;
        _label1.textColor = HEX_COLOR(@"#FFFFFF");
        _label1.backgroundColor = HEX_COLOR_A(@"#000000", 0.3);
        _label1.font = UIFONT_REGULAR(16);
        _label1.paddingX = 12;
        _label1.textAlignment = NSTextAlignmentCenter;
    }
    return _label1;
}

- (DTPaddingLabel *)label2 {
    if (!_label2) {
        _label2 = DTPaddingLabel.new;
        _label2.textColor = HEX_COLOR(@"#FFFFFF");
        _label2.backgroundColor = HEX_COLOR_A(@"#000000", 0.3);
        _label2.font = UIFONT_REGULAR(16);
        _label2.paddingX = 12;
        _label2.textAlignment = NSTextAlignmentCenter;
    }
    return _label2;
}

- (DTPaddingLabel *)label3 {
    if (!_label3) {
        _label3 = DTPaddingLabel.new;
        _label3.textColor = HEX_COLOR(@"#FFFFFF");
        _label3.backgroundColor = HEX_COLOR_A(@"#000000", 0.3);
        _label3.font = UIFONT_REGULAR(16);
        _label3.paddingX = 12;
        _label3.textAlignment = NSTextAlignmentCenter;
    }
    return _label3;
}

- (DTPaddingLabel *)label4 {
    if (!_label4) {
        _label4 = DTPaddingLabel.new;
        _label4.textColor = HEX_COLOR(@"#FFFFFF");
        _label4.backgroundColor = HEX_COLOR_A(@"#000000", 0.3);
        _label4.font = UIFONT_REGULAR(16);
        _label4.paddingX = 12;
        _label4.textAlignment = NSTextAlignmentCenter;
    }
    return _label4;
}

- (DTPaddingLabel *)label5 {
    if (!_label5) {
        _label5 = DTPaddingLabel.new;
        _label5.textColor = HEX_COLOR(@"#FFFFFF");
        _label5.backgroundColor = HEX_COLOR_A(@"#000000", 0.3);
        _label5.font = UIFONT_REGULAR(16);
        _label5.paddingX = 12;
        _label5.textAlignment = NSTextAlignmentCenter;
    }
    return _label5;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = UIScrollView.new;
    }
    return _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = UIView.new;
    }
    return _contentView;
}

@end
