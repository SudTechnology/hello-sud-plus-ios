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
@property (nonatomic, assign)NSTimeInterval beginTime;
@property (nonatomic, strong)void(^updateDancingDurationBlock)(NSInteger second);

/// 跳舞是否结束
/// @return
- (BOOL)isDanceFinished;
/// 开始跳舞
- (void)beginDancing;
@end

NS_ASSUME_NONNULL_END
