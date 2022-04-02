//
//  CommonHeader.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/19.
//

#ifndef CommonHeader_h
#define CommonHeader_h
#import <UIKit/UIKit.h>
/// button点击回调
typedef void(^UIBUTTON_TAP_BLOCK)(UIButton *sender);
/// view点击回调
typedef void(^UIVIEW_TAP_BLOCK)(UITapGestureRecognizer *gesture);
/// NSString
typedef void(^StringBlock)(NSString *str);
/// 空回调
typedef void(^EmptyBlock)(void);
/// 错误回调
typedef void(^ErrorBlock)(NSError *error);
/// 整形回调
typedef void(^Int64Block)(int64_t);


/// Utils
#import "Constant.h"
#import "AppUtil.h"
#import "DeviceUtil.h"
#import "ToastUtil.h"
#import "LanguageUtil.h"
/// Base
#import "BaseView.h"
#import "BaseModel.h"
#import "BaseTableViewCell.h"
#import "BaseViewController.h"
#import "BaseNavigationViewController.h"

/// Extension
#import "DTUIColor+Extension.h"
#import "DTUIDevice+Extension.h"
#import "DTNSError+Custom.h"
#import "NSBundle+Language.h"

/// Views
#import "DTSheetView.h"
#import "DTWebViewController.h"
#import "DTBlurEffectView.h"
#import "DTSVGAPlayerView.h"
#import "DTRippleAnimationView.h"
#import "DTPaddingLabel.h"

#endif /* CommonHeader_h */
