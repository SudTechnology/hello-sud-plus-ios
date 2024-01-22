//
// Created by kaniel on 2023/8/3.
// Copyright (c) 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Audio3dConfigStateModel.h"

/// 更多设置弹窗
@interface Audio3dMoreSettingPopView : BaseView
@property (nonatomic, strong)void(^rotateChangedBlock)(BOOL isSelected);
@property (nonatomic, strong)void(^lightChangedBlock)(BOOL isSelected);
@property (nonatomic, strong)void(^voiceChangedBlock)(BOOL isSelected);

- (void)updateConfig:(Audio3dConfigStateModel *)configStateModel;
@end