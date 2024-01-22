//
//  CustomRoomTableViewCell.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/20.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameConfigTableViewCell : BaseTableViewCell
@property(nonatomic, assign)BOOL isShowLine;
@property(nonatomic, strong)Int64Block sliderVolumeBlock;
@end

NS_ASSUME_NONNULL_END
