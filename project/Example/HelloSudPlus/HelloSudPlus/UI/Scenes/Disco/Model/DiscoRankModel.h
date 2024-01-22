//
//  DiscoRankModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/30.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 蹦迪排行榜数据列表
@interface DiscoRankModel : BaseModel
@property (nonatomic, assign)NSInteger rank;
@property (nonatomic, assign)NSInteger count;
@property (nonatomic, strong)NSString * name;
@property (nonatomic, strong)NSString * avatar;
@end

NS_ASSUME_NONNULL_END
