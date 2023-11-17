//
//  DiscoRankTableViewCell.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/30.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseTableViewCell.h"
#import "Audio3dInviteAnchorModel.h"
NS_ASSUME_NONNULL_BEGIN
/// 邀请主播cell
@interface Audio3dInviteAnchorCell : BaseTableViewCell
@property(nonatomic, strong) void (^inviteClickBlock)(Audio3dInviteAnchorModel *anchorModel);
@end

NS_ASSUME_NONNULL_END