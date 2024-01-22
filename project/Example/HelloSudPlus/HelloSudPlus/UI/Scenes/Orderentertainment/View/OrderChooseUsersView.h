//
//  OrderChooseUsersView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/18.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderChooseUsersView : BaseView
typedef void(^CompleteBlock)(void);
@property (nonatomic, copy) CompleteBlock completeBlock;

- (void)configUsersData:(NSArray <AudioRoomMicModel *>*)list;
@property (nonatomic, strong, readonly) NSMutableArray <AudioRoomMicModel *> *usersList;
- (NSInteger)usersCount;
- (NSArray<AudioRoomMicModel *> *)selectedUserList;
@end

NS_ASSUME_NONNULL_END
