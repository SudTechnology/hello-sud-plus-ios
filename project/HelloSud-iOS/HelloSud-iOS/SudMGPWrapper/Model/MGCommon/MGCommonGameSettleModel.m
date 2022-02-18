//
//  MGCommonGameSettleModel.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/18.
//

#import "MGCommonGameSettleModel.h"

@implementation MGCommonGameSettleResults

@end

@implementation MGCommonGameSettleModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"results": [MGCommonGameSettleResults class]
    };
}
@end
