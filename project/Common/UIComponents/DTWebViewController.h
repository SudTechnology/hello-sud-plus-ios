//
//  DTWebViewController.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/20.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 加载web页面
@interface DTWebViewController : BaseViewController

/// 加载URL地址
@property(nonatomic, copy)NSString *url;
@property(nonatomic, assign)BOOL isPresent;
@end

NS_ASSUME_NONNULL_END
