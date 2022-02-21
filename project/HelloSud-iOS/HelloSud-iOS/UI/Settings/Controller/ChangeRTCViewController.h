//
//  ChangeRTCViewController.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/15.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangeRTCViewController : BaseViewController
@property (nonatomic, copy) void (^onRTCChangeBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
