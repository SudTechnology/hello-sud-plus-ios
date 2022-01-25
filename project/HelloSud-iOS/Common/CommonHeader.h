//
//  CommonHeader.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/19.
//

#ifndef CommonHeader_h
#define CommonHeader_h
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
/// Views
#import "HSSheetView.h"
#import "HSWebViewController.h"
/// button点击回调
typedef void(^UIBUTTON_TAP_BLOCK)(UIButton *sender);
/// view点击回调
typedef void(^UIVIEW_TAP_BLOCK)(UITapGestureRecognizer *gesture);

#endif /* CommonHeader_h */
