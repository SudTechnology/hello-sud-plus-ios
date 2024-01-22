//
//  PKSettingView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PKSettingView : BaseView
typedef NS_ENUM(NSInteger, PKSettingType) {
    /// PK前
    PKSettingTypePKBefore,
    /// PK后
    PKSettingTypePKAfter
};
typedef NS_ENUM(NSInteger, PKSettingBtnEventType) {
    /// 关闭跨房pk
    PKSettingBtnEventTypeClosePK,
    /// 开始pk
    PKSettingBtnEventTypeStartPK,
    /// 修改pk
    PKSettingBtnEventTypeEditPK
};
typedef void(^SettingNodesEventBlock)(PKSettingBtnEventType type, NSNumber *time);
@property (nonatomic, copy) SettingNodesEventBlock settingNodesEventBlock;

/// 初始化【必需】
- (instancetype)initWithPKSettingType:(PKSettingType)pKSettingType;
@end

NS_ASSUME_NONNULL_END
