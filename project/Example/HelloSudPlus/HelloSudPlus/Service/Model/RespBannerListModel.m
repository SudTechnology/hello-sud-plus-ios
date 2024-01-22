//
//  RespGiftListModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RespBannerListModel.h"

@implementation RespBannerModel
@end

@implementation RespBannerListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"bannerInfoList": RespBannerModel.class};
}
@end
