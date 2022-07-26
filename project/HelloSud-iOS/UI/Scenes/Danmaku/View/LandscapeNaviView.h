//
//  LandscapeNaviView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 横屏导航栏
@interface LandscapeNaviView : BaseView
@property(nonatomic, copy) UIBUTTON_TAP_BLOCK closeTapBlock;
@property(nonatomic, copy) UIBUTTON_TAP_BLOCK backTapBlock;
@property(nonatomic, strong) NSString *roomName;
@end

NS_ASSUME_NONNULL_END
