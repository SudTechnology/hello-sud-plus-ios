//
//  HSMicListModel.h
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

@interface HSMicListData: BaseModel
@property (nonatomic , copy) NSArray<HSRoomMicList *>              * roomMicList;

@end

/// 查询房间麦位列表Model
@interface HSMicListModel : HSBaseRespModel
@property (nonatomic, strong) HSMicListData              * data;

@end

NS_ASSUME_NONNULL_END
