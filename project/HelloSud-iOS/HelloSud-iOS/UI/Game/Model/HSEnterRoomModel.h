//
//  HSEnterRoomModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN


/// 用户进入房间Model
@interface HSEnterRoomModel : HSBaseRespModel
@property (nonatomic, assign) NSInteger              roomId;
@property (nonatomic, copy) NSString              * roomName;
@property (nonatomic, assign) NSInteger              gameId;
@property (nonatomic, assign) NSInteger              memberCount;
@property (nonatomic, assign) NSInteger              roleType;
@end

NS_ASSUME_NONNULL_END
