//
//  DiscoRankHeadView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/30.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
/// 排行榜头像
@interface DiscoRankHeadView : BaseView
@property (nonatomic, strong)UIColor *borderColor;
@property (nonatomic, strong)NSString *imageURL;
@property (nonatomic, assign)NSInteger rank;
@end

NS_ASSUME_NONNULL_END
