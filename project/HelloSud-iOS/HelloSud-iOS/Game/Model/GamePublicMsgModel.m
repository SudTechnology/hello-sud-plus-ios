//
//  GamePublicMsgModel.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/19.
//

#import "GamePublicMsgModel.h"

@implementation GamePublicText
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"degf"  : @"default",
             @"en_GB" : @"en-GB",
             @"en_US" : @"en-US",
             @"ms_BN" : @"ms-BN",
             @"ms_MY" : @"ms-MY",
             @"zh_CN" : @"zh-CN",
             @"zh_HK" : @"zh-HK",
             @"zh_MO" : @"zh-MO",
             @"zh_SG" : @"zh-SG",
             @"zh_TW" : @"zh-TW",
             };
}
@end

@implementation GamePublicUser

@end

@implementation GamePublicMsg

@end

@implementation GamePublicMsgModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"msg": [GamePublicMsg class]
    };
}
@end
