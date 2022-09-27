//
//  GuessResultTableViewCell.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
/// 提示气泡
@interface TipPopView : BaseView
- (void)updateTip:(NSString *)tip;
@end

NS_ASSUME_NONNULL_END
