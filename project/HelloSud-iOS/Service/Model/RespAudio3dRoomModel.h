//
//  RespGiftListModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RespGiftListModel.h"

typedef NS_ENUM(NSInteger, Audio3dMicHandleType) {
    Audio3dMicHandleTypeUp = 0,
    Audio3dMicHandleTypeDown = 1,
};

typedef NS_ENUM(NSInteger, Audio3dMicLockHandleType) {
    Audio3dMicLockHandleTypeLock = 0,
    Audio3dMicLockHandleTypeUnlock = 1,
};

typedef NS_ENUM(NSInteger, Audio3dMicStateType) {
    Audio3dMicStateTypeForbidden = -1,
    Audio3dMicStateTypeClose = 0,
    Audio3dMicStateTypeOpen = 1,
};

/// 请求上下麦参数model
@interface ReqAudio3dUpMicModel : BaseModel
@property(nonatomic, strong) NSString *roomId;
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, assign) NSInteger micIndex;
/// 上麦或下麦(0:上麦，1：下麦)
@property(nonatomic, assign) Audio3dMicHandleType handleType;
@end

/// 请求更新麦位信息参数model
@interface ReqAudio3dUpdateMicModel : BaseModel
@property(nonatomic, strong) NSString *roomId;
@property(nonatomic, strong) NSString *userId;
/// 麦克风状态  -1:禁麦  0:闭麦  1:开麦
@property(nonatomic, assign) Audio3dMicStateType micphoneState;

@end

/// 请求锁闭麦参数model
@interface ReqAudio3dLockMicModel : BaseModel
@property(nonatomic, strong) NSString *roomId;
@property(nonatomic, assign) NSInteger micIndex;
/// 锁麦或解麦(0：锁麦，1：解麦)
@property(nonatomic, assign) Audio3dMicLockHandleType handleType;
@end

/// 查询麦位参数model
@interface ReqAudio3dMicSeatsModel : BaseModel
@property(nonatomic, strong) NSString *roomId;
@end
