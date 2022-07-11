//
//  RespAppIDListModel.h
//  DeveloperKit
//
//  Created by kaniel on 2022/7/11.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseRespModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 应用ID信息
@interface AppIDInfoModel : BaseModel
@property(nonatomic, strong)NSString *app_id;
@property(nonatomic, strong)NSString *app_key;
@property(nonatomic, strong)NSString *app_name;
@property(nonatomic, assign)BOOL isSelect;
@end
/// APP ID列表
@interface RespAppIDListModel : BaseRespModel
@property(nonatomic, strong)NSArray<AppIDInfoModel *> *data;
@end

NS_ASSUME_NONNULL_END
