//
//  DiscoMenuModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/7/1.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseModel.h"
NS_ASSUME_NONNULL_BEGIN
/// 蹦迪菜单数据model
@interface DiscoMenuModel : BaseModel
@property (nonatomic, assign)NSInteger rank;
@property (nonatomic, strong)AudioUserModel *fromUser;
@property (nonatomic, strong)AudioUserModel *toUser;
@property (nonatomic, assign)NSInteger duration;
@property (nonatomic, assign)int64_t beginTime;
@property (nonatomic, strong)void(^_Nullable updateDancingDurationBlock)(NSInteger second);
/// 特写时间
@property (nonatomic, assign)NSInteger specialDuration;

/// 跳舞是否结束
/// @return
- (BOOL)isDanceFinished;
/// 开始跳舞
- (void)beginDancing;
- (NSInteger)remainDuration;
/// 是否相同
/// @param model
/// @return
- (BOOL)isSame:(DiscoMenuModel *)model;
@end

NS_ASSUME_NONNULL_END
