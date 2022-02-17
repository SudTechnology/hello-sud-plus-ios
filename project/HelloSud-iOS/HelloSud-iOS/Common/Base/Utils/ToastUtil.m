//
//  ToastUtil.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/10.
//

#import "ToastUtil.h"
/// 延迟关闭toast时间
#define TOAST_DELAY_DISMISS_DURATION 2

@implementation ToastUtil
/// 展示信息，挂载当前window上
/// @param msg 需要展示内容
+ (void)show:(NSString *)msg {
    if (msg.length == 0) {
        return;
    }
    [SVProgressHUD dismiss];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setImageViewSize:CGSizeMake(0, -1)];
    [SVProgressHUD showImage:[UIImage new] status:msg];
    [SVProgressHUD dismissWithDelay:TOAST_DELAY_DISMISS_DURATION];
}
@end
