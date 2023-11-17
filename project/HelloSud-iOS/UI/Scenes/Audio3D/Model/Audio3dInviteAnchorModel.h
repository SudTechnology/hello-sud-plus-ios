//
//  DiscoRankModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/30.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 邀请主播model
@interface Audio3dInviteAnchorModel : BaseModel
@property(nonatomic, assign) BOOL isInvited;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *avatar;
@property(nonatomic, strong) NSString *userId;
@end

NS_ASSUME_NONNULL_END
