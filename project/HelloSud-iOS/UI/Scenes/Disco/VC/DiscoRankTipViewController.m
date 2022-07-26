//
//  DiscoRankTipViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/7/7.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoRankTipViewController.h"

@interface DiscoRankTipViewController ()
@property(nonatomic, strong) YYLabel *tipOpenLabel;
@end

@implementation DiscoRankTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSString.dt_room_disco_rank_instrument;
    self.view.backgroundColor = HEX_COLOR(@"#F5F6FB");
}

- (void)dtAddViews {
    [super dtAddViews];
    [self.view addSubview:self.tipOpenLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.tipOpenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.top.equalTo(@24);
        make.height.greaterThanOrEqualTo(@0);
    }];

}

- (void)dtConfigEvents {
    [super dtConfigEvents];

}

- (void)dtConfigUI {
    [super dtConfigUI];

}

- (YYLabel *)tipOpenLabel {
    if (!_tipOpenLabel) {
        _tipOpenLabel = [[YYLabel alloc] init];
        _tipOpenLabel.textColor = UIColor.whiteColor;
        _tipOpenLabel.font = UIFONT_REGULAR(12);
        _tipOpenLabel.numberOfLines = 0;
        _tipOpenLabel.preferredMaxLayoutWidth = kScreenWidth - 32;

        NSString *tip = [NSString stringWithFormat:@"%@\n\n%@\n\n%@", NSString.dt_room_disco_rank_tip_one, NSString.dt_room_disco_rank_tip_two, NSString.dt_room_disco_rank_tip_thr];
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:tip];
        attrTitle.yy_lineSpacing = 5;
        attrTitle.yy_font = UIFONT_REGULAR(14);
        attrTitle.yy_color = HEX_COLOR(@"#1A1A1A");
        [attrTitle yy_setAttribute:NSFontAttributeName value:UIFONT_BOLD(14) range:[tip rangeOfString:@"焦点王："]];
        [attrTitle yy_setAttribute:NSFontAttributeName value:UIFONT_BOLD(14) range:[tip rangeOfString:@"人气主播榜："]];

        _tipOpenLabel.attributedText = attrTitle;
    }
    return _tipOpenLabel;
}

@end
