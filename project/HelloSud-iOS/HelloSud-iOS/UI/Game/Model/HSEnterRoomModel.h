//
//  HSEnterRoomModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSEnterRoomData: BaseModel
@property (nonatomic, assign) NSInteger              roomId;
@property (nonatomic, copy) NSString              * roomName;
@property (nonatomic, assign) NSInteger              gameId;
@property (nonatomic, assign) NSInteger              memberCount;

@end

/// 用户进入房间Model
@interface HSEnterRoomModel : HSBaseRespModel
@property (nonatomic, strong) HSEnterRoomData              * data;
@end

NS_ASSUME_NONNULL_END
