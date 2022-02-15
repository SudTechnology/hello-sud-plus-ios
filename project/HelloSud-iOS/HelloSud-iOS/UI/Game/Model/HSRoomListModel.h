//
//  HSRoomListModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSRoomInfoList: BaseModel
@property (nonatomic, assign) NSInteger              roomId;
@property (nonatomic, copy) NSString              * roomName;
@property (nonatomic, assign) NSInteger              memberCount;
@property (nonatomic, copy) NSString              * roomPic;
@property (nonatomic, assign) NSInteger              sceneType;

@end

/// 所有开播房间列表
@interface HSRoomListModel : HSBaseRespModel
@property (nonatomic, copy) NSArray<HSRoomInfoList *>              * roomInfoList;

@end

NS_ASSUME_NONNULL_END
