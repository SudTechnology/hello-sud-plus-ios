//
// Created by kaniel on 2022/10/25.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

@interface UpgradeAlertView : BaseView
@property (nonatomic, copy)void(^sureBlock)(void);
@property (nonatomic, copy)void(^cancelBlock)(void);
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content upgradeType:(NSInteger)upgradeType;
@end
