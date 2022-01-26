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



/// Base
#import "BaseView.h"
#import "BaseModel.h"
#import "BaseTableViewCell.h"
#import "BaseViewController.h"
#import "BaseNavigationViewController.h"

/// Extension
#import "UIColor+Extension.h"
#import "UIDevice+Extension.h"
/// Utils
#import "Constant.h"
#import "AppUtil.h"
#import "DeviceUtil.h"
/// Views
#import "HSSheetView.h"
#import "HSWebViewController.h"
#import "HSBlurEffectView.h"
#import "HSSVGAPlayerView.h"
#import "HSRippleAnimationView.h"

#endif /* CommonHeader_h */
