//
//  RoomCmdGuessBetNotifyModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/15.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RoomBaseCMDModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 竞猜押注通知
@interface RoomCmdGuessBetNotifyModel : RoomBaseCMDModel
/// 被下注用户列表
@property(nonatomic, strong)NSArray<AudioUserModel *> *recUser;
@end

NS_ASSUME_NONNULL_END
