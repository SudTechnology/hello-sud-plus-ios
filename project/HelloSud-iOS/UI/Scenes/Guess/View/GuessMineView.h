//
//  GuessMineView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/13.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
/// 房间内猜自己赢挂件视图
@interface GuessMineView : BaseView
/// 更新押注金币
/// @param betCoin betCoin
- (void)updateBetCoin:(NSInteger)betCoin;
@end

NS_ASSUME_NONNULL_END
