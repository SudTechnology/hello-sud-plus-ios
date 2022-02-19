//
//  AppUtil.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/18.
//

#import "AppUtil.h"

@implementation AppUtil

#pragma mark - 字典 json字符串互转
+ (NSString*)dictionaryToJson: (NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)turnStringToDictionary: (NSString *)turnString {
    NSData *turnData = [turnString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *turnDic = [NSJSONSerialization JSONObjectWithData:turnData options:NSJSONReadingMutableLeaves error:nil];
    return turnDic;
}

+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string color:(NSString*)color {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor dt_colorWithHexString:color alpha:1] range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

/// 当前APP window视图
+ (UIWindow *)currentWindow {
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    if (win.windowLevel != UIWindowLevelNormal) {
        for (UIWindow *w in [UIApplication sharedApplication].windows) {
            if (w.windowLevel == UIWindowLevelNormal) {
                win = w;
                break;
            }
        }
    }
    return win;
}

//获取当前最上层的控制器
+ (UIViewController *)currentViewController {
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    //循环之前tempVC和topVC是一样的
    UIViewController *tempVC = topVC;
    while (1) {
        if ([topVC isKindOfClass:[UITabBarController class]]) {
            topVC = ((UITabBarController*)topVC).selectedViewController;
        }
        if ([topVC isKindOfClass:[UINavigationController class]]) {
            topVC = ((UINavigationController*)topVC).visibleViewController;
        }
        if (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }
        //如果两者一样，说明循环结束了
        if ([tempVC isEqual:topVC]) {
            break;
        } else {
        //如果两者不一样，继续循环
            tempVC = topVC;
        }
    }
    return topVC;
}

@end
