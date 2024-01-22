//
//  DiscoRankPopView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/30.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"
#import "Audio3dInviteAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 邀请主播视图
@interface InviteAnchorPopView : BaseView
- (void)showList:(NSArray<Audio3dInviteAnchorModel *> *)dataList;

@property(nonatomic, strong) void (^inviteClickBlock)(Audio3dInviteAnchorModel *anchorModel);
@end

NS_ASSUME_NONNULL_END
