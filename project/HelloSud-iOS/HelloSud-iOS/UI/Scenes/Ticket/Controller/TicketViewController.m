//
//  TicketViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/18.
//

#import "TicketViewController.h"

@interface TicketViewController ()

@end

@implementation TicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - GAME

/// 系统消息背景颜色
- (UIColor *)systemMsgBgColor {
    return [UIColor dt_colorWithHexString:@"#C84319" alpha:0.3];
}

/// 系统消息文本颜色
- (UIColor *)systemMsgTextColor {
    return [UIColor dt_colorWithHexString:@"#FFE77D" alpha:1];
}
@end
