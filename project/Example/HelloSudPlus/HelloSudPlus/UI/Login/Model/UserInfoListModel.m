//
//  UserInfoListModel.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/26.
//

#import "UserInfoListModel.h"

@implementation HSUserInfoData
@end

@implementation UserInfoListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"userInfos": [HSUserInfoData class]
    };
}
@end
