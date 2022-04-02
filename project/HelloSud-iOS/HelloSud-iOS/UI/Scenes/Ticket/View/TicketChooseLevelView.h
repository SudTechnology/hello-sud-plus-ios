//
//  TicketChooseLevelView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/1.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketChooseLevelView : BaseView
/// view点击回调
typedef void(^GameLevelCallBack)(NSInteger gameLevel);
@property(nonatomic, copy)GameLevelCallBack onGameLevelCallBack;
@end

NS_ASSUME_NONNULL_END
