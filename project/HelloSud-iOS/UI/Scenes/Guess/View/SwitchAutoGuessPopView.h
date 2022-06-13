//
//  SwitchAutoGuessPopView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/13.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
/// 自动竞猜切换弹出视图
@interface SwitchAutoGuessPopView : BaseView
@property (nonatomic, copy)void(^onCloseBlock)(void);
@property (nonatomic, copy)void(^onOpenBlock)(void);
@end

NS_ASSUME_NONNULL_END
