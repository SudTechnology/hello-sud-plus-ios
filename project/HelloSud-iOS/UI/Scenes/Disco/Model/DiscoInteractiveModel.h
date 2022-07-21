//
//  DiscoRankModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/30.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 蹦迪互动
@interface DiscoInteractiveModel : BaseModel
/// 互动指令表
@property (nonatomic, strong)NSArray <NSNumber *>*actionKeyList;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, assign)NSInteger coin;
@end

NS_ASSUME_NONNULL_END
