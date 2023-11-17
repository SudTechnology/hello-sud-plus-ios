//
//  Audio3dConfigStateModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2023/8/4.
//  Copyright © 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 3d语聊房配置状态model
@interface Audio3dConfigStateModel : BaseModel
/// 旋转状态
@property(nonatomic, assign) BOOL isRotateStateOpen;
/// 爆灯状态
@property(nonatomic, assign) BOOL isLightStateOpen;
/// 音浪状态
@property(nonatomic, assign) BOOL isVoiceStateOpen;
@end

NS_ASSUME_NONNULL_END
