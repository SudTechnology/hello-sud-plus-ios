//
//  TocketChooseModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TocketChooseModel : BaseModel
@property (nonatomic, copy) NSString *bgImgStr;
@property (nonatomic, copy) NSString *goldImgStr;
@property (nonatomic, copy) NSString *btnImgStr;
@property (nonatomic, copy) NSString *rewardStr;
@property (nonatomic, assign) BOOL isHiddenHot;
@end

NS_ASSUME_NONNULL_END
