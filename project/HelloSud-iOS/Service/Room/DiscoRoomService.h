//
//  DiscoRoomService.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/30.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "AudioRoomService.h"
#import "DiscoRankModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 蹦迪服务
@interface DiscoRoomService : AudioRoomService
/// 加入舞池
/// @param colorHexValue 昵称的颜色色值
- (void)joinDancePool:(NSString *)colorHexValue;
/// 离开舞池
- (void)leaveDancePool;
/// 加入主播位 0-0号主播位；1-1号主播位；2-2号主播位；3-3号主播位；4-4号主播位；5-5号主播位；6-6号主播位；7-7号主播位；-1-随机，默认随机
/// @param position
- (void)joinAnchorPosition:(NSString *)position;
@end

NS_ASSUME_NONNULL_END
