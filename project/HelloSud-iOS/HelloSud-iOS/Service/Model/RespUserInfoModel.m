//
//  RespUserInfoModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "RespUserInfoModel.h"

/// 响应用户信息model
@implementation HSUserInfoModel
@end

/// 响应用户信息model
@implementation RespUserInfoModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"userInfoList": [HSUserInfoModel class]};
}
@end
