//
//  MicListModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSRoomMicList: NSObject
@property (nonatomic, assign) NSInteger              roleType;
@property (nonatomic, assign) NSInteger              userId;
@property (nonatomic, assign) NSInteger              micIndex;

@end

/// 查询房间麦位列表Model
@interface MicListModel : BaseRespModel
@property (nonatomic , copy) NSArray<HSRoomMicList *>              * roomMicList;

@end

NS_ASSUME_NONNULL_END
