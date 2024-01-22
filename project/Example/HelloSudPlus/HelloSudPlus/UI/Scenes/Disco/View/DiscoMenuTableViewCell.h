//
//  DiscoMenuTableViewCell.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/7/1.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
/// 蹦迪菜单列表cell
@interface DiscoMenuTableViewCell : BaseTableViewCell
@property (nonatomic, strong)void(^danceFinishedBlock)(void);
@end

NS_ASSUME_NONNULL_END
