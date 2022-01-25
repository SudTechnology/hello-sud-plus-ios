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

@end

/// 用户进入房间Model
@interface HSEnterRoomModel : BaseModel
@property (nonatomic, assign) NSInteger              retCode;
@property (nonatomic, copy) NSString              * retMsg;
@property (nonatomic, strong) HSEnterRoomData              * data;
@end

NS_ASSUME_NONNULL_END
