//
//  RespGiftListModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RespGiftListModel.h"

@implementation GiftItemDetailModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"desc":@"description"};
}

@end

@implementation RespGiftModel
@end

@implementation RespGiftListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"giftList": RespGiftModel.class};
}
@end
