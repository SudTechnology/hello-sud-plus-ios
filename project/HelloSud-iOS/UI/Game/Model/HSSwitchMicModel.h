//
//  HSSwitchMicModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSSwitchMicData: BaseModel
@property (nonatomic, copy) NSString              * streamId;

@end

/// 房间上下麦Model
@interface HSSwitchMicModel : HSBaseRespModel
@property (nonatomic, strong) HSSwitchMicData              * data;

@end

NS_ASSUME_NONNULL_END
