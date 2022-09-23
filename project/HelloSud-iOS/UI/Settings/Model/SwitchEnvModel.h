//
//  SwitchLangModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/23.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SwitchEnvModel : BaseModel
@property(nonatomic, copy)NSString *title;
@property(nonatomic, assign)BOOL isSelect;
@property(nonatomic, assign)NSInteger envType;

@end

NS_ASSUME_NONNULL_END
