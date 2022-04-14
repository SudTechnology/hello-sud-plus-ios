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

@end

/// 所有开播房间列表
@interface RoomListModel : BaseRespModel
@property (nonatomic, copy) NSArray<HSRoomInfoList *> * roomInfoList;

@end

NS_ASSUME_NONNULL_END
