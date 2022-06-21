//
//  LandscapePopView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/21.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
/// 横屏提示弹出框
@interface LandscapePopView : BaseView
@property (nonatomic, copy)void(^enterBlock)(void);
@end

NS_ASSUME_NONNULL_END
