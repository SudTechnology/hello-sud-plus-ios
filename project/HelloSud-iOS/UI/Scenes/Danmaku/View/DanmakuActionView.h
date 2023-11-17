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
@interface DanmakuActionView : BaseView
@property(nonatomic, strong) NSArray <DanmakuActionListeItemModel *> *dataList;
@end

NS_ASSUME_NONNULL_END
