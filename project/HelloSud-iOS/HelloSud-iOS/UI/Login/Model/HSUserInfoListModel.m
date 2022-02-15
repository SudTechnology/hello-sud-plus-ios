//
//  HSUserInfoListModel.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/26.
//

#import "HSUserInfoListModel.h"

@implementation HSUserInfoData

@end
@implementation HSUserInfoListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"userInfos": [HSUserInfoData class]
    };
}
@end
