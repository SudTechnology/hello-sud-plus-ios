//
//  TicketJoinPopView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketJoinPopView : BaseView
@property (nonatomic, copy) UIBUTTON_TAP_BLOCK onJoinCallBack;
/// 门票场景等级类型
@property (nonatomic, assign) TicketLevelType ticketLevelType;
@end

NS_ASSUME_NONNULL_END
