//
//  DiscoDancingRoomViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/24.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoRoomViewController.h"
#import "DiscoNaviRankView.h"

@interface DiscoRoomViewController ()
@property(nonatomic, strong) BaseView *settingView;
@property(nonatomic, strong) MarqueeLabel *settingLabel;
@property(nonatomic, strong) DiscoNaviRankView *rankView;
@end

@implementation DiscoRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.naviView hiddenNodeWithRoleType:0];
    [self updateSettingState:self.gameId > 0];
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.naviView addSubview:self.settingView];
    [self.settingView addSubview:self.settingLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.naviView.roomModeView);
        make.height.equalTo(@20);
        make.width.mas_greaterThanOrEqualTo(56);
        make.trailing.equalTo(self.naviView.roomModeView.mas_leading).offset(-10);
        make.leading.greaterThanOrEqualTo(self.naviView.onlineImageView.mas_trailing).offset(10);
    }];
    [self.settingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@8);
        make.trailing.equalTo(@(-8));
        make.centerY.equalTo(self.settingView);
        make.height.mas_greaterThanOrEqualTo(0);
        make.width.mas_lessThanOrEqualTo(@66);
    }];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSettingTap:)];
    [self.settingView addGestureRecognizer:tap];
}

- (void)dtConfigUI {
    [super dtConfigUI];

}

/// 点击PK设置
- (void)onSettingTap:(UITapGestureRecognizer *)tap {
    if (self.gameId > 0) {
        [self handleChangeToGame:0];
        [self updateSettingState:NO];
    } else {
        [self handleChangeToGame:[self getCurrentGameID]];
        [self updateSettingState:YES];
    }
}

- (int64_t)getCurrentGameID {
    NSArray <HSGameItem *> *dataArr = AppService.shared.gameList;
    for (HSGameItem *item in dataArr) {
        for (NSNumber *scene in item.suitScene) {
            if ([scene integerValue] == self.configModel.enterRoomModel.sceneType) {
                return item.gameId;
            }
        }
    }
    return 0;
}

- (void)updateSettingState:(BOOL)isGameExist {
    if (isGameExist) {
        self.settingLabel.text = @"关闭蹦迪";
        [self.settingView dtRemoveGradient];
    } else {
        self.settingLabel.text = @"开启蹦迪";
        [self.settingView dtAddGradientLayer:@[@0, @0.25, @0.35, @0.5, @0.7, @0.85, @1]
                                      colors:@[(id) HEX_COLOR(@"#F40ADE").CGColor,
                                              (id) HEX_COLOR(@"#E02020").CGColor,
                                              (id) HEX_COLOR(@"#FA6400").CGColor,
                                              (id) HEX_COLOR(@"#EBAC00").CGColor,
                                              (id) HEX_COLOR(@"#6DD400").CGColor,
                                              (id) HEX_COLOR(@"#0091FF").CGColor,
                                              (id) HEX_COLOR(@"#6236FF").CGColor]
                                  startPoint:CGPointMake(0, 0.5)
                                    endPoint:CGPointMake(1, 0.5)
                                cornerRadius:0];
    }
}



- (DiscoNaviRankView *)rankView {
    if (!_rankView) {
        _rankView = [[DiscoNaviRankView alloc] init];
    }
    return _rankView;
}

- (BaseView *)settingView {
    if (!_settingView) {
        _settingView = [[BaseView alloc] init];
        _settingView.backgroundColor = HEX_COLOR_A(@"#FFFFFF", 0.2);
    }
    return _settingView;
}

- (MarqueeLabel *)settingLabel {
    if (!_settingLabel) {
        _settingLabel = [[MarqueeLabel alloc] init];
        _settingLabel.textColor = UIColor.whiteColor;
        _settingLabel.font = UIFONT_BOLD(12);
        _settingLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _settingLabel;
}
@end
