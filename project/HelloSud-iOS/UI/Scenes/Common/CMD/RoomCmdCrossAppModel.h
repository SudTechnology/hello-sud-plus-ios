//
// Created by kaniel on 2022/4/25.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

/// 跨App匹配状态
typedef NS_ENUM(NSInteger, CrossAppMatchSate) {
    /// 未开启
    CrossAppMatchSateNotBegin = 1,
    /// 组队中
    CrossAppMatchSateGroup = 2,
    /// 匹配中
    CrossAppMatchSateMatching = 3,
    /// 匹配成功
    CrossAppMatchSateMatchSucceed = 4,
    /// 匹配失败
    CrossAppMatchSateMatchFailed = 5,
};

/// 加入组队消息
@interface RoomCmdCrossAppJoinGroupModel : RoomBaseCMDModel
@property(nonatomic, assign) int64_t userId;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, assign) int64_t gameId;
@end

/// 匹配人数变更
@interface RoomCmdCrossAppPersonChangedModel : RoomBaseCMDModel
@property(nonatomic, assign) NSInteger totalNum;
@property(nonatomic, assign) NSInteger curNum;
@property(nonatomic, strong) NSString *groupId;
@property(nonatomic, strong) NSArray <NSNumber *> *userIds;
@end

/// 匹配状态变更
@interface RoomCmdCrossAppPersonMatchStateChangedModel : RoomBaseCMDModel
@property(nonatomic, assign) NSInteger totalNum;
@property(nonatomic, assign) NSInteger curNum;
@property(nonatomic, strong) NSString *groupId;
@property(nonatomic, strong) NSString *matchRoomId;
/// 1未开启，2组队中，3匹配中，4匹配成功，5匹配失败
@property(nonatomic, assign) CrossAppMatchSate matchStatus;
@end

@interface UserIndexInfo : NSObject
@property(nonatomic, assign) int64_t userId;
@property(nonatomic, assign) NSInteger index;
@end

/// 队长变更
@interface RoomCmdCrossAppGroupOwnerChangedModel : RoomBaseCMDModel
@property(nonatomic, assign) int64_t captain;
@property(nonatomic, strong) NSArray <UserIndexInfo *> *userList;
@end

/// 组队游戏变更
@interface RoomCmdCrossAppGroupGameChangedModel : RoomBaseCMDModel
@property(nonatomic, assign) int64_t gameId;
@end