//
//  ViewController.m
//  QuickStart-Runtime
//
//  Created by kaniel on 10/27/25.
//

#import "ViewController.h"
#import "QsrCommon.h"
#import "Runtime1ViewController.h"
#import "Runtime2ViewController.h"

@interface ViewController()
@property(nonatomic, strong)UIButton *runtime1Btn;
@property(nonatomic, strong)UIButton *runtime2Btn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    QsrCommon.shared.userId = @"sud_test_1";

    [self.view addSubview:self.runtime1Btn];
    [self.view addSubview:self.runtime2Btn];

    [self.runtime1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.runtime2Btn);
        make.height.equalTo(self.runtime2Btn);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.runtime2Btn.mas_top).offset(-30);
    }];
    
    [self.runtime2Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.width.equalTo(@80);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(@-90);
    }];

}


- (void)runtime1BtnClick:(UIButton *)sender {
    Runtime1ViewController *vc = [[Runtime1ViewController alloc]init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];

}

- (void)runtime2BtnClick:(id)sender {
    Runtime2ViewController *vc = [[Runtime2ViewController alloc]init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}


- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIButton *)runtime1Btn {
    if (!_runtime1Btn) {
        _runtime1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_runtime1Btn setBackgroundImage:[self imageWithColor:UIColor.orangeColor] forState:UIControlStateNormal];
        [_runtime1Btn setTitle:@"Runtime1" forState:UIControlStateNormal];
        _runtime1Btn.layer.cornerRadius = 15;
        _runtime1Btn.clipsToBounds = YES;
        [_runtime1Btn addTarget:self action:@selector(runtime1BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _runtime1Btn;
}

- (UIButton *)runtime2Btn {
    if (!_runtime2Btn) {
        _runtime2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_runtime2Btn setBackgroundImage:[self imageWithColor:UIColor.orangeColor] forState:UIControlStateNormal];
        [_runtime2Btn setTitle:@"Runtime2" forState:UIControlStateNormal];
        _runtime2Btn.layer.cornerRadius = 15;
        _runtime2Btn.clipsToBounds = YES;
        [_runtime2Btn addTarget:self action:@selector(runtime2BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _runtime2Btn;
}
@end

