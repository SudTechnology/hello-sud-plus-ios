//
//  DanmakuQuickSendView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
/// 弹幕快速发送视图
@interface DanmakuQuickSendView : BaseView
@property (nonatomic, copy)void(^onOpenBlock)(BOOL isOpen);
/// 调整是否展开状态
/// @param isOpen YES 开 NO关
- (void)showOpen:(BOOL)isOpen;
@end

NS_ASSUME_NONNULL_END
