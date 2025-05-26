//
//  SudGIPAPPState.m
//  SudMGPWrapper
//
//  Created by kaniel on 2022/7/4.
//

#import "SudGIPAPPBaseballState.h"
#import <MJExtension/MJExtension.h>

@implementation AppBaseballRankingItemModel
@end

@implementation AppBaseballRankingModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data": AppBaseballRankingItemModel.class};
}
@end

@implementation AppBaseballMyRankingModel
@end

@implementation AppBaseballRangeInfoModel
@end

@implementation AppBaseballTextConfigModel
@end
