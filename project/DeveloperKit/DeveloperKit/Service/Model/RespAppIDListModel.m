//
//  RespAppIDListModel.m
//  DeveloperKit
//
//  Created by kaniel on 2022/7/11.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RespAppIDListModel.h"

@implementation AppIDInfoModel
@end

@implementation RespAppIDListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data": AppIDInfoModel.class};
}
@end
