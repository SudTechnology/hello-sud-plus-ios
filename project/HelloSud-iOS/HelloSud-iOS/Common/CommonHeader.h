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
/// 空回调
typedef void(^EmptyBlock)(void);
/// 错误回调
typedef void(^ErrorBlock)(NSError *error);


/// Utils
#import "Constant.h"
#import "AppUtil.h"
#import "DeviceUtil.h"
#import "ToastUtil.h"
/// Base
#import "BaseView.h"
#import "BaseModel.h"
#import "BaseTableViewCell.h"
#import "BaseViewController.h"
#import "BaseNavigationViewController.h"

/// Extension
#import "UIColor+Extension.h"
#import "UIDevice+Extension.h"
#import "NSError+Custom.h"

/// Views
#import "SheetView.h"
#import "WebViewController.h"
#import "BlurEffectView.h"
#import "SVGAPlayerView.h"
#import "RippleAnimationView.h"
#import "PaddingLabel.h"

#endif /* CommonHeader_h */
