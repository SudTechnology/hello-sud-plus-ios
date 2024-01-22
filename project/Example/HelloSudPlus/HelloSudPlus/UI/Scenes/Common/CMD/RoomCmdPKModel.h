//
// Created by kaniel on 2022/4/25.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

/// PK邀请应答
@interface RoomCmdPKAckInviteModel : RoomBaseCMDModel
@property (nonatomic, assign)BOOL isAccept;
/// pkId
@property(nonatomic, strong)NSString *pkId;
/// 另外房间房主信息
@property(nonatomic, strong)AudioUserModel *otherUser;
@end

/// 开始跨房PK model
@interface RoomCmdPKStartedModel : RoomBaseCMDModel
/// PK倒计时长
@property (nonatomic, assign)NSInteger minuteDuration;
/// pkId
@property(nonatomic, strong)NSString *pkId;
@end

@interface RoomGameResultModel :BaseModel
@property (nonatomic, assign)int64_t roomId;
@property (nonatomic, assign)NSInteger totalScore;
@end

/// 用户排名信息
@interface RoomUserRankInfoModel :BaseModel
@property (nonatomic, assign)int64_t roomId;
@property (nonatomic, assign)int64_t userId;
@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, assign)NSInteger winScore;
@property (nonatomic, assign)NSInteger rank;
@end

@interface RoomPKGameResultContentModel :BaseModel
@property (nonatomic, strong)RoomGameResultModel *srcPkGameSettleInfo;
@property (nonatomic, strong)RoomGameResultModel *destPkGameSettleInfo;
@property (nonatomic, strong)NSArray<RoomUserRankInfoModel *> *userRankInfoList;
@end

/// 跨房PK游戏结果指令 model
@interface RoomPKGameResultCMDModel : RoomBaseCMDModel
@property (nonatomic, strong)RoomPKGameResultContentModel *content;
@end
