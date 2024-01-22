//
//  RoomListModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSRoomInfoList: BaseModel
@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, assign) NSInteger roomNumber;
@property (nonatomic, copy) NSString * roomName;
@property (nonatomic, assign) NSInteger memberCount;
@property (nonatomic, copy) NSString * roomPic;
@property (nonatomic, assign) NSInteger sceneType;
@property (nonatomic, copy) NSString * rtcType;
@property (nonatomic, copy) NSString * sceneTag;
@property (nonatomic, copy) NSString * gameLevelDesc;
/// pk状态 （1：待匹配 2：pk已匹配，未开始 3：k已匹配，已开始 4：pk匹配关闭 5：pk已结束）
@property (nonatomic, assign) NSInteger pkStatus;
/// 1未开启，2组队中，3匹配中，4匹配成功，5匹配失败
@property (nonatomic, assign) NSInteger teamStatus;
@end

/// 所有开播房间列表
@interface RoomListModel : BaseRespModel
@property (nonatomic, copy) NSArray<HSRoomInfoList *> * roomInfoList;

@end

NS_ASSUME_NONNULL_END
