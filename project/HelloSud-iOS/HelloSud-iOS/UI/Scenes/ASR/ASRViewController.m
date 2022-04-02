//
//  ASRViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/18.
//

#import "ASRViewController.h"

#define I_GUESS_YOU_SAID      1468434504892882946L // 你说我猜
#define DIGITAL_BOMB          1468091457989509190L // 数字炸弹
#define YOU_DRAW_AND_I_GUESS  1461228410184400899L // 你画我猜

@interface ASRViewController ()
@property(nonatomic, strong) UIButton *btnTip;
@end

@implementation ASRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showVoiceTip];
}

- (void)showVoiceTip {

    if (!self.btnTip) {
        self.btnTip = [[UIButton alloc] init];
        UIImage *bgImage = [[UIImage imageNamed:@"voice_tip"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 50, 19, 49) resizingMode:UIImageResizingModeStretch];
        [self.btnTip setBackgroundImage:bgImage forState:UIControlStateNormal];
        NSString *tip = @"";
        if (self.gameId == DIGITAL_BOMB) {
            tip = @"试试打开麦克风报数，懒人福利！";
        } else {
            tip = @"开麦抢答，比打字更快哦！";
        }
        [self.btnTip setTitle:tip forState:UIControlStateNormal];
        [self.sceneView addSubview:self.btnTip];
        [self.btnTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_equalTo(41);
            make.bottom.equalTo(self.operatorView.mas_top).offset(-10);
        }];
    }
}
@end
